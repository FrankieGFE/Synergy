--<APS - SchoolNet Code Department>
SELECT distinct
         crs.DEPARTMENT         AS [department_code]
       , dept.VALUE_DESCRIPTION + ' (2014-2015 +)' AS [department_name]
       , '' AS [subject_code]

FROM   rev.EPC_CRS crs
       JOIN rev.EPC_SCH_YR_CRS ycrs ON ycrs.COURSE_GU = crs.COURSE_GU
	   JOIN rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_YEAR_GU = ycrs.ORGANIZATION_YEAR_GU
	   JOIN rev.rev_year              yr  ON yr.YEAR_GU               = oyr.YEAR_GU
	                                         AND yr.SCHOOL_YEAR       = (select school_year from rev.SIF_22_Common_CurrentYear)
       LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.CourseInfo', 'DEPARTMENT') dept on dept.VALUE_CODE = crs.DEPARTMENT


