SELECT
	[Last Name]
	,PLACE.LNAME
     ,[First Name]
      ,[Middle Initial]
      ,[Birth Date]
	  ,SUBSTRING (PLACE.DOB,6,2) + '/' + RIGHT(PLACE.DOB,2) + '/' + LEFT (PLACE.DOB,4) BIRTHDATE
	  ,PLACE.DOB
      ,[Student ID]
	  ,PLACE.APS_ID
      ,[Test Date]
	  ,PLACE.test_date_code
      ,[High School]
	  ,TOM.SCORE
	  ,TOM.SUBTEST
	  ,TOM.SCH_YR
	  ,PLACE.SUBTEST
FROM
(
SELECT [Last Name]
      ,[First Name]
      ,[Middle Initial]
      ,[Birth Date]
      ,[Student ID]
      ,[Test Date]
      ,[High School]
	  ,SCORE
	  ,SUBTEST
	  ,SCH_YR
	  --,LOC.fld_LocNum
      --,[Reading Comprehension]
      --,[Sentence Skills]
      --,[Arithmetic]
      --,[Elementary Algebra]
      --,[College Level Math]
  FROM [180-SMAXODS-01].SCHOOLNET.[dbo].[CCR_APS non-charter accuplacer] AS ACCU
  UNPIVOT (SCORE FOR SUBTEST IN ([Reading Comprehension], [Sentence Skills], [Arithmetic], [Elementary Algebra], [College Level Math])) AS UNPIV
) AS TOM
  LEFT JOIN
  Assessments.[dbo].[CCR_ACCUPLACER] PLACE
  ON TOM.[Last Name] = PLACE.LName
  AND TOM.[FIRST NAME] = PLACE.FName
  AND TOM.[BIRTH DATE] = SUBSTRING (PLACE.DOB,6,2) + '/' + RIGHT(PLACE.DOB,2) + '/' + LEFT (PLACE.DOB,4)
  AND TOM.SUBTEST = PLACE.SUBTEST
  AND TOM.SCORE = PLACE.SCORE
  --AND TOM.[TEST DATE] = PLACE.test_date_code

  WHERE TOM.SCH_YR = '2014-2015'
  AND APS_ID IS NULL
  AND (TOM.SCORE IS NOT NULL AND TOM.SCORE != '')
ORDER BY [LAST NAME], [FIRST NAME], TOM.SUBTEST

  -- ON PLACE.LNAME = ACCU.[LAST NAME]
  --AND PLACE.FNAME = ACCU.[FIRST NAME]
  ----AND PLACE.DOB = RIGHT(ACCU.[BIRTH DATE],4) + '-' + LEFT (ACCU.[BIRTH DATE],2) + '-' + SUBSTRING(ACCU.[BIRTH DATE],4,2) 
  --AND PLACE.SUBTEST = ACCU.[

