BEGIN TRAN

SELECT
    [Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Student].[SIS_NUMBER]
    ,[Org].[ORGANIZATION_NAME]
    ,ISNULL([Credits].[Credits],0) AS [Credits]
    ,CASE
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='09' THEN '<6'
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='10' THEN '6-12.99999'
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='11' THEN '13-18.99999'
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
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
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
		  rev.EPC_STU_CRS_HIS AS [Cred]

	   LEFT JOIN
	   [rev].[EPC_REPEAT_TAG] AS [Repeat]
	   ON
	   [Cred].[REPEAT_TAG_GU]=[Repeat].[REPEAT_TAG_GU]

	   WHERE
		  [Cred].[COURSE_HISTORY_TYPE]='HIGH'
		  AND ISNULL([Repeat].[REPEAT_CODE],'')!='R'

	   GROUP BY
		  [Cred].[STUDENT_GU]
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
    [SSY].[GRADE] IN (190,200,210,220)
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND ISNULL([SSY].[YEAR_END_STATUS],'')=''
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2014 AND EXTENSION='S')
    AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910')
 
UPDATE
    [SSY]

    SET
    [SSY].[YEAR_END_STATUS]='P' --promoted
    ,[SSY].[FTE]=1.00 --they said this doesn't matter, but just for good measure.

FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [Org]
    ON
    [OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND ([SSY].[YEAR_END_STATUS] IS NULL OR [SSY].[YEAR_END_STATUS]='')
    AND ([SSY].[GRADE] IN (050,070,090,100,110,120,130,140,150,160,170,180)
	    OR [Org].[ORGANIZATION_GU] IN ('0B9510E9-6BA2-4E6C-9737-4BD2B162110A','4758136F-B2B7-4001-ABDD-EC37FE7C0FFD','E9F3BA05-A345-4A12-938B-61C8BFF669DE')
	   )

UPDATE
    [SSY]

    SET
    [SSY].[NEXT_GRADE_LEVEL]=CASE WHEN [Retained].[Retain]='X' THEN [SSY].[GRADE] ELSE [SSY].[NEXT_GRADE_LEVEL] END
    ,[SSY].[YEAR_END_STATUS]=CASE WHEN [Retained].[Retain]='X' THEN 'R' ELSE 'P' END
    ,[SSY].[FTE]=1.00

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
		  [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
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
    AND ([SSY].[YEAR_END_STATUS] IS NULL OR [SSY].[YEAR_END_STATUS]='')


--UPDATE 2015-16 previous year end status
UPDATE
    [SSY2]

    SET
    [SSY2].[PREVIOUS_YEAR_END_STATUS]=[SSY].[YEAR_END_STATUS] --promoted
    ,[SSY2].[FTE]=1.00 --they said this doesn't matter, but just for good measure.

FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [Org]
    ON
    [OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

    LEFT JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY2]
    ON
    [SSY].[STUDENT_GU]=[SSY2].[STUDENT_GU]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
    AND [SSY2].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY2].[STATUS] IS NULL
    AND [SSY2].[EXCLUDE_ADA_ADM] IS NULL
    AND ([SSY2].[PREVIOUS_YEAR_END_STATUS] IS NULL OR [SSY2].[PREVIOUS_YEAR_END_STATUS]='')

UPDATE
    [SSY]

    SET
    [SSY].[NEXT_GRADE_LEVEL]=[SSY].[GRADE]

FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='R')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210)
    AND [SSY].[YEAR_END_STATUS]='R'

UPDATE
    [SSY]

    SET
    [NEXT_GRADE_LEVEL]=[SSY].[GRADE]+10
	
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210)
    AND [SSY].[YEAR_END_STATUS]='P'

/*PRINT '--- UPDATING DIPLOMA TYPES'
UPDATE
    [Student]

    SET
    [DIPLOMA_TYPE]='01'
	
FROM
    [rev].[EPC_STU] AS [Student]
	
	INNER HASH JOIN
	[rev].[EPC_STU_SCH_YR] AS [SSY]
	ON
	[Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210,220)
	AND [Student].[DIPLOMA_TYPE] IS NULL
    --AND [SSY].[YEAR_END_STATUS]='P'
*/

UPDATE
    [SSY2]

    SET
    [SSY2].[GRADE]=[SSY].[GRADE]

FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [SSY].[STUDENT_GU]=[Student].[STUDENT_GU]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY2]
    ON
    [SSY].[STUDENT_GU]=[SSY2].[STUDENT_GU]
    
    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Levels]
    ON
    [SSY2].[GRADE]=[Levels].[VALUE_CODE]


WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
    AND [SSY2].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY2].[STATUS] IS NULL
    AND [SSY2].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210,220)
    AND [SSY].[YEAR_END_STATUS]='R'

PRINT '--- UPDATING SETTING NEXT GRADE LEVEL'
UPDATE
    SSY

    SET
    SSY.[NEXT_GRADE_LEVEL]=SSY.[GRADE]
    ,SSY.[YEAR_END_STATUS]='R'

FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER JOIN
(
SELECT
    [Student].[STUDENT_GU]
    ,[Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Student].[SIS_NUMBER]
    ,[Org].[ORGANIZATION_NAME]
    ,ISNULL([Credits].[Credits],0) AS [Credits]
    ,CASE
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='09' THEN '<6'
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='10' THEN '6-12.9999'
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='11' THEN '13-18.9999'
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
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
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
		  rev.EPC_STU_CRS_HIS AS [Cred]

	   LEFT JOIN
	   [rev].[EPC_REPEAT_TAG] AS [Repeat]
	   ON
	   [Cred].[REPEAT_TAG_GU]=[Repeat].[REPEAT_TAG_GU]

	   WHERE
		  [Cred].[COURSE_HISTORY_TYPE]='HIGH'
		  AND ISNULL([Repeat].[REPEAT_CODE],'')!='R'

	   GROUP BY
		  [Cred].[STUDENT_GU]
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
    [SSY].[GRADE] IN (190,200,210,220)
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND ISNULL([SSY].[YEAR_END_STATUS],'')!='G'
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2014 AND EXTENSION='S')
    AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','517','592','597','598','846','847','901','910')
) AS [Retain]
ON
[SSY].[STUDENT_GU]=[Retain].[STUDENT_GU]

WHERE
    [Retain].[Retain]='X'
    AND [Retain].[GRADE]!=[Retain].[NEXT_GRADE_LEVEL]

SELECT
    *
FROM
(
SELECT
    [Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Student].[SIS_NUMBER]
    ,[Org].[ORGANIZATION_NAME]
    ,ISNULL([Credits].[Credits],0) AS [Credits]
    ,CASE
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='09' THEN '<6'
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='10' THEN '6-12.9999'
	    WHEN [NextGrade].[VALUE_DESCRIPTION]='11' THEN '13-18.9999'
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
	,[Student].[DIPLOMA_TYPE]
FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
    AND
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2014 AND [EXTENSION]='S')
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
		  rev.EPC_STU_CRS_HIS AS [Cred]

	   LEFT JOIN
	   [rev].[EPC_REPEAT_TAG] AS [Repeat]
	   ON
	   [Cred].[REPEAT_TAG_GU]=[Repeat].[REPEAT_TAG_GU]

	   WHERE
		  [Cred].[COURSE_HISTORY_TYPE]='HIGH'
		  AND ISNULL([Repeat].[REPEAT_CODE],'')!='R'

	   GROUP BY
		  [Cred].[STUDENT_GU]
    ) AS [Credits]
    ON
    [SSY].[STUDENT_GU]=[Credits].[STUDENT_GU]

    LEFT JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY2]
    ON
    [Student].[STUDENT_GU]=[SSY2].[STUDENT_GU]
    AND [SSY2].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')

    LEFT JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [SSY2].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    LEFT JOIN
    [rev].[REV_ORGANIZATION] AS [Org]
    ON
    [OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

    LEFT JOIN
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
    [SSY].[GRADE] IN (190,200,210,220)
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND ISNULL([SSY].[YEAR_END_STATUS],'')!='G'
    AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910')
) AS [Retain]

WHERE
    [Retain].[Retain]='X'

ROLLBACK
