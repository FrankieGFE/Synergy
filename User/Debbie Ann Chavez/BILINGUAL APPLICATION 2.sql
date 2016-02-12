
SELECT * FROM 
(

SELECT DISTINCT 
	BEP.SCHOOL_CODE 
	--THIS IS THE 40TH DAY DATE
	,'2016-02-10' AS [DATE]
	,'' AS TITLE
	,CASE
		WHEN BEPProgramDescription = 'Enrichment' THEN 'Enrichment for FEP and English Speakers' 
		WHEN BEPProgramDescription = '2-Way Dual' THEN 'Dual Language Immersion' 
		WHEN BEPProgramDescription = 'Maintenance' THEN 'Maintenance Bilingual Program'
	ELSE ''
	END AS PlanType
	,CASE 
		WHEN ALSLA = 'Lang. Arts' THEN 'A.' 
		WHEN ALSES = 'ESL' THEN 'B.'
		/*
		WHEN ALSMA = 'Math' THEN 'C.'
		WHEN ALSSC = 'Science' THEN 'C.'
		WHEN ALSSS = 'Soc. Studies' THEN 'C.'
		WHEN ALSOT = 'Other' THEN 'C.'
		*/
	ELSE ''
	END AS CourseDescription

	,MIN(EnrollGrade) AS Grade
	
	--2-way dual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' THEN 1 ELSE 0 END) AS NumOfStudentsDual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' AND ELL = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS ELL3hrDual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' AND FEP = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS FEP3HrDual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' AND ELL = 'N' AND FEP = 'N' AND BEPHours = 3 THEN 1 ELSE 0 END) AS NonPhlote3hrDual

	--maintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND ELL = 'Y' AND BEPHours = 2 THEN 1 ELSE 0 END) AS ELL2hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND ELL = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS ELL3hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND FEP = 'Y' AND BEPHours = 1 THEN 1 ELSE 0 END) AS FEP1hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND FEP = 'Y' AND BEPHours = 2 THEN 1 ELSE 0 END) AS FEP2hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND FEP = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS FEP3hrMaintenance

	--Heritage
	,'' AS ELL2hrHeritage
	,'' AS ELL3hrHeritage
	
	--Transitional
	,'' AS ELL2hrTransitional
	,'' AS ELL3hrTransitional

	,'' AS FEPNonPHLOTE1hrHeritageRev
	,'' AS FEPNonPHLOTE2hrHeritageRev

	--Enrichment
	,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' 
	--ND FEP = 'Y' 
	--AND PHLOTE = 'N' 
	AND BEPHours = 1 THEN 1 ELSE 0 END) AS FEP1hrEnrich

	,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' 
	--AND FEP = 'Y' 
	--AND PHLOTE = 'N' 
	AND BEPHours = 2 THEN 1 ELSE 0 END) AS FEP2hrEnrich

	--,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' AND FEP = 'Y' AND PHLOTE = 'Y' AND BEPHours = 1 THEN 1 ELSE 0 END) AS FEPPHLOTE1hrEnrich
	--,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' AND FEP = 'Y' AND PHLOTE = 'Y' AND BEPHours = 2 THEN 1 ELSE 0 END) AS FEPPHLOTE2hrEnrich

	,NUMCLASSES.COUNTCLASSES AS NumClassesOffered
	,CASE 
		WHEN ALSLA = 'Lang. Arts' THEN 'Spanish' 
		WHEN ALSES = 'ESL' THEN 'English'
	ELSE 'Spanish'
	END AS LanguageOfDelivery

	,StaffLastName + ',' + StaffFirstName AS TeachersName
	
	,CASE WHEN ADDSTAFF.PRIMARY_TEACHER = 'N' THEN ADDSTAFF.LAST_NAME + ', ' + ADDSTAFF.FIRST_NAME  ELSE 'NONE' END AS EA

	, STAFFSTUFF.DOCUMENT_NUMBER AS License

	-- THIS IS TEACHING ARE LICENSE LIKE 200, 300, 520 ETC.
	,'' AS OtherLicense

	,CASE WHEN BILINGUAL.AUTHORIZED_TCH_AREA IS NOT NULL THEN 'Yes' ELSE 'No' END AS  BilingualEndorsed
	,CASE WHEN TESOL.AUTHORIZED_TCH_AREA IS NOT NULL THEN 'Yes' ELSE 'No' END AS  TESOLEndorsed

	,CASE WHEN CONTENT.BADGE_NUM IS NOT NULL THEN 'Yes' ELSE 'No' END AS ContentArea
	,CASE WHEN MCNL.BADGE_NUM IS NOT NULL THEN 'Yes' ELSE 'No' END AS MCNL
	,'' AS NACL
	,SUM(CASE WHEN ELL = 'Y' THEN 1 ELSE 0 END) AS ELLStudents

	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' THEN 1 ELSE 0 END) AS TotalDUAL

	,'' AS SUBJECT
	,'' AS COPYATOB
	, 'ALBUQUERQUE' AS RecordID_DistrictName
	, BEP.SCHOOL_CODE AS RecordID_LocationID
	, '001' + BEP.SCHOOL_CODE AS RecordID_SchoolCode
	, '001' AS RecordID_DistrictCode
	, '' AS CopyAtoC
	, '' AS CopyBtoC
	
	,'' AS NumOfStudentsTransitional
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' THEN 1 ELSE 0 END) AS NumOfStudentsMaintenance
	,'' AS NumOfStudentsHeritageELL
	,'' AS NumOfStudentsHeritageREV
	,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' THEN 1 ELSE 0 END) AS NumOfStudentsEnrichment
	,BEP.SCHOOL_CODE AS SchoolCode
	,'' AS SchoolCode_DistrictCode
	,'' AS SchoolCode_DistrictName
	,'' AS SchoolCode_LocationID
	,'' AS SchoolCode_SchoolName
	,'' AS SchoolCode_ID
	,'001' + BEP.SCHOOL_CODE AS SchoolCode_SchoolCode
FROM 

	APS.BilingualModelAndHoursDetailsAsOf('2016-02-10') AS BEP

	INNER JOIN

	(
			SELECT 
				SCHOOL_CODE
				,BADGE_NUM
				--,SectionID
				,COUNT(RN) AS COUNTCLASSES
			from 
			(
			SELECT 
				SCHOOL_CODE
				,CourseID
				,SectionID
				,BADGE_NUM
				,EnrollGrade
				,ROW_NUMBER() OVER (PARTITION BY SCHOOL_CODE, BADGE_NUM,SectionID ORDER BY SectionID) AS RN
			FROM 
				APS.BilingualModelAndHoursDetailsAsOf('2016-02-10') AS BEP
				) as t1
			WHERE
				RN = 1

			GROUP BY 
				SCHOOL_CODE, BADGE_NUM

	) AS NUMCLASSES

ON
BEP.SCHOOL_CODE = NUMCLASSES.SCHOOL_CODE
AND BEP.BADGE_NUM = NUMCLASSES.BADGE_NUM

INNER JOIN
(
SELECT DISTINCT STAFF.BADGE_NUM, CRED.DOCUMENT_NUMBER, STAFF.STAFF_GU
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU

) AS STAFFSTUFF
ON
STAFFSTUFF.BADGE_NUM = BEP.BADGE_NUM

---BILINGUAL ENDORSEMENT
LEFT JOIN
(
SELECT DISTINCT
	AUTHORIZED_TCH_AREA
	,BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA = '67'
) AS BILINGUAL
ON
BILINGUAL.BADGE_NUM = BEP.BADGE_NUM

---ADDITIONAL STAFF EA STUFF HERE

LEFT JOIN
(
SELECT PRIMARY_TEACHER, LAST_NAME, FIRST_NAME, STAFF_GU, SECTION_GU FROM 
APS.SectionsAndAllStaffAssigned AS T
INNER JOIN
rev.REV_PERSON AS P
ON
T.STAFF_GU = P.PERSON_GU
WHERE PRIMARY_TEACHER = 'N'

) AS ADDSTAFF

ON
BEP.SECTION_GU = ADDSTAFF.SECTION_GU
--AND STAFFSTUFF.STAFF_GU = ADDSTAFF.STAFF_GU


---TESOL ENDORSEMENT
LEFT JOIN
(
SELECT DISTINCT
	AUTHORIZED_TCH_AREA
	,BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA = '27'
) AS TESOL
ON
TESOL.BADGE_NUM = BEP.BADGE_NUM

--CONTENT AREA
LEFT JOIN
(
SELECT DISTINCT
	BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA IN ('32', '10', '51')
) AS CONTENT

ON
BEP.BADGE_NUM = CONTENT.BADGE_NUM

--Modern Classical
LEFT JOIN
(
SELECT DISTINCT
	BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA = '60'
) AS MCNL

ON
BEP.BADGE_NUM = MCNL.BADGE_NUM


GROUP BY 
	BEP.SCHOOL_CODE
	,CASE
		WHEN BEPProgramDescription = 'Enrichment' THEN 'Enrichment for FEP and English Speakers' 
		WHEN BEPProgramDescription = '2-Way Dual' THEN 'Dual Language Immersion' 
		WHEN BEPProgramDescription = 'Maintenance' THEN 'Maintenance Bilingual Program'
	ELSE ''
	END 
	,CASE 
		WHEN ALSLA = 'Lang. Arts' THEN 'A.' 
		WHEN ALSES = 'ESL' THEN 'B.'
		--WHEN ALSMA = 'Math' THEN 'C.'
		--WHEN ALSSC = 'Science' THEN 'C.'
		--WHEN ALSSS = 'Soc. Studies' THEN 'C.'
		--WHEN ALSOT = 'Other' THEN 'C.'
	ELSE ''
	END 
	,EnrollGrade
	,COUNTCLASSES
	,DOCUMENT_NUMBER
	,CASE 
		WHEN ALSLA = 'Lang. Arts' THEN 'Spanish' 
		WHEN ALSES = 'ESL' THEN 'English'
	ELSE 'Spanish'
	END
	,StaffLastName + ',' + StaffFirstName
	,CASE WHEN ADDSTAFF.PRIMARY_TEACHER = 'N' THEN ADDSTAFF.LAST_NAME + ', ' + ADDSTAFF.FIRST_NAME  ELSE 'NONE' END
	,BILINGUAL.AUTHORIZED_TCH_AREA 
	,TESOL.AUTHORIZED_TCH_AREA
	,CONTENT.BADGE_NUM 
	,MCNL.BADGE_NUM



/***********************************************************************************************************************

--READ AGAIN TO READ SAME RECORDS BUT CREATE THE 'C' RECORDS
***********************************************************************************************************************/

UNION ALL

SELECT DISTINCT 
	BEP.SCHOOL_CODE 
	--THIS IS THE 40TH DAY DATE
	,'2015-12-01' AS [DATE]
	,'' AS TITLE
	,CASE
		WHEN BEPProgramDescription = 'Enrichment' THEN 'Enrichment for FEP and English Speakers' 
		WHEN BEPProgramDescription = '2-Way Dual' THEN 'Dual Language Immersion' 
		WHEN BEPProgramDescription = 'Maintenance' THEN 'Maintenance Bilingual Program'
	ELSE ''
	END AS PlanType
	,CASE 
		--WHEN ALSLA = 'Lang. Arts' THEN 'A.' 
		--WHEN ALSES = 'ESL' THEN 'B.'
		
		WHEN ALSMA = 'Math' THEN 'C.'
		WHEN ALSSC = 'Science' THEN 'C.'
		WHEN ALSSS = 'Soc. Studies' THEN 'C.'
		WHEN ALSOT = 'Other' THEN 'C.'
		
	ELSE ''
	END AS CourseDescription

	,MIN(EnrollGrade) AS Grade
	
	--2-way dual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' THEN 1 ELSE 0 END) AS NumOfStudentsDual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' AND ELL = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS ELL3hrDual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' AND FEP = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS FEP3HrDual
	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' AND ELL = 'N' AND FEP = 'N' AND BEPHours = 3 THEN 1 ELSE 0 END) AS NonPhlote3hrDual

	--maintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND ELL = 'Y' AND BEPHours = 2 THEN 1 ELSE 0 END) AS ELL2hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND ELL = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS ELL3hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND FEP = 'Y' AND BEPHours = 1 THEN 1 ELSE 0 END) AS FEP1hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND FEP = 'Y' AND BEPHours = 2 THEN 1 ELSE 0 END) AS FEP2hrMaintenance
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' AND FEP = 'Y' AND BEPHours = 3 THEN 1 ELSE 0 END) AS FEP3hrMaintenance

	--Heritage
	,'' AS ELL2hrHeritage
	,'' AS ELL3hrHeritage
	
	--Transitional
	,'' AS ELL2hrTransitional
	,'' AS ELL3hrTransitional

	,'' AS FEPNonPHLOTE1hrHeritageRev
	,'' AS FEPNonPHLOTE2hrHeritageRev

--Enrichment
	--Enrichment
	,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' 
	--ND FEP = 'Y' 
	--AND PHLOTE = 'N' 
	AND BEPHours = 1 THEN 1 ELSE 0 END) AS FEP1hrEnrich

	,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' 
	--AND FEP = 'Y' 
	--AND PHLOTE = 'N' 
	AND BEPHours = 2 THEN 1 ELSE 0 END) AS FEP2hrEnrich

	--,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' AND FEP = 'Y' AND PHLOTE = 'Y' AND BEPHours = 1 THEN 1 ELSE 0 END) AS FEPPHLOTE1hrEnrich
	--,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' AND FEP = 'Y' AND PHLOTE = 'Y' AND BEPHours = 2 THEN 1 ELSE 0 END) AS FEPPHLOTE2hrEnrich

	,NUMCLASSES.COUNTCLASSES AS NumClassesOffered
	,CASE 
		WHEN ALSLA = 'Lang. Arts' THEN 'Spanish' 
		WHEN ALSES = 'ESL' THEN 'English'
	ELSE 'Spanish'
	END AS LanguageOfDelivery

	,StaffLastName + ',' + StaffFirstName AS TeachersName
	
	,CASE WHEN ADDSTAFF.PRIMARY_TEACHER = 'N' THEN ADDSTAFF.LAST_NAME + ', ' + ADDSTAFF.FIRST_NAME  ELSE 'NONE' END AS EA

	, STAFFSTUFF.DOCUMENT_NUMBER AS License

	-- THIS IS TEACHING ARE LICENSE LIKE 200, 300, 520 ETC.
	,'' AS OtherLicense

	,CASE WHEN BILINGUAL.AUTHORIZED_TCH_AREA IS NOT NULL THEN 'Yes' ELSE 'No' END AS  BilingualEndorsed
	,CASE WHEN TESOL.AUTHORIZED_TCH_AREA IS NOT NULL THEN 'Yes' ELSE 'No' END AS  TESOLEndorsed

	,CASE WHEN CONTENT.BADGE_NUM IS NOT NULL THEN 'Yes' ELSE 'No' END AS ContentArea
	,CASE WHEN MCNL.BADGE_NUM IS NOT NULL THEN 'Yes' ELSE 'No' END AS MCNL
	,'' AS NACL
	,SUM(CASE WHEN ELL = 'Y' THEN 1 ELSE 0 END) AS ELLStudents

	,SUM(CASE WHEN BEPProgramDescription = '2-Way Dual' THEN 1 ELSE 0 END) AS TotalDUAL

	,'' AS SUBJECT
	,'' AS COPYATOB
	, 'ALBUQUERQUE' AS RecordID_DistrictName
	, BEP.SCHOOL_CODE AS RecordID_LocationID
	, '001' + BEP.SCHOOL_CODE AS RecordID_SchoolCode
	, '001' AS RecordID_DistrictCode
	, '' AS CopyAtoC
	, '' AS CopyBtoC
	
	,'' AS NumOfStudentsTransitional
	,SUM(CASE WHEN BEPProgramDescription = 'Maintenance' THEN 1 ELSE 0 END) AS NumOfStudentsMaintenance
	,'' AS NumOfStudentsHeritageELL
	,'' AS NumOfStudentsHeritageREV
	,SUM(CASE WHEN BEPProgramDescription = 'Enrichment' THEN 1 ELSE 0 END) AS NumOfStudentsEnrichment
	,BEP.SCHOOL_CODE AS SchoolCode
	,'' AS SchoolCode_DistrictCode
	,'' AS SchoolCode_DistrictName
	,'' AS SchoolCode_LocationID
	,'' AS SchoolCode_SchoolName
	,'' AS SchoolCode_ID
	,'001' + BEP.SCHOOL_CODE AS SchoolCode_SchoolCode
FROM 

	APS.BilingualModelAndHoursDetailsAsOf('2016-02-10') AS BEP

	INNER JOIN

	(
			SELECT 
				SCHOOL_CODE
				,BADGE_NUM
				--,SectionID
				,COUNT(RN) AS COUNTCLASSES
			from 
			(
			SELECT 
				SCHOOL_CODE
				,CourseID
				,SectionID
				,BADGE_NUM
				,EnrollGrade
				,ROW_NUMBER() OVER (PARTITION BY SCHOOL_CODE, BADGE_NUM,SectionID ORDER BY SectionID) AS RN
			FROM 
				APS.BilingualModelAndHoursDetailsAsOf('2016-02-10') AS BEP
				) as t1
			WHERE
				RN = 1

			GROUP BY 
				SCHOOL_CODE, BADGE_NUM

	) AS NUMCLASSES

ON
BEP.SCHOOL_CODE = NUMCLASSES.SCHOOL_CODE
AND BEP.BADGE_NUM = NUMCLASSES.BADGE_NUM

INNER JOIN
(
SELECT DISTINCT STAFF.BADGE_NUM, CRED.DOCUMENT_NUMBER, STAFF.STAFF_GU
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU

) AS STAFFSTUFF
ON
STAFFSTUFF.BADGE_NUM = BEP.BADGE_NUM

---BILINGUAL ENDORSEMENT
LEFT JOIN
(
SELECT DISTINCT
	AUTHORIZED_TCH_AREA
	,BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA = '67'
) AS BILINGUAL
ON
BILINGUAL.BADGE_NUM = BEP.BADGE_NUM

---ADDITIONAL STAFF EA STUFF HERE

LEFT JOIN
(
SELECT PRIMARY_TEACHER, LAST_NAME, FIRST_NAME, STAFF_GU, SECTION_GU FROM 
APS.SectionsAndAllStaffAssigned AS T
INNER JOIN
rev.REV_PERSON AS P
ON
T.STAFF_GU = P.PERSON_GU
WHERE PRIMARY_TEACHER = 'N'

) AS ADDSTAFF

ON
BEP.SECTION_GU = ADDSTAFF.SECTION_GU
--AND STAFFSTUFF.STAFF_GU = ADDSTAFF.STAFF_GU


---TESOL ENDORSEMENT
LEFT JOIN
(
SELECT DISTINCT
	AUTHORIZED_TCH_AREA
	,BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA = '27'
) AS TESOL
ON
TESOL.BADGE_NUM = BEP.BADGE_NUM

--CONTENT AREA
LEFT JOIN
(
SELECT DISTINCT
	BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA IN ('32', '10', '51')
) AS CONTENT

ON
BEP.BADGE_NUM = CONTENT.BADGE_NUM

--Modern Classical
LEFT JOIN
(
SELECT DISTINCT
	BADGE_NUM
FROM
rev.EPC_STAFF AS STAFF
LEFT JOIN
rev.EPC_STAFF_CRD AS CRED
ON
CRED.STAFF_GU = STAFF.STAFF_GU
WHERE
AUTHORIZED_TCH_AREA = '60'
) AS MCNL

ON
BEP.BADGE_NUM = MCNL.BADGE_NUM


GROUP BY 
	BEP.SCHOOL_CODE
	,CASE
		WHEN BEPProgramDescription = 'Enrichment' THEN 'Enrichment for FEP and English Speakers' 
		WHEN BEPProgramDescription = '2-Way Dual' THEN 'Dual Language Immersion' 
		WHEN BEPProgramDescription = 'Maintenance' THEN 'Maintenance Bilingual Program'
	ELSE ''
	END 
	,CASE 
		--WHEN ALSLA = 'Lang. Arts' THEN 'A.' 
		--WHEN ALSES = 'ESL' THEN 'B.'
		WHEN ALSMA = 'Math' THEN 'C.'
		WHEN ALSSC = 'Science' THEN 'C.'
		WHEN ALSSS = 'Soc. Studies' THEN 'C.'
		WHEN ALSOT = 'Other' THEN 'C.'
	ELSE ''
	END 
	,EnrollGrade
	,COUNTCLASSES
	,DOCUMENT_NUMBER
	,CASE 
		WHEN ALSLA = 'Lang. Arts' THEN 'Spanish' 
		WHEN ALSES = 'ESL' THEN 'English'
	ELSE 'Spanish'
	END
	,StaffLastName + ',' + StaffFirstName
	,CASE WHEN ADDSTAFF.PRIMARY_TEACHER = 'N' THEN ADDSTAFF.LAST_NAME + ', ' + ADDSTAFF.FIRST_NAME  ELSE 'NONE' END
	,BILINGUAL.AUTHORIZED_TCH_AREA 
	,TESOL.AUTHORIZED_TCH_AREA
	,CONTENT.BADGE_NUM 
	,MCNL.BADGE_NUM

) AS T1

WHERE
CourseDescription != ''