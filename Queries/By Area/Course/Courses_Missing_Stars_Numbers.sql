/**** Looks for Missing or Erroneous STARS Course Numbers in Synergy that are Not flagged 'exclude from state reporting' ****/

/* Commented out the parts of this script that looks for Synergy course codes not existing in STARS (until Common Codes table is available)*/


--DECLARE @Courses TABLE 
--  ( 
--     coursecodelong NVARCHAR(12) 
--  ) 

--INSERT INTO @Courses 
--            (coursecodelong) 
--SELECT DISTINCT coursecodelong 
--FROM   [046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[course] --use Course table for now, until Common Codes table becomes available



SELECT A.course_id, 
       A.course_title, 
       A.course_duration, 
       A.state_course_code, 
       A.exclude_from_state_rpt, 
       D.school_year 

FROM   (SELECT * 
        FROM   [SYNSECONDDB].[ST_Daily].rev.epc_crs)AS A 
       JOIN (SELECT * 
             FROM   [SYNSECONDDB].[ST_Daily].rev.epc_sch_yr_crs)AS B 
         ON A.course_gu = B.course_gu 
       JOIN (SELECT * 
             FROM   [SYNSECONDDB].[ST_Daily].rev.rev_organization_year)AS C 
         ON B.organization_year_gu = C.organization_year_gu 
       JOIN (SELECT * 
             FROM   [SYNSECONDDB].[ST_Daily].rev.rev_year)AS D 
         ON C.year_gu = D.year_gu
		  
WHERE  school_year = 2015 

       AND ( state_course_code IS NULL --looks for any empty state_course_code fields in Synergy
             AND exclude_from_state_rpt = 'N' ) 

        OR Len(state_course_code) != 8 --looks for Synergy course codes that are not 8 characters long
		
		--OR school_year = 2015 --looks for Synergy course codes that are not in STARS
  --         AND exclude_from_state_rpt = 'N' 
  --         AND ( Substring(state_course_code, 1, 4) NOT IN (SELECT 
  --                   Substring(coursecodelong, 1, 4) FROM   @Courses) ) 
          
          


