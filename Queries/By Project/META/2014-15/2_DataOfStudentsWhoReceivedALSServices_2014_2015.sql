
EXECUTE AS LOGIN='QueryFileUser'
GO


DECLARE @AsOfDate AS DATETIME = '2014-12-15'
	   
	   
	   SELECT 
		'2015' AS SY
		--, SCH.SCHOOL_CODE		
		, CASE 
			WHEN [LOCATION CODE] > '900' THEN ENR.SCHOOL_CODE 
			WHEN [LOCATION CODE] = '040' THEN ENR.SCHOOL_CODE
			ELSE [LOCATION CODE] END AS SCHOOL
		, CASE 
			WHEN [LOCATION CODE] > '900' THEN ENR.SCHOOL_NAME 
			WHEN [LOCATION CODE] = '040' THEN ENR.SCHOOL_NAME
			ELSE ORG.ORGANIZATION_NAME END AS SCHOOL_NAME
		,ALS.SIS_NUMBER
		,[LAST NAME LONG]
		,[FIRST NAME LONG]
		,[HISPANIC INDICATOR]
		,[ETHNIC CODE SHORT]
		,[GENDER CODE]
		
		,CASE 
			WHEN ENR.GRADE IS NULL THEN [CURRENT GRADE LEVEL]
			WHEN [CURRENT GRADE LEVEL] = '12' THEN ENR.GRADE 
		ELSE [CURRENT GRADE LEVEL] END AS GRADE
		
		,CASE 
			WHEN [ENGLISH PROFICIENCY] = 1 THEN 'Y'
			WHEN PHL.DATE_ASSIGNED IS NOT NULL THEN 'Y'
		ELSE 'N' END AS PHLOTE
				
		,CASE
			WHEN FEP.STUDENT_GU IS NOT NULL THEN 'FEP'
			WHEN [ENGLISH PROFICIENCY] IN (2,3) THEN 'FEPM'
			WHEN [ENGLISH PROFICIENCY] = 4 THEN 'FEPE'
			WHEN [ENGLISH PROFICIENCY] = 1 THEN 'ELL'
			ELSE '' 
		END AS [ENGLISH PROFICIENCY]

		,ALS.STATE_STUDENT_NUMBER
	    ,ENR.YEAR_END_STATUS
		,CHILD_FIRST_LANGUAGE
		,BS.HOME_LANGUAGE AS PRIMARY_LANGUAGE

		,ISNULL(ACCESS.PERFORMANCE_LEVEL,'') AS ACCESS_PERFORMANCE_LEVEL
		,ISNULL(ACCESS.TEST_NAME,'')  AS ACCESS_TEST_NAME
		,ISNULL(ACCESS.TEST_SCORE,'')  AS ACCESS_TEST_SCORE
		,ISNULL(ACCESS.SCORE_DESCRIPTION,'')  AS ACCESS_SCORE_DESCRIPTION

		/*
		,CASE WHEN [ENGMODEL].[Field5] = 'BEP' THEN 'Bilingual Model'
			  WHEN [ENGMODEL].[Field5] = 'ESL' THEN 'English Model'
		ELSE ''
		END AS BILINGUAL_ENGLISH_MODEL
		

		--DONT COUNT KIDS IN BOTH, EVEN THOUGH STARS HAS THEM IN BOTH MODELS-----------------------------------------------------  
		,CASE WHEN [ENGLISH PROFICIENCY] = 1 AND [Bilingual Model] = 'BEP' THEN '' 
			  WHEN [ENGLISH PROFICIENCY] = 1 AND [English Model] = 'ESL' THEN [English Model]
		ELSE '' END AS [English Model]
		
		,CASE WHEN [ENGLISH PROFICIENCY] = 1 AND [Bilingual Model] = 'BEP' THEN [Bilingual Model] ELSE '' END AS [Bilingual Model]
		---------------------------------------------------------------------------------------------------------------------------
*/
		,ISNULL([English Model],'') AS [English Model]
		,ISNULL([Bilingual Model],'') AS [Bilingual Model]

		
		,ISNULL(BEPProgramDescription,'') AS BEPProgramDescription
		, ISNULL(ALS2W,'')  AS [Dual Language Immersion]
		, ISNULL(ALSMP,'') AS [Maintenance Bilingual]
		, ISNULL(ALSES,'') AS [Content Based English as a Second Language] 
		, ISNULL(ALSED,'') AS ALSED
		, ISNULL(ALSSH,'') AS ALSSH

		,ISNULL([Parent Refused],'') AS [Parent Refused]
		,ISNULL([Not Receiving Service],'') AS [Not Receiving Service]
		
		,CASE WHEN FRSTSENIOR.STUDENT_GU IS NULL AND ENR.GRADE = '12' THEN 'Y' ELSE 'N' END AS FIRST_TIME_SENIOR
		,ISNULL(CAST(CASE WHEN GRADS.GRADUATION_DATE IS NOT NULL THEN CAST(GRADUATION_DATE AS DATE) ELSE NULL END AS VARCHAR),'') AS GRADUATED
		,CASE WHEN GRADS.DIPLOMA_TYPE IS NOT NULL THEN DIPLOMA_TYPE ELSE '' END AS DIPLOMA_TYPE

		,CASE WHEN DROPOUT.State_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS DROPOUT


	    FROM 
	  
	  (
	   SELECT 
				[SY]
				, [LOCATION CODE]
				,[LAST NAME LONG]
				,[FIRST NAME LONG]
				,[HISPANIC INDICATOR]
				,[ETHNIC CODE SHORT]
				,[GENDER CODE]
				,[CURRENT GRADE LEVEL]
				,[ENGLISH PROFICIENCY]
				,[Field13]
	           ,SIS_NUMBER
			   ,STATE_STUDENT_NUMBER
		  ,STUDENT_GU
		  --SELECT * 
		  FROM
				--Uses the 80th Day Stars File
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS
				INNER JOIN 
				REV.EPC_STU AS STU
				ON STARS.[STUDENT ID] = STU.STATE_STUDENT_NUMBER
				           
		  WHERE
				[Period] = @AsOfDate
				--[Period] =  '2014-12-15'
				AND [DISTRICT CODE] = '001'

) AS ALS

LEFT JOIN 
APS.PHLOTEAsOf(@AsOfDate) AS PHL
ON
ALS.STUDENT_GU = PHL.STUDENT_GU

LEFT JOIN 
(SELECT * FROM 
rev.EPC_STU_PGM_ELL_HIS
WHERE
EXIT_DATE BETWEEN  '2014-06-01' AND '2014-08-14'
) AS FEP
ON
ALS.STUDENT_GU = FEP.STUDENT_GU

---------GET SCHOOL NAME FOR GOOD STARS LOCATIONS------------------------------------
LEFT JOIN 
rev.EPC_SCH AS SCH
ON
ALS.[LOCATION CODE] = SCH.SCHOOL_CODE

LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU
-------------------------------------------------------------------------------------

--GET SYNERGY LOCATION AND NAME WHERE STARS LOCATIONS ARE ROLLED UP, STATE LOCATIONS
LEFT JOIN 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS ENR
ON
ALS.STUDENT_GU = ENR.STUDENT_GU
----------------------------------------------------------------------------------------

--PULL STUDENTS FIRST LANGUAGE
LEFT JOIN 
(
SELECT
	STUDENT_GU
	,DATE_ASSIGNED
	,Q2_CHILD_FIRST_LANGUAGE
	,LANGUAGES AS CHILD_FIRST_LANGUAGE
FROM
	(
	SELECT
		STUDENT_GU
		,Q1_LANGUAGE_SPOKEN_MOST
		,Q2_CHILD_FIRST_LANGUAGE
		,Q3_LANGUAGES_SPOKEN
		,Q4_OTHER_LANG_UNDERSTOOD
		,Q5_OTHER_LANG_COMMUNICATED
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY DATE_ASSIGNED DESC) AS RN
		,DATE_ASSIGNED
		,LU.VALUE_DESCRIPTION AS LANGUAGES
	FROM
		rev.UD_HLS_HISTORY AS HLSHistory
		INNER JOIN 
		APS.LookupTable('K12', 'LANGUAGE') AS LU
		ON
		LU.VALUE_CODE = Q2_CHILD_FIRST_LANGUAGE
	WHERE
		DATE_ASSIGNED <= ('2014-12-15')
	) AS RowedHLS
WHERE
	RN = 1
) AS FIRSTLANG

ON
FIRSTLANG.STUDENT_GU = ALS.STUDENT_GU

----------------------------------------------------------------------------------------------
LEFT JOIN 
APS.BasicStudent AS BS
ON
ALS.STUDENT_GU = BS.STUDENT_GU

----------------------------------------------------------------------------------------------
--PULL ACCESS TEST SCORES 
LEFT JOIN 
(
SELECT 	
	LCETEST.STUDENT_GU
	,LCETEST.PERFORMANCE_LEVEL
	,LCETEST.TEST_NAME
	,SCORES.TEST_SCORE
	,SCORE_DESCRIPTION 
FROM 
APS.LCELatestEvaluationAsOf('2014-12-15') AS LCETEST

INNER HASH JOIN
rev.EPC_TEST_PART AS PART
ON LCETEST.TEST_GU = PART.TEST_GU
AND LCETEST.TEST_NAME = 'ACCESS'

INNER HASH JOIN
rev.EPC_STU_TEST_PART AS STU_PART
ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
AND STU_PART.STUDENT_TEST_GU = LCETEST.STUDENT_TEST_GU

INNER HASH JOIN
rev.EPC_STU_TEST_PART_SCORE AS SCORES
ON
SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

LEFT JOIN
rev.EPC_TEST_SCORE_TYPE AS SCORET
ON
SCORET.TEST_GU = LCETEST.TEST_GU
AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

LEFT JOIN
rev.EPC_TEST_DEF_SCORE AS SCORETDEF
ON
SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

WHERE
SCORETDEF.SCORE_DESCRIPTION = 'Overall LP'

) AS ACCESS

ON
ACCESS.STUDENT_GU = ALS.STUDENT_GU

/*-----------------------------------------------------------------------------------------------

--PULL ENGLISH AND BILINGUAL MODEL FROM STARS - BEP AND ESL 
--STARS DATABASE HAS THIS INCORRECT SO READING SYNERGY INSTEAD
-------------------------------------------------------------------------------------------------*/
/*
LEFT JOIN 
(
SELECT 
	[STUDENT ID]
	,[Field5]
 FROM 
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[PROGRAMS_FACT] AS BilingualModel

  WHERE
				[Period] = '2014-12-15'
				AND [DISTRICT CODE] = '001'
				AND BilingualModel.[Field5] IN ('ESL','BEP')
) AS ENGMODEL
ON
ALS.STATE_STUDENT_NUMBER = ENGMODEL.[STUDENT ID]
*/



/*-----------------------------------------------------------------------------------------------------------

--Students and Their Providers for English Model
------------------------------------------------------------------------------------------------------------*/

LEFT JOIN
(
	SELECT DISTINCT
	SIS_NUMBER
	,CASE WHEN RCVINGSERV.COURSE_ID IS NOT NULL THEN 'ESL' ELSE '' END AS [English Model]
	,RCVINGSERV.PARENT_REFUSED AS [Parent Refused]
	,CASE WHEN RCVINGSERV.STATUS = 'No Appropriate Course Assigned' THEN 'Y' ELSE '' END AS [Not Receiving Service]
    FROM 
	APS.LCEStudentsAndProvidersAsOf('2014-12-15') AS RCVINGSERV
	) AS RCVINGSERV
ON
RCVINGSERV.SIS_NUMBER = ALS.SIS_NUMBER

/*-----------------------------------------------------------------------------------------------------------

--Bilingual Students for Bilingual Model
------------------------------------------------------------------------------------------------------------*/

LEFT JOIN 
(SELECT 
SIS_NUMBER
,CASE WHEN SIS_NUMBER IS NOT NULL THEN 'BEP' ELSE '' END AS [Bilingual Model] 
FROM 
APS.LCEBilingualAsOf('2014-12-15') AS BP
INNER JOIN 
REV.EPC_STU AS STU
ON BP.STUDENT_GU = STU.STUDENT_GU
) AS BEP
ON
ALS.SIS_NUMBER = BEP.SIS_NUMBER


/*-----------------------------------------------------------------------------------------------------------

--PULL ENGLISH AND BILINGUAL MODEL FROM STARS - BEP AND ESL

** STARS DATABASE REPORTING ALL STUDENTS WITH TAGS (100% RECEIVING SERVICE) SO WE'RE USING SYNERGY INSTEAD
------------------------------------------------------------------------------------------------------------*/
LEFT JOIN 
/*(
SELECT 
*
FROM 
(
SELECT 
	[Student_ID]
	,CASE WHEN FIELD_18 = 1 THEN 'Dual Language Immersion'
		 WHEN FIELD_18 = 2 THEN 'Maintenance Bilingual'
		 WHEN FIELD_18 = 3 THEN 'Enrichment'
		 WHEN FIELD_18 = 4 THEN 'Transitional Bilingual'
		 WHEN FIELD_18 = 5 THEN 'Heritage Language'
		 WHEN FIELD_18 = 7 THEN 'Structured English Immersion'
		 WHEN FIELD_18 = 8 THEN 'Content Based English as a Second Language'
		 WHEN FIELD_18 = 9 THEN 'Pull Out English as a Second Language'
		 WHEN FIELD_18 = 10 THEN 'Specifically Designed Academic Instruction in English'
		 WHEN FIELD_18 = 11 THEN 'Sheltered Instruction Observation Protocol'
		 WHEN FIELD_18 = 12 THEN 'Other Model'
	ELSE '' END AS TAGS		 

 FROM
 OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from 80DBEP.csv'
                ) AS [B1]
) AS GET
PIVOT 
(
MAX([TAGS])
FOR [TAGS] IN ([Dual Language Immersion], [Maintenance Bilingual], [Enrichment],[Content Based English as a Second Language] )
) AS PIVOTME
) AS MODELTAGS
ON
MODELTAGS.[Student_ID] = ALS.STATE_STUDENT_NUMBER
*/

/*-----------------------------------------------------------------------------------------------------------

--Use Bilingual Model and Hours Function for Tags and Indicators
------------------------------------------------------------------------------------------------------------*/

(SELECT StudentID, MAX(BEPProgramDescription) AS BEPProgramDescription, MAX(ALS2W) AS ALS2W, MAX(ALSED) AS ALSED, MAX(ALSSH) AS ALSSH, MAX(ALSES) AS ALSES, MAX(ALSMP) AS ALSMP FROM 
APS.BilingualModelAndHoursDetailsAsOf('2014-12-15') AS BEPKIDS
GROUP BY StudentID
) AS MODELTAGS

ON
MODELTAGS.StudentID = ALS.SIS_NUMBER

-----------------------------------------------------------------------------------------------

--PULL FIRST TIME SENIORS
-------------------------------------------------------------------------------------------------
LEFT JOIN 
(
SELECT SIS_NUMBER, GRADE, BS.CLASS_OF, BS.STUDENT_GU FROM 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS PRIM
INNER JOIN 
APS.BasicStudent AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU
WHERE
GRADE = '12'
AND CLASS_OF != '2015'
) AS FRSTSENIOR
ON
FRSTSENIOR.STUDENT_GU = ALS.STUDENT_GU

-----------------------------------------------------------------------------------------------

--PULL GRADUATION DATE AND DIPLOMA TYPE
-------------------------------------------------------------------------------------------------
LEFT JOIN 
(
SELECT bs.GRADUATION_DATE, BS.STUDENT_GU, LU.VALUE_DESCRIPTION AS DIPLOMA_TYPE FROM 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS PRIM
INNER JOIN 
rev.epc_stu AS BS
ON
PRIM.STUDENT_GU = BS.STUDENT_GU
INNER JOIN 
APS.LookupTable('K12', 'DIPLOMA_TYPE') AS LU
ON
LU.VALUE_CODE = BS.DIPLOMA_TYPE
WHERE
GRADUATION_DATE BETWEEN '2014-08-01' AND '2015-08-01'
) AS GRADS
ON
GRADS.STUDENT_GU = ALS.STUDENT_GU



-----------------------------------------------------------------------------------------------

--READ A FILE OF DROPOUTS FROM THE STATE
-------------------------------------------------------------------------------------------------

LEFT JOIN
(
SELECT * FROM
 OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from DROPOUT20142015.csv'
                ) AS [D1]
) AS DROPOUT
ON
DROPOUT.State_ID = ALS.STATE_STUDENT_NUMBER