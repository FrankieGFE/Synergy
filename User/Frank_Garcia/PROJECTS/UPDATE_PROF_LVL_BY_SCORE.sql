

UPDATE
	db_Logon.dbo.[2009]
SET 
	db_Logon.dbo.[2009].[SPRING_DBA_MATH_PL] = CASE 
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_MATH_PL] LIKE '%1%' 
												THEN 'BEGININNG STEPS'
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_MATH_PL] LIKE '%2%' 
												THEN 'NEARING PROFICIENT'
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_MATH_PL] LIKE '%3%' 
												THEN 'PROFICIENT'
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_MATH_PL] LIKE '%4%' 
												THEN 'ADVANCED'
												ELSE db_Logon.dbo.[2009].[SPRING_DBA_MATH_PL]
												END
											
	,db_Logon.dbo.[2009].[SPRING_DBA_ELA_PL] = CASE 
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_ELA_PL] LIKE '%1%' 
												THEN 'BEGININNG STEPS'
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_ELA_PL] LIKE '%2%' 
												THEN 'NEARING PROFICIENT'
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_ELA_PL] LIKE '%3%' 
												THEN 'PROFICIENT'
												WHEN db_Logon.dbo.[2009].[SPRING_DBA_ELA_PL] LIKE '%4%' 
												THEN 'ADVANCED'
												ELSE db_Logon.dbo.[2009].[SPRING_DBA_ELA_PL]
												END
