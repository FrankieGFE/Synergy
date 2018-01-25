


SELECT 
	ORGANIZATION_NAME
	,[SIS Number]
	,[State Student Number]
	,[School Code]
	,[State School Code]
	,[Exclude_ADA_ADM]
	--,[Absence Date]

	,SUM(CASE WHEN [Excused Religious Half Day] = 'EHDCO' THEN 0.50 ELSE 0.00 END) AS [Excused Ilness Half Day]
	,SUM(CASE WHEN [Excused Religious Full Day] = 'EFDCO' THEN 1.00 ELSE 0.00 END) AS [Excused Ilness Full Day]

	,SUM(CASE WHEN [Unexcused Half Day] = 'UNHD' THEN 0.50 ELSE 0.00 END) AS [Unexcused Half Day]
	,SUM(CASE WHEN [Unexcused Full Day] = 'UNFD' THEN 1.00 ELSE 0.00 END) AS [Unexcused Full Day]

 FROM [APS].[STARSAttendanceDetailsILAsOf]('20180115', '20180118') AS ATT
 INNER JOIN 
 REV.EPC_SCH AS SCH
 ON
 SCH.SCHOOL_CODE = [School Code] 
 INNER JOIN 
 REV.REV_ORGANIZATION AS ORG
 ON
 ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU

 GROUP BY 

 ORGANIZATION_NAME
	,[SIS Number]
	,[State Student Number]
	,[School Code]
	,[State School Code]
	,[Exclude_ADA_ADM]


ORDER BY 
	ORGANIZATION_NAME