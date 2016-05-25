




	SELECT DISTINCT
		[ENROLLMENTS].[SCHOOL_YEAR]
		,[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[ENROLLMENTS].[GRADE]
		,[STUDENT].[GENDER]
		,[STUDENT].[ELL_STATUS]
		,[STUDENT].[SPED_STATUS]
		
		,[INCIDENT].[INCIDENT_DATE]
		,[INCIDENT].[INCIDENT_ID]
		
		,[Disposition].[DISPOSITION_DATE]
		,[Disposition].[DISPOSITION_ID]
		,[Discipline].[DAYS]
		,[Disposition_Code].[DISP_CODE]
		,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
		,[Disposition].[REASSIGNMENT_DAYS]
		,[Disposition].[DISPOSITION_START_DATE]
		,[Disposition].[DISPOSITION_END_DATE]
		
		
		,[Violation].[VIOLATION_ID]
		,[Violation_Code].[DISC_CODE]
		,[Violation_Code].[DESCRIPTION] AS [VIOLATION_DESCRIPTION]
		--,[Violation].[SEVERITY_LEVEL]
		,[Violation_Code].[SEVERITY_LEVEL]
		
		--,[Violation].*
		--,[INCIDENT].*
		--,[Violation_Code].*
		
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
			SCHOOL_YEAR = 2014
			AND EXTENSION = 'R'
			--AND EXCLUDE_ADA_ADM IS NULL
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
	    
		LEFT OUTER JOIN
		[rev].[EPC_STU_INC_VIOLATION] AS [Violation]
		ON
		[Discipline].[SCH_INCIDENT_GU] = [Violation].[SCH_INCIDENT_GU]
	    
		LEFT OUTER JOIN
		[rev].[EPC_CODE_DISC] AS [Violation_Code]
		ON
		[Violation].[CODE_DISC_GU] = [Violation_Code].[CODE_DISC_GU]
		
	WHERE
	--	[Disposition_Code].[DISP_CODE] IN ()
		--[Violation_Code].[DESCRIPTION] LIKE '%BULLY%'
		[Violation_Code].[DISC_CODE] IN ('12', '1EXTO', '1HRDS', '2BLG')
		