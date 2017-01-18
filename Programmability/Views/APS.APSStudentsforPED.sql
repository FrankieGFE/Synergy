--<APSStudentsforPED.txt>
/*
From: Judge, Glen D 
Sent: Friday, October 21, 2016 9:39 AM
To: Gutierrez, Andy J <Gutierrez_a@aps.edu>
Cc: Tefft, Stu <tefft@aps.edu>
Subject: Complete Student List

Can you send us a complete student list with the Guardian First/Last separated? We need this for a file to send to the State.  
If this works to we may ask you to send us this on the first of every month.

File Name – APSStudentsforPED.txt
Columns:
Location ID
Student State ID
Student Last Name
Student MI
Student First Name
DOB
Street Address
City
State
Zip
Guardian Last Name
Guardian First Name

Glen Judge
Network Engineer
Food and Nutrition Services
Albuquerque Public Schools
505-345-5661 x38251
judge@aps.edu

CREATED BY FRANK GARCIA 10-21-2016
*/

ALTER VIEW APS.APSStudentsforPED AS


SELECT 
    SCH.STATE_SCHOOL_CODE AS 'Location ID'
	,[Student].[STATE_STUDENT_NUMBER] AS 'Student State ID'
	,[Student].[LAST_NAME] AS 'Student Last Name'
	,[Student].[MIDDLE_NAME] AS 'Student MI'
	,[Student].[FIRST_NAME] AS 'Student First Name'
	,CONVERT(VARCHAR(10),[Student].[BIRTH_DATE],101) AS DOB
	,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS] ELSE [Student].[MAIL_ADDRESS] END AS 'Street Address'
    --,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS_2] ELSE [Student].[MAIL_ADDRESS_2] END AS 'Street Address 2'
    ,CASE WHEN [Student].[MAIL_CITY] IS NULL THEN [Student].[HOME_CITY] ELSE [Student].[MAIL_CITY] END AS [City]
    ,CASE WHEN [Student].[MAIL_STATE] IS NULL THEN [Student].[HOME_STATE] ELSE [Student].[MAIL_STATE] END AS [State]
    ,CASE WHEN [Student].[MAIL_ZIP] IS NULL THEN [Student].[HOME_ZIP] ELSE [Student].[MAIL_ZIP] END AS [Zip]
	,'Guardian 1 Last Name' = P1.LAST_NAME
	,'Guardian 1 First Name' = P1.FIRST_NAME
	,'Relation 1' = PAR1.RELATION_TYPE
	,'Guardian 2 Last Name' = P2.LAST_NAME
	,'Guardian 2 First Name' = P2.FIRST_NAME
	,'Relation 2' = PAR2.RELATION_TYPE
FROM
	APS.PrimaryEnrollmentDetailsAsOf(getdate()) AS [Enrollments]
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [Student] 
	ON
	[Enrollments].[STUDENT_GU] = [Student].[STUDENT_GU]	
	JOIN rev.EPC_SCH               sch ON sch.ORGANIZATION_GU      = Enrollments.ORGANIZATION_GU

	LEFT JOIN
	(
	SELECT 
	   ROW_NUMBER () OVER (PARTITION BY STUDENT_GU ORDER BY ORDERBY) AS RN
	   ,STUDENT_GU
	   ,PARENT_GU
	   ,SPAR.RELATION_TYPE
	   --,CASE WHEN ORDERBY IS NULL THEN 0 ELSE ORDERBY END AS ORDERBY
	FROM
	REV.EPC_STU_PARENT SPAR
	WHERE (SPAR.LIVES_WITH = 'Y' OR SPAR.CONTACT_ALLOWED = 'Y')
	) AS PAR1
	ON PAR1.STUDENT_GU = Student.STUDENT_GU
	AND RN = 1	
	
	JOIN
	REV.REV_PERSON AS P1
	ON PAR1.PARENT_GU = P1.PERSON_GU

	LEFT JOIN
	(
	SELECT 
	   ROW_NUMBER () OVER (PARTITION BY STUDENT_GU ORDER BY ORDERBY) AS RN2
	   ,STUDENT_GU
	   ,PARENT_GU
	   ,RELATION_TYPE
	   --,CASE WHEN ORDERBY IS NULL THEN 0 ELSE ORDERBY END AS ORDERBY
	FROM
	REV.EPC_STU_PARENT SPAR
	WHERE (SPAR.LIVES_WITH = 'Y' OR SPAR.CONTACT_ALLOWED = 'Y')
	) AS PAR2
	ON PAR2.STUDENT_GU = Student.STUDENT_GU
	AND RN2 = 2

	LEFT JOIN
	REV.REV_PERSON AS P2
	ON PAR2.PARENT_GU = P2.PERSON_GU

WHERE 1 = 1
	AND STATE_STUDENT_NUMBER IS NOT NULL
--ORDER BY STATE_STUDENT_NUMBER


