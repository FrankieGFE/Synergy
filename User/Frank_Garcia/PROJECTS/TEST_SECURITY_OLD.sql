USE [Lawson]
GO

/****** Object:  StoredProcedure [APS].[TEST_SECURITY]    Script Date: 11/2/2016 1:10:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [APS].[TEST_SECURITY] AS


TRUNCATE TABLE DBO.TEST_SECURITY

INSERT INTO DBO.TEST_SECURITY

SELECT
	[FULL-NAME]
	,[EMAIL-ADDRESS]
	,[POSITION DESCRIPTION]
	,EMPLOYEE
	,LOCATION
	,[STC QUIZ]
	,[TA QUIZ]
	,[STAFF QUIZ]
	,ORGANIZATION_GU
FROM
(
SELECT 
	 ROW_NUMBER () OVER (PARTITION BY T1.USERNAME ORDER BY emp.DATE_HIRED DESC) AS RN
	,T1.[LAST NAME]+', '+ T1.[FIRST NAME] AS [FULL-NAME]
	,EMP.EMAIL_ADDRESS AS [EMAIL-ADDRESS]
	,PAP.DESCRIPTION AS [POSITION DESCRIPTION]
	,RA.LOCATION AS LOCATION
	,EMP.EMPLOYEE AS EMPLOYEE
	,T1.USERNAME
	,T1.[STUDENT ID]
	,CASE WHEN [BASIC].[Test Administration Security Quiz] IS NULL THEN '' ELSE [BASIC].[Test Administration Security Quiz]
	END AS 'STAFF QUIZ'
	,CASE WHEN [STC].[STC Test Security Quiz] IS NULL THEN '' ELSE [STC].[STC Test Security Quiz]
	END AS 'STC QUIZ'
	,CASE WHEN TA.[Test Security Certification] IS NULL THEN '' ELSE TA.[Test Security Certification]
	END AS 'TA QUIZ'
	,SCH.ORGANIZATION_GU
FROM
(		
SELECT 
	[LAST NAME]
	,[FIRST NAME]
	,USERNAME
	,[STUDENT ID]
FROM		
OPENROWSET (
	'Microsoft.ACE.OLEDB.12.0', 
	'Text;Database=\\180-SMAXODS-01\E\SQLWorkingFiles\;', 
	'SELECT * FROM gc_044_Test_Secuirty_Basic.csv'  
)AS [BASIC]

UNION

SELECT
	[LAST NAME]
	,[FIRST NAME]
	,USERNAME
	,[STUDENT ID]
FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\180-SMAXODS-01\E\SQLWorkingFiles\;', 
			'SELECT * FROM gc_044_Test_Secuirty_School_Test_Admin.csv'  
		)AS [STC]

UNION

SELECT
	[LAST NAME]
	,[FIRST NAME]
	,USERNAME
	,[STUDENT ID]
FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\180-SMAXODS-01\E\SQLWorkingFiles\;', 
			'SELECT * FROM gc_044_Test_Security_Test_Admin.csv'  
		)AS TA
) T1

    LEFT JOIN
	EMPLOYEE AS EMP
	ON EMPLOYEE = T1.[STUDENT ID]
	LEFT JOIN
	Paposition AS PAP
	ON EMP.POSITION = PAP.POSITION
	LEFT JOIN
	Pcodes AS PC
	ON EMP.USER_LEVEL = PC.CODE
	AND R_TYPE = 'UL'
	LEFT JOIN
	APS.ActiveEmployeeMostRecentAssignment AS RA
	ON RA.EMPLOYEE = T1.[STUDENT ID]
	LEFT JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].ST_PRODUCTION.REV.EPC_SCH AS SCH
	ON SCH.SIS_SCHOOL_CODE = RA.LOCATION
		LEFT JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\180-SMAXODS-01\E\SQLWorkingFiles\;', 
			'SELECT * FROM gc_044_Test_Secuirty_Basic.csv'  
		)AS [BASIC]
		ON [BASIC].[STUDENT ID] = t1.[STUDENT ID]

		LEFT JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\180-SMAXODS-01\E\SQLWorkingFiles\;', 
			'SELECT * FROM gc_044_Test_Secuirty_School_Test_Admin.csv'  
		)AS [STC]
		ON [STC].[STUDENT ID] = t1.[STUDENT ID]

		LEFT JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\180-SMAXODS-01\E\SQLWorkingFiles\;', 
			'SELECT * FROM gc_044_Test_Security_Test_Admin.csv'  
		)AS TA
		ON TA.[STUDENT ID] = t1.[STUDENT ID]
) AS T2
WHERE RN = 1

GO


