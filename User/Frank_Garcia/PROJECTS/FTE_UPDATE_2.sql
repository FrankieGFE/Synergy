



BEGIN TRAN
--UPDATE rev.EPC_STU_SCH_YR SET FTE = '1.00'   ---- FOR SSY
--UPDATE REV.EPC_STU_ENROLL SET FTE = '1.00'   ---- FOR ENR
--UPDATE REV.EPC_STU_ENROLL_ACTIVITY SET FTE = '1.00'  --- FOR ACTIVITY
--	FROM
--	(

	SELECT  ---DISTINCT ORG.ORGANIZATION_NAME, SCH.SCHOOL_CODE
			 stu.SIS_NUMBER                            AS [student_code]
		   , yr.SCHOOL_YEAR                            AS [school_year]
		   , yr.EXTENSION
		   , sch.SCHOOL_CODE                           AS [school_code]
		   , ENR.FTE                                   AS ENR_FTE
		   , SSY.FTE                                   AS SSY_FTE
		   , ACT.FTE								   AS ACT_FTE                  
		   , ENR.ENROLLMENT_GU
		   , org.ORGANIZATION_NAME
		   --, sopt.SCHOOL_TYPE
		   , ST.VALUE_DESCRIPTION SCHOOL_TYPE
		   , ssy.PREVIOUS_YEAR_END_STATUS
		   , SSY.ENTER_DATE
		   , ACT.EFFECTIVE_DATE
		   , ENR.STUDENT_SCHOOL_YEAR_GU
		   , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
		   , ENR.ENTER_DATE ENR_ENTER_DATE
		   , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
		   , ssy.ENTER_CODE
		   , ENR.ENTER_CODE ENR_ENTER_CODE
		   , ENR.EXCLUDE_ADA_ADM
		   ----, CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep_end]
	   FROM rev.EPC_STU                    stu
		   --rev.EPC_STU                    stu
		   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		   JOIN rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
		   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
												  and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		   JOIN rev.epc_sch_yr_opt       sopt  ON sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
		   LEFT JOIN REV.EPC_STU_ENROLL  ENR ON ENR.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU
		   JOIN rev.SIF_22_Common_GetLookupValues('K12', 'SCHOOL_TYPE') ST ON ST.VALUE_CODE = SOPT.SCHOOL_TYPE
		   JOIN REV.EPC_STU_ENROLL_ACTIVITY ACT ON ENR.ENROLLMENT_GU = ACT.ENROLLMENT_GU
	WHERE  1 = 1
	       AND ssy.ENTER_DATE is not nulL
		   AND ssy.LEAVE_DATE IS NULL
		   AND ST.VALUE_DESCRIPTION !=  'SPECIAL SCHOOL'
		   AND (ENR.FTE IS NULL OR SSY.FTE IS NULL OR ACT.FTE IS NULL)
		   --and SIS_NUMBER = '102790268'

--) T1
--WHERE 1 = 1
	--AND REV.EPC_STU_SCH_YR.STUDENT_SCHOOL_YEAR_GU= T1.STUDENT_SCHOOL_YEAR_GU   --- FOR SSY
	--AND REV.EPC_STU_ENROLL.ENROLLMENT_GU= T1.ENROLLMENT_GU   --- FOR ENROLLMENT
	--AND REV.EPC_STU_ENROLL_ACTIVITY.ENROLLMENT_GU = T1.ENROLLMENT_GU   --- ACTIVITY
	--AND REV.EPC_STU_ENROLL_ACTIVITY.ENROLLMENT_GU NOT IN ('2b3ff5d3-082d-4c44-9c1b-d9fda7e6cf9e','2f253300-bc71-48c5-8cf7-770585ddecbd','53c81bf2-04b6-42ff-b968-89ef391e0e42')

ROLLBACK
--select * from rev.SIF_22_Common_GetLookupValues('k12.enrollment', 'fte')
