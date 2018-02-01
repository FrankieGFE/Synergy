BEGIN TRAN

UPDATE
	[180-SMAXODS-01].SchoolNet.dbo.CCR_ACT
SET
	SchoolNet.dbo.CCR_ACT.APS_ID = STUDENT.student_code
	,SchoolNet.dbo.CCR_ACT.State_ID = STUDENT.STATE_ID
	,[Assessment School Year Date] = '2015-6-30'
	,[Test Description] = 'ACT'
	--,ACT_HS_Code = APS_Sch_Code
	

	
--SELECT
--	STUDENT.[ALTERNATE STUDENT ID]
--	,STUDENT.[STUDENT ID]
--	,CCR.F_Name
--	,CCR.L_Name
--	,CCR.DOB_NEW
--	,STUDENT.BIRTHDATE
--	,STUDENT.Period
FROM
	[180-SMAXODS-01].SchoolNet.dbo.CCR_ACT AS ACT
	
LEFT JOIN
	ALLSTUDENTS AS STUDENT
	ON
	ACT.L_Name = STUDENT.last_name
	AND ACT.F_Name = STUDENT.first_name
	AND STUDENT.DOB = SUBSTRING (DOB_NEW,1,4)+'-'+ SUBSTRING (DOB_NEW, 5,2)+'-'+ SUBSTRING (DOB_NEW, 7,2)
	AND STUDENT.SCHOOL_YEAR = '2014'
WHERE ACT.APS_ID IS NULL
AND ACT.SCH_YR = '2014-2015'
AND [District Code] IS NULL
--AND ACT.[District Code] = 'FRANK'
--AND ACT.APS_ID IS NULL


ROLLBACK

--BEGIN TRAN
--UPDATE
--	[180-SMAXODS-01].SchoolNet.dbo.CCR_ACT
--SET
--	SchoolNet.dbo.CCR_ACT.APS_Sch_Code = CODES.[PED APS LOC]

--FROM
--CCR_ACT ACT
--JOIN
--school_codes_ACT_SAT_To_APS CODES
--ON ACT.ACT_HS_Code = CODES.[ACT SAT HS Code]

--WHERE SCH_YR = '2014-2015'
--AND [District Code] IS NULL

--ROLLBACK


--BEGIN TRAN
--UPDATE CCR_ACT
--	SET ACT_HS_CODE = APS_Sch_Code
--	FROM CCR_ACT
--	WHERE ACT_HS_CODE IS NULL
--	AND SCH_YR = '2014-2015'

--ROLLBACK