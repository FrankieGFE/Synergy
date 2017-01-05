
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	T1.*
	
	,[HS Cum Flat]
	,[HS Cum Weighted]
	
	--, CASE WHEN PARCC2015.[Student Id] IS NULL THEN PARCC2014.[Assessment - Date] ELSE PARCC2015.[Assessment - Date] END AS PARCC_Assessment_Date
	--, CASE WHEN PARCC2015.[Student Id] IS NULL THEN PARCC2014.[Test Subject] ELSE PARCC2015.[Test Subject] END AS PARCC_Test_Subject
	--, CASE WHEN PARCC2015.[Student Id] IS NULL THEN PARCC2014.[Test Scaled Score] ELSE PARCC2015.[Test Scaled Score]   END AS PARCC_Test_Scaled_Score
	--, CASE WHEN PARCC2015.[Student Id] IS NULL THEN PARCC2014.[Test Primary Result] ELSE PARCC2015.[Test Primary Result]  END AS PARCC_Test_Primary_Result
	

	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from DualPull.csv'
                ) AS [T1]

LEFT JOIN 
APS.CumGPA AS GPA
ON 
T1.SIS_NUMBER = GPA.SIS_NUMBER
/*
LEFT JOIN 

(SELECT 
	[Student Id]
	,[Assessment - Date]
	,[Test Subject]
	,[Test Scaled Score]
	,[Test Primary Result]
 FROM 

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from PARCC20142015.csv'
                ) AS [T2]
) AS PARCC2014
ON
T1.SIS_NUMBER = PARCC2014.[Student Id]

LEFT JOIN 

(SELECT 
	[Student Id]
	,[Assessment - Date]
	,[Test Subject]
	,[Test Scaled Score]
	,[Test Primary Result]
 FROM 

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from PARCC20152016.csv'
                ) AS [T3]
) AS PARCC2015
ON
T1.SIS_NUMBER = PARCC2015.[Student Id]
*/
	
REVERT
GO