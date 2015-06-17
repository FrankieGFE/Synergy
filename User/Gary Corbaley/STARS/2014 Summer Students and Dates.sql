

DECLARE @SchoolYear NUMERIC = 2015, @Extension NVARCHAR(1) = 'N', @onDate DATE


	DECLARE @FINAL_DATE DATETIME
	DECLARE @FirstDay DATE, @LastDay DATE
	DECLARE @CalTypeGu  UNIQUEIDENTIFIER
	DECLARE @NumNonDays INT
	
	DECLARE @SUMMER_CALENDAR TABLE
	(
		[CAL_DATE] DATETIME
	)

	-- Get the specific calendar GU for the requested school year and extension,
	-- and get the start and end dates for that year.
	SELECT TOP 1
		-- Set the varriable for the first day of school
		@FirstDay = DistrictCalType.START_DATE
		-- Set the varriables for the last day of school
		,@LastDay = DistrictCalType.END_DATE
		-- Set return value to last day of school 
		,@FINAL_DATE = DistrictCalType.END_DATE
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
		
SET @FirstDay = '06/03/2015' 
SET @LastDay = '07/24/2015'

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
--	SELECT TOP 1
--		-- Set a varriable to return the selected date
--		@FINAL_DATE = [CALENDAR_DAY] 
		
--	FROM
--		-- Get all the school days for the requested year 
--		[qMemberDays]
		
--	WHERE
--		-- Get all callendar dates for the given member day 
--		[MEMBER_DAY] = @MemberDay
--		-- Make sure that the callendar dates are valid school days
--		AND [isMemberDay] = 'TRUE'
	
--		-- Limit the recusion to a maximum of 365 loops
--	OPTION (maxrecursion 365)
	
--	-- Return the date for the requested member day
--RETURN @FINAL_DATE


INSERT INTO @SUMMER_CALENDAR
SELECT 
	[CALENDAR_DAY]
FROM
	[qMemberDays]
WHERE
	[CALENDAR_DAY] != '07/25/2015'
	AND [isMemberDay] = 'TRUE'
	
OPTION (maxrecursion 365)

SELECT --TOP 20000
	[SS_STUDENTS].[SIS_NUMBER]
	,[SS_STUDENTS].[STATE_STUDENT_NUMBER]
	,[SS_STUDENTS].[SCHOOL_CODE]
	,[SS_STUDENTS].[ORGANIZATION_NAME]
	,CONVERT(VARCHAR(4),YEAR([SS_STUDENTS].[ENTER_DATE])) + '-' + RIGHT('00' + CONVERT(VARCHAR(2),DATEPART(MM,[SS_STUDENTS].[ENTER_DATE])),2) + '-' + RIGHT('00'+CONVERT(VARCHAR(2),DATEPART(DD,[SS_STUDENTS].[ENTER_DATE])),2) AS [DATE_STARTED]
	,CONVERT(VARCHAR(4),YEAR([SS_STUDENTS].[LEAVE_DATE])) + '-' + RIGHT('00' + CONVERT(VARCHAR(2),DATEPART(MM,[SS_STUDENTS].[LEAVE_DATE])),2) + '-' + RIGHT('00'+CONVERT(VARCHAR(2),DATEPART(DD,[SS_STUDENTS].[LEAVE_DATE])),2) AS [DATE_WITHDREW]
	,CONVERT(VARCHAR(4),YEAR([MEMDAY].[CAL_DATE])) + '-' + RIGHT('00' + CONVERT(VARCHAR(2),DATEPART(MM,[MEMDAY].[CAL_DATE])),2) + '-' + RIGHT('00'+CONVERT(VARCHAR(2),DATEPART(DD,[MEMDAY].[CAL_DATE])),2) AS [ATTENDANCE_DATE]
FROM

	(
	SELECT DISTINCT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STATE_STUDENT_NUMBER]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]
		,[StudentSchoolYear].[ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE]
		
	FROM
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
				
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]	
		
		INNER JOIN
		rev.[EPC_SCH_YR_OPT] AS [SCHOOL_YEAR_OPTION]
		ON
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [SCHOOL_YEAR_OPTION].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN
		rev.[EPC_STU] AS [STUDENT]
		ON
		[StudentSchoolYear].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
			
		
	WHERE
		[RevYear].[SCHOOL_YEAR] = '2015'
		AND [RevYear].[EXTENSION] = 'N'
		AND [StudentSchoolYear].[NO_SHOW_STUDENT] = 'N'
		AND [SCHOOL_YEAR_OPTION].[SCHOOL_TYPE] = 1
	) AS [SS_STUDENTS]
	
	FULL OUTER JOIN
	@SUMMER_CALENDAR AS [MEMDAY]
	ON
	[MEMDAY].[CAL_DATE] >= [SS_STUDENTS].[ENTER_DATE]
	AND ([SS_STUDENTS].[LEAVE_DATE] IS NULL OR [MEMDAY].[CAL_DATE] <= [SS_STUDENTS].[LEAVE_DATE])
	
WHERE
	[SS_STUDENTS].[SCHOOL_CODE] IN ('237','249','261','250','280')
	--AND [SS_STUDENTS].[LEAVE_DATE] IS NOT NULL
	
ORDER BY
	[SS_STUDENTS].[SIS_NUMBER]