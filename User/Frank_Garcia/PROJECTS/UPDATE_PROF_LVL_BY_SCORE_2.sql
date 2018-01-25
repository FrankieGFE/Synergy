

UPDATE
	db_Logon.dbo.[2010]
SET 
	db_Logon.dbo.[2010].[SPRING_DBA_MATH_PL] = CASE 
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_MATH] AS DECIMAL)) < 40
												THEN 'BEGININNG STEPS'
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_MATH] AS DECIMAL)) BETWEEN 40 AND 69.99 
												THEN 'NEARING PROFICIENT'
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_MATH] AS DECIMAL)) BETWEEN 70 AND 89.99
												THEN 'PROFICIENT'
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_MATH] AS DECIMAL)) > 89.99
												THEN 'ADVANCED'
												ELSE ''
												END
											
	,db_Logon.dbo.[2010].[SPRING_DBA_ELA_PL] = CASE 
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_ELA] AS DECIMAL)) < 40
												THEN 'BEGININNG STEPS'
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_ELA] AS DECIMAL)) BETWEEN 40 AND 69.99
												THEN 'NEARING PROFICIENT'
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_ELA] AS DECIMAL)) BETWEEN 70 AND 89.99
												THEN 'PROFICIENT'
												WHEN (CAST (db_Logon.dbo.[2010].[SPRING_DBA_ELA] AS DECIMAL)) > 89.99
												THEN 'ADVANCED'
												ELSE ''
												END

