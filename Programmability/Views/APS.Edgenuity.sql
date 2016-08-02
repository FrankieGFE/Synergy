SELECT
	BS.SIS_NUMBER + 'aps' AS Username
	,BS.SIS_NUMBER AS Password
	,GENDER AS GENDER
	,'' AS Notes
	,HOME_ADDRESS AS Street
	,HOME_CITY AS CITY
	,HOME_STATE AS STATE
	,'' AS Country
	,'' AS CountryofBirth
	,RESOLVED_RACE AS Race
	,HISPANIC_INDICATOR AS Hispanic
	,PRIMARY_PHONE AS HomePhone
	,SED.GRADE AS GradeLevel
	,BS.SIS_NUMBER AS LocalID
	,CLASS_OF AS ProjectedGRaduationDate
	,'' AS Guadrian1Relationship
	,'' AS Guardian1LastName
	,'' AS Guardian1FirstName
	,'' AS Guardian1Email
	,'' AS Guardian1Pone
	,'' AS Guardian2Relationship
	,'' AS Guardian2LastName
	,'' AS Guardian2FirstName
	,'' AS Guardian2Email
	,'' AS Guardian2Phone
	,CASE WHEN SPED_STATUS = 'Y' THEN 'Yes' ELSE 'No'
	END AS SPED
	,'' AS LEP
	,CASE WHEN LUNCH_STATUS IN ('F','2','R') THEN 'Yes' ELSE 'No'
	END AS FRL
	,CASE WHEN ELL_STATUS = 'Y' THEN 'Yes' ELSE 'No'
	END AS ELL
	,'' AS IEP
	,CASE WHEN GIFTED_STATUS = 'Y' THEN 'Yes' ELSE 'No'
	END AS Gifted
	,'' AS Section504
	,'' AS SchoolCounselorName
	,CONVERT (VARCHAR,SED.ENTER_DATE, 101) AS EnrollmentDate
	,FIRST_NAME AS 'First Name' 
	,LAST_NAME AS 'Last Name'
	,'' AS 'Email Address'
	,PRIMARY_PHONE AS Phone
	,BS.SIS_NUMBER AS 'SUSD Student ID'
	,SED.SCHOOL_CODE AS 'School ID'
	,'' AS 'Secondary Email'
	,'' AS 'Cell Phone'
	,MIDDLE_NAME AS 'Middle Name'
	,'' AS 'Preferred Name'
	,CONVERT(VARCHAR, BS.BIRTH_DATE, 101) AS 'Date of Birth'
	,HOME_ZIP AS 'Zip'
	,'' AS Status
	,'' AS GradpointID

FROM
	APS.BasicStudentWithMoreInfo AS BS
	LEFT HASH JOIN
		APS.StudentEnrollmentDetails AS SED
		ON SED.SIS_NUMBER = BS.SIS_NUMBER

WHERE 1 = 1
--AND SED.SCHOOL_CODE IN ('517','518')
AND GRADE IN ('08','09','10','11','12')
AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
AND LEAVE_DATE IS NULL
AND EXCLUDE_ADA_ADM  IS NULL
AND SUMMER_WITHDRAWL_CODE IS NULL
AND EXTENSION = 'R'

ORDER BY LocalID




