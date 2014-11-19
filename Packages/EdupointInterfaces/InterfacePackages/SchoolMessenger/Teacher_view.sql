--<APS - School Messenger >
-- *Teacher data view*
ALTER VIEW [SchoolMessenger].[Teacher] AS
SELECT

   CASE WHEN LEFT([BADGE_NUM],2) LIKE 'e[0-9]' THEN CONVERT(VARCHAR(10),SUBSTRING([BADGE_NUM],2,LEN([BADGE_NUM])-1)) ELSE [BADGE_NUM] END AS [Staff Number]
 , stfp.FIRST_NAME   AS [First Name]
 , stfp.LAST_NAME    AS [Last Name]
 , stf.BADGE_NUM     AS [Badge Number]
 , stfp.EMAIL        AS [Staff Email]
 , sch.SCHOOL_CODE   AS [Staff Assignment Location]

FROM rev.EPC_STAFF              stf
JOIN rev.EPC_STAFF_SCH_YR       stfssy ON stfssy.STAFF_GU = stf.STAFF_GU
JOIN rev.REV_ORGANIZATION_YEAR  oyr    ON oyr.ORGANIZATION_YEAR_GU   = stfssy.ORGANIZATION_YEAR_GU
                                          AND oyr.YEAR_GU            = (SELECT YEAR_GU FROM REV.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_SCH                sch    ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON             stfp   ON stfp.PERSON_GU             = stf.STAFF_GU

WHERE
    LEFT([BADGE_NUM],2) LIKE 'e[0-9]'