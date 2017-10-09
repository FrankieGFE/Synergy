USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[BEPModelsAndHoursExceptionsAsOf]    Script Date: 10/3/2017 1:26:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER FUNCTION [APS].[BEPModelsAndHoursExceptionsAsOf](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	



SELECT 
	BEPDETAILS.SCHOOL_NAME
	,STUDENT_GU
	,BEPDETAILS.SIS_NUMBER
	,COURSE_ID
	,COURSE_TITLE
	,COURSE_LEVEL
	,STATE_COURSE_CODE
	,BEPDETAILS.GRADE
	,[01],[03],[04], [05],[10],[20],[27],[32],[45],[47],[51],[60],[67],	ELEM,MID,HIGH
	,[TEACHER NAME],BADGE_NUM,BEPDETAILS.EL,DEPARTMENT,BEPDETAILS.LAST_NAME
	, BEPDETAILS.FIRST_NAME,[HOUR],MODEL,QUALIFIED,ORGANIZATION_GU

 FROM 
 

 /****************************************************************************************************************************************

 FIRST JOIN IN THE DETAILS - THIS IS DIFFERENT FROM THE FUNCTION BECAUSE IT INCLUDES NON-QUALIFIED STAFF



 ******************************************************************************************************************************************/


(
SELECT STEP2.*, STEP1.EL, STEP1.ORGANIZATION_GU, STEP1.SCHOOL_CODE,STEP1.GRADE FROM (
SELECT 
	*
--SIS_NUMBER, STUDENT_GU, EL, SCHOOL_CODE  
FROM 
(


/*******************************************************************************************************************************************

STEP ONE - 1.	Start by pulling all students (El and NON EL) that have a BEP Indicator for stars code 1271-1274 and a teacher credential of:
Elementary (K-5) only.  Teacher must have a 67 – Bilingual Endorsement.  
Secondary grades only (6-12) Teacher must have both a 67 – Bilingual and a 60- Modern and Classical Language Endorsement
-- ONLY PULL QUALIFIED STAFF 

********************************************************************************************************************************************/


SELECT 
	PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
	, CASE 
			WHEN PRIM.GRADE IN ('K', '01', '02', '03', '04', '05') AND [67] = '67' AND ELEM = 'Y' THEN 'Y'
			WHEN PRIM.GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 
			WHEN PRIM.GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 

			WHEN PRIM.GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 
			WHEN PRIM.GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 

	ELSE 'N' END AS QUAL

	,[60], [67]
	,CASE WHEN ADMIN_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS EL
	,SCHOOL_CODE
	,PRIM.ORGANIZATION_GU
	,PRIM.GRADE
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS PRIM
LEFT JOIN 
APS.ELLCalculatedAsOf(@AsOfDate) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN 
APS.ScheduleDetailsAsOf(@AsOfDate) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
LEFT JOIN 
APS.LCETeacherEndorsements AS CRED
ON
SCH.STAFF_GU = CRED.STAFF_GU

WHERE
(LST.COURSE_LEVEL = 'BEP'
AND 
	(
	LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'
	OR LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'
	)
)
) AS T1
--WHERE QUAL = 'Y'
) AS STEP1


/***************************************************************************************************
2.	Based only on the students that have met the above requirement, then pull any additional courses that have a BEP and ESL indicator.  
Check those courses against the following credentials.
-- ONLY PULL QUALIFIED STAFF 

***************************************************************************************************/

INNER JOIN 

(SELECT * FROM 
(SELECT 
	 SIS_NUMBER, PRIM.STUDENT_GU
	 , LAST_NAME, FIRST_NAME
	 ,SCHOOL_NAME
	 , SCH.COURSE_ID, SCH.SECTION_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE

	,[01]
      ,[03]
      ,[04]
      ,[05]
      ,[10]
      ,[20]
      ,[27]
      ,[32]
      ,[45]
      ,[47]
      ,[51]
      ,[60]
      ,[67]
      ,[ELEM]
      ,[MID]
      ,[HIGH]
	  ,SCH.[TEACHER NAME]
	  ,STF.BADGE_NUM
	  ,SCH.DEPARTMENT

	  , CASE 
			--ELEMENTARY
			WHEN GRADE IN ('K', '01', '02', '03', '04', '05') AND [67] = '67' AND ELEM = 'Y' THEN 'Y'
			WHEN GRADE IN ('K', '01', '02', '03', '04', '05') AND LEFT(STATE_COURSE_CODE,4) = '1062' AND ELEM = 'Y' AND [27] = '27' THEN 'Y'

			--SECONDARY
			--(1271-1274, 1202-1203, 1254-1255, 1299)
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1254' AND '1255'  THEN 'Y' 
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1299'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1254' AND '1255'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1299'  THEN 'Y' 
			
			--1063
			WHEN GRADE IN ('06', '07', '08') AND [27] = '27' AND [20] = '20' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1063'  THEN 'Y'			
			WHEN GRADE IN ('09', '10', '11', '12') AND [27] = '27' AND [20] = '20' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1063'   THEN 'Y' 
			
			--1150
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [01] = '01' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1150'  THEN 'Y'			
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [01] = '01'  AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1150'   THEN 'Y' 

			--0304	
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND ([03] = '03' OR [45] = '45' OR [47] = '47') AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '0304'  THEN 'Y'			
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND ([03] = '03' OR [45] = '45' OR [47] = '47') AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '0304'   THEN 'Y' 

			--Health
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [04] = '04' AND [05] = '05'AND MID = 'Y' AND CRS.DEPARTMENT = 'Hea'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [04] = '04' AND [05] = '05' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Hea'  THEN 'Y' 

			--Math
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [51] = '51' AND MID = 'Y' AND CRS.DEPARTMENT = 'Math'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [51] = '51' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Math'  THEN 'Y' 

			--Social Studies
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [10] = '10' AND MID = 'Y' AND CRS.DEPARTMENT = 'Soc'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [10] = '10' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Soc'  THEN 'Y' 

			--Science
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [32] = '32' AND MID = 'Y' AND CRS.DEPARTMENT = 'Sci'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [32] = '32' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Sci'  THEN 'Y' 

	ELSE 'N' END AS QUALIFIED

 FROM 
 APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS PRIM
 INNER JOIN 
 APS.ScheduleDetailsAsOf(@AsOfDate) AS SCH
 ON
 PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU

LEFT JOIN 
APS.LCETeacherEndorsements AS CRED
ON
SCH.STAFF_GU = CRED.STAFF_GU

LEFT JOIN 
rev.EPC_STAFF AS STF
ON
CRED.STAFF_GU = STF.STAFF_GU

INNER JOIN 
REV.REV_PERSON AS PERS
ON
PRIM.STUDENT_GU = PERS.PERSON_GU

WHERE
COURSE_LEVEL IN ('BEP','ESL')

) AS T1
--WHERE
--QUALIFIED = 'Y'
) AS STEP2

ON
STEP2.SIS_NUMBER = STEP1.SIS_NUMBER

) AS BEPDETAILS




/**********************************************************************************************************************************************************

********************JOIN ABOVE DETAILS WITH COUNTS BELOW - COUNTS INCLUDE NON-QUALIFIED STAFF *************************************************************

***********************************************************************************************************************************************************/


INNER JOIN 

(
SELECT 
	
	SIS_NUMBER, 
	PRIM.SCHOOL_NAME, LAST_NAME, FIRST_NAME,
	EL,
	
	CASE 
		WHEN HIGHESTCOUNT = 1  THEN 1 
		WHEN HIGHESTCOUNT = 2 THEN 2	
		WHEN HIGHESTCOUNT >= 3 THEN 3
	ELSE '' END  AS [HOUR]


	,CASE 
		WHEN HIGHESTCOUNT = 1  THEN 'Heritage/Indigenous Language' 
		WHEN HIGHESTCOUNT = 2 THEN 'Heritage/Indigenous Language'
		WHEN HIGHESTCOUNT >= 3 AND FINISHUP.SCHOOL_CODE NOT IN ('206', '210', '213', '215', '216', '225', '339', '243', '244', '249', '252', '262', '255',
													'496', '285', '291', '300', '250', '327', '275', '333', '330', '392', '280', '370', '376', '379', '385', 
													'405', '415', '416', '475', '465', '470', '590', '576' )
								THEN 'Heritage/Indigenous Language'
		WHEN HIGHESTCOUNT >= 3 AND FINISHUP.SCHOOL_CODE IN ('206', '210', '213', '215', '216', '225', '339', '243', '244', '249', '252', '262', '255',
													'496', '285', '291', '300', '250', '327', '275', '333', '330', '392', '280', '370', '376', '379', '385', 
													'405', '415', '416', '475', '465', '470', '590', '576' )
								THEN '2-Way Dual'
		
	ELSE '' END AS MODEL

FROM 


(
SELECT 
	MAX(RN) AS HIGHESTCOUNT
	,STUDENT_GU, SIS_NUMBER, EL, SCHOOL_CODE
 FROM 
(
SELECT 
	SIS_NUMBER, STUDENT_GU, EL, SCHOOL_CODE
	,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY SIS_NUMBER) AS RN
FROM
		
		(
		SELECT STEP2.*, STEP1.EL, STEP1.ORGANIZATION_GU, STEP1.SCHOOL_CODE FROM (
SELECT 
	*
--SIS_NUMBER, STUDENT_GU, EL, SCHOOL_CODE  
FROM 
(


/*******************************************************************************************************************************************

STEP ONE - 1.	Start by pulling all students (El and NON EL) that have a BEP Indicator for stars code 1271-1274 and a teacher credential of:
Elementary (K-5) only.  Teacher must have a 67 – Bilingual Endorsement.  
Secondary grades only (6-12) Teacher must have both a 67 – Bilingual and a 60- Modern and Classical Language Endorsement
-- ONLY PULL QUALIFIED STAFF 

********************************************************************************************************************************************/


SELECT 
	PRIM.STUDENT_GU, SIS_NUMBER, SCH.COURSE_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE
	, CASE 
			WHEN PRIM.GRADE IN ('K', '01', '02', '03', '04', '05') AND [67] = '67' AND ELEM = 'Y' THEN 'Y'
			WHEN PRIM.GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 
			WHEN PRIM.GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 

			WHEN PRIM.GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 
			WHEN PRIM.GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 

	ELSE 'N' END AS QUAL

	,[60], [67]
	,CASE WHEN ADMIN_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS EL
	,SCHOOL_CODE
	,PRIM.ORGANIZATION_GU
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS PRIM
LEFT JOIN 
APS.ELLCalculatedAsOf(@AsOfDate) AS ELL
ON
PRIM.STUDENT_GU = ELL.STUDENT_GU

INNER JOIN 
APS.ScheduleDetailsAsOf(@AsOfDate) AS SCH
ON
PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU
LEFT JOIN 
APS.LCETeacherEndorsements AS CRED
ON
SCH.STAFF_GU = CRED.STAFF_GU

WHERE
(LST.COURSE_LEVEL = 'BEP'
AND 
	(
	LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'
	OR LEFT(CRS.STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'
	)
)
) AS T1
--WHERE QUAL = 'Y'
) AS STEP1


/***************************************************************************************************
2.	Based only on the students that have met the above requirement, then pull any additional courses that have a BEP and ESL indicator.  
Check those courses against the following credentials.
-- ONLY PULL QUALIFIED STAFF 

***************************************************************************************************/

INNER JOIN 

(SELECT * FROM 
(SELECT 
	 SIS_NUMBER, PRIM.STUDENT_GU
	 , LAST_NAME, FIRST_NAME
	 ,SCHOOL_NAME
	 , SCH.COURSE_ID, SCH.SECTION_ID, SCH.COURSE_TITLE, COURSE_LEVEL, STATE_COURSE_CODE

	,[01]
      ,[03]
      ,[04]
      ,[05]
      ,[10]
      ,[20]
      ,[27]
      ,[32]
      ,[45]
      ,[47]
      ,[51]
      ,[60]
      ,[67]
      ,[ELEM]
      ,[MID]
      ,[HIGH]
	  ,SCH.[TEACHER NAME]
	  ,STF.BADGE_NUM
	  ,SCH.DEPARTMENT

	  , CASE 
			--ELEMENTARY
			WHEN GRADE IN ('K', '01', '02', '03', '04', '05') AND [67] = '67' AND ELEM = 'Y' THEN 'Y'
			WHEN GRADE IN ('K', '01', '02', '03', '04', '05') AND LEFT(STATE_COURSE_CODE,4) = '1062' AND ELEM = 'Y' AND [27] = '27' THEN 'Y'

			--SECONDARY
			--(1271-1274, 1202-1203, 1254-1255, 1299)
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1254' AND '1255'  THEN 'Y' 
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [60] = '60' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1299'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1271' AND '1274'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1202' AND '1203'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) BETWEEN '1254' AND '1255'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [60] = '60' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1299'  THEN 'Y' 
			
			--1063
			WHEN GRADE IN ('06', '07', '08') AND [27] = '27' AND [20] = '20' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1063'  THEN 'Y'			
			WHEN GRADE IN ('09', '10', '11', '12') AND [27] = '27' AND [20] = '20' AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1063'   THEN 'Y' 
			
			--1150
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [01] = '01' AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1150'  THEN 'Y'			
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [01] = '01'  AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '1150'   THEN 'Y' 

			--0304	
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND ([03] = '03' OR [45] = '45' OR [47] = '47') AND MID = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '0304'  THEN 'Y'			
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND ([03] = '03' OR [45] = '45' OR [47] = '47') AND HIGH = 'Y' AND LEFT(STATE_COURSE_CODE,4) = '0304'   THEN 'Y' 

			--Health
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [04] = '04' AND [05] = '05'AND MID = 'Y' AND CRS.DEPARTMENT = 'Hea'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [04] = '04' AND [05] = '05' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Hea'  THEN 'Y' 

			--Math
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [51] = '51' AND MID = 'Y' AND CRS.DEPARTMENT = 'Math'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [51] = '51' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Math'  THEN 'Y' 

			--Social Studies
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [10] = '10' AND MID = 'Y' AND CRS.DEPARTMENT = 'Soc'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [10] = '10' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Soc'  THEN 'Y' 

			--Science
			WHEN GRADE IN ('06', '07', '08') AND [67] = '67' AND [32] = '32' AND MID = 'Y' AND CRS.DEPARTMENT = 'Sci'  THEN 'Y' 
			WHEN GRADE IN ('09', '10', '11', '12') AND [67] = '67' AND [32] = '32' AND HIGH = 'Y' AND CRS.DEPARTMENT = 'Sci'  THEN 'Y' 

	ELSE 'N' END AS QUALIFIED

 FROM 
 APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS PRIM
 INNER JOIN 
 APS.ScheduleDetailsAsOf(@AsOfDate) AS SCH
 ON
 PRIM.STUDENT_GU = SCH.STUDENT_GU
INNER JOIN 
rev.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
INNER JOIN 
REV.EPC_CRS AS CRS
ON
SCH.COURSE_GU = CRS.COURSE_GU

LEFT JOIN 
APS.LCETeacherEndorsements AS CRED
ON
SCH.STAFF_GU = CRED.STAFF_GU

LEFT JOIN 
rev.EPC_STAFF AS STF
ON
CRED.STAFF_GU = STF.STAFF_GU

INNER JOIN 
REV.REV_PERSON AS PERS
ON
PRIM.STUDENT_GU = PERS.PERSON_GU

WHERE
COURSE_LEVEL IN ('BEP','ESL')

) AS T1
--WHERE
--QUALIFIED = 'Y'
) AS STEP2

ON
STEP2.SIS_NUMBER = STEP1.SIS_NUMBER

		) AS BEPDETAILS

)AS COUNTME
	GROUP BY STUDENT_GU, SIS_NUMBER, EL, SCHOOL_CODE

) AS FINISHUP

INNER JOIN 
APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS PRIM
ON
FINISHUP.STUDENT_GU = PRIM.STUDENT_GU

INNER JOIN 
REV.REV_PERSON AS PERS
ON
PRIM.STUDENT_GU = PERS.PERSON_GU

) AS BEPCOUNTS

ON
BEPDETAILS.SIS_NUMBER = BEPCOUNTS.SIS_NUMBER



--ORDER BY BEPDETAILS.SIS_NUMBER


GO


