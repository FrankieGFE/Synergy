


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
		AND Y.SCHOOL_YEAR  = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
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


SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENT].[GRADE]
	,[ENROLLMENT].[SCHOOL_CODE]
	,[ENROLLMENT].[SCHOOL_NAME]
	,[ENROLLMENT].[ENTER_DATE]
	,[ENROLLMENT].[LEAVE_DATE]
	,[ATTENDANCE].[DAILY UNEXCUSED]
	,[ATTENDANCE].[DAILY EXCUSED]
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENT]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	--APS.AttendanceDaily AS [ATTENDANCE]
	DAILY_ATTENDANCE AS [ATTENDANCE]
	ON
	[ENROLLMENT].[STUDENT_GU] = [ATTENDANCE].[STUDENT_GU]
	
WHERE
	[ENROLLMENT].[SCHOOL_YEAR] = '2014'
	AND [ENROLLMENT].[EXTENSION] = 'R'
	AND [ENROLLMENT].[GRADE] = '05'
	--AND [ENROLLMENT].[SCHOOL_NAME] LIKE '%Eubank%'
	AND [ENROLLMENT].[SCHOOL_CODE] IN ('216','210','370','215','213','262','250','339','392','276','229','258')
	AND [ENROLLMENT].[ENTER_DATE] IS NOT NULL
	AND [ENROLLMENT].[LEAVE_DATE] IS NULL