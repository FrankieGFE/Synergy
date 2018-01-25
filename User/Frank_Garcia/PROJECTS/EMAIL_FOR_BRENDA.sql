USE [db_Logon]
GO

SELECT [APSTeacherID]
      ,[RandomSelect]
      ,[UsageGrp]
      ,[SchoolLvl]
      ,[FocusGrp]
      ,[SpecialUser]
      ,[Site]
      ,[UserName]
      ,[TOTAL20132014]
      ,CASE WHEN EMP.[EMAIL_ADDRESS] IS NULL THEN '' ELSE EMP.[EMAIL_ADDRESS] END AS [email]
  FROM [dbo].[Teachers_DE_focus_groups_emails] AS FOCUS
  LEFT JOIN
	[db_Logon].[dbo].[Employee_File] AS EMP
	ON FOCUS.[APSTEACHERID] = EMP.EMPLOYEE_ID
ORDER BY EMAIL
GO


