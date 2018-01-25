USE [Assessments]
GO
--SELECT
--	*
BEGIN TRAN
UPDATE
	AP
	--SET [Student Identifier] = T2.student_code
	SET [Student Identifier] = T2.[ALTERNATE STUDENT ID]
FROM
(
SELECT
	[AP Number]
	,[Last Name]
	,[First Name]
	--,[Middle Initial]
	--,STUDS.DOB AS STUD_DOB
	,STUD.BIRTHDATE
	,T1.DOB AS AP_DOB
	,T1.[Date of Birth]
	--,STUDS.student_code
	,STUD.[ALTERNATE STUDENT ID]
	,T1.[Student Identifier]
FROM
(
SELECT [AP Number]
      ,[Last Name]
      ,[First Name]
      ,[Middle Initial]
      ,[Student Street Address 1]
      ,[Student Street Address 2]
      ,[Student Street Address 3]
      ,[Student State]
      ,[Student Zip Code]
      ,[Student Province]
      ,[Student International Postal Code]
      ,[Student Country Code]
      ,[Sex]
	  ,CASE WHEN LEN([Date of Birth]) = 5
			THEN '19'+RIGHT([Date of Birth] ,2) + '-'+ '0'+ LEFT([DATE OF BIRTH],1) +'-'+ SUBSTRING([Date of Birth],2,2) 
			ELSE '19'+RIGHT([Date of Birth] ,2) + '-'+ LEFT([DATE OF BIRTH],2) +'-'+ SUBSTRING([Date of Birth],3,2) 
	  END AS 'DOB'
	  ,[Date of Birth]
      ,[Social Security Number]
      ,[School ID]
      ,[Education Level]
      ,[Student Identifier]
      ,AP.[student_code]
      ,[SCH_YR]
  FROM [dbo].[AP_NEED_IDS_TRASH] AS AP
  --WHERE [Student Identifier] IS NULL
) AS T1
--LEFT JOIN
--allstudents_ALL AS STUDS
--ON T1.[Last Name] = STUDS.LAST_NAME
--AND T1.[First Name] = STUDS.FIRST_NAME
--AND T1.DOB = STUDS.dob
LEFT JOIN
	[046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
	ON T1.[LAST NAME] = STUD.[LAST NAME LONG]
	AND T1.[First Name] = STUD.[FIRST NAME LONG]
	AND T1.DOB = STUD.BIRTHDATE

--WHERE T1.[Last Name] = 'Sullivan'
) AS T2
LEFT JOIN
	AP
	ON AP.[Last Name] = T2.[Last Name]
	AND AP.[First Name] = T2.[First Name]
	AND AP.[Date of Birth] = T2.[Date of Birth]
	AND AP.[Student Identifier] IS NULL
ROLLBACK
--ORDER BY [Last Name]
GO


