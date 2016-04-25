--<APS - SchoolNet student race data>
SELECT distinct
         stu.SIS_NUMBER                            AS [student_code]
       , CASE
	         WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'H'
			 WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'M'
             WHEN per.RESOLVED_ETHNICITY_RACE = '1'     THEN 'C'
             WHEN per.RESOLVED_ETHNICITY_RACE = '600'   THEN 'B'
             WHEN per.RESOLVED_ETHNICITY_RACE = '100'   THEN 'I'
             WHEN per.RESOLVED_ETHNICITY_RACE = '299'   THEN 'A'
             WHEN per.RESOLVED_ETHNICITY_RACE = '399'   THEN 'P'
             WHEN per.RESOLVED_ETHNICITY_RACE = '401'   THEN 'X'
        END                                         AS [race_code]

FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU           = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_PERSON            per  ON per.PERSON_GU            = stu.STUDENT_GU
