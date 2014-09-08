/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/08/2014 $
 * 
 * This function will return a single date for any given member day for a specific school year and extension.
 * The date is calculated from the given member day by first generating(at run time) a list of all the callendar dates for the specific year and assigning each date a member day value and marks them with a flag to identify if they are valid school days or just a weekend or holiday. The given member day is then compared to the day counter in the generated list and returning the first occuring date.
 */


-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[DateFromMemberDayAndSchoolYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.DateFromMemberDayAndSchoolYear() RETURNS INT AS BEGIN RETURN -1 END')
GO

ALTER FUNCTION APS.DateFromMemberDayAndSchoolYear(@SchoolYear NUMERIC, @Extension NVARCHAR(1), @MemberDay INT)
RETURNS DATETIME
AS
BEGIN

	DECLARE @FINAL_DATE DATETIME
	DECLARE @FirstDay DATE, @LastDay DATE
	DECLARE @CalTypeGu  UNIQUEIDENTIFIER
	DECLARE @NumNonDays INT

	-- Get the specific calendar GU for the requested school year and extension,
	-- and get the start and end dates for that year.
	SELECT
		-- Set the varriable for the first day of school
		@FirstDay = DistrictCalType.START_DATE
		-- Set the varriable for the last day of school
		,@LastDay = DistrictCalType.END_DATE
		-- Set the varriable for the school callendar
		,@CalTypeGu = DistrictCalType.ATT_CAL_TYPE_GU
	FROM
		-- Get callendar types
		rev.EPC_ATT_CAL_TYPE AS DistrictCalType
		-- Get callendar options
		INNER JOIN 
		rev.EPC_ATT_CAL_OPT AS DistrictCalOption
		ON
		DistrictCalType.ATT_CAL_OPT_GU = DistrictCalOption.ATT_CAL_OPT_GU
		
		-- Get the school years
		RIGHT JOIN
		rev.REV_YEAR AS SynYear
		ON
		DistrictCalOption.YEAR_GU = SynYear.YEAR_GU
		
	WHERE
		-- Only for given school year
		SynYear.SCHOOL_YEAR = @SchoolYear
		-- Only for given callendar extension
		AND SynYear.EXTENSION = @Extension	

	-- Define the keyword [qHolidays] to select all the holidays between the start and end dates for the requested school year.	
;WITH [qHolidays] AS (SELECT CAL_DATE FROM rev.EPC_ATT_CAL	WHERE ATT_CAL_TYPE_GU = @CalTypeGu AND CAL_DATE BETWEEN @FirstDay AND @LastDay AND HOLIDAY IN ('Hol'))	


	-- Define the keyword [qMemberDays] to recursively select all of the calendar dates between the start and end of the requested school year.
	-- Each date is assigned a member day value and marked as either an active school day or a non-school day.	
, [qMemberDays] AS (
	-- Get the initial values for the recursion
  SELECT 
  
	-- Set the first day of the school year
	CAST(@FirstDay AS DATETIME) AS [CALENDAR_DAY]
	
	-- Check to see if the first day is a weekend then set the first member day counter
	,CASE WHEN DATEPART(dw,@FirstDay) != 7 AND DATEPART(dw,@FirstDay) != 1 THEN 1 ELSE 0 END AS [MEMBER_DAY]
	
	-- Check to see if the first day is a weekend then set a TRUE/FALSE value that marks this date as a valid school day
	, CASE WHEN DATEPART(dw,@FirstDay) != 7 AND DATEPART(dw,@FirstDay) != 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS [isMemberDay]
  
  -- Join to a select statement that recursively calls [qMemberDays] and adds 1 day to the previously returned date
  UNION ALL
  
  -- Get the previous date from [qMemberDays] and then add 1 day to that date
  SELECT 
  
	-- Add 1 day to previous date
	DATEADD(dd, 1, [CALENDAR_DAY]),
	
	-- Check if the new date is a weekend or holiday and increment the member dat counter
	CASE 
		WHEN DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 7		-- Check for Saturdays 
		AND 
		DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 1			-- Check for Sundays
		AND
		DATEADD(dd, 1, [CALENDAR_DAY]) NOT IN (SELECT CAL_DATE FROM [qHolidays])	-- Calls [qHolidays] to check for all holidays in the given school year
		THEN [MEMBER_DAY] + 1 ELSE [MEMBER_DAY] + 0 END AS [MEMBER_DAY],			-- Increment memberday counter
		
	-- Check if the new date is a weekend or holiday then set a TRUE/FALSE value that marks this date as a valid school day
	CASE 
		WHEN DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 7		-- Check for Saturdays 
		AND 
		DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 1			-- Check for Sundays
		AND
		DATEADD(dd, 1, [CALENDAR_DAY]) NOT IN (SELECT CAL_DATE FROM [qHolidays])	-- Calls [qHolidays] to check for all holidays in the given school year
		THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS [isMemberDay]				-- Set TRUE/FALSE flag for valid school days
		
   FROM 
	-- Here the query calls itself thus creating the recursion
	[qMemberDays]
	
   WHERE 
		-- Stop adding new dates when the last day of the school year is reached
		DATEADD(dd, 1, [CALENDAR_DAY]) <= CAST(@LastDay AS DATETIME)
	)
	
	-- Get only the first occurance of the valid school date for the given member day
	SELECT TOP 1
		-- Set a varriable to return the selected date
		@FINAL_DATE = [CALENDAR_DAY] 
		
	FROM
		-- Get all the school days for the requested year 
		[qMemberDays]
		
	WHERE
		-- Get all callendar dates for the given member day 
		[MEMBER_DAY] <= @MemberDay 
		-- Make sure that the callendar dates are valid school days
		AND [isMemberDay] = 'TRUE'
		
		-- Sort the list of dates 
	ORDER BY [CALENDAR_DAY]
	
		-- Limit the recusion to a maximum of 365 loops
	OPTION (maxrecursion 365)
	
	-- Return the date for the requested member day
RETURN @FINAL_DATE

END