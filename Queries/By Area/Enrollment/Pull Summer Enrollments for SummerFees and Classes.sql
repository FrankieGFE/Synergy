 /*
 *		CREATED BY:  DEBBIE ANN CHAVEZ
 *		DATE:  6/23/2014
 *
 *		PULLS BASIC STUDENTS, ENROLLMENTS, AND ADDRESSES (CAN ADD OTHER FIELDS AS NEEDED: EX: STUDENT.SIS_NUMBER)
 *
 *		ORIGINAL REQUEST - RIGO, FOR CHARTER SCHOOL MAILINGS
 *
 */
  
  DECLARE @SCHOOL_YEAR INT = 2013
  DECLARE @EXTENSION VARCHAR (1) = 'S'
  DECLARE @NO_SHOW VARCHAR (1) = 'N'
  DECLARE @SCHOOL VARCHAR (3) = '590'
 
 
 SELECT 
         SCHOOL_YEAR
		 ,School.SCHOOL_CODE
		 ,Organization.ORGANIZATION_NAME

		 ,StudentSchoolYear.ENTER_DATE
		 ,StudentSchoolYear.LEAVE_DATE

		 ,student.SIS_NUMBER
		 , PERSON.LAST_NAME
		 , PERSON. FIRST_NAME
		 , Grades.[ALT_CODE_1] AS GRADE
		 ,ADDRESS.ADDRESS
		 , ADDRESS.CITY
		 , ADDRESS.STATE
		 , ADDRESS.ZIP_5

		 	,TOTAL_COST
			,TOTAL_PAY
			,BALANCE

			,STATUS

			,crs.COURSE_ID
			,sec.SECTION_ID
			,crs.COURSE_TITLE
			
			,cls.LEAVE_DATE
			,cls.ENTER_DATE




      FROM

				
			 [011-SYNERGYDB].ST_Production.rev.EPC_STU AS Student

				
				
			INNER JOIN		  
		    [011-SYNERGYDB].ST_Production.rev.EPC_STU_SCH_YR AS StudentSchoolYear
			ON
			StudentSchoolYear.STUDENT_GU = Student.STUDENT_GU
			
				INNER JOIN
             --READ ALL ENROLLMENTS         
            [011-SYNERGYDB].ST_Production.rev.EPC_STU_ENROLL AS Enroll
			ON 
            Enroll.STUDENT_SCHOOL_YEAR_GU = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
			

			LEFT JOIN
			rev.EPC_STU_FEE_SUM AS BALANCES
			ON
				BALANCES.STUDENT_GU = Student.STUDENT_GU

			
			--NEED ORG_YEAR FOR REV_YEAR
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION_YEAR AS OrgYear 
            ON 
            OrgYear.ORGANIZATION_YEAR_GU = StudentSchoolYear.ORGANIZATION_YEAR_GU
			--GET SCHOOL NAME
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION AS Organization 
            ON 
            Organization.ORGANIZATION_GU=OrgYear.ORGANIZATION_GU
			--GET SCHOOL NUMBER
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.EPC_SCH AS School 
            ON 
            School.ORGANIZATION_GU =OrgYear.ORGANIZATION_GU
			--GET SCHOOL YEAR
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.REV_YEAR AS RevYear 
            ON 
            RevYear.YEAR_GU = OrgYear.YEAR_GU 
			--GET STUDENT NAME AND ADDRESS_GU
			INNER JOIN
			rev.REV_PERSON AS PERSON
			ON
			PERSON.PERSON_GU = STUDENT.STUDENT_GU
			--GET STUDENT HOME ADDRESS
			INNER JOIN
			rev.REV_ADDRESS AS ADDRESS
			ON
			ADDRESS.ADDRESS_GU = PERSON.HOME_ADDRESS_GU
           -- GET THE GRADE LEVEL
		   INNER JOIN
            (
            SELECT
                  Val.[ALT_CODE_1]
                  ,Val.VALUE_CODE
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE]='Grade'
            ) AS [Grades]
            ON
            Enroll.[GRADE]=[Grades].[VALUE_CODE]

		 
	 LEFT JOIN rev.EPC_STU_CLASS         cls    ON cls.STUDENT_SCHOOL_YEAR_GU  = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU

    LEFT JOIN rev.EPC_SCH_YR_SECT       sec    ON cls.SECTION_GU              = sec.SECTION_GU

     LEFT JOIN rev.EPC_SCH_YR_CRS        sycrs  ON sycrs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU

     LEFT JOIN rev.EPC_CRS               crs    ON crs.COURSE_GU               = sycrs.COURSE_GU



 --CHANGE CRITERIA AS NEEDED
      WHERE
	  			RevYear.SCHOOL_YEAR = @SCHOOL_YEAR
				AND RevYear.EXTENSION = @EXTENSION
				AND NO_SHOW_STUDENT = @NO_SHOW
				--AND SCHOOL_CODE = @SCHOOL
			--AND SIS_NUMBER = 102790268
			AND Grades.ALT_CODE_1 BETWEEN '08' AND '12'


	ORDER BY 
		SCHOOL_CODE
		,STATUS
		,GRADE