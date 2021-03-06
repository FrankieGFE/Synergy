


--ALTER VIEW [APS].[ST_MATH_ADMIN] AS 
--GO
EXECUTE AS LOGIN='QueryFileUser'
GO



SELECT
	[FILE].iid
	,district_school_id
	,STAFF.school
	,district_teacher_id
	,email
	,last_name
	,first_name
	,position
	,access_level
FROM
(
SELECT
    distinct
	'' AS iid
	,SCH.SCHOOL_CODE AS district_school_id
	,CASE WHEN ORG.ORGANIZATION_NAME = 'Reginald Chavez Elementary School' THEN 'REGINALD CHAVEZ ELEM SCHOOL' 
	      WHEN ORG.ORGANIZATION_NAME = 'A. Montoya Elementary School' THEN 'A MONTOYA ELEMENTARY SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Arroyo Del Oso Elementary School' THEN 'ARROYO DEL OSO ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Dolores Gonzales Elementary School' THEN 'DOLORES GONZALES ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'East San Jose Elementary School' THEN 'EAST SAN JOSE ELEMENTARY SCH'
		  WHEN ORG.ORGANIZATION_NAME = 'Edmund G. Ross Elementary School' THEN 'EDMUND G ROSS ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Edward Gonzales Elementary School' THEN 'EDWARD GONZALES ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'George I. Sanchez Collaborative Community School' THEN 'GEORGE I SANCHEZ CMTY SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Governor Bent Elementary School' THEN 'GOVERNOR BENT ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Helen Cordero Elementary School' THEN 'HELEN CORDERO PRIMARY SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Janet Kahn Fine Arts Academy a.k.a Eubank Elementary School' THEN 'EUBANK ELEMENTARY SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Marie M. Hughes Elementary School' THEN 'MARIE M HUGHES ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Mary Ann Binford Elementary School' THEN 'MARY ANN BINFORD ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Matheson Park Elementary School' THEN 'MATHESON PARK ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Mission Avenue Elementary School' THEN 'MISSION AVE ELEMENTARY SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Mountain View Elementary School' THEN 'MOUNTAIN VIEW ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Rudolfo Anaya Elementary School' THEN 'RUDOLFO ANAYA ELEMENTARY SCH'
		  WHEN ORG.ORGANIZATION_NAME = 'School On Wheels High School' THEN 'SCHOOL ON WHEELS'
		  WHEN ORG.ORGANIZATION_NAME = 'Sombra Del Monte Elementary School' THEN 'SOMBRA DEL MONTE ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = 'Susie Rayos Marmon Elementary School' THEN 'SUSIE RAYOS MARMON ELEM SCHOOL'
		  WHEN ORG.ORGANIZATION_NAME = '' THEN ''
		  WHEN ORG.ORGANIZATION_NAME = '' THEN ''
	ELSE ORG.ORGANIZATION_NAME
	END AS school
	,STF.BADGE_NUM AS district_teacher_id
	,PER.EMAIL AS 'email'
	,PER.LAST_NAME AS 'last_name'
	,PER.FIRST_NAME AS 'first_name'
	,CASE WHEN STF.TYPE = 'TE' THEN 'teacher'
	      ELSE 'program_coordinator'
	END AS position
	,CASE WHEN STF.TYPE = 'TE' THEN 'class_level'
	      ELSE 'school_level'
	END AS access_level
	
FROM
	REV.EPC_STAFF AS STF
	JOIN
	REV.EPC_STAFF_SCH_YR SYR
	ON SYR.STAFF_GU = STF.STAFF_GU
	JOIN
	REV.REV_ORGANIZATION_YEAR OYR 
	ON OYR.ORGANIZATION_YEAR_GU = SYR.ORGANIZATION_YEAR_GU
	JOIN
	REV.REV_YEAR AS YR
	ON YR.YEAR_GU = OYR.YEAR_GU
	JOIN
	REV.REV_ORGANIZATION AS ORG 
	ON ORG.ORGANIZATION_GU = OYR.ORGANIZATION_GU
	JOIN
	REV.EPC_SCH AS SCH
	ON SCH.ORGANIZATION_GU = OYR.ORGANIZATION_GU
	JOIN
	REV.REV_PERSON AS PER
	ON PER.PERSON_GU = STF.STAFF_GU

WHERE 1 = 1
AND STF.TYPE IN ('SSS','SA','SCA')
--AND LAST_NAME = 'ST JOHN'
AND YR.SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
AND (PER.FIRST_NAME NOT IN ('TEACHER','PLACEMENT','Spedpre','SECTION') AND PER.FIRST_NAME NOT LIKE 'Staff%')
AND YR.EXTENSION = 'R'
--AND SCH.SCHOOL_CODE = '329'
) AS STAFF


		INNER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM admins_8_early_start_schools.csv'  
		)AS [FILE]
		ON [FILE].SCHOOL = STAFF.school

WHERE [FILE].IID IS NOT NULL
--and [Last Name] like '%,%'
--ORDER BY [E-Mail]
--REVERT
--GO
--AND district_teacher_id = 'e119804'


