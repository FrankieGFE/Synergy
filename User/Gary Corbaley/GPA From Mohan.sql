



SELECT
      ROW_NUMBER() OVER (partition by stu.student_gu order by stu.student_gu, type.gpa_type_name) rn 
    , stu.STUDENT_GU
    , stu.SIS_NUMBER 
	, def.GPA_CODE
    , gpa.GPA
    , gpa.CLASS_RANK
    , run.CLASS_SIZE
    , gpa.CLASS_RANK_PCTILE
    , type.GPA_TYPE_NAME


FROM REV.EPC_STU_SCH_YR          ssy
JOIN rev.EPC_STU                 stu  ON stu.STUDENT_GU                  = ssy.STUDENT_GU
JOIN rev.EPC_STU_GPA             gpa  ON ssy.STUDENT_SCHOOL_YEAR_GU      = gpa.STUDENT_SCHOOL_YEAR_GU
JOIN rev.EPC_SCH_YR_GPA_TYPE_RUN run  ON run.SCHOOL_YEAR_GPA_TYPE_RUN_GU = gpa.SCHOOL_YEAR_GPA_TYPE_RUN_GU
	                                     and run.SCHOOL_YEAR_GRD_PRD_GU    is null
JOIN rev.EPC_GPA_DEF_TYPE        type ON type.GPA_DEF_TYPE_GU            = run.GPA_DEF_TYPE_GU
                                         AND (    type.GPA_TYPE_NAME = 'HS Cum Flat' 
                                               OR type.GPA_TYPE_NAME = 'HS Cum Weighted')

JOIN rev.EPC_GPA_DEF             def  ON def.GPA_DEF_GU                  = type.GPA_DEF_GU
	                                     AND (   DEF.GPA_CODE = 'HSCF' 
	                                          OR DEF.GPA_CODE = 'HSCW')
JOIN rev.REV_ORGANIZATION_YEAR   oy   ON oy.ORGANIZATION_YEAR_GU         = ssy.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR                y    ON y.YEAR_GU                       = oy.YEAR_GU
	                                     AND y.YEAR_GU                   = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
and stu.SIS_NUMBER = '100070945'
order by gpa.GRADE_LEVEL
   
       
