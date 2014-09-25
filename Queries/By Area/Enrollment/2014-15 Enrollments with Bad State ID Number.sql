/*
*	Created By:  Don Jarrett
*	Date:  9/25/2014
*
*    Get all students with a 2014-15 enrollment and a bad state id number. A bad state id number is constituted by:
*    A)	Have an non-numeric somewhere in them
*    B)	Are blank
*    C)	Length other than 9
*
*/

SELECT
    [Student].[SIS_NUMBER]
    ,ISNULL([Student].[STATE_STUDENT_NUMBER],'') AS [STUDENT_STATE_NUMBER]
FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [SchoolYear]
    ON
    [Student].[STUDENT_GU]=[SchoolYear].[STUDENT_GU]

    INNER JOIN
    [rev].[REV_YEAR] AS [Year]
    ON
    [SchoolYear].[YEAR_GU]=[Year].[YEAR_GU]

WHERE
    (LEN([Student].[STATE_STUDENT_NUMBER])!=9 --length greater than 9
    OR ([Student].[STATE_STUDENT_NUMBER]='') --blank
    OR ([Student].[STATE_STUDENT_NUMBER] IS NULL) --blank
    OR ([Student].[STATE_STUDENT_NUMBER] LIKE '%[^0-9]%')) --non-numeric character
    AND [Year].[SCHOOL_YEAR]=2014