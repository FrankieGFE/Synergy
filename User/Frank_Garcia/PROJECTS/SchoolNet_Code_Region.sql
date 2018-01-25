USE ST_Production
GO

SELECT 
	DISTINCT porg.ORGANIZATION_NAME AS region_code
	,CASE
		WHEN porg.ORGANIZATION_NAME = '1. Elementary' THEN '5 Elementary Schools'
		WHEN porg.ORGANIZATION_NAME = '2.1 Middle School' THEN '3 Middle Schools'
		WHEN porg.ORGANIZATION_NAME = '2.1.1 Middle School Alternative' THEN '4 Alternative Middle Schools'
		WHEN porg.ORGANIZATION_NAME = '2.2 High Schools' THEN '1 High School'
		WHEN porg.ORGANIZATION_NAME = '2.2.1 High School Alternative' THEN '2 Alternative High Schools'
		WHEN porg.ORGANIZATION_NAME = '3. Special Ed' THEN '7 Special Ed Schools'
		WHEN porg.ORGANIZATION_NAME = '4. Alternative' THEN '6 Alternative Schools'
		WHEN porg.ORGANIZATION_NAME = '5. Unused' THEN '5 Elementary Schools'
		WHEN porg.ORGANIZATION_NAME = '1. Elementary' THEN '9 Unused'
	END AS region_name
	,'6400 Uptown Blvd NE' AS address_1
	,'APS' AS address_2
	,'Albuquerque' AS city
	,'NM' AS state
	,'87114' AS zip
	,'505-880-3700' AS phone
	,'email@aps.edu' AS email
	,'http://www.aps.edu' AS url


FROM  rev.REV_ORGANIZATION           org
      JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
	                                         AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
	  LEFT JOIN rev.REV_ORGANIZATION porg ON porg.ORGANIZATION_GU = org.PARENT_GU
	  
