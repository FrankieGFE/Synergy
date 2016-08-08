
ALTER VIEW [APS].[Edgenuity_Student_Export] AS 


SELECT
	BS.SIS_NUMBER + 'aps' AS Username
	,BS.SIS_NUMBER AS Password
	,BS.GENDER AS GENDER
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
	,'' AS GraduationDate
	,'' AS Guadrian1Relationship
	,SC.Parent1LastName AS Guardian1LastName
	,SC.Parent1FirstName AS Guardian1FirstName
	,SC.Parent1Email AS Guardian1Email
	,SC.Parent1PrimaryPhone AS Guardian1Pone
	,SC.Parent1Relation AS Guardian2Relationship
	,SC.Parent2LastName AS Guardian2LastName
	,SC.Parent2FirstName AS Guardian2FirstName
	,SC.Parent2Email AS Guardian2Email
	,SC.Parent2PrimaryPhone AS Guardian2Phone
	,CASE WHEN SPED_STATUS = 'Y' THEN 'Yes' ELSE 'No'
	END AS SPED
	,'' AS LEP
	,CASE WHEN LUNCH_STATUS IN ('F','2','R') THEN 'Yes' ELSE 'No'
	END AS FRL
	,CASE WHEN ELL_STATUS = 'Y' THEN 'Yes' ELSE 'No'
	END AS ELL
	,CASE WHEN sped.NEXT_IEP_DATE IS NOT NULL THEN 'Yes' ELSE 'No'
	END AS IEP
	,CASE WHEN GIFTED_STATUS = 'Y' THEN 'Yes' ELSE 'No'
	END AS Gifted
	,'' AS Section504
	,'' AS Title1
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
	APS.BasicStudentWithMoreInfo AS BS WITH (NOLOCK)
	LEFT HASH JOIN
		APS.StudentEnrollmentDetails AS SED WITH(NOLOCK)
		ON SED.SIS_NUMBER = BS.SIS_NUMBER
    LEFT HASH JOIN
	[APS].ParentContact AS SC WITH (NOLOCK)
	ON SC.[STUDENT ID NUMBER] = BS.SIS_NUMBER
	LEFT JOIN 
	(
	SELECT
				   *
		FROM
					REV.EP_STUDENT_SPECIAL_ED AS SPED
		WHERE
					NEXT_IEP_DATE IS NOT NULL
					AND (
						EXIT_DATE IS NULL 
						OR EXIT_DATE >= CONVERT(DATE, GETDATE())
						)
	) sped ON sped.STUDENT_GU = BS.STUDENT_GU

WHERE 1 = 1
--AND SED.SCHOOL_CODE IN ('517','518')
AND GRADE IN ('08','09','10','11','12') --- Request is for all active student in Grade Levels 8-12
AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
AND LEAVE_DATE IS NULL  --- Request is for all ACTIVE studentS in Grade Levels 8-12
AND EXCLUDE_ADA_ADM  IS NULL
AND SUMMER_WITHDRAWL_CODE IS NULL
AND EXTENSION = 'R'

--ORDER BY LocalID




