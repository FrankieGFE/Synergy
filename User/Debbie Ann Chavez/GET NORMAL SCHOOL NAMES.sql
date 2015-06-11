

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT 
	CLUSTER
	,SCHOOL
	,[LASTYEAR NOHLS] AS [Year Ago 5/22/2014 No HLS]
	
	
	,[Current Quarter 5/22/2014] AS [Current Quarter 5/22/2015 Needs EPT]
	,[LAST YEAR NOTEST] AS [Year Ago 5/22/2014 No EPT]
	

FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from CLUSTER_NOHLS.csv'
                ) AS CLUSTER

			LEFT JOIN
			rev.REV_ORGANIZATION AS ORG
			ON
			ORG.ORGANIZATION_NAME = CLUSTER.SCHOOL

			LEFT JOIN
			(SELECT 
				SchoolName
				,COUNT (*) AS [Current Quarter 5/22/2014]
			 FROM 
			APS.LCEStudentsNeedingTestingAsOf(GETDATE())
			GROUP BY 
				SchoolName
			) AS T1

	ON 
	T1.SchoolName = ORG.ORGANIZATION_NAME

      REVERT
GO