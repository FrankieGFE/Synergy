USE [ST_Production]
GO

/****** Object:  View [APS].[CleverSchools]    Script Date: 8/21/2017 1:49:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*
	Created by Debbie Ann Chavez (ORIGINAL CODE FROM MLM/EDUPOINT)
	Date 7/18/2016
*/


CREATE VIEW [APS].[CleverSchools] AS

SELECT
         sch.SCHOOL_CODE                      AS [School_id]
       , org.ORGANIZATION_NAME                AS [School_name]
       , sch.STATE_SCHOOL_CODE                AS [State_id]
       , oadr.STREET_NAME                     AS [School_address]
       , oadr.CITY                            AS [School_city]
       , oadr.STATE                           AS [School_state]
       , oadr.ZIP_5                           AS [School_zip]
       , org.PHONE                            AS [School_phone]
      , CASE
	       WHEN lgrd.VALUE_DESCRIPTION in ('P3', 'P4', '5C', '8C') THEN 'Prekindergarten'
	       WHEN lgrd.VALUE_DESCRIPTION = 'K'                       THEN 'Kindergarten'
	       WHEN lgrd.VALUE_DESCRIPTION in ('PG', 'Grad', '12+')    THEN 'Postgraduate'
		   WHEN lgrd.VALUE_DESCRIPTION = '01'                      THEN '1'
		   WHEN lgrd.VALUE_DESCRIPTION = '02'                      THEN '2'
		   WHEN lgrd.VALUE_DESCRIPTION = '03'                      THEN '3'
		   WHEN lgrd.VALUE_DESCRIPTION = '04'                      THEN '4'
		   WHEN lgrd.VALUE_DESCRIPTION = '05'                      THEN '5'
		   WHEN lgrd.VALUE_DESCRIPTION = '06'                      THEN '6'
		   WHEN lgrd.VALUE_DESCRIPTION = '07'                      THEN '7'
		   WHEN lgrd.VALUE_DESCRIPTION = '08'                      THEN '8'
		   WHEN lgrd.VALUE_DESCRIPTION = '09'                      THEN '9'
		   ELSE lgrd.VALUE_DESCRIPTION
		  END                         	      AS [Low_Grade]
      , CASE
	       WHEN hgrd.VALUE_DESCRIPTION in ('P3', 'P4', '5C', '8C') THEN 'Prekindergarten'
	       WHEN hgrd.VALUE_DESCRIPTION = 'K'                       THEN 'Kindergarten'
	       WHEN hgrd.VALUE_DESCRIPTION in ('PG', 'Grad', '12+')    THEN 'Postgraduate'
		   WHEN hgrd.VALUE_DESCRIPTION = '01'                      THEN '1'
		   WHEN hgrd.VALUE_DESCRIPTION = '02'                      THEN '2'
		   WHEN hgrd.VALUE_DESCRIPTION = '03'                      THEN '3'
		   WHEN hgrd.VALUE_DESCRIPTION = '04'                      THEN '4'
		   WHEN hgrd.VALUE_DESCRIPTION = '05'                      THEN '5'
		   WHEN hgrd.VALUE_DESCRIPTION = '06'                      THEN '6'
		   WHEN hgrd.VALUE_DESCRIPTION = '07'                      THEN '7'
		   WHEN hgrd.VALUE_DESCRIPTION = '08'                      THEN '8'
		   WHEN hgrd.VALUE_DESCRIPTION = '09'                      THEN '9'
		   ELSE hgrd.VALUE_DESCRIPTION
		  END                       	      AS [High_Grade]
       , prns.FIRST_NAME+ ' ' +prns.LAST_NAME AS [Principal]
       , prns.EMAIL                           AS [Principal Email]
FROM   rev.REV_ORGANIZATION           org
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
                                              AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.REV_ADDRESS      oadr ON oadr.ADDRESS_GU = org.ADDRESS_GU
	   LEFT JOIN rev.REV_PERSON       prns ON prns.PERSON_GU = sch.PRINCIPAL_STAFF_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') lgrd on lgrd.VALUE_CODE 
	                                                                       = (select min(grade) from rev.EPC_SCH_GRADE sg
																		      where sg.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU)
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') hgrd on hgrd.VALUE_CODE 
	                                                                       = (select max(grade) from rev.EPC_SCH_GRADE sg
																		      where sg.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
																			  and cast(sg.grade as int) <= 230)



-- THIS IS NEEDED FOR TECHNOLOGY EMPLOYEES IN CLEVERADMIN FILE
UNION 

SELECT 

'068' AS SCH
,'Technology' AS SCHOOL
,'068' AS STATE
,'Uptown' AS STREET
,'Albuquerque' AS CITY
,'NM' AS STATE
,'87110' AS ZIP
,'5058308082' AS PHONE
,'' AS LOWGRADE
,'' AS HIGHGRADE
,'Aaron Jaramillo' AS PRINCIPAL
,'jaramillo_ab@aps.edu' AS EMAIL

UNION 

SELECT

'053' AS SCH
,'Technology Hardware' AS SCHOOL
,'053' AS STATE
,'Uptown' AS STREET
,'Albuquerque' AS CITY
,'NM' AS STATE
,'87110' AS ZIP
,'5058308082' AS PHONE
,'' AS LOWGRADE
,'' AS HIGHGRADE
,'Aaron Jaramillo' AS PRINCIPAL
,'jaramillo_ab@aps.edu' AS EMAIL





GO


