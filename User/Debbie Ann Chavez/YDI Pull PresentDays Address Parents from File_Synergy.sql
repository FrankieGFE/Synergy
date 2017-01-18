

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	T1.*
	,Parents
	,GETPARENTS.[ADDRESS]
	,GETPARENTS.CITY
	,GETPARENTS.[STATE]
	,GETPARENTS.ZIP
	,TOTAL_MEMBER_DAYS
	,Total_Absences
	,TOTAL_MEMBER_DAYS - Total_Absences AS Total_Days_Present
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from 1516.txt'
                ) AS [T1]


LEFT JOIN 
(SELECT SIS_NUMBER, STATE_STUDENT_NUMBER, Parents
, ISNULL(MAIL_ADDRESS,HOME_ADDRESS) AS [ADDRESS]
, ISNULL(MAIL_CITY,HOME_CITY) AS [CITY]
, ISNULL(MAIL_STATE,HOME_STATE) AS [STATE]
, ISNULL(MAIL_ZIP,HOME_ZIP) AS ZIP
 
FROM 
APS.BasicStudentWithMoreInfo
) AS GETPARENTS
ON
GETPARENTS.SIS_NUMBER = T1.[APS ID]

LEFT JOIN 
(

SELECT 
	SUM(CAST(MEMBER_DAYS AS INT)) AS TOTAL_MEMBER_DAYS
	,STUID 
 FROM 
STUDENT_SCHOOL_MEMBERDAYS_2015
GROUP BY STUID
) AS MEMBERDAYS
ON
MEMBERDAYS.STUID = T1.[APS ID]

LEFT JOIN 
(
SELECT 
SIS_NUMBER, 
	SUM(Total_Exc_Unex) AS Total_Absences
FROM(
SELECT 
	[SIS Number] AS SIS_NUMBER, Total_Exc_Unex

	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from DaysPresent2015.csv'
                ) AS [T1]

) AS PRESENT
GROUP BY SIS_NUMBER
) AS PRESENTS
ON
PRESENTS.SIS_NUMBER = T1.[APS ID]

	

REVERT
GO