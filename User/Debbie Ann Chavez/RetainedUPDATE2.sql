
SELECT 
Retained.SIS_NUMBER
,[Retained].[GRADE]
,[Retained].[NEXT_GRADE_LEVEL]
,[SSY].GRADE
,[SSY].[NEXT_GRADE_LEVEL]
,[SSY].[YEAR_END_STATUS]
,[SSY].[FTE]
,[Retained].[Retain]
,CASE WHEN [Retained].[Retain]='X' THEN [SSY].[GRADE] ELSE [SSY].[NEXT_GRADE_LEVEL] END AS UPDATE_NEXT_GRADE_LEVEL
,CASE WHEN [Retained].[Retain]='X' THEN 'R' ELSE [SSY].[YEAR_END_STATUS] END AS UPDATE_YEAR_END_STATUS
,1.00 AS UPDATE_FTE
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER JOIN
    (
	   SELECT
		  [SSY].[STUDENT_SCHOOL_YEAR_GU]
		  ,[Person].[LAST_NAME]
		  ,[Person].[FIRST_NAME]
		  ,[Student].[SIS_NUMBER]
		  ,ISNULL([Credits].[Credits],0) AS [Credits]
		  ,CASE
			  WHEN [NextGrade].[VALUE_DESCRIPTION]='09' THEN '<6'
			  WHEN [NextGrade].[VALUE_DESCRIPTION]='10' THEN '6-12'
			  WHEN [NextGrade].[VALUE_DESCRIPTION]='11' THEN '13-18'
			  WHEN [NextGrade].[VALUE_DESCRIPTION]='12' THEN '>=19'
			  ELSE ''
		   END AS [Expected Credits]
		  ,[GradeLevels].[VALUE_DESCRIPTION] AS [GRADE]
		  ,ISNULL([NextGrade].[VALUE_DESCRIPTION],'') AS [NEXT_GRADE_LEVEL]
		  ,CASE
			 WHEN [GradeLevels].[VALUE_DESCRIPTION]='09' THEN 
				CASE WHEN [Credits].[Credits]<6 THEN 'X' 
				WHEN [Credits].[Credits] IS NULL THEN 'X'
				ELSE '' 
				END
			 WHEN [GradeLevels].[VALUE_DESCRIPTION]='10' THEN 
				CASE WHEN [Credits].[Credits]<13 THEN 'X' 
				WHEN [Credits].[Credits] IS NULL THEN 'X'
				ELSE '' 
			 END
			 WHEN [GradeLevels].[VALUE_DESCRIPTION]='11' THEN 
				CASE WHEN [Credits].[Credits]<19 THEN 'X'
				WHEN [Credits].[Credits] IS NULL THEN 'X'
				ELSE '' 
			 END
			 WHEN [GradeLevels].[VALUE_DESCRIPTION]='12' THEN 
				CASE WHEN [Credits].[Credits]<19 THEN 'X' 
				WHEN [Credits].[Credits] IS NULL THEN 'X'
				ELSE '' 
			 END
			 ELSE ''
		   END AS [Retain]
		  ,[Student].[EXPECTED_GRADUATION_YEAR]
	
	   FROM
		  [rev].[EPC_STU] AS [Student]

		  INNER JOIN
		  [rev].[EPC_STU_SCH_YR] AS [SSY]
		  ON
		  [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
		  AND
		  [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
		  AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
		  AND [SSY].[STATUS] IS NULL

		  INNER JOIN
		  [rev].[REV_PERSON] AS [Person]
		  ON
		  [Student].[STUDENT_GU]=[Person].[PERSON_GU]

		  LEFT JOIN
		  (
			 SELECT
				[STUDENT_GU]
				,SUM([CREDIT_COMPLETED]) AS [Credits]
			 FROM
				rev.EPC_STU_CRS_HIS

			 WHERE
				[COURSE_HISTORY_TYPE]='HIGH'

			 GROUP BY
				[STUDENT_GU]
		  ) AS [Credits]
		  ON
		  [SSY].[STUDENT_GU]=[Credits].[STUDENT_GU]

		  INNER JOIN
		  [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
		  ON
		  [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

		  INNER JOIN
		  [rev].[REV_ORGANIZATION] AS [Org]
		  ON
		  [OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

		  INNER JOIN
		  [rev].[EPC_SCH] AS [School]
		  ON
		  [Org].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

		  LEFT JOIN
		  [APS].[LookupTable]('K12','GRADE') AS [GradeLevels]
		  ON
		  [SSY].[GRADE]=[GradeLevels].[VALUE_CODE]

		  LEFT JOIN
		  [APS].[LookupTable]('K12','GRADE') AS [NextGrade]
		  ON
		  [SSY].[NEXT_GRADE_LEVEL]=[NextGrade].[VALUE_CODE]

	   WHERE
		  [GradeLevels].[VALUE_DESCRIPTION] IN ('09','10','11','12')
		  --AND [Student].[SIS_NUMBER]=970113129
		  AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910')
    ) AS [Retained]
    ON
    [SSY].[STUDENT_SCHOOL_YEAR_GU]=[Retained].[STUDENT_SCHOOL_YEAR_GU]
	 	  AND RETAINED.Retain = 'X'
    --AND ([SSY].[YEAR_END_STATUS] IS NULL OR [SSY].[YEAR_END_STATUS]='')