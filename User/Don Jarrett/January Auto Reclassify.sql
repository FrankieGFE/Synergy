EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN

SELECT
	[OldFile].[LAST_NAME]
	,[OldFile].[FIRST_NAME]
	,[OldFile].[SIS_NUMBER]
	,[Org].[ORGANIZATION_NAME] AS [School]
	,[GradeLevels].[VALUE_DESCRIPTION] AS [Grade]
	,CASE
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='09' THEN
				CASE WHEN [Credits].[Credits]<6 THEN '09'
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN '10'
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN '11'
					 WHEN [Credits].[Credits]>=19 THEN '12'
				END
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='10' THEN
				CASE WHEN [Credits].[Credits]<6 THEN '10'
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN '10'
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN '11'
					 WHEN [Credits].[Credits]>=19 THEN '12'
				END				
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='11' THEN
				CASE WHEN [Credits].[Credits]<6 THEN '11'
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN '11'
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN '11'
					 WHEN [Credits].[Credits]>=19 THEN '12'
				END
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='12' THEN
				CASE WHEN [Credits].[Credits]<6 THEN '12'
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN '12'
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN '12'
					 WHEN [Credits].[Credits]>=19 THEN '12'
				END
			END AS [New Grade]
	,ISNULL([Credits].[Credits],0) AS [Credits]
    ,CASE
	    WHEN [NextGradeLevels].[VALUE_DESCRIPTION]='09' THEN '<6'
	    WHEN [NextGradeLevels].[VALUE_DESCRIPTION]='10' THEN '6-12.99999'
	    WHEN [NextGradeLevels].[VALUE_DESCRIPTION]='11' THEN '13-18.99999'
	    WHEN [NextGradeLevels].[VALUE_DESCRIPTION]='12' THEN '>=19'
	    ELSE ''
     END AS [Expected Credits]
    ,CASE
	   WHEN [GradeLevels].[VALUE_DESCRIPTION]='09' THEN 
		  CASE WHEN [Credits].[Credits]<6 THEN '' 
		  WHEN [Credits].[Credits] IS NULL THEN ''
		  ELSE 'P' 
		  END
	   WHEN [GradeLevels].[VALUE_DESCRIPTION]='10' THEN 
		  CASE WHEN [Credits].[Credits]<13 THEN '' 
		  WHEN [Credits].[Credits] IS NULL THEN ''
		  ELSE 'P' 
	   END
	   WHEN [GradeLevels].[VALUE_DESCRIPTION]='11' THEN 
		  CASE WHEN [Credits].[Credits]<19 THEN ''
		  WHEN [Credits].[Credits] IS NULL THEN ''
		  ELSE 'P' 
	   END
	   WHEN [GradeLevels].[VALUE_DESCRIPTION]='12' THEN 
		  CASE WHEN [Credits].[Credits]<19 THEN '' 
		  WHEN [Credits].[Credits] IS NULL THEN ''
		  ELSE '' 
	   END
	   ELSE ''
	END AS [Reclass]
	,[stu].[EXPECTED_GRADUATION_YEAR] AS [Expected Graduation Year]
	,[stu].[DIPLOMA_TYPE] AS [Diploma Type]
FROM
(
SELECT
	[LAST_NAME]
	,[FIRST_NAME]
	,[SIS_NUMBER]
FROM
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\STU-1408 Auto-Reclassify List Post SS 2014.xlsx', 'SELECT * FROM [Sheet1$]')
UNION
SELECT
	[LAST_NAME]
	,[FIRST_NAME]
	,[SIS_NUMBER]
FROM
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\STU-1408 Auto-Reclassify List Pre SS 2014.xlsx', 'SELECT * FROM [Sheet1$]')
) AS [OldFile]

		INNER JOIN
		[rev].[EPC_STU] AS [stu]
		ON
		[OldFile].[SIS_NUMBER]=[stu].[SIS_NUMBER]

		INNER JOIN
		[rev].[EPC_STU_SCH_YR] AS [ssy]
		ON
		[stu].[STUDENT_GU]=[ssy].[STUDENT_GU]
		AND [ssy].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')

		LEFT JOIN
		(
			SELECT
			[crs].[STUDENT_GU]
			,SUM([crs].[CREDIT_COMPLETED]) AS [Credits]
			FROM
			rev.EPC_STU_CRS_HIS AS [crs]

			LEFT JOIN
			[rev].[EPC_REPEAT_TAG] AS [rpt]
			ON
			[crs].[REPEAT_TAG_GU]=[rpt].[REPEAT_TAG_GU]

			WHERE
			[crs].[COURSE_HISTORY_TYPE]='HIGH'
			AND ISNULL([rpt].[REPEAT_CODE],'')!='R'

			GROUP BY
			[crs].[STUDENT_GU]
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
		[APS].[LookupTable]('K12','GRADE') AS [NextGradeLevels]
		ON
		CASE WHEN [SSY].[GRADE]=220 THEN 220 ELSE [SSY].[GRADE]+10 END=[NextGradeLevels].[VALUE_CODE]

WHERE
	[School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910')
    AND [ssy].[GRADE] IN (190,200,210,220)
    AND [ssy].[STATUS] IS NULL
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL
    AND ISNULL([ssy].[YEAR_END_STATUS],'')=''


UPDATE
	[ssy]

	SET
		[ssy].[GRADE]=CASE
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='09' THEN
				CASE WHEN [Credits].[Credits]<6 THEN 190
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN 200
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN 210
					 WHEN [Credits].[Credits]>=19 THEN 220
				END
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='10' THEN
				CASE WHEN [Credits].[Credits]<6 THEN 200
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN 200
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN 210
					 WHEN [Credits].[Credits]>=19 THEN 220
				END				
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='11' THEN
				CASE WHEN [Credits].[Credits]<6 THEN 210
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN 210
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN 210
					 WHEN [Credits].[Credits]>=19 THEN 220
				END
			WHEN [GradeLevels].[VALUE_DESCRIPTION]='12' THEN
				CASE WHEN [Credits].[Credits]<6 THEN 220
					 WHEN [Credits].[Credits]>=6 AND [Credits].[Credits]<13 THEN 220
					 WHEN [Credits].[Credits]>=13 AND [Credits].[Credits]<19 THEN 220
					 WHEN [Credits].[Credits]>=19 THEN 220
				END
			END
FROM
(
SELECT
	[LAST_NAME]
	,[FIRST_NAME]
	,[SIS_NUMBER]
FROM
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\STU-1408 Auto-Reclassify List Post SS 2014.xlsx', 'SELECT * FROM [Sheet1$]')
UNION
SELECT
	[LAST_NAME]
	,[FIRST_NAME]
	,[SIS_NUMBER]
FROM
	   OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; 
				HDR=YES; IMEX=1; Database=\\syntempssis.aps.edu.actd\Files\TempQuery\STU-1408 Auto-Reclassify List Pre SS 2014.xlsx', 'SELECT * FROM [Sheet1$]')
) AS [OldFile]

		INNER JOIN
		[rev].[EPC_STU] AS [stu]
		ON
		[OldFile].[SIS_NUMBER]=[stu].[SIS_NUMBER]

		INNER JOIN
		[rev].[EPC_STU_SCH_YR] AS [ssy]
		ON
		[stu].[STUDENT_GU]=[ssy].[STUDENT_GU]
		AND [ssy].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')

		LEFT JOIN
		(
			SELECT
			[crs].[STUDENT_GU]
			,SUM([crs].[CREDIT_COMPLETED]) AS [Credits]
			FROM
			rev.EPC_STU_CRS_HIS AS [crs]

			LEFT JOIN
			[rev].[EPC_REPEAT_TAG] AS [rpt]
			ON
			[crs].[REPEAT_TAG_GU]=[rpt].[REPEAT_TAG_GU]

			WHERE
			[crs].[COURSE_HISTORY_TYPE]='HIGH'
			AND ISNULL([rpt].[REPEAT_CODE],'')!='R'

			GROUP BY
			[crs].[STUDENT_GU]
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
		[APS].[LookupTable]('K12','GRADE') AS [NextGradeLevels]
		ON
		CASE WHEN [SSY].[GRADE]=220 THEN 220 ELSE [SSY].[GRADE]+10 END=[NextGradeLevels].[VALUE_CODE]

WHERE
	[School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910')
    AND [ssy].[GRADE] IN (190,200,210,220)
    AND [ssy].[STATUS] IS NULL
    AND [ssy].[EXCLUDE_ADA_ADM] IS NULL
    AND ISNULL([ssy].[YEAR_END_STATUS],'')=''


COMMIT

REVERT
GO