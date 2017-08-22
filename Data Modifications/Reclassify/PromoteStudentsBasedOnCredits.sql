/*************** COMMENT THIS OUT FOR DETAILS BELOW   *******************/


BEGIN TRANSACTION 

UPDATE rev.EPC_STU_SCH_YR 
SET GRADE = NEW_GRADE 
	-- NOT NEEDED IN JANUARY, NYR WILL CREATE
	--,NEXT_GRADE_LEVEL = NEXT_GRADE_LEVEL_CODE
/**/


--SELECT * 
--  COMMENT OUT TO HERE FOR UPDATE



-------------------------------------------------------------------------------------------
FROM 
	 (
SELECT EVERYTHING.*, [NewGrade].VALUE_DESCRIPTION AS NEW_PRETTY_GRADE 

-- THIS IS NOT NEEDED NOW IN JANUARY, NYR CREATES THIS:  

	--NewGrade.ALT_CODE_SIF AS NEW_NEXT_GRADE
	--,[NewNextGrade].VALUE_CODE AS NEXT_GRADE_LEVEL_CODE

FROM (

SELECT *

			-- WE NEED TO CHANGE THE LOGIC TO RETAIN STUDENTS IN SAME GRAD YEAR - DO NOT PROMOTE THEM BEYOND
,
			CASE WHEN SSY_GRADE = 190 AND EXPECTED_GRADUATION_YEAR >=2019 THEN 200
				 WHEN SSY_GRADE = 200 AND EXPECTED_GRADUATION_YEAR >=2019 THEN 210
				 WHEN SSY_GRADE = 210 AND EXPECTED_GRADUATION_YEAR <2019 THEN 220
			ELSE ''
		END AS NEW_GRADE 

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
	    WHEN [GradeLevels].[VALUE_DESCRIPTION]='09' THEN '<6'  
	    WHEN [GradeLevels].[VALUE_DESCRIPTION]='10' THEN '6-12.99999'
	    WHEN [GradeLevels].[VALUE_DESCRIPTION]='11' THEN '13-18.99999'
	    WHEN [GradeLevels].[VALUE_DESCRIPTION]='12' THEN '>=19'
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
	,SSY.STUDENT_SCHOOL_YEAR_GU
	,SSY.GRADE AS SSY_GRADE

FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
    AND
    [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2017 AND [EXTENSION]='R')
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
    AND [SSY].[YEAR_GU]=(SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE SCHOOL_YEAR=2017 AND EXTENSION='R')
   AND [School].[SCHOOL_CODE] NOT IN ('048','058','188','592','597','598','846','847','901','910', '022', '611', '848')
   ) AS DETAILS
    WHERE
   [Retain] = ''
) AS EVERYTHING

   LEFT JOIN
    [APS].[LookupTable]('K12','GRADE') AS [NewGrade]
    ON
    EVERYTHING.NEW_GRADE=[NewGrade].[VALUE_CODE]

	LEFT JOIN
    [APS].[LookupTable]('K12','GRADE') AS [NewNextGrade]
    ON
    [NewGrade].[ALT_CODE_SIF] = NewNextGrade.VALUE_DESCRIPTION


WHERE 
NEW_GRADE != 0

) AS UPDATEME


/**** COMMENT THIS OUT FOR DETAILS ABOVE ***
*/
WHERE
UPDATEME.STUDENT_SCHOOL_YEAR_GU = rev.EPC_STU_SCH_YR.STUDENT_SCHOOL_YEAR_GU



COMMIT