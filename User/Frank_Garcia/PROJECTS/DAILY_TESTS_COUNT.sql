/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
  [test_date_code]
  ,[test_type_name]
  ,COUNT (STUDENT_CODE) AS RECORDS

  FROM [SchoolNetDevelopment].[dbo].[test_result]
  
  GROUP BY
	test_date_code
	,test_type_name
	 
  ORDER BY test_type_name, test_date_code
