BEGIN TRAN

EXECUTE AS LOGIN='QueryFileUser'
GO

--6E5C9F97-F075-4729-9801-F852F170CD0A --new school's guid
/*UPDATE
    [SSY]

    SET
    [SSY].[NEXT_SCHOOL_GU]='6E5C9F97-F075-4729-9801-F852F170CD0A'
    ,[SSY].[NEXT_GRADE_LEVEL]=[SSY].[GRADE]+10
    ,[SSY].[CHANGE_ID_STAMP]='D31C8E29-6CFB-43BB-B597-AA36480983F2'
    ,[SSY].[CHANGE_DATE_TIME_STAMP]=CAST(GETDATE() AS DATE)
/*
SELECT
    [Student].[SIS_NUMBER]
    ,[Student].[GRID_CODE]
    ,[GridCodeA].[SY1516_GridCode]
    ,[SSY].[NEXT_GRADE_LEVEL]
    ,[SSY].[NEXT_SCH_ATTEND]
    ,[SSY].[GRADE] */
FROM
    [rev].[EPC_STU] AS [Student]

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]

    INNER HASH JOIN
    (
    SELECT 
	   *
    FROM
	   OPENROWSET (
			 'Microsoft.ACE.OLEDB.12.0', 
			 'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\5thgrade.xlsx;', 
			 'SELECT * from [K thru 4th Grade$]'
	   )) AS [GridCodeA]

    ON
    [Student].[SIS_NUMBER]=[GridCodeA].[APS_STUID]

WHERE
    [Year].[SCHOOL_YEAR]=2014
    AND [Year].[EXTENSION]='R'

UPDATE
    [SSY]

    SET
    [SSY].[NEXT_SCHOOL_GU]='6E5C9F97-F075-4729-9801-F852F170CD0A'
    ,[SSY].[NEXT_GRADE_LEVEL]=[SSY].[GRADE]+10
    ,[SSY].[CHANGE_ID_STAMP]='D31C8E29-6CFB-43BB-B597-AA36480983F2'
    ,[SSY].[CHANGE_DATE_TIME_STAMP]=CAST(GETDATE() AS DATE)

    /*SELECT
	   [Student].[SIS_NUMBER]
	   ,[Student].[GRID_CODE]
	   ,[GridCodeB].[SY1516_GridCode]
	   ,[SSY].[NEXT_GRADE_LEVEL]
	   ,[SSY].[NEXT_SCH_ATTEND]
	   ,[SSY].[GRADE]*/
    FROM
	   [rev].[EPC_STU] AS [Student]
 
        INNER HASH JOIN
	   [rev].[EPC_STU_SCH_YR] AS [SSY]
	   ON
	   [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

	   INNER HASH JOIN
	   [rev].[REV_YEAR] AS [Year]
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]

	   INNER HASH JOIN
	   (
	   SELECT 
		  *
	   FROM
		  OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\5thgrade.xlsx;', 
				'SELECT * from [Grade5$]'
		  )) AS [GridCodeB]

	   ON
	   [Student].[SIS_NUMBER]=[GridCodeB].[APS_STUID]

    WHERE
	   [Year].[SCHOOL_YEAR]=2014
	   AND [Year].[EXTENSION]='R'*/

UPDATE
    [Student]

    SET
    [Student].[GRID_CODE]=CAST([GridCodeA].[SY1516_GridCode] AS DECIMAL(9,0))

/*
SELECT
    [Student].[SIS_NUMBER]
    ,[Student].[GRID_CODE]
    ,[GridCodeA].[SY1516_GridCode]
    ,[SSY].[NEXT_GRADE_LEVEL]
    ,[SSY].[NEXT_SCH_ATTEND]
    ,[SSY].[GRADE] */
FROM
    [rev].[EPC_STU] AS [Student]

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]

    INNER HASH JOIN
    (
    SELECT 
	   *
    FROM
	   OPENROWSET (
			 'Microsoft.ACE.OLEDB.12.0', 
			 'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\5thgrade.xlsx;', 
			 'SELECT * from [K thru 4th Grade$]'
	   )) AS [GridCodeA]

    ON
    [Student].[SIS_NUMBER]=[GridCodeA].[APS_STUID]

WHERE
    [Year].[SCHOOL_YEAR]=2015
    AND [Year].[EXTENSION]='R'

UPDATE
    [Student]

    SET
    [Student].[GRID_CODE]=CAST([GridCodeB].[SY1516_GridCode] AS DECIMAL(9,0))

    /*SELECT
	   [Student].[SIS_NUMBER]
	   ,[Student].[GRID_CODE]
	   ,[GridCodeB].[SY1516_GridCode]
	   ,[SSY].[NEXT_GRADE_LEVEL]
	   ,[SSY].[NEXT_SCH_ATTEND]
	   ,[SSY].[GRADE]*/
    FROM
	   [rev].[EPC_STU] AS [Student]
 
        INNER HASH JOIN
	   [rev].[EPC_STU_SCH_YR] AS [SSY]
	   ON
	   [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

	   INNER HASH JOIN
	   [rev].[REV_YEAR] AS [Year]
	   ON
	   [SSY].[YEAR_GU]=[Year].[YEAR_GU]

	   INNER HASH JOIN
	   (
	   SELECT 
		  *
	   FROM
		  OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\5thgrade.xlsx;', 
				'SELECT * from [Grade5$]'
		  )) AS [GridCodeB]

	   ON
	   [Student].[SIS_NUMBER]=[GridCodeB].[APS_STUID]

    WHERE
	   [Year].[SCHOOL_YEAR]=2015
	   AND [Year].[EXTENSION]='R'


SELECT
    [Student].[SIS_NUMBER]
    ,[Student].[GRID_CODE]
    ,[GridCodeA].[SY1516_GridCode]
    ,[SSY].[NEXT_GRADE_LEVEL]
    ,[SSY].[NEXT_SCHOOL_GU]
    ,[Grades].[VALUE_DESCRIPTION] AS [Grade]
FROM
    [rev].[EPC_STU] AS [Student]

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]

    INNER HASH JOIN
    (
    SELECT 
	   *
    FROM
	   OPENROWSET (
			 'Microsoft.ACE.OLEDB.12.0', 
			 'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\5thgrade.xlsx;', 
			 'SELECT * from [K thru 4th Grade$]'
	   )) AS [GridCodeA]

    ON
    [Student].[SIS_NUMBER]=[GridCodeA].[APS_STUID]

    INNER HASH JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [SSY].[GRADE]=[Grades].[VALUE_CODE]

WHERE
    [Year].[SCHOOL_YEAR]=2015
    AND [Year].[EXTENSION]='R'
    
UNION
SELECT
    [Student].[SIS_NUMBER]
    ,[Student].[GRID_CODE]
    ,[GridCodeB].[SY1516_GridCode]
    ,[SSY].[NEXT_GRADE_LEVEL]
    ,[SSY].[NEXT_SCHOOL_GU]
    ,[Grades].[VALUE_DESCRIPTION] AS [Grade]
FROM
    [rev].[EPC_STU] AS [Student]

    INNER HASH JOIN
    [rev].[EPC_STU_SCH_YR] AS [SSY]
    ON
    [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]

    INNER HASH JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SSY].[YEAR_GU]=[Year].[YEAR_GU]

    INNER HASH JOIN
    (
    SELECT 
	   *
    FROM
	   OPENROWSET (
			 'Microsoft.ACE.OLEDB.12.0', 
			 'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\5thgrade.xlsx;', 
			 'SELECT * from [Grade5$]'
	   )) AS [GridCodeB]

    ON
    [Student].[SIS_NUMBER]=[GridCodeB].[APS_STUID]

    INNER HASH JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [SSY].[GRADE]=[Grades].[VALUE_CODE]

WHERE
    [Year].[SCHOOL_YEAR]=2015
    AND [Year].[EXTENSION]='R'
    
REVERT
GO

ROLLBACK
