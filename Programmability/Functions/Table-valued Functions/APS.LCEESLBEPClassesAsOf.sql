
/*********************************************************************************

-- MAY MAKE THIS 2 REPORTS, ONE WITH JUST THE ERRORS ? 


**********************************************************************************/
ALTER FUNCTION [APS].[LCEESLBEPClassesAsOf](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	

SELECT 
	ORGANIZATION_NAME
	,COURSE_ID
	,COURSE_TITLE
	,SECTION_ID
	,CASE WHEN LST.COURSE_LEVEL = 'BEP' THEN 'BEP' ELSE '' END AS BEP
	,CASE WHEN LST.COURSE_LEVEL = 'ESL' THEN 'ESL' ELSE '' END AS ESL
	--,CASE WHEN SCH.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END AS COUNTKIDS
	,COUNT (*) AS [Count Of Students]
	,STF.BADGE_NUM
	,[TEACHER NAME]
	,CASE WHEN CRED.ElementaryBilingual = 1 THEN 'Y' ELSE '' END AS [Elementary Bilingual]
	,CASE WHEN CRED.ElementaryBilingualWaiverOnly = 1 THEN 'Y' ELSE '' END AS [Elementary Bilingual Waiver Only]
	,CASE WHEN CRED.ElementaryESL = 1 THEN 'Y' ELSE '' END AS [Elementary ESL]
	,CASE WHEN CRED.ElementaryTESOL = 1 THEN 'Y' ELSE '' END AS [Elementary TESOL]
	,CASE WHEN CRED.ElementaryTESOLWaiverOnly = 1 THEN 'Y' ELSE '' END AS [Elementary TESOL Waiver Only]
	
	,CASE WHEN CRED.SecondaryBilingual = 1 THEN 'Y' ELSE '' END AS [Secondary Bilingual]
	,CASE WHEN CRED.SecondaryBilingualWaiverOnly = 1 THEN 'Y' ELSE '' END AS [Secondary Bilingual Waiver Only]
	,CASE WHEN CRED.SecondaryESL = 1 THEN 'Y' ELSE '' END AS [Secondary ESL]
	,CASE WHEN CRED.SecondaryTESOL = 1 THEN 'Y' ELSE '' END AS [Secondary TESOL]
	,CASE WHEN CRED.SecondaryTESOLWaiverOnly = 1 THEN 'Y' ELSE '' END AS [Secondary TESOL Waiver Only]

	,CASE WHEN CRED.Navajo = 1 THEN 'Y' ELSE '' END AS [Navajo]
	, ORGANIZATION_GU
 FROM 
APS.ScheduleDetailsAsOf(GETDATE()) AS SCH
INNER JOIN 
REV.EPC_CRS_LEVEL_LST AS LST
ON
SCH.COURSE_GU = LST.COURSE_GU
LEFT JOIN 
APS.LCETeacherEndorsementsAsOf(GETDATE()) AS CRED
ON
CRED.STAFF_GU = SCH.STAFF_GU
LEFT JOIN 
REV.EPC_STAFF AS STF
ON
SCH.STAFF_GU = STF.STAFF_GU


WHERE
LST.COURSE_LEVEL IN ('BEP', 'ESL')
-- Teachers without the correct credentials
--AND CRED.STAFF_GU IS NULL

GROUP BY 
	ORGANIZATION_NAME
	,COURSE_ID
	,COURSE_TITLE
	,SECTION_ID
	,CASE WHEN LST.COURSE_LEVEL = 'BEP' THEN 'BEP' ELSE '' END 
	,CASE WHEN LST.COURSE_LEVEL = 'ESL' THEN 'ESL' ELSE '' END 

	,STF.BADGE_NUM
	,[TEACHER NAME]
	,CASE WHEN CRED.ElementaryBilingual = 1 THEN 'Y' ELSE '' END 
	,CASE WHEN CRED.ElementaryBilingualWaiverOnly = 1 THEN 'Y' ELSE '' END
	,CASE WHEN CRED.ElementaryESL = 1 THEN 'Y' ELSE '' END 
	,CASE WHEN CRED.ElementaryTESOL = 1 THEN 'Y' ELSE '' END 
	,CASE WHEN CRED.ElementaryTESOLWaiverOnly = 1 THEN 'Y' ELSE '' END 
	
	,CASE WHEN CRED.SecondaryBilingual = 1 THEN 'Y' ELSE '' END 
	,CASE WHEN CRED.SecondaryBilingualWaiverOnly = 1 THEN 'Y' ELSE '' END 
	,CASE WHEN CRED.SecondaryESL = 1 THEN 'Y' ELSE '' END 
	,CASE WHEN CRED.SecondaryTESOL = 1 THEN 'Y' ELSE '' END
	,CASE WHEN CRED.SecondaryTESOLWaiverOnly = 1 THEN 'Y' ELSE '' END 

	,CASE WHEN CRED.Navajo = 1 THEN 'Y' ELSE '' END 
	,ORGANIZATION_GU

--ORDER BY ORGANIZATION_NAME



