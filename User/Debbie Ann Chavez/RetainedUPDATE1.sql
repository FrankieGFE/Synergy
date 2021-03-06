

SELECT 
	SIS_NUMBER
	,SSY.YEAR_END_STATUS
	,SSY.FTE
	,[GradeLevels].VALUE_DESCRIPTION AS GRADE
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
    --AND ([SSY].[YEAR_END_STATUS] IS NULL OR [SSY].[YEAR_END_STATUS]='')
	AND [SSY].[YEAR_END_STATUS]!='G'
    AND ([SSY].[GRADE] IN (050,070,090,100,110,120,130,140,150,160,170,180)
	    OR [Org].[ORGANIZATION_GU] IN ('0B9510E9-6BA2-4E6C-9737-4BD2B162110A','4758136F-B2B7-4001-ABDD-EC37FE7C0FFD','E9F3BA05-A345-4A12-938B-61C8BFF669DE')
	   )
