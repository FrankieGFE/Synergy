

SELECT 

	PART1.*, 
	PART2.RELATED_SERVICE, PART2.[START_DATE], PART2.END_DATE, PART2.IEP_REVIEW_DATE

	,CASE WHEN PART1.SEC_SRV_SHOW = 'N' AND PART1.END_DATE < GETDATE() AND PART1.END_DATE != PART1.IEP_REVIEW_DATE THEN 'X' END AS REMOVE1
	,CASE WHEN PART1.SEC_SRV_SHOW = 'Y' AND PART2.RELATED_SERVICE IS NOT NULL AND PART2.END_DATE < GETDATE() AND PART2.END_DATE != PART2.IEP_REVIEW_DATE THEN 'X' END AS REMOVE2
	,CASE WHEN PART1.SEC_SRV_SHOW = 'Y' AND PART2.RELATED_SERVICE IS NULL AND PART1.END_DATE < GETDATE() AND PART1.END_DATE != PART1.IEP_REVIEW_DATE THEN 'X' END AS REMOVE3
	,CASE WHEN PART1.SEC_SRV_SHOW = 'Y' AND PART2.[START_DATE] > GETDATE() AND PART2.RELATED_SERVICE IS NULL THEN 'X' END AS REMOVE4

FROM (

/**********************************************************************************************************

	PULLS RECORDS THAT EXIST ONLY ONCE, NOT IN SECOND SCHEDULE

***********************************************************************************************************/

SELECT
	T1.*
	
FROM (
SELECT 
	ROW_NUMBER() OVER (PARTITION BY RELATEDSERVICES.SIS_NUMBER, RELATEDSERVICES.RELATED_SERVICE ORDER BY RELATEDSERVICES.RELATED_SERVICE) AS RN
	,RELATEDSERVICES.SIS_NUMBER
	,PRIM.SCHOOL_CODE AS CURR_SCH
	,PRIM.SCHOOL_NAME AS CURR_SCH_NAME
	,PRIM.GRADE AS CURR_GRADE
	,NEXTYR.SCHOOL_CODE AS NEXT_SCH
	,NEXTYR.SCHOOL_NAME AS NEXT_SCH_NAME
	,NEXTYR.GRADE AS NEXT_GRADE
	,RELATEDSERVICES.SEC_SRV_SHOW
	,RELATEDSERVICES.RELATED_SERVICE
	,RELATEDSERVICES.[START_DATE]
	,RELATEDSERVICES.END_DATE
	,RELATEDSERVICES.IEP_REVIEW_DATE
	,RELATEDSERVICES.INTEGRATED_STATUS
	,RELATEDSERVICES.PRIMARY_DISABILITY_CODE
	
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.LatestPrimaryEnrollmentInYear('A3F9F1FB-4706-49AA-B3A3-21F153966191') AS NEXTYR
ON
PRIM.STUDENT_GU = NEXTYR.STUDENT_GU
INNER JOIN 
(SELECT 
--DISTINCT SIS_NUMBER
	SIS_NUMBER, SSRV.SERVICE_DESCRIPTION AS RELATED_SERVICE, IEPS.START_DATE, IEPS.END_DATE, SEC_SRV_SHOW,IEP.[NEXT_IEP_DATE] AS IEP_REVIEW_DATE
	,IEPS.INTERACTION, INTEGRATED_STATUS.VALUE_DESCRIPTION AS INTEGRATED_STATUS, IEP.PRIMARY_DISABILITY_CODE, Student.STUDENT_GU
   FROM
		  [rev].[EP_STUDENT_SPECIAL_ED] AS [Sped]

		  INNER JOIN
		  [rev].[EPC_STU] AS [Student]
		  ON
		  [Sped].[STUDENT_GU]=[Student].[STUDENT_GU]

		  INNER JOIN
		  [rev].[REV_PERSON] AS [Person]
		  ON
		  [Student].[STUDENT_GU]=[Person].[PERSON_GU]

		  INNER JOIN 
			  (
			 SELECT
				SSY.*
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS [RN]
			 FROM
				[rev].[EPC_STU_SCH_YR] AS SSY
				INNER JOIN 
				REV.REV_YEAR AS YRS
				ON
				SSY.YEAR_GU = YRS.YEAR_GU
				AND YRS.YEAR_GU IN (SELECT * FROM REV.SIF_22_Common_CurrentYearGU) 
			 WHERE
				[EXCLUDE_ADA_ADM] IS NULL
				AND ([LEAVE_DATE] IS NULL
				OR [LEAVE_DATE]<=GETDATE())
		  ) AS [SSY]
		  ON
		  [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
		  AND [SSY].[RN]=1
    
		  INNER JOIN
		  [rev].[EP_STUDENT_IEP] AS [IEP]
		  ON
		  [Sped].[STUDENT_GU]=[IEP].[STUDENT_GU]

		  INNER JOIN
		  [rev].[EP_STU_IEP_SERVICE] AS [IEPS]
		  ON
		  [IEP].[IEP_GU]=[IEPS].[IEP_GU]
    
		  INNER JOIN
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [ISRV]
		  ON
		  [ieps].[SERVICE_GU]=[isrv].[SERVICE_GU]

		  LEFT JOIN
		  [rev].[EP_AZ_STUDENT_IEP] AS [AIEP]
		  ON
		  [IEP].[IEP_GU]=[AIEP].[IEP_GU]
		  AND [IEP].[NEXT_IEP_DATE]>=GETDATE()

		  INNER JOIN 
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [SSRV]
		  ON
		  [IEPS].[SERVICE_GU]=[SSRV].[SERVICE_GU]
		   AND SSRV.SERVICE_DESCRIPTION IN ( 'SE English Language Arts','SE Science','SE Math','SE Social Studies')

		  LEFT JOIN
		  [rev].[EP_AZ_IEP_LRE] AS [LRE]
		  ON
		  [IEP].[IEP_GU]=[LRE].[IEP_GU]

		  INNER JOIN 
		   [APS].[LookupTable]('K12.SpecialEd.IEP','SERVICE_INTERACTION') AS INTEGRATED_STATUS
		   ON
		   INTEGRATED_STATUS.VALUE_CODE = IEPS.INTERACTION
		   AND INTERACTION = 'N'
       WHERE
		  [IEP].[IEP_STATUS]='CU'
		  AND [IEP].[IEP_VALID]='Y'
		  AND IEP.PRIMARY_DISABILITY_CODE != 'GI'
) AS RELATEDSERVICES
ON
RELATEDSERVICES.STUDENT_GU = PRIM.STUDENT_GU

) AS T1

WHERE RN = 1
) AS PART1

/**********************************************************************************************************

	PULLS RECORDS THAT EXIST IN BOTH SCHEDULES

***********************************************************************************************************/

LEFT JOIN 
(
SELECT
	T1.*
	--,CASE WHEN RELATED_SERVICE = 'N' AND END_DATE < GETDATE() AND END_DATE != IEP_REVIEW_DATE THEN 'X' END AS REMOVE1
	--,CASE WHEN RELATED_SERVICE = 'Y' AND RN = 2 AND END_DATE < GETDATE() AND END_DATE != IEP_REVIEW_DATE THEN 'X' END AS REMOVE1
FROM (
SELECT 
	ROW_NUMBER() OVER (PARTITION BY RELATEDSERVICES.SIS_NUMBER, RELATEDSERVICES.RELATED_SERVICE ORDER BY RELATEDSERVICES.RELATED_SERVICE) AS RN
	,RELATEDSERVICES.SIS_NUMBER
	,PRIM.SCHOOL_CODE AS CURR_SCH
	,PRIM.SCHOOL_NAME AS CURR_SCH_NAME
	,PRIM.GRADE AS CURR_GRADE
	,NEXTYR.SCHOOL_CODE AS NEXT_SCH
	,NEXTYR.SCHOOL_NAME AS NEXT_SCH_NAME
	,NEXTYR.GRADE AS NEXT_GRADE
	,RELATEDSERVICES.SEC_SRV_SHOW
	,RELATEDSERVICES.RELATED_SERVICE
	,RELATEDSERVICES.[START_DATE]
	,RELATEDSERVICES.END_DATE
	,RELATEDSERVICES.IEP_REVIEW_DATE
	,RELATEDSERVICES.INTEGRATED_STATUS
	,RELATEDSERVICES.PRIMARY_DISABILITY_CODE
	
 FROM 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
INNER JOIN 
APS.LatestPrimaryEnrollmentInYear('A3F9F1FB-4706-49AA-B3A3-21F153966191') AS NEXTYR
ON
PRIM.STUDENT_GU = NEXTYR.STUDENT_GU
INNER JOIN 
(SELECT 
--DISTINCT SIS_NUMBER
	SIS_NUMBER, SSRV.SERVICE_DESCRIPTION AS RELATED_SERVICE, IEPS.START_DATE, IEPS.END_DATE, SEC_SRV_SHOW,IEP.[NEXT_IEP_DATE] AS IEP_REVIEW_DATE
	,IEPS.INTERACTION, INTEGRATED_STATUS.VALUE_DESCRIPTION AS INTEGRATED_STATUS, IEP.PRIMARY_DISABILITY_CODE, Student.STUDENT_GU
   FROM
		  [rev].[EP_STUDENT_SPECIAL_ED] AS [Sped]

		  INNER JOIN
		  [rev].[EPC_STU] AS [Student]
		  ON
		  [Sped].[STUDENT_GU]=[Student].[STUDENT_GU]

		  INNER JOIN
		  [rev].[REV_PERSON] AS [Person]
		  ON
		  [Student].[STUDENT_GU]=[Person].[PERSON_GU]

		  INNER JOIN 
			  (
			 SELECT
				SSY.*
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS [RN]
			 FROM
				[rev].[EPC_STU_SCH_YR] AS SSY
				INNER JOIN 
				REV.REV_YEAR AS YRS
				ON
				SSY.YEAR_GU = YRS.YEAR_GU
				AND YRS.YEAR_GU IN (SELECT * FROM REV.SIF_22_Common_CurrentYearGU) 
			 WHERE
				[EXCLUDE_ADA_ADM] IS NULL
				AND ([LEAVE_DATE] IS NULL
				OR [LEAVE_DATE]<=GETDATE())
		  ) AS [SSY]
		  ON
		  [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
		  AND [SSY].[RN]=1
    
		  INNER JOIN
		  [rev].[EP_STUDENT_IEP] AS [IEP]
		  ON
		  [Sped].[STUDENT_GU]=[IEP].[STUDENT_GU]

		  INNER JOIN
		  [rev].[EP_STU_IEP_SERVICE] AS [IEPS]
		  ON
		  [IEP].[IEP_GU]=[IEPS].[IEP_GU]
    
		  INNER JOIN
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [ISRV]
		  ON
		  [ieps].[SERVICE_GU]=[isrv].[SERVICE_GU]

		  LEFT JOIN
		  [rev].[EP_AZ_STUDENT_IEP] AS [AIEP]
		  ON
		  [IEP].[IEP_GU]=[AIEP].[IEP_GU]
		  AND [IEP].[NEXT_IEP_DATE]>=GETDATE()

		  INNER JOIN 
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [SSRV]
		  ON
		  [IEPS].[SERVICE_GU]=[SSRV].[SERVICE_GU]
		   AND SSRV.SERVICE_DESCRIPTION IN ( 'SE English Language Arts','SE Science','SE Math','SE Social Studies')

		  LEFT JOIN
		  [rev].[EP_AZ_IEP_LRE] AS [LRE]
		  ON
		  [IEP].[IEP_GU]=[LRE].[IEP_GU]

		  INNER JOIN 
		   [APS].[LookupTable]('K12.SpecialEd.IEP','SERVICE_INTERACTION') AS INTEGRATED_STATUS
		   ON
		   INTEGRATED_STATUS.VALUE_CODE = IEPS.INTERACTION
		   AND INTERACTION = 'N'
       WHERE
		  [IEP].[IEP_STATUS]='CU'
		  AND [IEP].[IEP_VALID]='Y'
		  AND IEP.PRIMARY_DISABILITY_CODE != 'GI'
) AS RELATEDSERVICES
ON
RELATEDSERVICES.STUDENT_GU = PRIM.STUDENT_GU

) AS T1

WHERE RN = 2
) AS PART2

ON
PART1.SIS_NUMBER = PART2.SIS_NUMBER
AND PART1.RELATED_SERVICE = PART2.RELATED_SERVICE




