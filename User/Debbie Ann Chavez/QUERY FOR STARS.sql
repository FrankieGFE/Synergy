

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
    [Year].[SCHOOL_YEAR]
	,[SE].[STUDENT ID] AS STATE_ID
	,SIS_NUMBER
    ,ORGANIZATION_NAME
    ,[Year].[EXTENSION]
    ,[SSY].[ENTER_DATE]
    ,[SSY].[ENTER_CODE]
    ,[SSY].[LEAVE_DATE]
    ,[SSY].[LEAVE_CODE]
	,LU.ALT_CODE_2 AS STATE_LEAVE_CODE
	,SSY.SUMMER_WITHDRAWL_CODE
	,SSY.SUMMER_WITHDRAWL_DATE


FROM
    OPENROWSET( 'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from Student.txt'
         ) AS [SE]

    LEFT HASH JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [SE].[STUDENT ID]=[Student].[STATE_STUDENT_NUMBER]

    LEFT HASH JOIN
    (
         SELECT
              [SSY].*
              ,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY SCHOOL_YEAR DESC, [ENTER_DATE] DESC, [EXCLUDE_ADA_ADM]) AS [RN]
         FROM
              [rev].[EPC_STU_SCH_YR] AS [SSY]

              INNER HASH JOIN
              [rev].[REV_YEAR] AS [Year]
              ON
              [SSY].[YEAR_GU]=[Year].[YEAR_GU]
			  AND EXTENSION != 'S'

         WHERE
              --[SSY].[EXCLUDE_ADA_ADM] IS NULL
              ([Year].[SCHOOL_YEAR]<=2014)

    ) AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
    AND [SSY].[RN]=1

    LEFT HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]

	LEFT JOIN
	rev.REV_ORGANIZATION_YEAR AS ORGYR
	ON
	SSY.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU

	LEFT JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	LEFT JOIN
	APS.LookupTable ('K12', 'LEAVE_CODE') AS LU
	ON
	SSY.LEAVE_CODE = LU.VALUE_CODE


ORDER BY 
SCHOOL_YEAR, ORGANIZATION_NAME, SIS_NUMBER

REVERT
GO
