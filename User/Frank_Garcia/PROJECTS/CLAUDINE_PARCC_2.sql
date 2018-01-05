USE [Assessments]
GO


UPDATE 
	[StudentTestUpdateExport_EOY]
	SET [NOT TESTED CODE] = 'Y'
	,[NOT TESTED REASON] = '2'

--SELECT * FROM
--(
--SELECT 
--	  ROW_NUMBER () OVER (PARTITION BY[Local Student Identifier] ORDER BY [Local Student Identifier]) AS RN
--	  ,[State Abbreviation]
--      ,[Testing District]
--      ,[Testing School]
--      ,[Responsible District Identifier]
--      ,[School Institution Identifier]
--      ,[State Student Identifier]
--      ,[Local Student Identifier]
--      ,[PARCC Student Identifier]
--      ,[Last or Surname]
--      ,[First Name]
--      ,[Middle Name]
--      ,[Birthdate]
--      ,[Sex]
--      ,[Optional State Data 1]
--      ,[Student Test UUID]
--      ,[Student Test Status]
--      ,[Not Tested Code]
--      ,[Not Tested Reason]
--	  ,AE.Assessment
--      ,[Void PBA EOY Score  Code]
--      ,[Void PBA EOY Score  Reason]
--      ,[End of Record]
  FROM [dbo].[StudentTestUpdateExport_EOY] AS EOY

  JOIN
  ALLSTUDENTS AS STUD
  ON EOY.[State Student Identifier] = STUD.STATE_ID

  JOIN
  AIMS.DBO.Program_Assessment_Exemptions AS AE
  ON STUD.student_code = AE.APS_ID

  WHERE AE.Assessment LIKE '%PARCC%'
  AND AE.Opt_Out_Or_In != 'IN'
  AND AE.SCH_YR = '2014-2015'
  --[RDAVM].AIMS.dbo.Program_Assessment_Exemptions AS AE
  --ORDER BY [Not Tested Code]
  --ON AE.APS_ID = 
--) AS T1
--WHERE RN = 1

GO


