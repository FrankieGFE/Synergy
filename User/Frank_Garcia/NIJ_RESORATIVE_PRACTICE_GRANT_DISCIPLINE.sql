
USE
ST_Production
GO

SELECT
	SCHOOL_CODE
	,SCHOOL_NAME
	,SIS_NUMBER
	,GRADE
	,DAYS
	,CASE WHEN disp_STATE_CODE = '2' THEN 'In-School Suspension'
	      WHEN disp_STATE_CODE = '3' THEN 'Out-Of-School Suspension'
		  WHEN disp_STATE_CODE = '4' THEN 'Expulsion'
		  WHEN disp_STATE_CODE = '5' THEN 'LTS'
		  ELSE disp_STATE_CODE
	END AS disp_STATE_CODE_
	,STATE_CODE
	,disp_state_code
	--,DISC_CODE
	,DISP_CODE
	,[DESCRIPTION]
	,INCIDENT_ID
	,INCIDENT_DATE
	,DISPOSITION_DESCRIPTION
	,rn1
FROM
	(

	SELECT 
		--[ENROLLMENTS].[SCHOOL_YEAR]
		ROW_NUMBER () OVER (PARTITION BY [STUDENT].[SIS_NUMBER], [INCIDENT].[INCIDENT_ID] ORDER BY [INCIDENT].[INCIDENT_ID]) AS RN1
		,[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[STUDENT].[SIS_NUMBER]
		--,[STUDENT].[FIRST_NAME]
		--,[STUDENT].[LAST_NAME]
		,[ENROLLMENTS].[GRADE]
		--,[STUDENT].[GENDER]
		--,STUDENT.BIRTH_DATE
		--,[STUDENT].[ELL_STATUS]
		--,[STUDENT].[SPED_STATUS]

		
		,[INCIDENT].[INCIDENT_DATE]
		,[INCIDENT].[INCIDENT_ID]
		
		,[Disposition].[DISPOSITION_DATE]
		--,[Disposition].[DISPOSITION_ID]
		,[Discipline].[DAYS]
		,[Disposition_Code].[DISP_CODE]
		,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
		,[Disposition].[REASSIGNMENT_DAYS]
		--,[Disposition].[DISPOSITION_START_DATE]
		--,[Disposition].[DISPOSITION_END_DATE]
		,[Disposition_Code].STATE_CODE as disp_state_code
		
		
		--,[Violation].[VIOLATION_ID]
		,[Violation_Code].[DISC_CODE]
		,Violation_Code.STATE_CODE
		--,[Violation_Code].[DESCRIPTION] AS [VIOLATION_DESCRIPTION]
		--,[Violation].[SEVERITY_LEVEL]
		--,[Violation_Code].[SEVERITY_LEVEL]
		
	
	--, REFERRED_BY_LNAME
	--, REFERRED_BY_FNAME
	--, REFERRER_TYPE
	--, Violation.ADDITIONAL_TEXT
	--,INCIDENT.[DESCRIPTION]
	--,PRIVATE_DESCRIPTION
		--,[Violation].*
		--,[INCIDENT].*
		,[Violation_Code].[DESCRIPTION]
		
		--[Violation_Code].[DISC_CODE]
		--,[Violation_Code].[DESCRIPTION]
		
	FROM
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
		FROM
			APS.StudentEnrollmentDetails
			
		WHERE
			SCHOOL_YEAR = 2016
			AND EXTENSION = 'R'
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
	    
		 JOIN
		[rev].[EPC_CODE_DISP] AS [Disposition_Code]
		ON
		[Disposition].[CODE_DISP_GU] = [Disposition_Code].[CODE_DISP_GU]
	    
		LEFT OUTER JOIN
		[rev].[EPC_STU_INC_VIOLATION] AS [Violation]
		ON
		[Discipline].[SCH_INCIDENT_GU] = [Violation].[SCH_INCIDENT_GU]
	    
		LEFT OUTER JOIN
		[rev].[EPC_CODE_DISC] AS [Violation_Code]
		ON
		[Violation].[CODE_DISC_GU] = [Violation_Code].[CODE_DISC_GU]
		--JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ENROLLMENTS.GRADE

	WHERE 1 = 1
	--	[Disposition_Code].[DISP_CODE] IN ()
		--[Violation_Code].[DESCRIPTION] LIKE '%BULLY%'
		AND (disposition_code.STATE_CODE IN ('2','3','4','5')  OR [Disposition_Code].[DESCRIPTION] = 'Referral: Arrest/Legal/Justice System')
		--AND Violation_Code IN ('S OSS','S ISS')
	    AND SCHOOL_CODE IN ('496','416','413','420','427','450','425','492','457','465','475','448')
	    AND GRADE IN ('06','07','08')
) T1
--WHERE SIS_NUMBER = '104465794'
		ORDER BY SCHOOL_NAME, disp_state_code
