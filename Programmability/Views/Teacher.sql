/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-04-28 
 *
 * This is the SchoolMessenger pull for Teacher.
 */

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SchoolMessenger].[Teacher]'))
	EXEC ('CREATE VIEW SchoolMessenger.Teacher AS SELECT 0 AS DUMMY')
GO

ALTER VIEW SchoolMessenger.Teacher AS
SELECT

   CAST(replace(stf.BADGE_NUM,'e','') as INT) AS [Staff Number]
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

GO