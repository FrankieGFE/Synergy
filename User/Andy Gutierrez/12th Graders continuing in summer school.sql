SELECT
      [PRIMARY].[SCHOOL_CODE] AS [PRIMARY_SCHOOL_CODE]
      ,[PRIMARY].[SCHOOL_NAME] AS [PRIMARY_SCHOOL_NAME]
      ,[PRIMARY].[ENTER_DATE] 
      ,[PRIMARY].[LEAVE_DATE]
      ,[STUDENT].[SIS_NUMBER]
      ,[STUDENT].[STATE_STUDENT_NUMBER]
      ,[PRIMARY].[GRADE] AS [PRIMARY_GRADE]
      
      ,[SUMMER].[SCHOOL_CODE] AS [SUMMER_SCHOOL_CODE]
      ,[SUMMER].[SCHOOL_NAME] AS [SUMMER_SCHOOL_NAME]
      ,[SUMMER].[ENTER_DATE]
      ,[SUMMER].[LEAVE_DATE]
      
FROM
      APS.PrimaryEnrollmentDetailsAsOf('05/25/2016') AS [PRIMARY]
      
      INNER JOIN
      APS.BasicStudent AS [STUDENT]
      ON
      [PRIMARY].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
      
      INNER JOIN
      APS.StudentEnrollmentDetails AS [SUMMER]
      ON
      [PRIMARY].[STUDENT_GU] = [SUMMER].[STUDENT_GU]
      AND [SUMMER].[SCHOOL_YEAR] = '2015'
      AND [SUMMER].[EXTENSION] = 'S'
      
WHERE
      [PRIMARY].[GRADE] = '12'

