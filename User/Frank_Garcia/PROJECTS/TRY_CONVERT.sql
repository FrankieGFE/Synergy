SELECT TOP 1000 [Last Name]
      ,[First Name]
      ,[Birth Date]
      ,[Student ID]
	  ,[Test Date]
      
FROM
	[ACCUPLACER_2015-2016_V2]
WHERE
TRY_CONVERT(DATE, REPLACE( [Test Date],'-',''), 101) IS NULL
ORDER BY [Test Date]