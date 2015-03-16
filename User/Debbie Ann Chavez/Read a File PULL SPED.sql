
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	META.*
	,CASE WHEN PRIMARY_DISABILITY_CODE IS NOT NULL THEN 'Y' ELSE 'N' END AS SPED
 FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from TESTFILE.csv'
                ) AS META

LEFT JOIN 
	(
SELECT
            CurrentSPED.SIS_NUMBER
            ,CurrentSPED.PRIMARY_DISABILITY_CODE
FROM   
            APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enrollment
            LEFT JOIN
            (
            SELECT
                        STU.SIS_NUMBER
						,SPED.STUDENT_GU
                        ,PRIMARY_DISABILITY_CODE
            FROM
                        REV.EP_STUDENT_SPECIAL_ED AS SPED
						INNER JOIN
						rev.EPC_STU AS STU
						ON
						SPED.STUDENT_GU = STU.STUDENT_GU

            WHERE
                        NEXT_IEP_DATE IS NOT NULL
                        AND (
                                    EXIT_DATE IS NULL 
                                    OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                                    )
            ) AS CurrentSPED
            ON
            Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU
WHERE 
            CurrentSPED.STUDENT_GU IS NOT NULL
	)
	AS T1
	ON
	T1.SIS_NUMBER = META.[Student ID]

	ORDER BY [Student ID]

      REVERT
GO

