/*
	Created by Debbie Ann Chavez
	Date 5/10/2016

	This updates street name and city to proper case.  CMP sends us a file with all UPPER CASE.
*/


BEGIN TRANSACTION 

UPDATE rev.EPC_STREET
SET STREET_NAME = APS.FormatTitleCase(STREET_NAME), CITY = APS.FormatTitleCase(CITY)

FROM 
(SELECT STREET_GU FROM 
rev.EPC_STREET
WHERE
 STREET_NAME COLLATE LATIN1_General_CS_AI = UPPER(STREET_NAME)
AND SCHOOL_YEAR = '2016'
) AS T1

WHERE
T1.STREET_GU = rev.EPC_STREET.STREET_GU

ROLLBACK