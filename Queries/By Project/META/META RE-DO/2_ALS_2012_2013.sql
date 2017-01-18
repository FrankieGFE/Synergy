/**

  Author:	Debbie Ann Chavez
  Date:		7/9/2013

  2.	Data of students who received Alternative Language Services (ALS) - *2012, 2013 only.
		For students that are PHLOTE, NON-PHLOTE, ELL, FEPM, FEPE use the last day STARS for each school year (2009-2013) and pull ALL students (English proficiency 0-4).
		To identify students that are FEP, pull from STARS file where English proficiency is equal to 0 and where students tested out of ELL on their first assessment in Schoolmax.
				DETAIL - For the students above pull the following:
		a.	SY, School, ID Number, Last Name, First Name, Hispanic Indicator, Grade Level, Ethnicity, 
			Gender, Phlote, English Proficiency, 
			(Spring) KDPR ELA, (Spring) KDPR Math, (Spring) DRA PL,  -- FROM FRANK AIMS
			(Spring) DBA ELA, (Spring) DBA ELA PL, (Spring) DBA Math, (Spring) DBA Math PL,  -- FROM FRANK AIMS
			SBA Read (English & Spanish) PL, SBA Read (English & Spanish) SS, 
			SBA Math (English & Spanish) PL, SBA Math (English & Spanish) SS

    
    -Must change SchoolYear, and AsOfDate

FOR ACCESS:  
	-Must change AsOfDate,School Year
		AND EVALDate to last day of school:
			2009 LD = 05-22-2009
			2010 LD = 05-28-2010
			2011 LD = 05-31-2011
			2012 LD = 05-29-2012
			2013 LD = 05-22-2013
   
FOR 40-DAY:  
   	    -Must change SchoolYear, 
	    and AsOfDate, *note AsOfDay is the 40-Day at the start of year:
			2013 = 2012-10-01
			2012 = 2011-10-01
			2011 = 2010-10-01
			2010 = 2009-10-01
			2009 = 2008-10-01

FOR EOY:  
			USE 06-01-CCYY
	
**/

USE PR
GO


DECLARE @SchoolYear AS INT = 2013
DECLARE @AsOfDate AS DATETIME = '2012-12-15'
--DONT EVEN NEED THIS ANYMORE: 
DECLARE @120THDAY AS DATETIME = '2012-12-15'

--THIS IS NEEDED FOR ACCESS LATEST EVAL DATE
DECLARE @EVALDate AS DATETIME = '2013-05-22'

-- CHANGE THE DROPOUT FILE NAME!! 

-- CHANGE THE SENIOR START DATE HARDCODED IN SUBSELECT = '2012-10-01'

--  CHANGE EOY Stars File FOR GRAD DATA HARDCODED IN SUBSELECT = '2014-06-01'

SELECT
		
		ALS.[SY]
		,ALS.[LOCATION CODE] AS SCHOOL
		,SCHNME.SCH_NME_27 AS SCHOOL_NAME
		,ALS.ID_NBR
		,ALS.[LAST NAME LONG]
		,ALS.[FIRST NAME LONG]
		,ALS.[HISPANIC INDICATOR]
		,ALS.[ETHNIC CODE SHORT]
		,ALS.[GENDER CODE]
		,ALS.[Field11] AS GRADE
		
		,CASE WHEN Phlote120.PHLOTE IS NOT NULL THEN Phlote120.PHLOTE ELSE Phlote.PHLOTE END AS PHLOTE
		
		,CASE 
			  WHEN THE120DAY.[ENGLISH PROFICIENCY] = 1 THEN 'ELL' 
			  WHEN EverEll = '' AND THE120DAY.[ENGLISH PROFICIENCY] = 0 THEN 'FEP' 
			  WHEN THE120DAY.[ENGLISH PROFICIENCY] = 0 THEN ''
			  WHEN THE120DAY.[ENGLISH PROFICIENCY] IN (2,3) THEN 'FEPM'
			  WHEN THE120DAY.[ENGLISH PROFICIENCY] = 4 THEN 'FEPE' 
		ELSE 
			 CASE WHEN ALS.[ENGLISH PROFICIENCY] = 1 THEN 'ELL'
			  WHEN EverEll = '' AND ALS.[ENGLISH PROFICIENCY] = 0 THEN 'FEP' 
			  WHEN ALS.[ENGLISH PROFICIENCY] IN (2,3) THEN 'FEPM'
			  WHEN ALS.[ENGLISH PROFICIENCY] = 4 THEN 'FEPE' 
			 ELSE '' END
		 		 
		 END AS [ENGLISH PROFICIENCY]
		 
		--,ISNULL(CASE WHEN SBA_READ.TEST_SUB IN ('REAE','REAS') THEN SBA_READ.SCORE_1 END, '') AS SBA_READ_PL
		--,ISNULL(CASE WHEN SBA_READ.TEST_SUB IN ('REAE','REAS') THEN SBA_READ.SCORE_2 END, '') AS SBA_READ_SS
		--,ISNULL(CASE WHEN SBA_MATH.TEST_SUB IN ('MATE','MATS') THEN SBA_MATH.SCORE_1 END,'') AS SBA_MATH_PL
		--,ISNULL(CASE WHEN SBA_MATH.TEST_SUB IN ('MATE','MATS') THEN SBA_MATH.SCORE_2 END, '') AS SBA_MATH_SS
		,ALS.STATE_ID 
		
		, CASE WHEN ENROLL.END_STAT = 57 THEN 'P' 
				WHEN ENROLL.END_STAT = 63 THEN 'R'
				WHEN ENROLL.END_STAT = 59 THEN 'G'
				ELSE ''
			END AS YEAR_END_STATUS

		,CASE WHEN Phlote2.HLS_Q_2 != 0 THEN 'Y' ELSE '' END AS [Students with first language Non-English]
		,CASE WHEN Phlote2.HLS_Q_2 = 0 THEN 'Y' ELSE '' END AS [Students with first language English]

	,ISNULL([ELL Level].[ELL Level],'') AS [Ell Level]
	,ISNULL([ELL Level].[Most Recent Test],'') AS [Most Recent Test]
	,ISNULL([ELL Level].Score,'') AS [Score]

	,Language.LANG_DESCR AS PRIMARY_LANGUAGE

	,CASE WHEN Retained.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS Retained

	,CASE WHEN Dropout.[State ID] IS NOT NULL THEN 'Y' ELSE '' END AS Dropout

	--THESE ARE THE BILINGUAL TAGS FROM STARS PROGRAMS FACT 
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'ESL' AND [Field18] = 9  THEN 'X' END,'') AS ESL
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'ESL' AND [Field18] = 12 THEN 'X' END,'') AS ELD
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'BEP' AND [Field18] = 2 THEN 'X' END,'') AS MAINTPRG
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'BEP' AND [Field18] = 4 THEN 'X' END,'') AS TRANSITL
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'BEP' AND [Field18] = 1 THEN 'X' END,'') AS TWO_W_DUAL	


	,CASE WHEN SENIORS.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS [Students that were Seniors at the start of the SY]

	,CASE WHEN GRADS.GRAD IS NOT NULL THEN 'Y' ELSE '' END AS [Students that were Seniors at the start of the SY that graduated]

	,CASE WHEN CAREER.CAREERDIP IS NOT NULL THEN 'Y' ELSE '' END AS [Students that were Seniors at the start of the SY that earned a Career Diploma]

	,CASE WHEN PARENTREFUSED.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS [Parent Refused]

	,CASE WHEN NOTRECEIVINGSERVICE.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS [Not Receiving Service]

	FROM
		
		/********************************************************************************************************

		START WITH THE 80-DAY KIDS REPORTED

		********************************************************************************************************/
		
		(
	   SELECT 
				[SY]
				,CASE WHEN [Field12] IS NULL THEN [LOCATION CODE] ELSE [Field12] END AS [LOCATION CODE]
				,[LAST NAME LONG]
				,[FIRST NAME LONG]
				,[HISPANIC INDICATOR]
				,[ETHNIC CODE SHORT]
				,[GENDER CODE]
				,[Field11]
				,[ENGLISH PROFICIENCY]
				,[Field13]
	                  
				,CASE WHEN CensusState.STATE_ID IS NOT NULL THEN CensusState.ID_NBR ELSE
				CASE WHEN CensusID.ID_NBR IS NOT NULL THEN CensusID.ID_NBR ELSE
				CASE WHEN CensusPrior.PRIOR_ID IS NOT NULL THEN CAST(CensusPrior.ID_NBR AS INT)
				ELSE '' END END END 
				AS ID_NBR
				,CensusState.STATE_ID    

				,[Period]

	           
		  FROM
				--Uses the 80th Day Stars File
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS
				--MATCH STATEID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusState
				ON
				CensusState.DST_NBR = 1 
				AND STARS.[STUDENT ID] = CensusState.STATE_ID collate database_default
	            
	            
				--MATCH STARSID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusID
				ON
				CensusID.DST_NBR = 1
				AND STARS.[Field13] = CensusID.ID_NBR 
	            
	            
				--MATCH STATEID TO GET PRIORID
				LEFT JOIN
				DBTSIS.CE020_V AS CensusPrior
				ON
				CensusPrior.DST_NBR = 1
				AND STARS.[STUDENT ID] = CensusPrior.PRIOR_ID collate database_default                 
		  WHERE
				[Period] = @AsOfDate
				AND [DISTRICT CODE] = '001'
		) AS ALS

--------------------------------------------------------------------------------------------------------------
--GET 120TH DAY DATA BECAUSE 80 DAY WAS BAD
	LEFT JOIN 
			(
			SELECT * FROM 
			[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS

			WHERE
			[Period] = @120THDAY
			AND [DISTRICT CODE] = '001'
			) AS THE120DAY

			ON
			ALS.[Field13] = THE120DAY.[Field13]
----------------------------------------------------------------------------------------------------------------
--80TH DAY PHLOTE
	LEFT JOIN
	APS.PhloteStatusAsOf (@AsOfDate) AS Phlote
	ON
	Phlote.DST_NBR = 1
	AND Phlote.ID_NBR = ALS.ID_NBR
------------------------------------------------------------------------------------------------------------------
--120 DAY PHLOTE
LEFT JOIN
	APS.PhloteStatusAsOf (@120THDAY) AS Phlote120
	ON
	Phlote.DST_NBR = 1
	AND Phlote120.ID_NBR = ALS.ID_NBR
-----------------------------------------------------------------------------------------------------------------------

/********************************************************************************************************

CALCULATE FEP STUDENTS

********************************************************************************************************/


	FULL OUTER JOIN
	(
		SELECT 
			*
		FROM
			(
		SELECT
			DST_NBR
			,ID_NBR
			,MAX(ELL_STAT) AS EverEll
		FROM 
			DBTSIS.NM034_V
		--MAY NEED TO TAKE OUT ?????
		--WHERE
		--SCH_YR = @SchoolYear
		GROUP BY
			DST_NBR,
			ID_NBR
			) AS EVER
		WHERE
			EverEll = '' OR EverEll IS NULL
	) AS FEP

	ON
	Phlote.DST_NBR = FEP.DST_NBR
	AND Phlote.ID_NBR = FEP.ID_NBR

/********************************************************************************************************

PULL SBA TESTS - (FRANK IS PULLING INSTEAD)

********************************************************************************************************/

/*
	LEFT JOIN
	(
	SELECT 
		*
	FROM
		(SELECT
			ROW_NUMBER() OVER (PARTITION BY DST_NBR, SCH_YR, TEST_ID, TEST_SUB, ID_NBR ORDER BY TEST_DT DESC) AS RN,
			DST_NBR
			,ID_NBR
			,SCH_YR
			,TEST_ID
			,TEST_SUB
			,TEST_DT
			,SCORE_1
			,SCORE_2			
		 FROM
			DBTSIS.GS055_V
		 WHERE
			DST_NBR = 1
			AND TEST_ID = 'SBA'
			AND TEST_SUB IN ('REAE', 'REAS')
			AND SCH_YR = @SchoolYear
		)AS SBA_Tests
	WHERE
		RN = 1
	) AS SBA_READ
ON
Phlote.ID_NBR = SBA_READ.ID_NBR

LEFT JOIN
	(
	SELECT 
		*
	FROM
		(SELECT
			ROW_NUMBER() OVER (PARTITION BY DST_NBR, SCH_YR, TEST_ID, TEST_SUB, ID_NBR ORDER BY TEST_DT DESC) AS RN,
			DST_NBR
			,ID_NBR
			,SCH_YR
			,TEST_ID
			,TEST_SUB
			,TEST_DT
			,SCORE_1
			,SCORE_2			
		 FROM
			DBTSIS.GS055_V
		 WHERE
			DST_NBR = 1
			AND TEST_ID = 'SBA'
			AND TEST_SUB IN ('MATE', 'MATS')
			AND SCH_YR = @SchoolYear
		)AS SBA_Tests
	WHERE
		RN = 1
	) AS SBA_MATH
ON
Phlote.ID_NBR = SBA_MATH.ID_NBR
*/


/********************************************************************************************************
	--GET THE SCHOOL NAME FROM THE ACTUAL PHYSICAL SCHOOL CODE IN STARS (NOT STATE SCHOOL CODE NUMBER)
********************************************************************************************************/

LEFT JOIN
DBTSIS.SY010_V AS SCHNME
ON
SCHNME.DST_NBR = 1
AND SCHNME.SCH_NBR = ALS.[LOCATION CODE] collate DATABASE_DEFAULT



/********************************************************************************************************
	READ STUDENT'S LAST ENROLLMENT THAT HOLDS HOW THE STUDENT ENDED THE SCHOOL YEAR, YEAR END STATUS
********************************************************************************************************/

LEFT JOIN 
(SELECT DISTINCT ENR.ID_NBR, ENR.END_STAT FROM 
APS.MostRecentPrimaryEnrollBySchYr(@SchoolYear) AS MRE
INNER JOIN 
DBTSIS.ST010 AS ENR
ON
MRE._Id= ENR._Id
INNER JOIN 
DBTSIS.CE020_V AS CEN
ON
ENR.ID_NBR = CEN.ID_NBR
WHERE
MRE.DST_NBR = 1
) AS ENROLL
ON
ENROLL.ID_NBR = ALS.ID_NBR

/**********************************************************************
		GET FIRST LANGUAGE ENGLISH AND NON ENGLISH
***********************************************************************/
LEFT JOIN
DBTSIS.NM030 AS Phlote2 WITH (NOLOCK)
ON
Phlote.NM030_Id = Phlote2._Id


/**********************************************************************
		PULL ACCESS SCORES
***********************************************************************/	
	
	LEFT JOIN
	APS.LCELatestEvaluationAsOf (@EVALDate) AS [ELL Level]
	ON
	Phlote.DST_NBR = [ELL Level].DST_NBR
	AND Phlote.ID_NBR = [ELL Level].ID_NBR

/**********************************************************************
		Get Primary Language
***********************************************************************/	

LEFT JOIN
	DBTSIS.CE030_V AS Language
	ON
	Phlote.DST_NBR = Language.DST_NBR
	AND Phlote.[Primary Language] = Language.LANG_CD



/**********************************************************************
		Get Retained
***********************************************************************/	
LEFT JOIN 
(
	SELECT 
		Enrolled.ID_NBR
		,Enrolled.DST_NBR
	FROM
		(
		SELECT
			ROW_NUMBER() OVER (PARTITION BY DST_NBR, ID_NBR ORDER BY BEG_ENR_DT DESC) AS RN
			,DST_NBR
			,ID_NBR
			,SCH_YR
		FROM
			DBTSIS.ST010_V
		WHERE
			 DST_NBR = 1
			 AND NONADA_SCH != 'X' 
			 AND SCH_YR = @SchoolYear
			 AND CAST(BEG_ENR_DT AS VARCHAR) <= @AsOfDate
			 AND END_ENR_DT NOT LIKE '%0000'
			 AND END_STAT = 63
		) AS Enrolled
	WHERE
		RN = 1
	) AS Retained
	ON
	Phlote.DST_NBR = Retained.DST_NBR
	AND Phlote.ID_NBR = Retained.ID_NBR

/************************************************************************************************
--READ FILE OF DROPOUTS FROM DOLORES/STATE PED
--Dropout2013.csv means they last attended in 2012-2013 and did not show up anywhere in 2013-2014
--Dropout2014.csv means they last attended in 2013-2014 and did not show up anywhere in 2014-2015
*************************************************************************************************/
		LEFT JOIN 
		(
		SELECT * FROM 
	OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=E:\SQLWorkingFiles;', 'SELECT * from "Dropout2013.csv"')
		) AS Dropout

		ON Dropout.[State ID]  = ALS.STATE_ID


/**********************************************************************
	Pull Indicator For Bilingual Tags for Bilingual from PED 
***********************************************************************/	

	LEFT JOIN
				
				(SELECT 
				[Field5], [Field18], [STUDENT ID], Period
				FROM
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[PROGRAMS_FACT] 
				WHERE
				[DISTRICT CODE] = '001'
				AND [Field5] IN ('ESL', 'BEP')
				) AS BilingualModel
				ON
				ALS.STATE_ID = BilingualModel.[STUDENT ID] collate database_default
				AND BilingualModel.Period = ALS.Period



/******************************************************************************
	READ 40-DAY SNAPSHOT TO SEE WHICH SENIORS STARTED OUT THE YEAR AS A SENIOR
*******************************************************************************/	

	LEFT JOIN

(
		SELECT STARS.[Field11] AS SENIORGRADE
		,CASE WHEN CensusState.STATE_ID IS NOT NULL THEN CensusState.ID_NBR ELSE
				CASE WHEN CensusID.ID_NBR IS NOT NULL THEN CensusID.ID_NBR ELSE
				CASE WHEN CensusPrior.PRIOR_ID IS NOT NULL THEN CAST(CensusPrior.ID_NBR AS INT)
				ELSE '' END END END 
				AS ID_NBR
		FROM
				--STARS 40-day Student Snapshot				
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS

						
				--MATCH STATEID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusState
				ON
				CensusState.DST_NBR = 1 
				AND STARS.[STUDENT ID] = CensusState.STATE_ID collate database_default
	            	            
				--MATCH STARSID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusID
				ON
				CensusID.DST_NBR = 1
				AND STARS.[Field13] = CensusID.ID_NBR 
	            
	            --MATCH STATEID TO GET PRIORID
				LEFT JOIN
				DBTSIS.CE020_V AS CensusPrior
				ON
				CensusPrior.DST_NBR = 1
				AND STARS.[STUDENT ID] = CensusPrior.PRIOR_ID collate database_default                 
		WHERE
				STARS.[DISTRICT CODE] = '001'
				AND STARS.[Field11] = '12'
				AND STARS.[Period] = '2012-10-01'
		) AS SENIORS

		ON
		SENIORS.ID_NBR = ALS.ID_NBR



/******************************************************************************
	READ EOY STARS HISTORY TO SEE WHICH SENIORS GRADUATED
*******************************************************************************/	

	LEFT JOIN

(		
		SELECT 
		CASE WHEN CensusState.STATE_ID IS NOT NULL THEN CensusState.ID_NBR ELSE
				CASE WHEN CensusID.ID_NBR IS NOT NULL THEN CensusID.ID_NBR ELSE
				CASE WHEN CensusPrior.PRIOR_ID IS NOT NULL THEN CAST(CensusPrior.ID_NBR AS INT)
				ELSE '' END END END 
				AS ID_NBR
		,STUDENT.[DIPLOMA TYPE CODE] AS GRAD 
		FROM
				--STARS 40-day Student Snapshot				
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS

				--READ STUDENT DATABASE END OF YEAR FOR GRAD DATA
				INNER JOIN
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUDENT] AS STUDENT
				ON
				STARS.[STUDENT ID] = STUDENT.[STUDENT ID]
				AND STUDENT.[Period] = '2013-06-01'
				AND STUDENT.[DISTRICT CODE] = '001'
				
				--MATCH STATEID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusState
				ON
				CensusState.DST_NBR = 1 
				AND STARS.[STUDENT ID] = CensusState.STATE_ID collate database_default
	            	            
				--MATCH STARSID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusID
				ON
				CensusID.DST_NBR = 1
				AND STARS.[Field13] = CensusID.ID_NBR 
	            
	            
				--MATCH STATEID TO GET PRIORID
				LEFT JOIN
				DBTSIS.CE020_V AS CensusPrior
				ON
				CensusPrior.DST_NBR = 1
				AND STARS.[STUDENT ID] = CensusPrior.PRIOR_ID collate database_default                 
		WHERE
				STARS.[DISTRICT CODE] = '001'
				AND STARS.[Field11] = '12'
				AND STARS.[Period] = '2012-10-01'
		) AS GRADS

		ON
		GRADS.ID_NBR = ALS.ID_NBR



/******************************************************************************
	READ EOY STARS HISTORY TO SEE WHICH SENIORS earned a Career Diploma
*******************************************************************************/	

LEFT JOIN 
(
SELECT 
		CASE WHEN CensusState.STATE_ID IS NOT NULL THEN CensusState.ID_NBR ELSE
				CASE WHEN CensusID.ID_NBR IS NOT NULL THEN CensusID.ID_NBR ELSE
				CASE WHEN CensusPrior.PRIOR_ID IS NOT NULL THEN CAST(CensusPrior.ID_NBR AS INT)
				ELSE '' END END END 
				AS ID_NBR
		,STUDENT.[21_Expected_Diploma_Type] AS CAREERDIP 
		FROM
				--STARS 40-day Student Snapshot				
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS

				--READ STUDENT DATABASE END OF YEAR FOR GRAD DATA
				INNER JOIN
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[SPECIAL_ED_SNAP] AS STUDENT
				ON
				STARS.[STUDENT ID] = STUDENT.[STUDENT ID]
				AND STUDENT.[Period] = '2013-06-01'
				AND STUDENT.[DISTRICT CODE] = '001'
				
				--MATCH STATEID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusState
				ON
				CensusState.DST_NBR = 1 
				AND STARS.[STUDENT ID] = CensusState.STATE_ID collate database_default
	            	            
				--MATCH STARSID TO GET ID NUMBER
				LEFT JOIN
				DBTSIS.CE020_V AS CensusID
				ON
				CensusID.DST_NBR = 1
				AND STARS.[Field13] = CensusID.ID_NBR 
	            
	            
				--MATCH STATEID TO GET PRIORID
				LEFT JOIN
				DBTSIS.CE020_V AS CensusPrior
				ON
				CensusPrior.DST_NBR = 1
				AND STARS.[STUDENT ID] = CensusPrior.PRIOR_ID collate database_default                 
		WHERE
				STARS.[DISTRICT CODE] = '001'
				AND STARS.[Field11] = '12'
				AND STARS.[Period] = '2012-10-01'
) AS CAREER

ON
CAREER.ID_NBR = ALS.ID_NBR



/******************************************************************************
	PARENT REFUSED SERVICES
*******************************************************************************/	

LEFT JOIN 
(SELECT ID_NBR FROM 
APS.LCEMostRecentServicesRefusalAsOf(@EVALDate)
WHERE 
DST_NBR = 1
) AS PARENTREFUSED

ON
PARENTREFUSED.ID_NBR = ALS.ID_NBR



/******************************************************************************
	STUDENTS NOT RECEIVING SERVICES
*******************************************************************************/	
LEFT JOIN 
(
SELECT * FROM 
APS.LCEStudentsAndProvidersAsOf(@EVALDate)
WHERE 
DST_NBR = 1
AND COURSE IS NULL AND PARENT_REFUSAL = 'N'
) AS NOTRECEIVINGSERVICE
ON
NOTRECEIVINGSERVICE.ID_NBR = ALS.ID_NBR

WHERE
	ALS.ID_NBR IS NOT NULL
	--AND ALS.ID_NBR != 0

--GROUP BY
--ALS.[SY]

ORDER BY [ENGLISH PROFICIENCY] ASC