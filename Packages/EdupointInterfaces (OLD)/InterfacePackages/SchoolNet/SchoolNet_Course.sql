--<APS - SchoolNet course data>
SELECT 
       -- 2013(K12.Setup.DistrictSetup_AppYear)+LocationNumbe(K12.School.SchoolCode)+-k12-CourseInfo-Course-CourseID
	   -- Course_code 2013580062E11
         CAST(yr.SCHOOL_YEAR as VARCHAR(4)) 
		 + sch.SCHOOL_CODE
		 + crs.COURSE_ID                             AS [course_code]
	   --k12-CourseInfo-Course-CourseTitle + ‘ – ‘ + k12-CourseInfo-Course-CourseID + ‘ – ‘ +Location Number (K12.School.SchoolCode)
       , crs.COURSE_TITLE
	     + '-' + crs.COURSE_ID
		 + '-' + sch.SCHOOL_CODE                     AS [course_name]
       , crs.DEPARTMENT                              AS [department_code]
       , lgrade.VALUE_DESCRIPTION                    AS [low_grade]
       , hgrade.VALUE_DESCRIPTION                    AS [high_grade]
       , CASE
               WHEN LEFT(crs.STATE_COURSE_CODE,4) not like '%[^0-9]%' THEN
                    CASE
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0129 and 0199 THEN '4-01'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 3001 and 3099 THEN '4-23'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0201 and 0299 THEN '4-02' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0301 and 0399 THEN '4-03' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0401 and 0499 THEN '4-04' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0501 and 0599 THEN '4-05'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0601 and 0699 THEN '4-06' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0701 and 0799 THEN '4-07' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0801 and 0899 THEN '4-08'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 0901 and 0999 THEN '4-09' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1000 and 1099 THEN '4-10'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1101 and 1199 THEN '4-11' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1201 and 1299 THEN '4-12'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1300 and 1399 THEN '4-13' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1401 and 1499 THEN '4-14' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1501 and 1599 THEN '4-15'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1601 and 1699 THEN '4-16'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1701 and 1799 THEN '4-17' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1801 and 1899 THEN '4-18' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 1901 and 1999 THEN '4-19' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2000 and 2099 THEN '4-20' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2101 and 2199 THEN '4-21'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2201 and 2299 THEN '4-22' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2301 and 2399 THEN '4-23'
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2401 and 2499 THEN '4-24' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2501 and 2599 THEN '4-25' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2601 and 2699 THEN '4-26' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2701 and 2799 THEN '4-27' 
                         WHEN CAST(LEFT(crs.STATE_COURSE_CODE,4) as int) between 2801 and 2899 THEN '4-28'
                    ELSE ''
                    END
               ELSE ''
               END                                   AS [subject_code]
       , ''                                          AS [mark_category_code]
       , ''                                          AS [mark_category_name]
       , CASE
	         WHEN crs.AP_INDICATOR = 'Y' THEN '1'
			 ELSE '0'
	     END                                         AS [is_AP]
	   --When (K12.Course.CourseInfo.Department) = Soc or Eng or Math or Sci Then ‘1’ Else ‘2’
       , CASE
	         WHEN crs.DEPARTMENT IN ('Soc', 'Eng', 'Math', 'Sci') THEN '1'
			 ELSE '0'
	     END                                         AS [is_core] 
FROM   rev.EPC_CRS crs
       JOIN rev.EPC_SCH_YR_CRS ycrs ON ycrs.COURSE_GU = crs.COURSE_GU
	   JOIN rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_YEAR_GU = ycrs.ORGANIZATION_YEAR_GU
	   JOIN rev.rev_year              yr  ON yr.YEAR_GU               = oyr.YEAR_GU
	                                         AND yr.SCHOOL_YEAR       = (select school_year from rev.SIF_22_Common_CurrentYear)                      
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') lgrade ON lgrade.VALUE_CODE = crs.GRADE_RANGE_LOW
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') hgrade ON hgrade.VALUE_CODE = crs.GRADE_RANGE_HIGH

