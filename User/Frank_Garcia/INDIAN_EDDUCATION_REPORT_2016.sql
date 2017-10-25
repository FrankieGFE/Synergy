

EXECUTE AS LOGIN='QueryFileUser'
GO


WITH
INCIDENCES_16 AS
(
SELECT
	SIS_NUMBER
	,COUNT(INCIDENT_ID) INCIDENCES
FROM
	(

	SELECT 
		ROW_NUMBER () OVER (PARTITION BY [STUDENT].[SIS_NUMBER], INCIDENT_ID ORDER BY [Disposition].[DISPOSITION_DATE] DESC) AS RN1
		,[STUDENT].[SIS_NUMBER]
		,Violation_Code.SCHOOL_YEAR
		,INCIDENT_ID
	FROM
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN2
		FROM
			APS.StudentEnrollmentDetails
			
		WHERE
			SCHOOL_YEAR = 2016
			AND EXTENSION = 'R'
			AND EXCLUDE_ADA_ADM IS NULL
		) AS [ENROLLMENTS]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		[rev].[EPC_STU_INC_DISCIPLINE] AS [Discipline]
		ON
		[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [Discipline].[STUDENT_SCHOOL_YEAR_GU]
	    
		INNER JOIN
		rev.EPC_SCH_INCIDENT AS [INCIDENT]
		ON
		[Discipline].[SCH_INCIDENT_GU] = [INCIDENT].[SCH_INCIDENT_GU]
	    
		INNER JOIN
		[rev].[EPC_STU_INC_DISPOSITION] AS [Disposition]
		ON
		[Discipline].[STU_INC_DISCIPLINE_GU] = [Disposition].[STU_INC_DISCIPLINE_GU]
	    
		INNER JOIN
		[rev].[EPC_CODE_DISP] AS [Disposition_Code]
		ON
		[Disposition].[CODE_DISP_GU] = [Disposition_Code].[CODE_DISP_GU]
		AND Disposition_Code.SCHOOL_YEAR =  2016
	    
		LEFT OUTER JOIN
		[rev].[EPC_STU_INC_VIOLATION] AS [Violation]
		ON
		[Discipline].[SCH_INCIDENT_GU] = [Violation].[SCH_INCIDENT_GU]
	    
		LEFT OUTER JOIN
		[rev].[EPC_CODE_DISC] AS [Violation_Code]
		ON
		[Violation].[CODE_DISC_GU] = [Violation_Code].[CODE_DISC_GU]
		AND Violation_Code.SCHOOL_YEAR = 2016

	WHERE 1 = 1
		AND RN2 = 1
) T1
WHERE 1 = 1
AND RN1 = 1
GROUP BY SIS_NUMBER

)
, ABSENSES_16 AS
(
SELECT
	[SIS Number]
	,[Total Excused]
	,[Total Unexcused]
	,[School Code]
FROM
(
SELECT
	ROW_NUMBER () OVER (PARTITION BY [SIS Number] ORDER BY SA.[School Code]) AS RN
	,[SIS Number]
	,[Total Excused]
	,[Total Unexcused]
	,SA.[School Code]
	
FROM
	STUDENT_ATTENDANCE_2016 SA
	JOIN
	REV.EPC_STU STU
	ON STU.SIS_NUMBER = SA.[SIS Number]
	JOIN
	APS.EnrollmentsForYear ('F7D112F7-354D-4630-A4BC-65F586BA42EC') YR
	ON YR.STUDENT_GU = STU.STUDENT_GU
	AND YR.ORGANIZATION_GU = SA.ORGANIZATION_GU

) A
WHERE 1 = 1 
--AND RN = 1
)

SELECT distinct
	[ALTERNATE STUDENT ID] AS [Student ID]
	,[STUDENT ID] AS [STARS ID]
	,[CURRENT GRADE LEVEL] AS [Grade Level]
	,[GENDER CODE] AS Gender
	,BS.HISPANIC_INDICATOR AS [Hispanic Indicator]
	,BS.RESOLVED_RACE AS [Resolved Race]
	,BS.RACE_1
	,BS.RACE_2
	,BS.RACE_3
	,BS.RACE_4
	,BS.RACE_5
	,BS.LUNCH_STATUS AS [FRPL Status]
	,BS.ELL_STATUS AS [ELL Status]
	,BS.SPED_STATUS AS [SPED Status]

	,CASE WHEN STUD.GRADUATION_DATE = '1900-01-01 00:00:00' OR STUD.GRADUATION_DATE IS NULL THEN '' 
	      ELSE CONVERT(VARCHAR,STUD.GRADUATION_DATE, 101)
	END AS 'Graduation Date'
	,CASE WHEN STUD.GRADUATION_STATUS IS NULL THEN '' ELSE STUD.GRADUATION_STATUS
	END AS 'Graduation Status'

	,CASE WHEN INCIDENCES_16.INCIDENCES IS NULL THEN '' ELSE INCIDENCES_16.INCIDENCES
	END AS [#Behavioral Incidences 2016]

	,ABSENSES_16.[Total Excused] AS [#Total Excused Absenses 2016]
	,ABSENSES_16.[Total Unexcused] AS [#Total Unexcused Absenses 2016]
	--,ABSENSES_16.[School Code]

FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM INDIAN_EDUCATION_REPORT_6.csv'  
		)AS STU
	LEFT HASH JOIN
	APS.BasicStudentWithMoreInfo BS
	ON BS.SIS_NUMBER = STU.[ALTERNATE STUDENT ID]
LEFT HASH JOIN
	REV.EPC_STU STUD
	ON STUD.SIS_NUMBER = STU.[ALTERNATE STUDENT ID]
LEFT JOIN
	INCIDENCES_16
	ON INCIDENCES_16.SIS_NUMBER = STU.[ALTERNATE STUDENT ID]
LEFT JOIN
	ABSENSES_16
	ON ABSENSES_16.[SIS Number] = STU.[ALTERNATE STUDENT ID]
WHERE 1 = 1
	--AND STU.PERIOD = '2017-03-01'
	--AND STU.[DISTRICT CODE] = '001'
	--and STU.[ALTERNATE STUDENT ID] = '186787'
	--and GRADUATION_DATE < getdate()
ORDER BY [ALTERNATE STUDENT ID]


REVERT
GO
