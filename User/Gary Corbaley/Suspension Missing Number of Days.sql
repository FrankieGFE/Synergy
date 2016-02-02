


SELECT
	*
FROM
	(
	SELECT
		[ENROLLMENTS].[SCHOOL_YEAR]
		,[ENROLLMENTS].[SCHOOL_CODE]
		--,[ENROLLMENTS].[SCHOOL_NAME]
		,[STUDENT].[SIS_NUMBER]
		--,[STUDENT].[FIRST_NAME]
		--,[STUDENT].[LAST_NAME]
		--,[ENROLLMENTS].[GRADE]
		--,[STUDENT].[GENDER]
		--,[STUDENT].[ELL_STATUS]
		--,[STUDENT].[SPED_STATUS]
		
		,[INCIDENT].[INCIDENT_DATE]
		,[INCIDENT].[INCIDENT_ID]
		
		,[Disposition].[DISPOSITION_DATE]
		,[Disposition].[DISPOSITION_ID]
		,[Disposition].[DISPOSITION_START_DATE]
		,[Disposition].[DISPOSITION_END_DATE]
		,[Discipline].[DAYS]
		--,[Disposition_Code].[DISP_CODE]
		--,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
		--,[Disposition].[REASSIGNMENT_DAYS]
		
		
		
		,[Violation].[VIOLATION_ID]
		,[Violation_Code].[DISC_CODE]
		,[Violation_Code].[DESCRIPTION] AS [VIOLATION_DESCRIPTION]
		--,[Violation].[SEVERITY_LEVEL]
		,[Violation_Code].[SEVERITY_LEVEL]
		
		--,[Violation].*
		--,[INCIDENT].*
		--,[Violation_Code].*
		
		,ROW_NUMBER() OVER (PARTITION BY [STUDENT].[SIS_NUMBER], [Disposition].[DISPOSITION_ID], [ENROLLMENTS].[SCHOOL_CODE] ORDER BY [Disposition].[DISPOSITION_START_DATE] DESC) AS RN
		
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
		[Disposition_Code].[DISP_CODE] IN ('S OSS','S ISS', 'S BUS', 'S EXTRA',  'ZH504LTS', 'ZHLTSCON', 'ZHLTSCV', 'ZHLTSNRS', 'ZHLTSOTH', 'ZHLTSVQP', 'ZHSPLTS', 'EXPEL', 'ZH504EXP', 'ZHSPEXP', 'ZHEXP1YR')
		--AND [Disposition].[DISPOSITION_START_DATE] IS NOT NULL
		--AND [Disposition].[DISPOSITION_END_DATE] != [Disposition].[DISPOSITION_START_DATE]
		--AND [Discipline].[DAYS] = 0
		
	) AS [DISPOSITION_DUPS]
	
	
	INNER JOIN
	(
	SELECT
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
		,[Disposition].[DISPOSITION_START_DATE]
		,[Disposition].[DISPOSITION_END_DATE]
		,[Discipline].[DAYS]
		,[Disposition_Code].[DISP_CODE]
		,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
		,[Disposition].[REASSIGNMENT_DAYS]
		
		
		
		,[Violation].[VIOLATION_ID]
		,[Violation_Code].[DISC_CODE]
		,[Violation_Code].[DESCRIPTION] AS [VIOLATION_DESCRIPTION]
		--,[Violation].[SEVERITY_LEVEL]
		,[Violation_Code].[SEVERITY_LEVEL]
		
		--,[Violation].*
		--,[INCIDENT].*
		--,[Violation_Code].*
		
		,ROW_NUMBER() OVER (PARTITION BY [Disposition].[DISPOSITION_ID], [ENROLLMENTS].[SCHOOL_CODE] ORDER BY [Disposition].[DISPOSITION_START_DATE] DESC) AS RN
		
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
		[Disposition_Code].[DISP_CODE] IN ('S OSS','S ISS', 'S BUS', 'S EXTRA',  'ZH504LTS', 'ZHLTSCON', 'ZHLTSCV', 'ZHLTSNRS', 'ZHLTSOTH', 'ZHLTSVQP', 'ZHSPLTS', 'EXPEL', 'ZH504EXP', 'ZHSPEXP', 'ZHEXP1YR')
		--AND [Disposition].[DISPOSITION_START_DATE] IS NOT NULL
		--AND [Disposition].[DISPOSITION_END_DATE] != [Disposition].[DISPOSITION_START_DATE]
		--AND [Discipline].[DAYS] = 0
	)
	AS [DISPOSITION_D]
		
WHERE
	[DISPOSITION_DUPS].[RN] = 2