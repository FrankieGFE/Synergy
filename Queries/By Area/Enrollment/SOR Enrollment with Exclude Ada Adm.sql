/*
*	Created By:  Debbie Ann Chavez
*	Date:  7/16/2014
*
*	Pull SOR enrollments tagged Concurrent.
*/


SELECT 
	School.SCHOOL_CODE
	,Organization.ORGANIZATION_NAME
	,Student.SIS_NUMBER
	,RevYear.SCHOOL_YEAR
	,StudentSchoolYear.EXCLUDE_ADA_ADM

 FROM
			--READ ALL ENROLLMENTS
            rev.EPC_STU_SCH_YR AS StudentSchoolYear	
			
			--THEN FILTER TO READ ONLY SOR ENROLLMENT
			INNER JOIN
			rev.EPC_STU_YR AS SOR
			ON
			SOR.STU_SCHOOL_YEAR_GU = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
			
			--GET STUDENT NUMBER
			INNER JOIN 
            rev.EPC_STU AS Student
            ON 
            Student.STUDENT_GU = StudentSchoolYear.STUDENT_GU
			
			--GET SCHOOL YEAR
			 INNER JOIN 
           rev.REV_ORGANIZATION_YEAR AS OrgYear 
            ON 
            OrgYear.ORGANIZATION_YEAR_GU = StudentSchoolYear.ORGANIZATION_YEAR_GU
              INNER JOIN 
           rev.REV_YEAR AS RevYear 
            ON 
            RevYear.YEAR_GU = OrgYear.YEAR_GU 
            AND RevYear.SCHOOL_YEAR = 2013
			AND RevYear.EXTENSION = 'S'
		   
		   --GET SCHOOL
		    INNER JOIN 
           rev.REV_ORGANIZATION AS Organization 
            ON 
            Organization.ORGANIZATION_GU=OrgYear.ORGANIZATION_GU
            INNER JOIN 
           rev.EPC_SCH AS School 
            ON 
            School.ORGANIZATION_GU =OrgYear.ORGANIZATION_GU
          
	
WHERE
	StudentSchoolYear.EXCLUDE_ADA_ADM IS NOT NULL
