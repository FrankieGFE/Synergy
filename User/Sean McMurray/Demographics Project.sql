/*Created by Sean McMurray e207878
  For Even Start Project
*/



SELECT
	[STUDENT].[STATE_STUDENT_NUMBER] AS [State Number]
	,[STUDENT].[SIS_NUMBER] AS [ID Number]
	,[STUDENT].[FIRST_NAME] AS [First Name]
	,[STUDENT].[LAST_NAME] AS [Last Name]
	,[STUDENT].MIDDLE_NAME AS [Middle Name]
	,[ENROLLMENTS].[SCHOOL_CODE] AS [School Code]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [School Name]
	,[STUDENT].[GENDER] AS [Gender]
	,[STUDENT].[HISPANIC_INDICATOR] AS [Hispanic Ind]
	,[STUDENT].[RESOLVED_RACE] AS Race
	,[STUDENT].LUNCH_STATUS AS [Lunch Status]
	,[STUDENT].[ELL_STATUS] AS [ELL Status]
	,[STUDENT].CONTACT_LANGUAGE AS [Home Language]
	,SPED_STATUS AS [SPED Status]
	,[STUDENT].[PRIMARY_DISABILITY_CODE] AS [Prim Disability Code]
	,[GIFTED_STATUS] AS [Gifted Status]
	--Days Enrolled
	--Days Absent
	--Number of state-reportable behaviors
	,[GRADE] AS [Grade]
	--,PREK_PROGRAM
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, SCHOOL_YEAR ORDER BY ENTER_DATE DESC) AS RN
	FROM
		APS.StudentEnrollmentDetails
	WHERE
		SCHOOL_YEAR = '2015'  --WHAT SCHOOL YEAR???
		AND EXTENSION = 'R'   --WHAT SEMESTER???
		AND EXCLUDE_ADA_ADM IS NULL
		AND ENTER_DATE IS NOT NULL	
	)  AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]

	--INNER JOIN
 --   REV.UD_STU ON REV.EPC_STU.STUDENT_GU = REV.UD_STU.STUDENT_GU
	
	LEFT OUTER JOIN
	(
	SELECT
               *
    FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
    WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                            EXIT_DATE IS NULL 
                            OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                            )
	) AS [CurrentSPED]
    ON
    [STUDENT].[STUDENT_GU] = [CurrentSPED].[STUDENT_GU]

WHERE (GRADE = 'PK')
	  OR
	  (GRADE = 'K')
	  OR
	  (GRADE = '01')
	  OR
	  (GRADE = '02')
	  OR
	  (GRADE = '03')
	  OR
	  (GRADE = '04')
	
ORDER BY [School Name], GRADE;