EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
		T1.*
		,PRIM.GRADE as Grade
		,BS.SIS_NUMBER as [Student Number]
		,PRIM.SCHOOL_CODE as [School Code]
		,PRIM.SCHOOL_NAME as [School Name]
		,BS.HOME_ADDRESS as [Home Address]
		,BS.HOME_CITY as [City]
		,BS.HOME_STATE as [State]
		,BS.HOME_ZIP as [Zip]
		,BS.Parents as Parents
		,PRIM.ENTER_DATE as [Enter Date]
       ,PRIM.LEAVE_DATE as [Leave Date]
             
       FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from ImpactAide2017.csv'
                ) AS [T1]

       LEFT JOIN 
       rev.REV_PERSON AS PERS
       ON
       T1.[Last Name] = PERS.LAST_NAME
       AND T1.[First Name] = PERS.FIRST_NAME
       AND T1.[Birthdate] = PERS.BIRTH_DATE

       LEFT JOIN 
       APS.BasicStudentWithMoreInfo AS BS
       ON
       PERS.PERSON_GU = BS.STUDENT_GU

       LEFT JOIN 
       APS.PrimaryEnrollmentDetailsAsOf('2016-09-12') AS PRIM
       ON
       BS.STUDENT_GU = PRIM.STUDENT_GU 

       
REVERT
GO


