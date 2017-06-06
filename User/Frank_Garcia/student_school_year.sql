

BEGIN TRAN
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
	  [SSCH].[Student's ID] AS [SIS_NUMBER]
      ,SSCHC.SCHOOL_CODE AS [SCHOOL_CODE]
      ,'2017.N' AS [SCHOOL_YEAR]
      ,'DEFAULT' AS [ACTION]
      ,grade.VALUE_CODE AS [GRADE_LEVEL]
      ,'20170701' AS [ENTER_DATE]
      ,'' AS [NEXT_GRADE_LEVEL]
      ,'' AS [NEXT_SCHOOL]
      ,'CONC' AS [ENTER_CODE]
      ,'' AS [PERMIT_TYPE]
      ,'' AS [PERMIT_DATE]
      ,'' AS [TRACK]
      ,'' AS [LEAVE_DATE]
      ,'' AS [LEAVE_CODE]
      ,'' AS [INSTRUCTIONAL_SETTING]
      ,'' AS [BUS_TO_SCHOOL]
      ,'' AS [BUS_FROM_SCHOOL]
      ,'' AS [DISTRICT_OF_RESIDENCE]
      ,'1' AS [EXCLUDE_FROM_ADAADM]
      ,'1.0' AS [FTE]
      ,'' AS [GRADE_EXIT_CODE]
      ,'' AS [HOMEBOUND]
      ,'' AS [LAST_SCHOOL]
      ,'' AS [LOCKER_NUMBER]
      ,'01' AS [PROGRAM_CODE]
      ,'' AS [SPECIAL_ENROLLMENT_CODE]
      ,'' AS [SPECIAL_PROGRAM_CODE]
      ,'' AS [SUMMER_WITHDRAWAL_REASON_CODE]
      ,'' AS [SUMMER_WITHDRAWAL_CODE]
      ,'' AS [SUMMER_WITHDRAWAL_DATE]
      ,'' AS [TITLE1_PROGRAM]
      ,'' AS [TITLE1_SERVICE]
      ,'' AS [TITLE1_EXIT]
      ,'' AS [TUITION_PAYER_CODE]
      ,'' AS [COUNSELOR_BADGE_NUM]
      ,'' AS [USER_CODE1]
      ,'' AS [USER_CODE2]
      ,'' AS [USER_CODE3]
      ,'' AS [USER_CODE4]
      ,'' AS [USER_CODE5]
      ,'' AS [USER_CODE6]
      ,'' AS [USER_CODE7]
      ,'' AS [USER_CODE8]
      ,'' AS [ENR_USER_CODE1]
      ,'' AS [ENR_USER_CODE2]
      ,'' AS [ENR_USER_CODE3]
      ,'' AS [ENR_USER_CODE_DD4]
      ,'' AS [ENR_USER_CODE_DD5]
      ,'' AS [ENR_USER_CODE_DD6]
      ,'' AS [WITHDRAWAL_REASON_CODE]
      ,'' AS [YEAR_END_STATUS]
      ,'' AS [CAHSEE_ELA_RETAKE]
      ,'' AS [CAHSEE_MATH_RETAKE]
      ,'' AS [OVERRIDE_FORCE_STS]
      ,'' AS [RECEIVER_SCHOOL]
      ,'' AS [SPECIAL_ED_SCHOOL_OF_ATTENDANCE]
      ,'' AS [TRANSPORT_ELIGIBLE]
      ,'' AS [PICKUP_TRANS_TYPE]
      ,'' AS [DROPOFF_TRANS_TYPE]
      ,'' AS [PICKUP_BUS_STOP]
      ,'' AS [DROPOFF_BUS_STOP]
      ,'' AS [PICKUP_TRANS_TIME]
      ,'' AS [DROPOFF_TRANS_TIME]
      ,'' AS [PICKUP_LOC_TYPE]
      ,'' AS [DROPOFF_LOC_TYPE]
      ,'' AS [PICKUP_ADDRESS]
      ,'' AS [DROPOFF_ADDRESS]
      ,'' AS [PICKUP_CITY]
      ,'' AS [DROPOFF_CITY]
      ,'' AS [PICKUP_STATE]
      ,'' AS [DROPOFF_STATE]
      ,'' AS [PICKUP_ZIP_CODE]
      ,'' AS [DROPOFF_ZIP_CODE]
      ,'' AS [PICKUP_TRANS_REASON_CODE]
      ,'' AS [DROPOFF_TRANS_REASON_CODE]
      ,'' AS [PICKUP_TRANS_REASON_DATE]
      ,'' AS [DROPOFF_TRANS_REASON_DATE]
      ,'' AS [PICKUP_COMMENT]
      ,'' AS [DROPOFF_COMMENT]
      ,'' AS [SPEC_TRANS_REQ_COMMENT]
      ,'' AS [USER_DATE1]
      ,'' AS [USER_DATE2]
      ,'' AS [USER_DATE3]
      ,'' AS [USER_DATE4]
      ,'' AS [USER_CHECK1]
      ,'' AS [USER_CHECK2]
      ,'' AS [USER_CHECK3]
      ,'' AS [USER_CHECK4]
      ,'' AS [USER_CHECK5]
      ,'' AS [USER_CHECK6]
      ,'' AS [USER_CHECK7]
      ,'' AS [USER_CHECK8]
      ,'' AS [USER_NUM1]
      ,'' AS [USER_NUM2]
      ,'' AS [USER_NUM3]
      ,'' AS [USER_NUM4]
      ,'' AS [USER_NUM5]
      ,'' AS [USER_NUM6]
      ,'' AS [USER_NUM7]
      ,'' AS [USER_NUM8]
      ,'' AS [USER_NUMDD1]
      ,'' AS [USER_NUMDD2]
      ,'' AS [USER_NUMDD3]
      ,'' AS [USER_NUMDD4]
      ,'' AS [USER_NUMDD5]
      ,'' AS [USER_NUMDD6]
      ,'' AS [USER_NUMDD7]
      ,'' AS [USER_NUMDD8]
      ,'' AS [ENR_USER_CHECK1]
      ,'' AS [ENR_USER_CHECK2]
      ,'' AS [ENR_USER_CHECK3]
      ,'' AS [ENR_USER_NUM1]
      ,'' AS [ENR_USER_NUM2]
      ,'' AS [ENR_USER_NUM3]
      ,'' AS [ENR_USER_NUM4]
      ,'' AS [ENR_USER_NUM5]
      ,'' AS [COMPLETION_STATUS]
      ,'' AS [DISTRICT_SPECIAL_EDUCATION_ACCOUNTABILITY]
      ,'' AS [USER_CODEDD1]
      ,'' AS [USER_CODEDD2]
      ,'' AS [USER_CODEDD3]
      ,'' AS [USER_CODEDD4]
      ,'' AS [USER_CODEDD5]
      ,'' AS [USER_CODEDD6]
      ,'' AS [USER_CODEDD7]
      ,'' AS [USER_CODEDD8]
      ,'' AS [FEEDER_DISTRICT_ID]
      ,'' AS [FEEDER_STUDENT_ID]
      ,'' AS [SCHOOL_COMPLETION_CODE]
      ,'' AS [NON_RESIDENT]
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
AND  ssy.ENTER_DATE is not NULL
AND YR.SCHOOL_YEAR = '2016'
and yr.EXTENSION = 'r'
and EXCLUDE_ADA_ADM is NULL
and LEAVE_DATE is NULL
) SSY
ON SSY.SIS_NUMBER = [SSCH].[Student's ID]


LEFT JOIN
REV.REV_ORGANIZATION AS SORG
ON SORG.ORGANIZATION_NAME = [SSCH].[Summer School Site]
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON RIGHT(CAST(grade.VALUE_DESCRIPTION AS VARCHAR),1) = CAST([SSCH].[Grade for Summer School] AS VARCHAR (02))
AND grade.VALUE_DESCRIPTION NOT IN ('C1','C2','C3','C4','T1','T2','T3','T4','11','12','P1','P2')
JOIN REV.EPC_SCH AS SSCHC
ON SSCHC.ORGANIZATION_GU = SORG.ORGANIZATION_GU

WHERE grade.VALUE_CODE IS NOT NULL


REVERT
GO

ROLLBACK