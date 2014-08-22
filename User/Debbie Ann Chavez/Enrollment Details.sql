 SELECT 
            School.SCHOOL_CODE,Organization.ORGANIZATION_NAME, Student.SIS_NUMBER, RevYear.SCHOOL_YEAR, Enroll.EXCLUDE_ADA_ADM
           , PERSON.LAST_NAME, PERSON.FIRST_NAME,Grades.[ALT_CODE_1] AS GRADE
		   ,(CONVERT (VARCHAR (8), Enroll.ENTER_DATE, 112)) AS ENTERDATE ,(CONVERT (VARCHAR (8), Enroll.LEAVE_DATE, 112)) AS LEAVEDATE
		   ,HOMELANGUAGE.VALUE_DESCRIPTION AS HOME_LANGUAGE
		   ,HOMELANGUAGE2.VALUE_DESCRIPTION AS LANGUAGE_FIRST_LEARN 
		  ,HOMELANGUAGE3.VALUE_DESCRIPTION AS LANGUAGE_BY_HOME
		  ,HOMELANGUAGE4.VALUE_DESCRIPTION AS LANGUAGE_TO_HOME
		  ,HOMELANGUAGE5.VALUE_DESCRIPTION AS LANGUAGE_BY_ADULT_HOME
		   ,Student.STUDENT_GU

		   /*
		    ,StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
            ,Enroll.CHANGE_DATE_TIME_STAMP
            ,Enroll.CHANGE_ID_STAMP
             ,EnterCode.ALT_CODE_1 AS ENTER_CODE
            ,LeaveCode.ALT_CODE_1 AS LEAVE_CODE
            ,Enroll.ENR_USER_DD_4 AS HOMECHAR
            ,Enroll.ADD_DATE_TIME_STAMP
            ,Enroll.ADD_ID_STAMP
            ,Changed.LAST_NAME AS CHGLSTNME
            ,Changed.FIRST_NAME AS CHGFRSNME
            ,Added.LAST_NAME AS ADDLSTNME
            ,Added.FIRST_NAME AS ADDFRSNME
            ,AddBadge.BADGE_NUM AS ADDBADGE
            ,ChangeBadge.BADGE_NUM AS CHGBADGE
			*/
      FROM
            [011-SYNERGYDB].ST_Production.rev.EPC_STU_SCH_YR AS StudentSchoolYear
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.EPC_STU AS Student
            ON 
            Student.STUDENT_GU = StudentSchoolYear.STUDENT_GU
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION_YEAR AS OrgYear 
            ON 
            OrgYear.ORGANIZATION_YEAR_GU = StudentSchoolYear.ORGANIZATION_YEAR_GU
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION AS Organization 
            ON 
            Organization.ORGANIZATION_GU=OrgYear.ORGANIZATION_GU
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.EPC_SCH AS School 
            ON 
            School.ORGANIZATION_GU =OrgYear.ORGANIZATION_GU
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.REV_YEAR AS RevYear 
            ON 
            RevYear.YEAR_GU = OrgYear.YEAR_GU 
            AND RevYear.SCHOOL_YEAR > 2011
            INNER JOIN 
            [011-SYNERGYDB].ST_Production.rev.EPC_STU_ENROLL AS Enroll
            ON 
            Enroll.STUDENT_SCHOOL_YEAR_GU = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
			INNER JOIN
			rev.REV_PERSON AS PERSON
			ON
			PERSON.PERSON_GU = Student.STUDENT_GU

          
		  
		  -- THIS IS TO GET THE GRADE LEVEL
		  
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
            INNER JOIN
            (
            SELECT
                  Val.*
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12.Enrollment'
                  AND [Def].[LOOKUP_DEF_CODE]='ENTER_CODE'
            ) AS [EnterCode]
            ON
            Enroll.[ENTER_CODE]=[EnterCode].[VALUE_CODE]
            LEFT JOIN
            (
            SELECT
                  Val.*
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12.Enrollment'
                  AND [Def].[LOOKUP_DEF_CODE]='LEAVE_CODE'
            ) AS [LeaveCode]
            ON
            Enroll.[LEAVE_CODE]=[LeaveCode].[VALUE_CODE]
            LEFT HASH JOIN
            [011-SYNERGYDB].[ST_Production].[rev].[REV_PERSON] AS [Changed]
            ON
            Enroll.[CHANGE_ID_STAMP]=[Changed].[PERSON_GU]
            LEFT HASH JOIN
            [011-SYNERGYDB].[ST_Production].[rev].[REV_PERSON] AS [Added]
            ON
            Enroll.[ADD_ID_STAMP]=[Added].[PERSON_GU]
            LEFT HASH JOIN
        [011-synergydb].[ST_Production].[rev].[EPC_STAFF] AS [ChangeBadge]
        ON
        Enroll.[CHANGE_ID_STAMP]=[ChangeBadge].[STAFF_GU]
        LEFT HASH JOIN
        [011-synergydb].[ST_Production].[rev].[EPC_STAFF] AS [AddBadge]
        ON
        Enroll.[ADD_ID_STAMP]=[AddBadge].[STAFF_GU]   

			LEFT JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE

	ON
	Student.HOME_LANGUAGE = HOMELANGUAGE.VALUE_CODE


	LEFT JOIN
	rev.EPC_STU_PGM_ELL AS LANGUAGES
	ON
	LANGUAGES.STUDENT_GU = Student.STUDENT_GU

	
	LEFT JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE2

	ON
	LANGUAGES.LANGUAGE_FIRST_LEARN = HOMELANGUAGE2.VALUE_CODE

		INNER JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE3

	ON
	LANGUAGES.LANGUAGE_BY_HOME = HOMELANGUAGE3.VALUE_CODE

	LEFT JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE4

	ON
	LANGUAGES.LANGUAGE_TO_HOME = HOMELANGUAGE4.VALUE_CODE


		LEFT JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE5

	ON
	LANGUAGES.LANGUAGE_BY_ADULT_HOME = HOMELANGUAGE5.VALUE_CODE

	

      
      WHERE
            NO_SHOW_STUDENT = 'N'
            AND 
			(RevYear.SCHOOL_YEAR = 2014 --AND RevYear.EXTENSION = 'S'
			)		
			AND 
		
		 StudentSchoolYear.STATUS is NULL
		 AND SCHOOL_CODE = '250'
		 AND Grades.[ALT_CODE_1] = 'K'


	ORDER BY HOMELANGUAGE.VALUE_DESCRIPTION