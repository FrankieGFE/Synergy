



/*** this gets Absences and tardies for all schools for a given school year ***/
SELECT 
	   --a.grade, 
    --   a.organization_year_gu, 
    --   b.sis_number, 
    --   b.state_student_number, 
    --   c.last_name, 
    --   c.first_name, 
    --   c.middle_name, 
    --   c.gender, 
    --   c.birth_date, 
    --   e.organization_name, 
    --   f.sis_school_code, 
    --   f.state_school_code, 
    --   g.enrollment_gu,-- Get ENROLLMENT_GU based on STUDENT_SCHOOL_YEAR_GU, 
    --   h.abs_date, 
    --   h.code_abs_reas1_gu, 
    --   i.code_abs_reas_gu, 
    --   j.abbreviation, 
    --   j.description, 
    --   j.type,
    --   j.*
    h.*
FROM   (SELECT * 
        FROM   [rev].[epc_stu_sch_yr] 
        
         WHERE  year_gu IN (SELECT year_gu 
                           FROM   [SYNSECONDDB].[ST_Daily].[rev].[rev_year] 
                           WHERE  school_year = 2013 
                                  AND extension = 'S') -- Summer 2013 
        )AS a 

       JOIN (SELECT * 
             FROM   [rev].[epc_stu])AS b 
         ON a.student_gu = b.student_gu 
       JOIN (SELECT * 
             FROM   [rev].[rev_person])AS c 
         ON b.[student_gu] = c.[person_gu] 
       JOIN (SELECT * 
             FROM   [rev].[rev_organization_year])AS d 
         ON a.organization_year_gu = d.organization_year_gu 
       JOIN (SELECT * 
             FROM   [rev].[rev_organization])AS e 
         ON d.organization_gu = e.organization_gu 
       JOIN (SELECT * 
             FROM   [rev].[epc_sch] 
            --where sis_school_code = '210' 
            )AS f 
         ON e.organization_gu = f.organization_gu 
       LEFT JOIN (SELECT * 
                  FROM   [rev].[epc_stu_enroll])AS g 
               ON a.student_school_year_gu = g.student_school_year_gu 
       LEFT JOIN (SELECT * 
                  FROM   [rev].[epc_stu_att_daily])AS h
               ON g.enrollment_gu = h.enrollment_gu 
       LEFT JOIN (SELECT * 
                  FROM   [rev].[epc_code_abs_reas_sch_yr])AS i 
               ON h.code_abs_reas1_gu = i.code_abs_reas_sch_year_gu -- reas1 = morning period, reas2 = afternoon period
			   OR h.code_abs_reas2_gu = i.code_abs_reas_sch_year_gu
       LEFT JOIN (SELECT * 
                  FROM   [rev].[epc_code_abs_reas])AS j
               ON i.code_abs_reas_gu = j.code_abs_reas_gu  