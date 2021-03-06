/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [UDOPT_OUT_GU]
      ,[ADD_DATE_TIME_STAMP]
      ,[ADD_ID_STAMP]
      ,[ASSESSMENT]
      ,[CHANGE_DATE_TIME_STAMP]
      ,[CHANGE_ID_STAMP]
      ,[END_OF_COURSE_EXAM]
      ,[GRADE_LEVEL]
      ,[STUDENT_GU]
      ,[DATE_RECEIVED]
      ,[END_DATE]
      ,[NOTES]
  FROM [ST_Production].[rev].[UD_OPT_OUT] OO
  LEFT JOIN APS.LookupTable ('REVELATION.UD.OPTOUT','ASSESSMENT') AS LU
  ON LU.VALUE_CODE = OO.ASSESSMENT

  ORDER BY ASSESSMENT