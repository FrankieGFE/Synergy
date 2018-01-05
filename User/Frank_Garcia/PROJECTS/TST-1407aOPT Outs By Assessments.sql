



SELECT 
	SCHOOL_LOCATION
	,ORGANIZATION_NAME
	,ORGANIZATION_GU
	,SCH_YR
	,CASE WHEN [End of Course Exam] IS NULL THEN 0 ELSE [End of Course Exam] END AS 'End of Course Exam'
	,CASE WHEN [Istation] IS NULL THEN 0 ELSE Istation END AS Istation
	,CASE WHEN [Math Interim Assessment] IS NULL THEN 0 ELSE [Math Interim Assessment] END AS 'Math Interim Assessment'
	,CASE WHEN [NMAPA] IS NULL THEN 0 ELSE NMAPA END AS 'NMAPA'
	,CASE WHEN [PARCC] IS NULL THEN 0 ELSE PARCC END AS 'PARCC'
	,CASE WHEN [PARCC ELA] IS NULL THEN 0 ELSE [PARCC ELA] END AS 'PARCC ELA'
	,CASE WHEN [PARCC Math] IS NULL THEN 0 ELSE [PARCC MATH] END AS 'PARCC MATH'
	,CASE WHEN [Reading Interim Assessment] IS NULL THEN 0 ELSE [Reading Interim Assessment] END AS 'Reading Interim Assessment'
	,CASE WHEN [Standards-Based Assessment Science] IS NULL THEN 0 ELSE [Standards-Based Assessment Science] END AS [Standards-Based Assessment Science]
	,SCHOOL_TYPE
	,TOTALS = ISNULL([End of Course Exam],0)+ ISNULL ([Istation],0) + ISNULL ([Math Interim Assessment],0) + ISNULL ([NMAPA],0)
	          + ISNULL ([PARCC],0) + ISNULL ([PARCC ELA],0) + ISNULL ([PARCC Math],0) + ISNULL ([Reading Interim Assessment],0) + ISNULL ([Standards-Based Assessment Science],0)

FROM
(


SELECT
	SCHOOL_LOCATION
	,ORGANIZATION_NAME
	,ORG.ORGANIZATION_GU
	,SCH_YR
	,VALUE_DESCRIPTION as Assessments
	,COUNT(VALUE_DESCRIPTION) as Exemptions 
	,CASE WHEN ORGANIZATION_NAME LIKE '%ELEMENTARY SCHOOL' THEN '1'
	      WHEN ORGANIZATION_NAME LIKE '%MIDDLE SCHOOL' THEN '2'
		  WHEN ORGANIZATION_NAME LIKE '%HIGH SCHOOL' THEN '3'
	ELSE '4'
	END AS SCHOOL_TYPE
	,'joint' AS JOIN_ER
FROM [rev].[UD_OPT_OUT] OO
JOIN
	[APS].[LookupTable]('Revelation.UD.OptOut','ASSESSMENT') B
	on OO.assessment=B.value_code
JOIN 
	REV.EPC_SCH AS SCH
	ON SCH.SCHOOL_CODE = OO.SCHOOL_LOCATION

JOIN	
	REV.REV_ORGANIZATION AS ORG
	ON ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU

WHERE 1 = 1
AND OO.SCH_YR = '2016'
AND ORG.ORGANIZATION_GU LIKE @School

GROUP BY VALUE_DESCRIPTION, SCHOOL_LOCATION, SCH_YR, ORGANIZATION_NAME,ORG.ORGANIZATION_GU
) TT
PIVOT
	(MAX([EXEMPTIONS])FOR ASSESSMENTS IN ([End of Course Exam],[Istation],[Math Interim Assessment],[NMAPA]
    ,[PARCC],[PARCC ELA],[PARCC Math],[Reading Interim Assessment],[Standards-Based Assessment Science])) AS UP1

UNION


select 
	  '001' AS SCHOOL_LOCATION
	  ,'DISTRICT' AS ORGANIZATION_NAME
	  ,NEWID() AS ORGANIZATION_GU
	  ,''AS DT
	   ,[End of Course Exam]
       ,Istation
	   ,[Math Interim Assessment]
	   ,NMAPA
	   ,PARCC
	   ,[PARCC ELA]
	   ,[PARCC Math]
	   ,[Reading Interim Assessment]
	   ,[Standards-Based Assessment Science]
	   ,'5' AS D3
	   ,TOTALS = ISNULL([End of Course Exam],0)+ ISNULL ([Istation],0) + ISNULL ([Math Interim Assessment],0) + ISNULL ([NMAPA],0)
				 + ISNULL ([PARCC],0) + ISNULL ([PARCC ELA],0) + ISNULL ([PARCC Math],0) + ISNULL ([Reading Interim Assessment],0) + ISNULL ([Standards-Based Assessment Science],0)

FROM
(
SELECT
	SCH_YR
	,VALUE_DESCRIPTION as Assessments
	,COUNT(VALUE_DESCRIPTION) as Exemptions 
FROM [rev].[UD_OPT_OUT] OO
JOIN
	[APS].[LookupTable]('Revelation.UD.OptOut','ASSESSMENT') B
	on OO.assessment=B.value_code
JOIN 
	REV.EPC_SCH AS SCH
	ON SCH.SCHOOL_CODE = OO.SCHOOL_LOCATION

JOIN	
	REV.REV_ORGANIZATION AS ORG
	ON ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU

WHERE 1 = 1
AND OO.SCH_YR = '2016'
AND ORG.ORGANIZATION_GU LIKE @School

GROUP BY VALUE_DESCRIPTION, SCH_YR
) tt
pivot 
	(max([exemptions]) for ASSESSMENTS IN ([End of Course Exam],[Istation],[Math Interim Assessment],[NMAPA]
    ,[PARCC],[PARCC ELA],[PARCC Math],[Reading Interim Assessment],[Standards-Based Assessment Science])) AS UP1

ORDER BY SCHOOL_TYPE, ORGANIZATION_NAME


