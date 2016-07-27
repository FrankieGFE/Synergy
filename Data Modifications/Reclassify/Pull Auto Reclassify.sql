BEGIN TRANSACTION


/**********************************************************************************************************************************************	
 --This is the Basic Pull which calculates Expected Credits and tags which students should be RETAINED
 --This pulls CURRENT YEAR ACTIVE PRIMARY ENROLLMENTS IN GRADES 9-12 AND NOT AT ALTERNATIVE SCHOOLS
************************************************************************************************************************************************/
/*
SELECT
    [Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Student].[SIS_NUMBER]
    ,[Org].[ORGANIZATION_NAME]
	,YEAR_END_STATUS
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
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2015 AND EXTENSION='R')
   AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910', '022', '611', '848')
*/

/**********************************************************************************************************************************************	
 --first update--
	THIS WILL UPDATE CURRENT YEAR ACTIVE PRIMARY ENROLLMENTS IN GRADES PK-8th GRADE 
	OR AT: eCADEMY, Career Enrichment Center, eCademy Virtual
	THIS WILL UPDATE:  YEAR END STATUS = P 
						FTE = 1.00
	*** NOT NEEDED FOR 2015-2016 ***
************************************************************************************************************************************************/
/*
UPDATE
    [SSY]

    SET
    [SSY].[YEAR_END_STATUS]='P' --promoted
    ,[SSY].[FTE]=1.00 --they said this doesn't matter, but just for good measure.

--SELECT 
--	SIS_NUMBER
--	,SSY.YEAR_END_STATUS
--	,SSY.FTE
--	,[GradeLevels].VALUE_DESCRIPTION AS GRADE
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

	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	SSY.STUDENT_GU = STU.STUDENT_GU

	INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [GradeLevels]
    ON
    [SSY].[GRADE]=[GradeLevels].[VALUE_CODE]

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND ([SSY].[YEAR_END_STATUS] IS NULL OR [SSY].[YEAR_END_STATUS]='')
    AND ([SSY].[GRADE] IN (050,070,090,100,110,120,130,140,150,160,170,180)
	    OR [Org].[ORGANIZATION_GU] IN ('0B9510E9-6BA2-4E6C-9737-4BD2B162110A','4758136F-B2B7-4001-ABDD-EC37FE7C0FFD','E9F3BA05-A345-4A12-938B-61C8BFF669DE')
	   )
*/

/**********************************************************************************************************************************************	
--- 2nd update
	For students that will be retained this updates to keep their same grade level in the Next Grade field 
	and updates the Year End status to an R for retained.
	
	This is pulling 09-12th grade only
	This skips the Alternative schools:  '048','058','188','592','597','598','846','847','901','910'
	This is also skipping students that have a ‘G’ in the Year End Status field.
	This updates only students that have an ‘X’ in the Retained column.  

	THIS WILL UPDATE:   NEXT_GRADE_LEVEL
						YEAR_END_STATUS 
						FTE 	
************************************************************************************************************************************************/

UPDATE
    [SSY]

    SET
    [SSY].[NEXT_GRADE_LEVEL]=CASE WHEN [Retained].[Retain]='X' THEN [SSY].[GRADE] ELSE [SSY].[NEXT_GRADE_LEVEL] END
    ,[SSY].[YEAR_END_STATUS]=CASE WHEN [Retained].[Retain]='X' THEN 'R' ELSE [SSY].[YEAR_END_STATUS] END
    ,[SSY].[FTE]=1.00
/*
SELECT 
Retained.SIS_NUMBER
,[SSY].[NEXT_GRADE_LEVEL]
,[SSY].[YEAR_END_STATUS]
,[SSY].[FTE]
*/
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

    INNER JOIN
    (
	   SELECT
    SSY.STUDENT_SCHOOL_YEAR_GU
	,[Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Student].[SIS_NUMBER]
    ,[Org].[ORGANIZATION_NAME]
	,YEAR_END_STATUS
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
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2015 AND EXTENSION='R')
    AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910', '022', '611', '848')
    ) AS [Retained]
    ON
    [SSY].[STUDENT_SCHOOL_YEAR_GU]=[Retained].[STUDENT_SCHOOL_YEAR_GU]
	 AND RETAINED.Retain = 'X'

/**********************************************************************************************************************************************	
--- 3rd update
--UPDATE 2016-17 previous year end status	
************************************************************************************************************************************************/


UPDATE
   [SSY2]

    SET
    [SSY2].[PREVIOUS_YEAR_END_STATUS]=[SSY].[YEAR_END_STATUS] --promoted
    ,[SSY2].[FTE]=1.00 --they said this doesn't matter, but just for good measure.

/*
SELECT 
[SSY2].[PREVIOUS_YEAR_END_STATUS]
,[SSY2].[FTE]
,STU.SIS_NUMBER
,SSY.YEAR_END_STATUS
*/
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]

	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	SSY.STUDENT_GU = STU.STUDENT_GU

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
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY2].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2016 AND [EXTENSION]='R')
    AND [SSY2].[STATUS] IS NULL
    AND [SSY2].[EXCLUDE_ADA_ADM] IS NULL




--4th update
/*
UPDATE
    [SSY]

    SET
    [SSY].[NEXT_GRADE_LEVEL]=[SSY].[GRADE]

SELECT 
	[SSY].[NEXT_GRADE_LEVEL]
	,STU.SIS_NUMBER
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	SSY.STUDENT_GU = STU.STUDENT_GU

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210)
    AND [SSY].[YEAR_END_STATUS]='R'
*/


--5th Update	
/*
UPDATE
    [SSY]
    SET
    [NEXT_GRADE_LEVEL]=[SSY].[GRADE]+10


SELECT 
	[NEXT_GRADE_LEVEL]
	,STU.SIS_NUMBER
FROM
    [rev].[EPC_STU_SCH_YR] AS [SSY]
	INNER JOIN 
	rev.EPC_STU AS STU
	ON
	SSY.STUDENT_GU = STU.STUDENT_GU

WHERE
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210)
    AND [SSY].[YEAR_END_STATUS]='P'
*/


--6th update

UPDATE
    [SSY2]

    SET
    [SSY2].[GRADE]=[SSY].[GRADE]
	,FTE = 1.00

/*
SELECT 
[SSY2].[GRADE]
,[Student].SIS_NUMBER
*/

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
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2015 AND [EXTENSION]='R')
    AND [SSY2].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2016 AND [EXTENSION]='R')
    AND [SSY].[STATUS] IS NULL
    AND [SSY].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY2].[STATUS] IS NULL
    AND [SSY2].[EXCLUDE_ADA_ADM] IS NULL
    AND [SSY].[GRADE] IN (190,200,210,220)
    AND [SSY].[YEAR_END_STATUS]='R'


/*
--7th update
PRINT '--- UPDATING SETTING NEXT GRADE LEVEL'
UPDATE
    SSY

    SET
    SSY.[NEXT_GRADE_LEVEL]=SSY.[GRADE]
    ,SSY.[YEAR_END_STATUS]='R'


SELECT 
SSY.[NEXT_GRADE_LEVEL]
,SSY.[YEAR_END_STATUS]
,SIS_NUMBER
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
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2015 AND EXTENSION='R')
    AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910', '022', '611', '848')
) AS [Retain]
ON
[SSY].[STUDENT_GU]=[Retain].[STUDENT_GU]

WHERE
    [Retain].[Retain]='X'
    AND [Retain].[GRADE]!=[Retain].[NEXT_GRADE_LEVEL]

*/

-----SAME QUERY AS ABOVE, JUST TO SHOW RESULTS
-----

SELECT
    *
FROM
(
SELECT
    [Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Student].[SIS_NUMBER]
    ,[Org].[ORGANIZATION_NAME]
	,YEAR_END_STATUS
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
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2015 AND EXTENSION='R')
   AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910', '022', '611', '848')
) AS [Retain]

WHERE
    [Retain].[Retain]='X'

--COMMIT

ROLLBACK

