USE
SCHOOLNET
GO

SELECT
	DISTNO
	,SCHNUMB
	,DEP
	,DEPMAIL
	,STID
	,FNAME
	,LNAME
	,MI
	,TID
	,TFNAME
    ,TLNAME
	,TEST
	,VNO
	,NOITEMS
	,COURSEID
	,TESTDATE
	,ITEMDATA
	,[Q1]
    ,[Q2]
    ,[Q3]
    ,[Q4]
    ,[Q5]
    ,[Q6]
    ,[Q7]
    ,[Q8]
    ,[Q9]
    ,[Q10]
    ,[Q11]
    ,[Q12]
    ,[Q13]
    ,[Q14]
    ,[Q15]
    ,[Q16]
    ,[Q17]
    ,[Q18]
    ,[Q19]
    ,[Q20]
    ,[Q21]
    ,[Q22]
    ,[Q23]
    ,[Q24]
    ,[Q25]
    ,[Q26]
    ,[Q27]
    ,[Q28]
    ,[Q29]
    ,[Q30]
    ,[Q31]
    ,[Q32]
    ,[Q33]
    ,[Q34]
    ,[Q35]
    ,[Q36]
    ,[Q37]
    ,[Q38]
    ,[Q39]
    ,[Q40]
    ,[Q41]
    ,[Q42]
    ,[Q43]
    ,[Q44]
    ,[Q45]
    ,[Q46]
    ,[Q47]
    ,[Q48]
    ,[Q49]
    ,[Q50]
    ,[Q51]
    ,[Q52]
    ,[Q53]
    ,[Q54]
    ,[Q55]
    ,[Q56]
    ,[Q57]
    ,[Q58]
    ,[Q59]
    ,[Q60]
    ,[Q61]
	,[Q62]

FROM
(

SELECT
	*
FROM
	(
	SELECT
	ROW_NUMBER () OVER (PARTITION BY SOAP1.STID_2, SOAP2.TFNAME, SOAP2.TLNAME, SOAP1.TEST ORDER BY SOAP1.STID_2, SOAP1.TEST, SOAP2.TID) AS RN
	,SOAP1.DISTNO
	,SOAP1.SCHNUMB
	,SOAP1.DEP
	,SOAP1.DEPMAIL
	,SOAP1.STID_2 AS STID
	,SOAP1.FNAME
	,SOAP1.LNAME
	,SOAP1.MI
	,CASE
		WHEN SOAP2.TID IS NULL THEN '999999999' ELSE SOAP2.TID
	END AS TID
	,SUBSTRING(SOAP2.TFNAME, 1, NULLIF(CHARINDEX(',', SOAP2.TFNAME) - 1, -1)) AS TFNAME
    ,SUBSTRING(SOAP2.TFNAME, CHARINDEX(',', SOAP2.TFNAME) + 1, 8000) AS TLNAME
	,SOAP1.TEST
	,RIGHT(SOAP1.TEST,4) AS VNO
	,CASE
		WHEN SOAP1.TEST = 'Algebra I 7 12 V001' THEN '37'
		WHEN SOAP1.TEST = 'Algebra II 10 12 V002' THEN '27'
		WHEN SOAP1.TEST = 'Biology 9 12 V003' THEN '50'
		WHEN SOAP1.TEST = 'Chemistry 9 12 V003' THEN '50'
		WHEN SOAP1.TEST = 'ECONOMICS 9 12 V001' THEN '44'
		WHEN SOAP1.TEST = 'English Language Arts III Reading 11 11 V002' THEN '24'
		WHEN SOAP1.TEST = 'English Language Arts III Writing 11 11 V002' THEN '18'
		WHEN SOAP1.TEST = 'English Language Arts IV Reading 12 12 V001' THEN '24'
		WHEN SOAP1.TEST = 'English Language Arts IV Writing 12 12 V001' THEN '22'
		WHEN SOAP1.TEST = 'HEALTH EDUCATION 6 12 V001' THEN '60'
		WHEN SOAP1.TEST = 'INTEGRATED GENERAL SCIENCE 6 8 V001' THEN '49'
		WHEN SOAP1.TEST = 'Introduction to Art 4 5 V001' THEN '16'
		WHEN SOAP1.TEST = 'Introduction to Art 6 8 V001' THEN '18'
		WHEN SOAP1.TEST = 'Introduction to Art 9 12 V001' THEN '27'
		WHEN SOAP1.TEST = 'Music 4 5 V001' THEN '19'
		WHEN SOAP1.TEST = 'Music 9 12 V001' THEN '48'
		WHEN SOAP1.TEST = 'NEW MEXICO HISTORY 7 12 V001' THEN '44'
		WHEN SOAP1.TEST = 'Physical Education 4 5 V001' THEN '18'
		WHEN SOAP1.TEST = 'Physical Education 6 8 V001' THEN '28'
		WHEN SOAP1.TEST = 'Physical Education 9 12 V001' THEN '31'
		WHEN SOAP1.TEST = 'Social Studies 6 6 V001' THEN '30'
		WHEN SOAP1.TEST = 'SPANISH I 7 12 V001' THEN '32'
		WHEN SOAP1.TEST = 'Spanish Language Arts III Reading 11 11 V001' THEN '30'
		WHEN SOAP1.TEST = 'Spanish Language Arts III Writing 11 11 V001' THEN '10'
		WHEN SOAP1.TEST = 'US GOVERNMENT COMPREHENSIVE 9 12 V001' THEN '50'
		WHEN SOAP1.TEST = 'US History 9 12 V002' THEN '62'
		WHEN SOAP1.TEST = 'World History and Geography 9 12 V001' THEN '45'
	END AS NOITEMS
	,SOAP2.COURSEID
	,SOAP1.TESTDATE
	,'Y' AS ITEMDATA
	,[Q1]
    ,[Q2]
    ,[Q3]
    ,[Q4]
    ,[Q5]
    ,[Q6]
    ,[Q7]
    ,[Q8]
    ,[Q9]
    ,[Q10]
    ,[Q11]
    ,[Q12]
    ,[Q13]
    ,[Q14]
    ,[Q15]
    ,[Q16]
    ,[Q17]
    ,[Q18]
    ,[Q19]
    ,[Q20]
    ,[Q21]
    ,[Q22]
    ,[Q23]
    ,[Q24]
    ,[Q25]
    ,[Q26]
    ,[Q27]
    ,[Q28]
    ,[Q29]
    ,[Q30]
    ,[Q31]
    ,[Q32]
    ,[Q33]
    ,[Q34]
    ,[Q35]
    ,[Q36]
    ,[Q37]
    ,[Q38]
    ,[Q39]
    ,[Q40]
    ,[Q41]
    ,[Q42]
    ,[Q43]
    ,[Q44]
    ,[Q45]
    ,[Q46]
    ,[Q47]
    ,[Q48]
    ,[Q49]
    ,[Q50]
    ,[Q51]
    ,[Q52]
    ,[Q53]
    ,[Q54]
    ,[Q55]
    ,[Q56]
    ,[Q57]
    ,[Q58]
    ,[Q59]
    ,[Q60]
    ,[Q61]
	,[Q62]


FROM
	EOC_SOAP AS SOAP1
LEFT JOIN
	EOC_SOAP_2 AS SOAP2
	ON SOAP1.STID_2 = SOAP2.STID	
	AND SOAP1.TEST = SOAP2.TEST_DESCR
) AS T1
WHERE RN = 1
AND STID IS NOT NULL
--AND STID = '739718286'
AND TEST IN ('INTEGRATED GENERAL SCIENCE 6 8 V001','Social Studies 6 6 V001','Algebra II 10 12 V002','Introduction to Art 4 5 V001','Introduction to Art 6 8 V001','Introduction to Art 9 12 V001','Biology 9 12 V003','Chemistry 9 12 V003','English Language Arts III Reading 11 11 V002'
			,'English Language Arts III Writing 11 11 V002','English Language Arts IV Reading 12 12 V001','English Language Arts IV Writing 12 12 V001','HEALTH EDUCATION 6 12 V001','Music 4 5 V001','Music 9 12 V001','Physical Education 4 5 V001','Physical Education 6 8 V001'
			,'Physical Education 9 12 V001','SPANISH I 7 12 V001','Spanish Language Arts III Reading 11 11 V001','Spanish Language Arts III Writing 11 11 V001','US History 9 12 V002','World History and Geography 9 12 V001')
--ORDER BY STID, TEST, TID
) AS T3
--WHERE TEST = 'World History and Geography 9 12 V001'
ORDER BY TEST