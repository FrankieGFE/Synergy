

SELECT T2.*
	,CASE 

WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'ENTER' THEN 'ENTERING' 
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'EMERG' THEN 'EMERGING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'DEVEL' THEN 'DEVELOPING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'EXPAN' THEN 'EXPANDING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'BRIDG' THEN 'BRIDGING'
WHEN TEST_NAME = 'ACCESS' AND PERFORMANCE_LEVEL = 'REACH' THEN 'REACHING'

WHEN TEST_NAME = 'LAS' AND PERFORMANCE_LEVEL = 'FEP' THEN 'BRIDGING'
WHEN TEST_NAME = 'LAS' AND PERFORMANCE_LEVEL = 'LEP' THEN 'DEVELOPING'
WHEN TEST_NAME = 'LAS' AND PERFORMANCE_LEVEL = 'NEP' THEN 'ENTERING'

WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'BEG' THEN 'ENTERING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'EARLI' THEN 'EMERGING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'IMM' THEN 'DEVELOPING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'EARLA' THEN 'EXPANDING'
WHEN TEST_NAME = 'NMELPA' AND PERFORMANCE_LEVEL = 'ADV' THEN 'BRIDGING'

WHEN TEST_NAME = 'PRE-LAS' AND PERFORMANCE_LEVEL = 'FEP' THEN 'Initial FEP'
WHEN TEST_NAME = 'PRE-LAS' AND PERFORMANCE_LEVEL = 'LEP' THEN 'DEVELOPING'
WHEN TEST_NAME = 'PRE-LAS' AND PERFORMANCE_LEVEL = 'NEP' THEN 'ENTERING'

WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'ELL' THEN 'ENTERING'
WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'NULL' THEN 'NULL'
WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'C-PRO' THEN 'Initial FEP'
WHEN TEST_NAME = 'SCREENER' AND PERFORMANCE_LEVEL = 'ADV' THEN 'Initial FEP'

WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'ELL' THEN 'ENTERING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'ENTER' THEN 'ENTERING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'EMERG' THEN 'EMERGING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'DEVEL' THEN 'DEVELOPING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'EXPAN' THEN 'EXPANDING'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'BRIDG' THEN 'Initial FEP'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'ADV' THEN 'Initial FEP'
WHEN TEST_NAME = 'WAPT' AND PERFORMANCE_LEVEL = 'REACH' THEN 'Initial FEP'

WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'EMERG' THEN 'ALT-EMERGING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'ENGA' THEN 'ALT-ENGAGING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'ENTER' THEN 'ALT-ENTERING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'EXPL' THEN 'ALT-EXPLORING'
WHEN TEST_NAME = 'ALT ACCESS' AND PERFORMANCE_LEVEL = 'INIT' THEN 'ALT-INITIATING'

ELSE '' END AS CONSOLIDATED_PERFORMANCE_LEVEL
 FROM (

SELECT DISTINCT

	SIS_NUMBER, DATE_ASSIGNED, LU1.VALUE_DESCRIPTION AS Q1_LANGUAGE_SPOKEN_MOST, LU2.VALUE_DESCRIPTION AS Q2_CHILD_FIRST_LANGUAGE, LU3.VALUE_DESCRIPTION AS Q3_LANGUAGES_SPOKEN
	, LU4.VALUE_DESCRIPTION AS Q4_OTHER_LANG_UNDERSTOOD, LU5.VALUE_DESCRIPTION AS Q5_OTHER_LANG_COMMUNICATED
	, PHLOTE, ADMIN_DATE, TEST_NAME, PERFORMANCE_LEVEL 
	,CASE WHEN LAST_SCHOOL_AND_YEAR_ENROLLED IS NULL THEN (CAST(SCHOOL_YEAR AS VARCHAR) +''+ Non_Primary_School) ELSE LAST_SCHOOL_AND_YEAR_ENROLLED END AS LAST_YEAR_AND_SCHOOL_ENROLLED
	,CASE WHEN CURRENTLY_ENROLLED = '' THEN 'N' ELSE CURRENTLY_ENROLLED END AS CURRENT_PRIMARY_ENROLLMENT

FROM (
SELECT 
	STU.SIS_NUMBER
	,HLS.*
	,TEST.ADMIN_DATE
	,TEST.TEST_NAME
	,TEST.PERFORMANCE_LEVEL
,MAX(CAST(SOR.SCHOOL_YEAR AS VARCHAR) +' ' + SOR.SCHOOL_NAME) AS LAST_SCHOOL_AND_YEAR_ENROLLED
,CASE WHEN PRIM.STUDENT_GU IS NOT NULL THEN 'Y' ELSE '' END AS CURRENTLY_ENROLLED
,LATESTNONPRIM.Non_Primary_School
,LATESTNONPRIM.SCHOOL_YEAR
,LATESTNONPRIM.EXTENSION
,LATESTNONPRIM.ENTER_DATE
,LATESTNONPRIM.LEAVE_DATE
,LATESTNONPRIM.GRADE

 FROM 
 (
SELECT
	STUDENT_GU
	,DATE_ASSIGNED
	,Q1_LANGUAGE_SPOKEN_MOST
	,Q2_CHILD_FIRST_LANGUAGE
	,Q3_LANGUAGES_SPOKEN
	,Q4_OTHER_LANG_UNDERSTOOD
	,Q5_OTHER_LANG_COMMUNICATED
	,CASE WHEN (Q1_LANGUAGE_SPOKEN_MOST + Q2_CHILD_FIRST_LANGUAGE + Q3_LANGUAGES_SPOKEN + Q4_OTHER_LANG_UNDERSTOOD + Q5_OTHER_LANG_COMMUNICATED != '0000000000') THEN 'Y' ELSE 'N' END AS PHLOTE
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
	FROM
		rev.UD_HLS_HISTORY AS HLSHistory
	WHERE
		DATE_ASSIGNED <= GETDATE()
	) AS RowedHLS
WHERE
	RN = 1
	--AND Q1_LANGUAGE_SPOKEN_MOST + Q2_CHILD_FIRST_LANGUAGE + Q3_LANGUAGES_SPOKEN + Q4_OTHER_LANG_UNDERSTOOD + Q5_OTHER_LANG_COMMUNICATED != '0000000000'
) AS HLS
INNER JOIN 
APS.LCELatestEvaluationAsOf(GETDATE()) AS TEST
ON
HLS.STUDENT_GU = TEST.STUDENT_GU
INNER JOIN 
rev.EPC_STU AS STU
ON
HLS.STUDENT_GU = STU.STUDENT_GU
LEFT JOIN 
APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
ON
PRIM.STUDENT_GU = STU.STUDENT_GU

LEFT JOIN 
APS.StudentSchoolOfRecord AS SOR
ON
SOR.STUDENT_GU = STU.STUDENT_GU

LEFT JOIN 
(SELECT 
	SIS_NUMBER, STUDENT_GU, SCHOOL_YEAR, EXTENSION, GRADE, NON_PRIMARY_SCHOOL, ENTER_DATE, LEAVE_DATE
	FROM (
SELECT
 SIS_NUMBER, SCHOOL_YEAR, EXTENSION, VALUE_DESCRIPTION AS GRADE, ORG.ORGANIZATION_NAME AS Non_Primary_School, SSY.ENTER_DATE, SSY.LEAVE_DATE
,PRIMORG.ORGANIZATION_NAME AS Primary_School, STU.STUDENT_GU, SSY.STUDENT_SCHOOL_YEAR_GU, ORG.ORGANIZATION_GU, SSY.GRADE AS LU_GRADE
,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER, SCHOOL_YEAR ORDER BY SSY.ENTER_DATE DESC) AS RN

FROM 
(SELECT * FROM 
rev.EPC_STU_SCH_YR
WHERE
EXCLUDE_ADA_ADM IS NOT NULL
--AND (LEAVE_DATE IS NULL OR LEAVE_DATE > GETDATE())
--AND YEAR_GU = (SELECT * FROM rev.SIF_22_Common_CurrentYearGU)
) AS SSY

INNER JOIN
rev.REV_YEAR AS YEARS
ON
SSY.YEAR_GU = YEARS.YEAR_GU

INNER JOIN 
rev.EPC_STU AS STU
ON
SSY.STUDENT_GU = STU.STUDENT_GU


INNER JOIN 
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
ORGYR.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

INNER JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

INNER JOIN 
APS.LookupTable('K12', 'Grade') AS LU
ON
LU.VALUE_CODE = SSY.GRADE


LEFT JOIN 
APS.PrimaryEnrollmentsAsOf(GETDATE()) AS PRIM
ON
STU.STUDENT_GU = PRIM.STUDENT_GU

LEFT JOIN 
rev.REV_ORGANIZATION_YEAR AS PRIMORGYR
ON
PRIM.ORGANIZATION_YEAR_GU = PRIMORGYR.ORGANIZATION_YEAR_GU

LEFT JOIN 
rev.REV_ORGANIZATION AS PRIMORG
ON
PRIMORGYR.ORGANIZATION_GU = PRIMORG.ORGANIZATION_GU
) AS LATESTOPEN
WHERE
LATESTOPEN.RN = 1
) AS LATESTNONPRIM

ON
LATESTNONPRIM.STUDENT_GU = HLS.STUDENT_GU


GROUP BY 
STU.SIS_NUMBER
	,HLS.STUDENT_GU
	,DATE_ASSIGNED
	,Q1_LANGUAGE_SPOKEN_MOST
	,Q2_CHILD_FIRST_LANGUAGE
	,Q3_LANGUAGES_SPOKEN
	,Q4_OTHER_LANG_UNDERSTOOD
	,Q5_OTHER_LANG_COMMUNICATED
	,PHLOTE
	,TEST.ADMIN_DATE
	,TEST.TEST_NAME
	,TEST.PERFORMANCE_LEVEL
,CASE WHEN PRIM.STUDENT_GU IS NOT NULL THEN 'Y' ELSE '' END
,PRIM.SCHOOL_YEAR
,PRIM.SCHOOL_NAME
,LATESTNONPRIM.Non_Primary_School
,LATESTNONPRIM.SCHOOL_YEAR
,LATESTNONPRIM.EXTENSION
,LATESTNONPRIM.ENTER_DATE
,LATESTNONPRIM.LEAVE_DATE
,LATESTNONPRIM.GRADE

) AS T1

LEFT JOIN 
APS.LookupTable('K12','LANGUAGE') AS LU1
ON
LU1.VALUE_CODE = T1.Q1_LANGUAGE_SPOKEN_MOST

LEFT JOIN 
APS.LookupTable('K12','LANGUAGE') AS LU2
ON
LU2.VALUE_CODE = T1.Q2_CHILD_FIRST_LANGUAGE

LEFT JOIN 
APS.LookupTable('K12','LANGUAGE') AS LU3
ON
LU3.VALUE_CODE = T1.Q3_LANGUAGES_SPOKEN

LEFT JOIN 
APS.LookupTable('K12','LANGUAGE') AS LU4
ON
LU4.VALUE_CODE = T1.Q4_OTHER_LANG_UNDERSTOOD

LEFT JOIN 
APS.LookupTable('K12','LANGUAGE') AS LU5
ON
LU5.VALUE_CODE = T1.Q5_OTHER_LANG_COMMUNICATED
) AS T2
WHERE
LAST_YEAR_AND_SCHOOL_ENROLLED != '' OR 
LAST_YEAR_AND_SCHOOL_ENROLLED IS NOT NULL



ORDER BY SIS_NUMBER