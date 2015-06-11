EXECUTE AS LOGIN='QueryFileUser'
GO

DECLARE @AsOfDate DATE = GETDATE()

SELECT 
	ORG2.ORGANIZATION_NAME AS CLUSTER
	,ESL.ORGANIZATION_NAME
	
	,[Req ESL Current]
	,[Received ESL Current Quarter]
	,COALESCE([Received ESL Current Quarter]*100/NULLIF([Req ESL Current],0),0) * 1.0 AS CurrentPercent

	,[Req ESL Prior]
	,[Received ESL Prior Quarter]
	,COALESCE([Received ESL Prior Quarter]*100/NULLIF([Req ESL Prior],0),0) *1.0  AS PriorPercent

	,CREQ AS [Year Ago 5/22/2014 Req ESL]
	,CREC AS [Year Ago 5/22/2014 Received ESL]
	,CURP AS [Year Ago 5/22/2014 Percent]

	
 FROM 
(
SELECT 
		ORGANIZATION_NAME
		,COUNT(*) AS [Req ESL Current]
		,SUM(CASE WHEN [STATUS] = '' THEN 1 ELSE 0 END) AS [Received ESL Current Quarter]
 FROM 
APS.LCEStudentsAndProvidersAsOf(@AsOfDate) AS ESL

GROUP BY 
	ORGANIZATION_NAME
)AS ESL

LEFT JOIN
(
SELECT 
		ORGANIZATION_NAME
		,COUNT(*) AS [Req ESL Prior]
		,SUM(CASE WHEN [STATUS] = '' THEN 1 ELSE 0 END) AS [Received ESL Prior Quarter]
 FROM 
APS.LCEStudentsAndProvidersAsOf('2015-03-15') AS ESL

GROUP BY 
	ORGANIZATION_NAME
) AS T1

ON
ESL.ORGANIZATION_NAME = T1.ORGANIZATION_NAME

LEFT JOIN
(SELECT 
	CLUSTER
	,SCHOOL
	,CREQ
	,CREC
	,CURP
FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from 2A_ALS.csv'
                ) AS ALS

) AS YAGO

ON YAGO.SCHOOL = ESL.ORGANIZATION_NAME


	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	CAST(YAGO.CLUSTER AS VARCHAR) = SCHOOL.SCHOOL_CODE

	INNER JOIN
	rev.REV_ORGANIZATION AS ORG2
	ON
	SCHOOL.ORGANIZATION_GU = ORG2.ORGANIZATION_GU


      REVERT
GO