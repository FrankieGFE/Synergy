-- <APS - Transfer System – Locations Extract>
declare @SchYr VARCHAR(4)
set @SchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
SELECT
   sch.SCHOOL_CODE                         AS [Location Number]
 , sch.STATE_SCHOOL_CODE                   AS [State Location Number]
 , sch.LIVE_IN_GENESIS                     AS [Location is Active]
 , org.ORGANIZATION_NAME                   AS [Location Name]
 , porg.ORGANIZATION_NAME                  AS [Location Level]
 , pper.LAST_NAME + ', ' + pper.FIRST_NAME AS [Principal Name]
 , pper.EMAIL                              AS [Principal Email]
 , adr.ADDRESS                             AS [Address]
 , org.PHONE                               AS [Phone]
 , ''                                      AS [Bilingual]
 , @SchYr                                  AS [Most Recent School Year]
       
FROM   rev.REV_ORGANIZATION          org
      JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
	                                         AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
      JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
	  JOIN rev.EPC_SCH_YR_OPT        sopt ON sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
	  LEFT JOIN rev.REV_ORGANIZATION porg ON porg.ORGANIZATION_GU = org.PARENT_GU
	  LEFT JOIN rev.REV_ADDRESS      adr  ON adr.ADDRESS_GU = org.ADDRESS_GU
	  LEFT JOIN rev.REV_PERSON       pper ON pper.PERSON_GU = sch.PRINCIPAL_STAFF_GU

