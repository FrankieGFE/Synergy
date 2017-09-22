USE [ST_Production]
GO

/****** Object:  View [APS].[LCETeacherEndorsements]    Script Date: 9/20/2017 3:36:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/******************************************************************************************

Created by Debbie Ann Chavez
Date 9/20/2017

These are the new LCE Licensure Endorsement requirements for 2017-2018 and beyond.  


*******************************************************************************************/



 ALTER VIEW [APS].[LCETeacherEndorsements] AS 
 

SELECT 
	LICENSES.*, ENDORSEMENTS.[01],[03], [04] ,[05], [10], [20], [27], [32], [45], [47], [51], [60], [67]
 FROM 

(
SELECT 
	STAFF_GU
	,CASE WHEN [0200] = '0200' OR [0208] = '0208' OR [0250] = '0250' OR [0400] = '0400' OR [0408] = '0408' OR [0500] = '0500' OR [0505] = '0505' OR [0520] = '0520' THEN 'Y' ELSE '' END AS ELEM
	,CASE WHEN [0200] = '0200' OR [0208] = '0208' OR [0300] = '0300' OR [0308] = '0308' OR [0350] = '0350' OR [0400] = '0400' OR [0408] = '0408' OR [0500] = '0500' OR [0505] = '0505' OR [0800] = '0800' OR [0520] = '0520' THEN 'Y' ELSE '' END AS MID
	,CASE WHEN [0300] = '0300' OR [0308] = '0308' OR [0350] = '0350' OR [0400] = '0400' OR [0408] = '0408' OR [0500] = '0500' OR [0505] = '0505' OR [0800] = '0800' OR [0520] = '0520' THEN 'Y' ELSE '' END AS HIGH
 FROM 
	(
SELECT
	STAFF_GU, CERT_CODE
FROM 
	REV.UD_LICENSURE_DATA AS CRED
WHERE
	CERT_CODE IN ('0200', '0208', '0250' ,'0300', '0308', '0350', '0400', '0408', '0500', '0505', '0800', '0520') 
) AS T1

PIVOT
(
MAX (CERT_CODE) 
FOR CERT_CODE IN ([0200], [0208], [0250] ,[0300], [0308], [0350], [0400], [0408], [0500], [0505], [0800], [0520]) 
) AS PIVOTME
) AS LICENSES

LEFT JOIN 

(
SELECT *

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

) AS ENDORSEMENTS

ON

LICENSES.STAFF_GU = ENDORSEMENTS.STAFF_GU

GO


