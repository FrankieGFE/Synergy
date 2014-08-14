 /*
 *		CREATED BY:  DEBBIE ANN CHAVEZ
 *		DATE:  6/23/2014
 *
 *		PULLS BASIC STUDENTS, ENROLLMENTS, AND ADDRESSES (CAN ADD OTHER FIELDS AS NEEDED: EX: STUDENT.SIS_NUMBER)
 *
 *		ORIGINAL REQUEST - RIGO, FOR CHARTER SCHOOL MAILINGS
 *
 */
  
  USE ST_Production
  GO


  DECLARE @SCHOOL_YEAR INT = 2014
  DECLARE @EXTENSION VARCHAR (1) = 'R'
  DECLARE @NO_SHOW VARCHAR (1) = 'N'
  DECLARE @SCHOOL VARCHAR (3) = '276'
 
 
 SELECT 
       
	   
	     SCHOOL_YEAR
		 ,School.SCHOOL_CODE
		 ,Organization.ORGANIZATION_NAME		
		 ,student.SIS_NUMBER
		 , PERSON.LAST_NAME
		 , PERSON. FIRST_NAME
		 , Grades.[ALT_CODE_1] AS GRADE
		
		  ,CASE  		  
					WHEN	HOME_LANGUAGE != '00' THEN 'Y' 
					WHEN HOMELANGUAGE2.VALUE_DESCRIPTION != 'English' THEN 'Y'
					WHEN  HOMELANGUAGE3.VALUE_DESCRIPTION != 'English' THEN 'Y'
					WHEN HOMELANGUAGE4.VALUE_DESCRIPTION != 'English' THEN 'Y'
					WHEN HOMELANGUAGE5.VALUE_DESCRIPTION != 'English' THEN 'Y'
		 ELSE 'N' END AS PHLOTE

		  ,DECL.DECLND AS [Declined_Test]
		  ,TESTS.[Most Recent Test]

		   ,HOMELANGUAGE.VALUE_DESCRIPTION AS HOME_LANGUAGE
		   ,HOMELANGUAGE2.VALUE_DESCRIPTION AS LANGUAGE_FIRST_LEARN 
		   ,HOMELANGUAGE3.VALUE_DESCRIPTION AS LANGUAGE_BY_HOME
		   ,HOMELANGUAGE4.VALUE_DESCRIPTION AS LANGUAGE_TO_HOME
		   ,HOMELANGUAGE5.VALUE_DESCRIPTION AS LANGUAGE_BY_ADULT_HOME

      FROM
	  			
			 rev.EPC_STU AS Student		
						
			INNER JOIN
			rev.EPC_STU_SCH_YR AS SSY
			ON
			SSY.STUDENT_GU = Student.STUDENT_GU

			INNER JOIN
			rev.EPC_STU_ENROLL AS ENROLL
			ON
			SSY.STUDENT_SCHOOL_YEAR_GU = ENROLL.STUDENT_SCHOOL_YEAR_GU
			AND ENROLL.EXCLUDE_ADA_ADM IS NULL
			
			INNER JOIN
			rev.REV_ORGANIZATION_YEAR AS ORGYR
			ON
			ORGYR.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
						
			--GET SCHOOL NAME
            INNER JOIN 
          rev.REV_ORGANIZATION AS Organization 
            ON 
            Organization.ORGANIZATION_GU=ORGYR.ORGANIZATION_GU
			--GET SCHOOL NUMBER
            INNER JOIN 
           rev.EPC_SCH AS School 
            ON 
            School.ORGANIZATION_GU =ORGYR.ORGANIZATION_GU
			--GET SCHOOL YEAR
            INNER JOIN 
           rev.REV_YEAR AS RevYear 
            ON 
            RevYear.YEAR_GU = SSY.YEAR_GU 
			--GET STUDENT NAME AND ADDRESS_GU
			INNER JOIN
			rev.REV_PERSON AS PERSON
			ON
			PERSON.PERSON_GU = STUDENT.STUDENT_GU
		
           -- GET THE GRADE LEVEL
		  LEFT JOIN
            (
            SELECT
                  Val.[ALT_CODE_1]
                  ,Val.VALUE_CODE
            FROM
                  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE]='Grade'
            ) AS [Grades]
            ON
            SSY.[GRADE]=[Grades].[VALUE_CODE]

/*********************************************************************************************************************
*
*		WE DO NOT STORE MOST RECENT PHLOTE AS OF YET IN SYNERGY SO WE ARE USING HOME LANGUAGE
*		HOME LANGUAGE IS WHERE TRAINING TOLD FOLKS TO STORE PRIMARY LANGUAGE 
*
**********************************************************************************************************************/

		LEFT JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
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
                  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE2

	ON
	LANGUAGES.LANGUAGE_FIRST_LEARN = HOMELANGUAGE2.VALUE_CODE

		LEFT JOIN
		 (SELECT
                  Val.VALUE_CODE
				  ,Val.VALUE_DESCRIPTION
            FROM
                  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
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
                  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
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
                  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
                  INNER JOIN
                  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
                  ON
                  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
                  AND [Def].[LOOKUP_NAMESPACE]='K12'
                  AND [Def].[LOOKUP_DEF_CODE] = 'Language'
	) AS HOMELANGUAGE5

	ON
	LANGUAGES.LANGUAGE_BY_ADULT_HOME = HOMELANGUAGE5.VALUE_CODE



/*****************************************************************************************
*		READ SCHOOLMAX FOR:
*			1.  MOST RECENT TEST DECLINED
*			2.  MOST RECENT TEST ASSESSMENT
*
******************************************************************************************/


--Pulls Tests Declined	from schoolmax
	LEFT JOIN 

	(
	SELECT * FROM 
OPENQUERY([SMAXDBPROD.APS.EDU.ACTD],'SELECT * FROM PR.APS.LCEMostRecentTestDeclineAsOf (GETDATE())
WHERE DST_NBR = 1')

	) AS DECL

	ON
	CAST(DECL.ID_NBR AS VARCHAR) = Student.SIS_NUMBER 
	-------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------
	--Pulls Most Recent LCETest

	LEFT JOIN
	(SELECT * FROM 
	OPENQUERY([SMAXDBPROD.APS.EDU.ACTD],'SELECT * FROM PR.APS.LCELatestEvaluationAsOf (GETDATE())
	WHERE DST_NBR = 1')
	) AS TESTS

	ON
	CAST(TESTS.ID_NBR AS VARCHAR) = Student.SIS_NUMBER

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


 --CHANGE CRITERIA AS NEEDED
      WHERE
	  			
				RevYear.SCHOOL_YEAR = @SCHOOL_YEAR
				AND RevYear.EXTENSION = @EXTENSION
				AND NO_SHOW_STUDENT = @NO_SHOW
				
				--active students only
				AND STATUS IS NULL
				--AND SCHOOL_CODE = @SCHOOL

AND 
	(
	HOME_LANGUAGE != '00'
	OR HOMELANGUAGE2.VALUE_DESCRIPTION != 'English'
	OR HOMELANGUAGE3.VALUE_DESCRIPTION != 'English'
	OR HOMELANGUAGE4.VALUE_DESCRIPTION != 'English'
	OR HOMELANGUAGE5.VALUE_DESCRIPTION != 'English'
	)


AND (
		DECLND != 'Y'
		OR 
		DECLND IS NULL
		)


    AND [Most Recent Test] IS NULL
AND [ALT_CODE_1] NOT IN ('P1', 'P2', 'PK')

	ORDER BY 
	SCHOOL_CODE
	,GRADE
	--Student.HOME_LANGUAGE