

--change name of view
CREATE VIEW [APS].[License] AS

SELECT
	'e' + right('0000000'+ rtrim(Employee.EMPLOYEE), 6) AS EmployeeNumber
	,Licensure.Certificate_Number
	,Licensure.Certification_Type_Code
	,Licensure.Certification_Type
	,Licensure.Certification_Area_Code
	,Licensure.Certification_Area
	,Licensure.Certification_Effective_Date
	,Licensure.Certification_Expiration_Date
	,Licensure.Certification_Status
	,PED_Date
FROM
	dbo.Licensure

	INNER JOIN

	[180-SMAXODS-01.APS.EDU.ACTD].Lawson.dbo.Employee
	ON
	Licensure.Staff_ID = REPLACE(Employee.FICA_NBR, '-','')