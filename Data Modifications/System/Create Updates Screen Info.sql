
BEGIN TRANSACTION

INSERT INTO rev.UD_VER

SELECT
	MOSTRECENTVER.VER_GU AS VER_GU
	,GETDATE() AS ADD_DATE_TIME_STAMP
	,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS ADD_ID_STAMP
	,NULL AS CHANGE_DATE_TIME_STAMP
	,NULL AS CHANGE_ID_STAMP
	
	--ENTER IN THE REFRESH DATE
	,'2016-04-05' AS REFRESH_DATE

	--ENTER THE USER INTERFACE URL
	,'http://synfunc.aps.edu.actd/' AS URL

	--ENTER IN ANY NOTES FOR ENVIRONMENT
	,'DO NOT REFRESH!!! Per Patti, Building Out and Testing Scheduling Tables' AS NOTES
	

FROM 
(
SELECT * FROM (
SELECT 
	ROW_NUMBER() OVER (ORDER BY DEPLOYMENT_DATE DESC) AS RN
	,VER_GU
 FROM 
REV.REV_VER
) AS T1
WHERE
RN = 1
) AS MOSTRECENTVER

SELECT * FROM 
rev.UD_VER

ROLLBACK