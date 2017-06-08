

BEGIN TRAN
EXECUTE AS LOGIN='QueryFileUser'
GO



SELECT *
	--SSCH.[Summer School Site]
	--,SSCH.[Student's ID]
	--,SSCH.[Grade for Summer School]
	--,SORG.ORGANIZATION_GU
	--,SORG.ORGANIZATION_NAME
	--,GRADE.VALUE_CODE
	--,GRADE.VALUE_DESCRIPTION
	--,STUDENT_SCHOOL_YEAR_GU
--UPDATE rev.EPC_STU_SCH_YR  SET SUMMER_SCHOOL_GU = ORGANIZATION_GU, SUMMER_GRADE_LEVEL = VALUE_CODE
FROM
(
	SELECT
	ssy.student_school_year_gu
	,sorg.ORGANIZATION_GU
	,grade.VALUE_CODE 
	,[Student's ID]
	,[Summer School Site]
	,[Grade for Summer School]
	,VALUE_DESCRIPTION
	FROM
		
		OPENROWSET 
		(
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM K3_plus_2017_Student_Enrollment_5_25.csv'  
		)AS [SSCH]

	JOIN
	(
	SELECT	
		STU.SIS_NUMBER
		,ssy.STUDENT_SCHOOL_YEAR_GU

	FROM   rev.EPC_STU                    stu
		   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
												  --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
WHERE 1= 1
AND  ssy.ENTER_DATE is not null
AND YR.SCHOOL_YEAR = '2016'
and yr.EXTENSION = 'r'
and EXCLUDE_ADA_ADM is null
and LEAVE_DATE is null
) SSY
ON SSY.SIS_NUMBER = [SSCH].[Student's ID]


LEFT JOIN
REV.REV_ORGANIZATION AS SORG
ON SORG.ORGANIZATION_NAME = [SSCH].[Summer School Site]
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON RIGHT(CAST(grade.VALUE_DESCRIPTION AS VARCHAR),1) = CAST([SSCH].[Grade for Summer School] AS VARCHAR (02))
AND grade.VALUE_DESCRIPTION NOT IN ('C1','C2','C3','C4','T1','T2','T3','T4','11','12','P1','P2')
) st1
--where
--rev.EPC_STU_SCH_YR.STUDENT_SCHOOL_YEAR_GU = st1.STUDENT_SCHOOL_YEAR_GU
REVERT
GO

ROLLBACK
