/**
 * 
 * $Revision: 228 $
 * $LastChangedBy: e204042 $
 * $LastChangedDate: 2014-10-13 10:21:14 -0600 (Mon, 13 Oct 2014) $
 *
 *
 * Update Health tables with new Disposition codes.
 *
 *
 */

BEGIN TRAN

SELECT
    [Student].[SIS_NUMBER]
    ,[Person].[LAST_NAME]
    ,[Person].[FIRST_NAME]
    ,[Organization].[ORGANIZATION_NAME]
    ,[h].[DISPOSITION] AS [Old Value]
    ,[hi].[OUTCOMES] AS [New Value]
FROM
    [rev].[UD_HEALTHINCIDENT] AS [hi]

    INNER JOIN
    [rev].[EPC_STU_HEALTH] AS [h]

    ON
    [hi].[HEALTH_GU]=[h].[HEALTH_GU]
    AND ISNULL([h].[DISPOSITION],'')!=[hi].[OUTCOMES]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]
    ON
    [h].[STUDENT_GU]=[Student].[STUDENT_GU]

    INNER JOIN
    [rev].[REV_PERSON] AS [Person]
    ON
    [Student].[STUDENT_GU]=[Person].[PERSON_GU]

    INNER JOIN
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
    ON
    [Enroll].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [Organization]
    ON
    [OrgYear].[ORGANIZATION_GU]=[Organization].[ORGANIZATION_GU]

UPDATE
    [h]
   
SET
    [h].[DISPOSITION]=LEFT([hi].[OUTCOMES],5)

FROM
    [rev].[EPC_STU_HEALTH] AS [h]

    INNER JOIN
    [rev].[UD_HEALTHINCIDENT] AS [hi]

    ON
    [h].[HEALTH_GU]=[hi].[HEALTH_GU]
    AND ISNULL([h].[DISPOSITION],'')!=[hi].[OUTCOMES]

SELECT
    [hi].*
    ,[h].[DISPOSITION]
FROM
    [rev].[UD_HEALTHINCIDENT] AS [hi]

    INNER JOIN
    [rev].[EPC_STU_HEALTH] AS [h]

    ON
    [hi].[HEALTH_GU]=[h].[HEALTH_GU]

ROLLBACK