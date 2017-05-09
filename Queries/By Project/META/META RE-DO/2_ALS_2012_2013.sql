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

SELECT DISTINCT
	FINALFINAL.*
	,CASE 
WHEN [Most Recent Test] = 'ACCESS' AND [Ell Level] = 'Entering' THEN 'ENTERING' 
WHEN [Most Recent Test] = 'ACCESS' AND [Ell Level] = 'Emerging' THEN 'EMERGING'
WHEN [Most Recent Test] = 'ACCESS' AND [Ell Level] = 'Developing' THEN 'DEVELOPING'
WHEN [Most Recent Test] = 'ACCESS' AND [Ell Level] = 'Expanding' THEN 'EXPANDING'
WHEN [Most Recent Test] = 'ACCESS' AND [Ell Level] = 'Bridging' THEN 'BRIDGING'
WHEN [Most Recent Test] = 'ACCESS' AND [Ell Level] = 'Reaching' THEN 'REACHING'
WHEN [Most Recent Test] = 'LAS' AND [Ell Level] = 'Fully English Proficient' THEN 'BRIDGING'
WHEN [Most Recent Test] = 'LAS' AND [Ell Level] = 'Limited English Proficient' THEN 'DEVELOPING'
WHEN [Most Recent Test] = 'LAS' AND [Ell Level] = 'Non-English Proficient' THEN 'ENTERING'

WHEN [Most Recent Test] = 'ELPA' AND [Ell Level] = 'Beginning' THEN 'ENTERING'
WHEN [Most Recent Test] = 'ELPA' AND [Ell Level] = 'Early Intermediate' THEN 'EMERGING'
WHEN [Most Recent Test] = 'ELPA' AND [Ell Level] = 'Intermediate' THEN 'DEVELOPING'
WHEN [Most Recent Test] = 'ELPA' AND [Ell Level] = 'Early Advanced' THEN 'EXPANDING'
WHEN [Most Recent Test] = 'ELPA' AND [Ell Level] = 'Advanced' THEN 'BRIDGING'

WHEN [Most Recent Test] = 'PRE-LAS' AND [Ell Level] = 'Fully English Proficient' THEN 'Initial FEP'
WHEN [Most Recent Test] = 'PRE-LAS' AND [Ell Level] = 'Limited English Proficient' THEN 'DEVELOPING'
WHEN [Most Recent Test] = 'PRE-LAS' AND [Ell Level] = 'Non-English Proficient' THEN 'ENTERING'

WHEN [Most Recent Test] = 'SCRE' AND [Ell Level] = 'English Language Learner' THEN 'ENTERING'
WHEN [Most Recent Test] = 'SCRE' AND [Ell Level] = 'NULL' THEN 'NULL'
WHEN [Most Recent Test] = 'SCRE' AND [Ell Level] = 'Proficient' THEN 'Initial FEP'

WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'ELL' THEN 'ENTERING'
WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'Entering' THEN 'ENTERING'
WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'Emerging' THEN 'EMERGING'
WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'Developing' THEN 'DEVELOPING'
WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'Expanding' THEN 'EXPANDING'
WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'Bridging' THEN 'Initial FEP'
WHEN [Most Recent Test] = 'WAPT' AND [Ell Level] = 'Reaching' THEN 'Initial FEP'

ELSE [Ell Level] END AS CONSOLIDATED_PERFORMANCE_LEVEL



FROM (
SELECT 

SY
,SCHOOL
,SCHOOL_NAME
,ID_NBR
,[LAST NAME LONG]
,[FIRST NAME LONG]
,[HISPANIC INDICATOR]
,[ETHNIC CODE SHORT]
,[GENDER CODE]

,GRADE AS ORIGINAL_GRADE 
,CASE 
			WHEN GRADE = 'KF' THEN 'K'
			WHEN GRADE IN ('C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4') THEN 'Continuing Special Education Student'
ELSE GRADE END AS GRADE

,PHLOTE AS PHLOTE
, CASE 
		WHEN PHLOTE = 'N' AND [Ell Level] != '' THEN 'Y' 
ELSE PHLOTE END AS [ADJUSTED PHLOTE]


,[ENGLISH PROFICIENCY] AS [ENGLISH PROFICIENCY]
,CASE 
				
				--WHEN [ENGLISH PROFICIENCY] = '' AND [ELL Eligible] = '' AND [Most Recent Test] NOT IN ('WAPT', 'SCREENER', 'PRE-LAS') AND [Test Date] < '20100701' THEN 'FEPE'
				--WHEN [ENGLISH PROFICIENCY] = '' AND [ELL Eligible]  = ''  AND [Most Recent Test] NOT IN ('WAPT', 'SCREENER', 'PRE-LAS') AND [Test Date] BETWEEN '20100701' AND '20110701' THEN 'FEPM'
				--WHEN [ENGLISH PROFICIENCY] = '' AND [ELL Eligible]  = ''  AND [Most Recent Test] NOT IN ('WAPT', 'SCREENER', 'PRE-LAS') AND [Test Date] BETWEEN  '20110701' AND '20120701' THEN 'FEP'
				WHEN [ENGLISH PROFICIENCY] = '' AND [ELL Eligible]  = 'X' THEN 'ELL'
				WHEN [ENGLISH PROFICIENCY] != '' AND [Most Recent Test] IN ('WAPT', 'SCREENER', 'PRE-LAS') AND [ELL Eligible]  = ''   THEN 'InitialFEP'
				WHEN [ENGLISH PROFICIENCY] = '' AND [Most Recent Test] IN ('WAPT', 'SCREENER', 'PRE-LAS') AND [ELL Eligible]  = ''   THEN 'InitialFEP'

				WHEN PHLOTE = 'Y' AND [Test Date] IS NULL AND  PRIMARY_LANGUAGE != 'American Sign language' THEN 'NOT DETERMINABLE'
				WHEN PHLOTE = 'N' AND [Test Date] IS NULL THEN '' 
		ELSE  [ENGLISH PROFICIENCY] 
END AS [ADJUSTED ENGLISH PROFICIENCY]


,STATE_ID

,YEAR_END_STATUS
,END_ENR_DT		


--,[Students with first language Non-English]
--,[Students with first language English]

,[Students First Language]

,PRIMARY_LANGUAGE

,[Ell Level]
,[Most Recent Test]
,Score

,[English Model]
,[Bilingual Model]

,BEPProgramDescription
,[Dual Language Immersion]
,[Maintenance Bilingual]
,[Content Based English as a Second Language]
,ALSED
,ALSSH
,[Parent Refused]
,[Not Receiving Service]
,[Students that were Seniors at the start of the SY]
,GRADUATED
--,[Students that were Seniors at the start of the SY that earned a Career Diploma]
,DIPLOMA_TYPE
,Dropout
,GIFTED
,SPED

FROM (
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
		
		,ALS.[Field11] AS [GRADE]
		/*
		,CASE 
			WHEN ALS.[Field11] = '12' THEN ENROLL.GRDE
			--WHEN [CURRENT GRADE LEVEL] = 'PK' THEN ENR.GRADE
			WHEN ALS.[Field11] = 'KF' THEN ENROLL.GRDE
			WHEN ENROLL.GRDE IS NULL THEN ALS.[Field11]
		ELSE ALS.[Field11] END AS GRADE
		*/

		,ISNULL(CASE WHEN Phlote120.PHLOTE IS NOT NULL THEN Phlote120.PHLOTE ELSE Phlote.PHLOTE END, 'NOT IDENTIFIED AS OF 80TH DAY') AS PHLOTE
		
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
		
	,CASE WHEN ENROLL.ID_NBR IS NULL THEN 'NO ENROLLMENT FOUND - DUP STATEID' 
		WHEN ENROLL.END_STAT = 57 THEN 'P' 
				WHEN ENROLL.END_STAT = 63 THEN 'R'
				WHEN ENROLL.END_STAT IN (59,60) THEN 'G'
			ELSE ''
	END AS YEAR_END_STATUS
	,ENROLL.END_ENR_DT


		,ISNULL(FRSTLANG.LANG_DESCR, '') AS [Students First Language]


	,ISNULL([ELL Level].[ELL Level],'') AS [Ell Level]
	,ISNULL([ELL Level].[Most Recent Test],'') AS [Most Recent Test]
	,ISNULL([ELL Level].Score,'') AS [Score]
	,[ELL Eligible] 
	,[Test Date]

	,Language.LANG_DESCR AS PRIMARY_LANGUAGE

	--,CASE WHEN Retained.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS Retained

	,CASE WHEN Dropout.[Student ID] IS NOT NULL THEN 'Y' ELSE '' END AS Dropout

	/*--THESE ARE THE BILINGUAL TAGS FROM STARS PROGRAMS FACT 
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'ESL' AND [Field18] = 9  THEN 'X' END,'') AS ESL
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'ESL' AND [Field18] = 12 THEN 'X' END,'') AS ELD
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'BEP' AND [Field18] = 2 THEN 'X' END,'') AS MAINTPRG
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'BEP' AND [Field18] = 4 THEN 'X' END,'') AS TRANSITL
	,ISNULL(CASE WHEN BilingualModel.[Field5] = 'BEP' AND [Field18] = 1 THEN 'X' END,'') AS TWO_W_DUAL	
	*/

		,ISNULL([English Model],'') AS [English Model]
		,ISNULL([Bilingual Model],'') AS [Bilingual Model]

		
		,ISNULL(BEPProgramDescription,'') AS BEPProgramDescription


		, CASE WHEN ALS2W > 0 THEN 'ALS2W' ELSE '' END  AS [Dual Language Immersion]
		, CASE WHEN ALSMP > 0 THEN 'ALSMP' ELSE '' END  AS [Maintenance Bilingual]
		
		, CASE WHEN ALSES > 0 THEN 'ALSES' ELSE '' END AS [Content Based English as a Second Language] 
		, CASE WHEN ALSED > 0 THEN 'ALSED' ELSE '' END AS ALSED
		, CASE WHEN ALSSH > 0 THEN 'ALSSH' ELSE '' END AS ALSSH


	
	,CASE WHEN PARENTREFUSED.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS [Parent Refused]
	,CASE WHEN NOTRECEIVINGSERVICE.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS [Not Receiving Service]

	
	,CASE WHEN SENIORS.ID_NBR IS NOT NULL THEN 'Y' ELSE '' END AS [Students that were Seniors at the start of the SY]

	,GRADS.GRAD AS GRADUATED
	,CAREER.DIPLOMA_TYPE 
	--,CASE WHEN CAREER.CAREERDIP IS NOT NULL THEN 'Y' ELSE '' END AS [Students that were Seniors at the start of the SY that earned a Career Diploma]

	,CASE WHEN SPED.[Primary Disability] = 'GI' THEN 'Y' ELSE '' END AS GIFTED
	,CASE WHEN SPED.ID_NBR IS NOT NULL THEN SPED.[Primary Disability] ELSE '' END AS SPED

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
(SELECT DISTINCT ENR.ID_NBR, ENR.END_STAT,ENR.GRDE, MRE.SCH_NBR, ENR.END_ENR_DT
 FROM 
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
LEFT JOIN 
DBTSIS.CE030_V AS FRSTLANG
ON
FRSTLANG.LANG_CD = Phlote2.HLS_Q_2
AND FRSTLANG.DST_NBR = 1



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


/************************************************************************************************
--READ FILE OF DROPOUTS FROM DOLORES/STATE PED
--Dropout2013.csv means they last attended in 2012-2013 and did not show up anywhere in 2013-2014
--Dropout2014.csv means they last attended in 2013-2014 and did not show up anywhere in 2014-2015
*************************************************************************************************/
		LEFT JOIN 
		(
		SELECT * FROM 
	OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=E:\SQLWorkingFiles;', 'SELECT * from "Dropout2012.csv"')
		) AS Dropout

		ON Dropout.[Student ID]  = ALS.STATE_ID


/**********************************************************************
	Pull Indicator For Bilingual Tags for Bilingual from PED 
***********************************************************************/	

					---- THIS DATA WAS NOT REPORTED CORRECTLY -- 
				/*(SELECT 
				[Field5], [Field18], [STUDENT ID], Period
				FROM
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[PROGRAMS_FACT] 
				WHERE
				[DISTRICT CODE] = '001'
				AND [Field5] IN ('ESL', 'BEP')
				) AS BilingualModel
				ON
				ALS.STATE_ID = BilingualModel.[STUDENT ID] collate database_default
				AND BilingualModel.Period = ALS.Period*/

LEFT JOIN
(
	SELECT DISTINCT
	ID_NBR
	,CASE WHEN RCVINGSERV.COURSE IS NOT NULL THEN 'ESL' ELSE '' END AS [English Model]
	,RCVINGSERV.PARENT_REFUSAL AS [Parent Refused]
	,CASE WHEN RCVINGSERV.COURSE IS NULL AND PARENT_REFUSAL = 'N' THEN 'Y' ELSE '' END AS [Not Receiving Service]
    FROM 
	APS.LCEStudentsAndProvidersAsOf('2012-12-15') AS RCVINGSERV
	) AS RCVINGSERV
ON
RCVINGSERV.ID_NBR = ALS.ID_NBR


/*-----------------------------------------------------------------------------------------------------------

--Bilingual Students for Bilingual Model
------------------------------------------------------------------------------------------------------------*/

LEFT JOIN 
(
SELECT DISTINCT
ID_NBR
,CASE WHEN ID_NBR IS NOT NULL THEN 'BEP' ELSE '' END AS [Bilingual Model] 
FROM 
dbo.BilingualModelHours_2013_80D AS BP
WHERE [Bilingual Model] != 'No Model'

) AS BEP
ON
ALS.ID_NBR = BEP.ID_NBR



/*-----------------------------------------------------------------------------------------------------------

--Use Bilingual Model and Hours Function for Tags and Indicators
------------------------------------------------------------------------------------------------------------*/
LEFT JOIN 
(SELECT ID_NBR
,MAX([Bilingual Model]) AS BEPProgramDescription
--,MAX(CASE WHEN [Bilingual Model] = 'Two-Way' THEN 'Two-Way' ELSE '' END) AS ALS2W
--,MAX(CASE WHEN [Course Tags] LIKE '%ELD%' THEN 'ELD' ELSE '' END) AS ALSED
--,MAX(CASE WHEN [Course Tags] LIKE '%SH%' THEN 'SH' ELSE '' END) AS ALSSH
--,MAX(CASE WHEN [Course Tags] LIKE '%ESL%' THEN 'ESL' ELSE '' END) AS ALSES
--,MAX(CASE WHEN [Bilingual Model] = 'Maintenance' THEN 'Maintenance' ELSE '' END) AS ALSMP 
FROM 
dbo.BilingualModelHours_2013_80D AS BEPKIDS
GROUP BY ID_NBR
) AS MODELTAGS

ON
MODELTAGS.ID_NBR = ALS.ID_NBR 


/**************************************************************************************************************

--PER WENDY PULL TAGS FOR ALL LCE CLASSES AND NOT ONLY BILINGUAL ABOVE

***************************************************************************************************************/

LEFT JOIN 
(SELECT 
	ID_NBR
	,SUM(ALSSH) AS ALSSH
	,SUM(ALSED) AS ALSED
	,SUM(ALS2W) AS ALS2W
	,SUM(ALSMP) AS ALSMP
	,SUM(ALSES) AS ALSES
 FROM 
(
SELECT 
	SCH.ID_NBR
	,CASE WHEN LCECLASS.SH_CONT != '' THEN 1 ELSE 0 END AS ALSSH
	,CASE WHEN LCECLASS.ELD != '' THEN 1 ELSE 0 END AS ALSED
	,CASE WHEN LCECLASS.TWO_W_DUAL != '' THEN 1 ELSE 0 END AS ALS2W
	,CASE WHEN LCECLASS.MAINTPRG != '' THEN 1 ELSE 0 END AS ALSMP
	,CASE WHEN LCECLASS.ESL != '' THEN 1 ELSE 0 END AS ALSES
FROM
APS.ScheduleWithMoreInfoAsOf('2012-12-15') AS SCH
INNER JOIN 
APS.LCEClassesAsOf('2012-12-15') AS LCECLASS
ON
LCECLASS.DST_NBR = SCH.DST_NBR
AND LCECLASS.SCH_YR = SCH.SCH_YR
AND LCECLASS.SCH_NBR = SCH.SCH_NBR
AND LCECLASS.COURSE = SCH.COURSE
AND LCECLASS.XSECTION = SCH.SECT_ASG

GROUP BY ID_NBR	,CASE WHEN LCECLASS.SH_CONT != '' THEN 1 ELSE 0 END
	,CASE WHEN LCECLASS.ELD != '' THEN 1 ELSE 0 END
		,CASE WHEN LCECLASS.TWO_W_DUAL != '' THEN 1 ELSE 0 END
	,CASE WHEN LCECLASS.MAINTPRG != '' THEN 1 ELSE 0 END
	,CASE WHEN LCECLASS.ESL != '' THEN 1 ELSE 0 END

) AS T1
GROUP BY ID_NBR
) AS TAGSFORALL

ON
TAGSFORALL.ID_NBR = ALS.ID_NBR








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
	SELECT DISTINCT TN010.ID_NBR, TN082.CODE_DESCR AS DIPLOMA_TYPE, GRAD_DT AS GRAD
	--, DIPCODES.CODE_DESCR
	 FROM 
	DBTSIS.TN010 AS TN010
	INNER JOIN 
	DBTSIS.TN082_V AS TN082
	ON
	TN010.GRAD_TYP = TN082.CODE_NME
	AND TN082.CODE_TYPE = 'GRDTY'
	AND TN010.DST_NBR = TN082.DST_NBR
WHERE
TN010.DST_NBR = 1
AND GRAD_DT < '20130730'
		) AS GRADS

		ON
		GRADS.ID_NBR = ALS.ID_NBR



/******************************************************************************
	READ EOY STARS HISTORY TO SEE WHICH SENIORS earned a Career Diploma
*******************************************************************************/	

LEFT JOIN 
(
SELECT DISTINCT TN010.ID_NBR, TN082.CODE_DESCR AS DIPLOMA_TYPE
--, DIPCODES.CODE_DESCR
 FROM 
DBTSIS.TN010 AS TN010
INNER JOIN 
DBTSIS.TN082_V AS TN082
ON
TN010.GRAD_TYP = TN082.CODE_NME
AND TN082.CODE_TYPE = 'GRDTY'
AND TN010.DST_NBR = TN082.DST_NBR
WHERE
TN010.DST_NBR = 1
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



/******************************************************************************
	SPED AND GIFTED
*******************************************************************************/	

LEFT JOIN 
(
SELECT ID_NBR, [Primary Disability] 
FROM 
APS.SpedAsOf(@AsOfDate)
WHERE
DST_NBR = 1 AND SCH_YR = 2013
) AS SPED
ON
SPED.ID_NBR = ALS.ID_NBR





WHERE
	ALS.ID_NBR IS NOT NULL
	AND ALS.ID_NBR != 0

--GROUP BY
--ALS.[SY]


) AS FINAL
) AS FINALFINAL
WHERE
SCHOOL < '900'
AND ORIGINAL_GRADE NOT IN ('P1', 'P2', 'PK')


ORDER BY [ENGLISH PROFICIENCY] ASC