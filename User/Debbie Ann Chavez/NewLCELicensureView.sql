

/******************************************************************************************

Created by Debbie Ann Chavez
Date 9/20/2017

These are the new LCE Licensure Endorsement requirements for 2017-2018 and beyond.  


*******************************************************************************************/



 CREATE VIEW [APS].[CleverStudents] AS 



SELECT *, '' AS ELEM, '' AS MID, '' AS HIGH

FROM 
(
SELECT
	STAFF_GU, CERT_AREA
FROM 
	REV.UD_LICENSURE_DATA AS CRED
WHERE
	CERT_AREA IN ('01', '03', '04', '05', '10', '20', '27', '32', '45', '47', '51', '60', '67') 

) AS T1

PIVOT
(
MAX (CERT_AREA) 
FOR CERT_AREA IN ([01], [03], [04] ,[05], [10], [20], [27], [32], [45], [47], [51], [60], [67]) 
) AS PIVOTME

ORDER BY STAFF_GU