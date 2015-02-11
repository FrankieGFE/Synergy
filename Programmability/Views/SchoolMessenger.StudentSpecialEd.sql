IF OBJECT_ID('SchoolMessenger.StudentSpecialEd') IS NOT NULL DROP VIEW SchoolMessenger.StudentSpecialEd
GO
CREATE VIEW SchoolMessenger.StudentSpecialEd AS

SELECT
    [Student].[SIS_NUMBER] AS [STUDENT ID]
    ,CurrentSPED.PRIMARY_DISABILITY_CODE AS [SERVICE INDICATOR]
    --,[Codes].[VALUE_DESCRIPTION] AS [DESCRIPTION]
FROM   
            APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enrollment

            INNER JOIN
            (
            SELECT
                        STUDENT_GU
                        ,PRIMARY_DISABILITY_CODE
            FROM
                        REV.EP_STUDENT_SPECIAL_ED AS SPED
            WHERE
                        NEXT_IEP_DATE IS NOT NULL
                        AND (
                                    EXIT_DATE IS NULL 
                                    OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                                    )
            ) AS CurrentSPED
            ON
            Enrollment.STUDENT_GU = CurrentSPED.STUDENT_GU

		  INNER JOIN
		  [rev].[EPC_STU] AS [Student]
		  ON
		  [Enrollment].[STUDENT_GU]=[Student].[STUDENT_GU]

		  INNER JOIN
		  [APS].[LookupTable]('K12.SpecialEd','DISABILITY_CODE') AS [Codes]
		  ON
		  CurrentSPED.PRIMARY_DISABILITY_CODE=[Codes].[VALUE_CODE]

WHERE 
            CurrentSPED.STUDENT_GU IS NOT NULL

GO