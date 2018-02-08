



;WITH 
Qry_DCM (COURSE_GU,COURSE_ID,COURSE_TITLE,CREDIT) AS
(
SELECT 
    COURSE_GU
    ,COURSE_ID
    ,COURSE_TITLE
    ,CREDIT 
FROM 
    rev.EPC_CRS
)
,Qry_SchoolMaster (ORGANIZATION_GU,ORGANIZATION_YEAR_GU,YEAR_GU,COURSE_GU,SECTION_GU,SCHOOL_YEAR
,ORGANIZATION_NAME,SCHOOL_CODE,COURSE_ID,COURSE_TITLE,SECTION_ID,CREDIT) AS
(
    SELECT
	   [ORG].[ORGANIZATION_GU]
	   ,[ORGYEAR].[ORGANIZATION_YEAR_GU]
	   ,[YEAR].[YEAR_GU]
	   ,[CRS].[COURSE_GU]
	   ,[SCHYRSECT].[SECTION_GU]
	   ,[YEAR].[SCHOOL_YEAR]
	   ,[ORG].[ORGANIZATION_NAME]
	   ,[SCH].[SCHOOL_CODE]
	   ,[CRS].[COURSE_ID]
	   ,[CRS].[COURSE_TITLE]
	   ,[SCHYRSECT].[SECTION_ID]
	   ,[SCHYRSECT].[CREDIT]
    FROM
	   [rev].[EPC_CRS] AS [CRS]

	   INNER JOIN
	   [rev].[EPC_SCH_YR_CRS] AS [SCHYRCRS]
	   ON
	   [CRS].[COURSE_GU]=[SCHYRCRS].[COURSE_GU]

	   INNER JOIN
	   [rev].[EPC_SCH_YR_SECT] AS [SCHYRSECT]
	   ON
	   [SCHYRCRS].[SCHOOL_YEAR_COURSE_GU]=[SCHYRSECT].[SCHOOL_YEAR_COURSE_GU]

	   INNER JOIN
	   [rev].[REV_ORGANIZATION_YEAR] AS [ORGYEAR]
	   ON
	   [SCHYRSECT].[ORGANIZATION_YEAR_GU]=[ORGYEAR].[ORGANIZATION_YEAR_GU]
	   	   
	   INNER JOIN
	   [rev].[REV_ORGANIZATION] AS [ORG]
	   ON
	   [ORGYEAR].[ORGANIZATION_GU]=[ORG].[ORGANIZATION_GU]

	   INNER JOIN
	   [rev].[EPC_SCH] AS [SCH]
	   ON
	   [ORGYEAR].[ORGANIZATION_GU]=[SCH].[ORGANIZATION_GU]

	   INNER JOIN
	   [rev].[REV_YEAR] AS [YEAR]
	   ON
	   [ORGYEAR].[YEAR_GU]=[YEAR].[YEAR_GU]

WHERE
    [YEAR].[SCHOOL_YEAR] IN (SELECT * FROM rev.SIF_22_Common_CurrentYear)

)
, Qry_WrongCredits (ORGANIZATION_GU,ORGANIZATION_YEAR_GU,YEAR_GU,COURSE_GU
,SECTION_GU,SCHOOL_YEAR,ORGANIZATION_NAME,SCHOOL_CODE,COURSE_ID,COURSE_TITLE,SECTION_ID,CREDIT,SchMasterCREDIT) AS
(
    SELECT 
	   Qry_SchoolMaster.ORGANIZATION_GU
	   ,Qry_SchoolMaster.ORGANIZATION_YEAR_GU
	   ,Qry_SchoolMaster.YEAR_GU
	   ,Qry_SchoolMaster.COURSE_GU
	   ,Qry_SchoolMaster.SECTION_GU
	   ,Qry_SchoolMaster.SCHOOL_YEAR
	   ,Qry_SchoolMaster.ORGANIZATION_NAME
	   ,Qry_SchoolMaster.SCHOOL_CODE
	   ,Qry_SchoolMaster.COURSE_ID
	   ,Qry_SchoolMaster.COURSE_TITLE
	   ,Qry_SchoolMaster.SECTION_ID
	   ,Qry_DCM.CREDIT
	   ,Qry_SchoolMaster.CREDIT
FROM
    Qry_DCM AS [Qry_DCM]
    
    INNER JOIN 
    Qry_SchoolMaster AS [Qry_SchoolMaster] 
    ON 
    [Qry_DCM].COURSE_GU = [Qry_SchoolMaster].COURSE_GU

WHERE
    ISNULL([Qry_DCM].[CREDIT],0)!=ISNULL([Qry_SchoolMaster].[CREDIT],0)
)


SELECT
    [Qry_WrongCredits].[SCHOOL_YEAR]
    ,[Qry_WrongCredits].[ORGANIZATION_NAME]
    ,[Qry_WrongCredits].[SCHOOL_CODE]
    ,[Qry_WrongCredits].[COURSE_ID]
    ,[Qry_WrongCredits].[COURSE_TITLE]
    ,[Qry_WrongCredits].[SECTION_ID]
    ,[Qry_WrongCredits].[CREDIT]
    ,[Qry_WrongCredits].[SchMasterCredit]
	,STU.SIS_NUMBER
	,HIST.COURSE_ID
	,HIST.SECTION_ID
	,HIST.CREDIT_COMPLETED
	
FROM
    [rev].[EPC_SCH_YR_SECT] AS [SCHYRSECT]

    INNER JOIN
    [Qry_WrongCredits] AS [Qry_WrongCredits]
    ON
    [SCHYRSECT].[SECTION_GU]=[Qry_WrongCredits].[SECTION_GU]

	INNER JOIN 
	[SYNERGYDBDC.APS.EDU.ACTD].ST_Production.REV.EPC_STU_CRS_HIS AS HIST
	ON
	SCHYRSECT.SECTION_GU = HIST.SECTION_GU
	AND HIST.SCHOOL_YEAR = '2017'

	INNER JOIN 
	[SYNERGYDBDC.APS.EDU.ACTD].ST_Production.REV.EPC_STU AS STU
	ON
	HIST.STUDENT_GU = STU.STUDENT_GU

	WHERE
	[Qry_WrongCredits].CREDIT != HIST.CREDIT_COMPLETED
