--<APS - SchoolNet student enrollment data>
SELECT distinct
         stu.SIS_NUMBER                            AS [student_code]
       , yr.SCHOOL_YEAR                            AS [school_year]
       , sch.SCHOOL_CODE                           AS [school_code]
       , grade.VALUE_DESCRIPTION                   AS [grade_code]
       , stfp.LAST_NAME + ', ' + stfp.FIRST_NAME   AS [division_teacher_code]
       , CASE
	         WHEN frm.FRM_CODE = '2' THEN 'F'
			 WHEN frm.FRM_CODE is null  THEN 'N'
	         WHEN (frm.FRM_CODE is null or frm.FRM_CODE not in ('F','R', 'N', '2')) THEN 'U'
			 ELSE frm.FRM_CODE
	     END                                       AS [lunch_code]
       , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
       , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
       , CAST(yr.SCHOOL_YEAR as VARCHAR(4)) 
	     + '-' + SUBSTRING(lcd.VALUE_DESCRIPTION,1,2) AS [withdraw_code]
       , rm.ROOM_NAME                              AS [division_code]
	   , CASE
	        WHEN COALESCE(ssy.PREVIOUS_YEAR_END_STATUS, ssy.ENR_USER_1) = 'R' then '1' 
			ELSE '0'
	     END                                       AS [retained]
       , '' AS [migrant]
	    -- an ‘A’ for students enrolled at 
		-- Mary Ann Binford, Cochiti, Duranes, Eugene Field, Mark Twain, Navajo, Onate, and Susie Rayos Marmon 
		-- and ‘default’ for all others
       , CASE
	         WHEN sch.SCHOOL_CODE in ('250', '237', '249', '261', '364', '327', '227', '280' ) 
			 THEN 'A'
			 ELSE 'default'
	     END                                       AS [calendar_code]
       , '' AS [gpa]
       , '' AS [credits_accumulated]
       , '' AS [credits_attempted]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU) + 1
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.Enrollment', 'Leave_CODE') lcd ON lcd.VALUE_CODE = ssy.LEAVE_CODE
       LEFT JOIN (SELECT   fh.STUDENT_GU
	                     , fh.FRM_CODE
						 , ROW_NUMBER() OVER(partition by fh.student_gu order by fh.exit_date) rn
	              FROM   rev.EPC_STU_PGM_FRM_HIS fh 
	              WHERE  fh.EXIT_DATE is null
	             )                    frm  ON frm.STUDENT_GU           = stu.STUDENT_GU and frm.rn = 1
       -- For homeroom and hm teacher
	   LEFT JOIN rev.EPC_SCH_YR_SECT  sect ON sect.SECTION_GU          = ssy.HOMEROOM_SECTION_GU
       LEFT JOIN rev.EPC_STAFF_SCH_YR stf  ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
	   LEFT JOIN rev.REV_PERSON       stfp ON stfp.PERSON_GU           = stf.STAFF_GU
	   LEFT JOIN rev.EPC_SCH_ROOM     rm   ON rm.ROOM_GU               = sect.ROOM_GU
WHERE  ssy.ENTER_DATE is not null