--<APS - SchoolNet school  data>
DECLARE  @vDistrict_Number VARCHAR(max)
SET @vDistrict_Number = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')
; with TermCount AS
(
select t.OrgGU
	   , count(t.OrgGU) over (partition by t.orgGU)  as cnt
	   , row_number() over (partition by t.orgGU order by t.OrgGu) rn
from   rev.SIF_22_TermInfo() t
       join rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_GU = t.OrgGU
	                                         and oyr.YEAR_GU = (select year_gu from rev.SIF_22_Common_CurrentYearGU)
)
SELECT 
        sch.SCHOOL_CODE        AS [school_code]
      , org.ORGANIZATION_NAME  AS [school_name]
      , CASE
	        WHEN sopt.SCHOOL_TYPE = '1' THEN 'ES'
			WHEN sopt.SCHOOL_TYPE = '2' THEN 'MS'
			WHEN sopt.SCHOOL_TYPE = '3' THEN 'HS'
			ELSE 'OT'
	    END                    AS [school_type_code]
      , @vDistrict_Number      AS [district_code]
      , porg.ORGANIZATION_NAME AS [region_code]
      , ( select
	             grd.value_description
		  from   rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd
	      where  grd.VALUE_CODE = ( 
	                               select 
	                                      min(sgrd.GRADE)
		                           from   rev.EPC_SCH_GRADE    sgrd    
	                               where  sgrd.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
								  )
	     )                     AS [grade_start]
      , ( select
	             grd.value_description
		  from   rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd
	      where  grd.VALUE_CODE = ( 
	                               select 
	                                      max(sgrd.GRADE)
		                           from   rev.EPC_SCH_GRADE    sgrd    
	                               where  sgrd.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
								  )
	     )                     AS [grade_end]
      , tc.cnt                 AS [number_of_terms]
      , org.WEBSITE_URL        AS [school_URL]
      , adr.ADDRESS            AS [address_1]
      , adr.ADDRESS2           AS [address_2]
      , adr.CITY               AS [CITY]
      , adr.STATE              AS [STATE]
      , adr.ZIP_5              AS [zip]
      , org.PHONE              AS [phone]
      , org.DEFAULT_EMAIL      AS [email]
      , ''                     AS [Path]
FROM  rev.REV_ORGANIZATION           org
      JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
	                                         AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
      JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
	  JOIN rev.EPC_SCH_YR_OPT        sopt ON sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
	  LEFT JOIN rev.REV_ORGANIZATION porg ON porg.ORGANIZATION_GU = org.PARENT_GU
	  LEFT JOIN rev.REV_ADDRESS      adr  ON adr.ADDRESS_GU = org.ADDRESS_GU
	  LEFT JOIN TermCount            tc   ON tc.OrgGU       = org.ORGANIZATION_GU and tc.rn = 1
	  
