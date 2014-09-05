
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

	SELECT
		@FirstDay = DistrictCalType.START_DATE
		,@LastDay = DistrictCalType.END_DATE
		,@CalTypeGu = DistrictCalType.ATT_CAL_TYPE_GU
	FROM
		rev.EPC_ATT_CAL_TYPE AS DistrictCalType
		INNER JOIN 
		rev.EPC_ATT_CAL_OPT AS DistrictCalOption
		ON
		DistrictCalType.ATT_CAL_OPT_GU = DistrictCalOption.ATT_CAL_OPT_GU
	
		RIGHT JOIN
		rev.REV_YEAR AS SynYear
		ON
		DistrictCalOption.YEAR_GU = SynYear.YEAR_GU
	WHERE
		SynYear.SCHOOL_YEAR = @SchoolYear
		AND SynYear.EXTENSION = @Extension	
		
;WITH [qHolidays] AS (SELECT CAL_DATE FROM rev.EPC_ATT_CAL	WHERE ATT_CAL_TYPE_GU = @CalTypeGu AND CAL_DATE BETWEEN @FirstDay AND @LastDay AND HOLIDAY IN ('Hol'))	
		
, [qMemberDays] AS (
  SELECT CAST(@FirstDay AS DATETIME) AS [CALENDAR_DAY],CASE WHEN DATEPART(dw,@FirstDay) != 7 THEN 1 ELSE 0 END AS [MEMBER_DAY], CAST(1 AS BIT) AS [isMemberDay]
  UNION ALL
  SELECT DATEADD(dd, 1, [CALENDAR_DAY]),
	CASE 
		WHEN DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 7 
		AND 
		DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 1  
		AND
		DATEADD(dd, 1, [CALENDAR_DAY]) NOT IN (SELECT CAL_DATE FROM [qHolidays])
		THEN [MEMBER_DAY] + 1 ELSE [MEMBER_DAY] + 0 END AS [MEMBER_DAY],
	CASE 
		WHEN DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 7 
		AND 
		DATEPART(dw,DATEADD(dd, 1, [CALENDAR_DAY])) != 1  
		AND
		DATEADD(dd, 1, [CALENDAR_DAY]) NOT IN (SELECT CAL_DATE FROM [qHolidays])
		THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS [isMemberDay]
    FROM [qMemberDays]
   WHERE 
		DATEADD(dd, 1, [CALENDAR_DAY]) <= CAST(@LastDay AS DATETIME)
	)
	
	SELECT 
		@FINAL_DATE = [CALENDAR_DAY] 
	FROM [qMemberDays]
	WHERE [MEMBER_DAY] = @MemberDay AND [isMemberDay] = 'TRUE'
	OPTION (maxrecursion 365)
	
RETURN @FINAL_DATE

END