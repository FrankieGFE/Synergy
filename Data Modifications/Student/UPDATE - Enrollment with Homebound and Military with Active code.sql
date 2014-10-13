/**
 * 
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 *
 * Update Enrollment records where the Home/Charter School is set to Home and set
 * HOMEBOUND to 'Y'.
 *
 * Update Student records where the ACTIVE_MILITARY='Y' and set FAMILY_MILITARY_CODE TO 'AC' (Active)
 *
 *
 */

BEGIN TRAN
--uncomment this parts to run the update
UPDATE 
    [Enroll]
    SET [Enroll].[HOMEBOUND]='Y'

FROM
    [rev].[EPC_STU_ENROLL] AS [Enroll]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [StudentSchoolYear]

    ON
    [Enroll].[STUDENT_SCHOOL_YEAR_GU]=[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]

    INNER JOIN
    [rev].[REV_YEAR] AS [Year]

    ON
    [StudentSchoolYear].[YEAR_GU]=[Year].[YEAR_GU]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]

    ON
    [StudentSchoolYear].[STUDENT_GU]=[Student].[STUDENT_GU]

WHERE
    LOWER([Enroll].[ENR_USER_DD_4])='home'
    AND [Year].[SCHOOL_YEAR]=2014
    AND [Year].[EXTENSION]='R'

UPDATE 
    [StudentSchoolYear]
    SET [StudentSchoolYear].[HOMEBOUND]='Y'

FROM
    [rev].[EPC_STU_ENROLL] AS [Enroll]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [StudentSchoolYear]

    ON
    [Enroll].[STUDENT_SCHOOL_YEAR_GU]=[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]

    INNER JOIN
    [rev].[REV_YEAR] AS [Year]

    ON
    [StudentSchoolYear].[YEAR_GU]=[Year].[YEAR_GU]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]

    ON
    [StudentSchoolYear].[STUDENT_GU]=[Student].[STUDENT_GU]

WHERE
    LOWER([Enroll].[ENR_USER_DD_4])='home'
    AND [Year].[SCHOOL_YEAR]=2014
    AND [Year].[EXTENSION]='R'

SELECT
    [Student].[STUDENT_GU]
    ,[Student].[SIS_NUMBER]
    ,[Student].[STATE_STUDENT_NUMBER]
FROM
    [rev].[EPC_STU_ENROLL] AS [Enroll]

    INNER JOIN
    [rev].[EPC_STU_SCH_YR] AS [StudentSchoolYear]

    ON
    [Enroll].[STUDENT_SCHOOL_YEAR_GU]=[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]

    INNER JOIN
    [rev].[REV_YEAR] AS [Year]

    ON
    [StudentSchoolYear].[YEAR_GU]=[Year].[YEAR_GU]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]

    ON
    [StudentSchoolYear].[STUDENT_GU]=[Student].[STUDENT_GU]

WHERE
    LOWER([Enroll].[ENR_USER_DD_4])='home'
    AND [Year].[SCHOOL_YEAR]=2014
    AND [Year].[EXTENSION]='R'

COMMIT

BEGIN TRAN
--uncomment this part to run the update
UPDATE [Student]
    SET [Student].[MILITARY_FAMILY_CODE]='AC'

FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [rev].[EPC_STU_PARENT] AS [StuParent]

    ON
    [Student].[STUDENT_GU]=[StuParent].[STUDENT_GU]

    INNER JOIN
    [rev].[UD_PARENT] AS [Parent]

    ON
    [StuParent].[PARENT_GU]=[Parent].[PARENT_GU]

WHERE
    [Parent].[ACTIVE_MILITARY]='Y'


SELECT
    [Student].[STUDENT_GU]
    ,[Student].[SIS_NUMBER]
    ,[Student].[STATE_STUDENT_NUMBER]
FROM
    rev.EPC_STU_PARENT AS [StuParent]

    INNER JOIN
    [rev].[EPC_STU] AS [Student]

    ON
    [StuParent].[STUDENT_GU]=[Student].[STUDENT_GU]

    INNER JOIN
    [rev].[UD_PARENT] AS [Parent]
    
    ON
    [StuParent].[PARENT_GU]=[Parent].[PARENT_GU]

WHERE
    [Parent].[ACTIVE_MILITARY]='Y'

COMMIT