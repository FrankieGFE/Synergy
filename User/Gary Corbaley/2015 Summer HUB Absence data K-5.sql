



;WITH
DAILY_ATTENDANCE AS
(
SELECT
	[STUDENT_GU]
	-- GROUP DAILY TOTALS BY ABSENCE TYPE
	,SUM(CASE WHEN [ABSENCE CODE] = 'UX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY UNEXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'EX' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY EXCUSED'
	,SUM(CASE WHEN [ABSENCE CODE] = 'T' THEN [ABSENCE PERIODS] ELSE 0 END) AS 'DAILY TARDY'
FROM
	(
	SELECT
		[STUDENT_GU]
		-- GET TOTAL DAYS
		,COUNT(ABS_DATE) AS [ABSENCE PERIODS]
		,[ABSENCE CODE]
	FROM	
		(
		SELECT 
		SIS_NUMBER
		, ORG.ORGANIZATION_NAME
		, ESAD.ABS_DATE
		, CASE
				WHEN ISNUMERIC(ECAR.ABBREVIATION) = 1 OR ECAR.ABBREVIATION = 'T' THEN 'T'  
				WHEN ECAR.ABBREVIATION = 'ABS' THEN 'UX'
				ELSE 'EX'END 
			AS [ABSENCE CODE]
		--, ECAR.ABBREVIATION  AS [ABSENCE CODE]
		, S.STUDENT_GU
		, SSY.STUDENT_SCHOOL_YEAR_GU
		, ESAD.DAILY_ATTEND_GU

		FROM rev.EPC_STU_ATT_DAILY        AS ESAD
		INNER  JOIN rev.EPC_STU_ENROLL           AS ESE    ON ESE.ENROLLMENT_GU                = ESAD.ENROLLMENT_GU 
		INNER  JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU       = ESE.STUDENT_SCHOOL_YEAR_GU 
		INNER  JOIN rev.EPC_STU								AS S      ON S.STUDENT_GU = SSY.STUDENT_GU 
		INNER  JOIN rev.REV_ORGANIZATION_YEAR AS ORGYR ON SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
		INNER  JOIN rev.REV_ORGANIZATION AS ORG ON ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

		INNER  JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU    = ESAD.CODE_ABS_REAS1_GU 											
		AND ECARSY.ORGANIZATION_YEAR_GU     = ORGYR.ORGANIZATION_YEAR_GU 

		INNER  JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   ON ECARSY.CODE_ABS_REAS_GU             = ECAR.CODE_ABS_REAS_GU 

		INNER  JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                           = ORGYR.YEAR_GU 
		--This view only runs for the current school year and Regular Extension
		AND Y.SCHOOL_YEAR  = '2014'
		AND Y.EXTENSION  = 'R'

		WHERE
		--DAILY CONTAINS PERIOD TOO, SO EXCLUDE MID AND HIGH
		ORGANIZATION_NAME LIKE '%Elementary%'
		AND ESAD.ABS_DATE <= GETDATE()
		) AS [DAILY_ATT]
		
	GROUP BY
		[STUDENT_GU]
		,[ABSENCE CODE]
	) AS [DAILY_ATT]
	
GROUP BY
	[STUDENT_GU]
)


-----------------------------------------

SELECT
	'2014 - 2015' AS [SCHOOL_YEAR]
	,1 AS [DST_NBR]
	,[STUDENT].[SIS_NUMBER] AS [APS_STUDENT_ID]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[LAST_NAME] AS [LST_NME]
	,[STUDENT].[FIRST_NAME] AS [FRST_NME]
	,[STUDENT].[MIDDLE_NAME] AS [M_NME]
	,[ENROLLMENTS].[GRADE] AS [ENROLLMENT_GRADE]
	,[ENROLLMENTS].[SCHOOL_CODE] AS [SCHOOL_LOCATION_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[ENTER_DATE] AS [BEG_ENR_DT]
	,[ENROLLMENTS].[LEAVE_DATE] AS [END_ENR_DT]
	,[DAILY_ATTENDANCE].[DAILY EXCUSED]
	,[DAILY_ATTENDANCE].[DAILY UNEXCUSED]
	,[DAILY_ATTENDANCE].[DAILY TARDY]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf('05/22/2015') AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	DAILY_ATTENDANCE AS [DAILY_ATTENDANCE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [DAILY_ATTENDANCE].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[ENTER_DATE] <= '08/13/2014'
	AND [ENROLLMENTS].[LEAVE_DATE] IS NULL
	AND [ENROLLMENTS].[LIST_ORDER] <= '70'