

SELECT 
	T1.*,
	EMP.LOCATION
	,ORG.ORGANIZATION_NAME
	,PEMP.HM_PHONE_NBR
FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\180-SMAXODS-01\SQLWorkingFiles;',
                  'SELECT * from 20112012HHS.csv'
                ) AS [T1]
	
	LEFT JOIN 
	APS.ActiveEmployeeMostRecentAssignment AS EMP
	ON
	T1.[Badge ID] = EMP.EMPLOYEE

	LEFT JOIN 
	dbo.Paemployee AS PEMP
	ON
	T1.[Badge ID] = PEMP.EMPLOYEE

	LEFT JOIN 
	[SYNERGYDBDC.APS.EDU.ACTD].ST_Production.rev.EPC_SCH AS SCH
	ON
	EMP.LOCATION = SCH.SCHOOL_CODE 

	LEFT JOIN 
	[SYNERGYDBDC.APS.EDU.ACTD].ST_Production.rev.REV_ORGANIZATION AS ORG
	ON
	SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU

