
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	STU.SIS_NUMBER, ENR.SCHOOL_NAME AS JUMP_SCHOOL
	,CASE WHEN LEFT(ENR.SCHOOL_NAME,5) != LEFT(T1.[Homeschool Site],5) THEN 'NOT AT JUMP SCHOOL'
		  WHEN STU.SIS_NUMBER IS NULL THEN 'NO SIS NUMBER'
		  WHEN ENR.SCHOOL_NAME IS NULL THEN 'NO JUMPSTART ENROLLMENT FOUND'

		  ELSE '' END AS CHANGES
	, T1.* 
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from JumpStart.csv'
                ) AS [T1]

	LEFT JOIN
	REV.EPC_STU AS STU
	ON
	T1.[Student's ID] = STU.SIS_NUMBER

	LEFT JOIN 
	APS.StudentEnrollmentDetails AS ENR
	ON
	ENR.STUDENT_GU = STU.STUDENT_GU
	AND ENR.SCHOOL_YEAR = '2017'
	AND ENR.EXTENSION = 'N'
	--AND LEFT(ENR.SCHOOL_NAME,5) != LEFT(T1.[Homeschool Site],5) 

	ORDER BY T1.[Homeschool Site]

	

	REVERT
GO