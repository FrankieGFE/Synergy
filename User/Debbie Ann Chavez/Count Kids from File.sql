

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT 
	FILES.School
	,REPLACE(REPLACE(FILES.[Staff Name], CHAR(13), ''), CHAR(10), ' ') 
	,FILES.[APS Course#]
	,FILES.[State Course #]
	,FILES.[Section]
	,FILES.[Title]
	,FILES.[Primary]
	--,SIS_NUMBER
	--,COURSE_LEAVE_DATE
	
	, COUNT(SCH.STUDENT_GU)

 FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from APS_DCM_II.csv'
                ) AS FILES

LEFT JOIN 
APS.BasicSchedule2 AS SCH

ON
SCH.ORGANIZATION_NAME = FILES.School
AND
SCH.COURSE_ID = FILES.[APS Course#]
AND
SCH.SECTION_ID = FILES.Section
AND 
COURSE_LEAVE_DATE IS NULL

LEFT JOIN
rev.EPC_STU AS STU
ON
STU.STUDENT_GU = SCH.STUDENT_GU

GROUP BY 
		FILES.School
	,FILES.[Staff Name]
	,FILES.[APS Course#]
	,FILES.[State Course #]
	,FILES.[Section]
	,FILES.[Title]
	,FILES.[Primary]


ORDER BY 
	FILES.School
	,FILES.[Staff Name]
	,FILES.[APS Course#]
	,FILES.[State Course #]
	,FILES.[Section]
	,FILES.[Title]
	,FILES.[Primary]



      REVERT
GO