/*
	Created by Debbie Ann Chavez
	Date 2016-04-12

	JUST CHANGE:  

		REFRESH DATE
		ENTER THE URL
		NOTES
		AND ROLLBACK IF LOOKS GOOD THEN COMMIT

		For JoAnn's info:
		Run the script on the environment you're refreshing (e.g. SynergyTraining)
		There should only be one record when you run this.  If there's more than one use
		the delete statement at the bottom.

*/



BEGIN TRANSACTION

INSERT INTO rev.UD_VER

SELECT
	MOSTRECENTVER.VER_GU AS VER_GU
	,GETDATE() AS ADD_DATE_TIME_STAMP
	,'CCD645FF-DA2A-489D-8FDB-2B3E650E6E85' AS ADD_ID_STAMP
	,NULL AS CHANGE_DATE_TIME_STAMP
	,NULL AS CHANGE_ID_STAMP
		
	--ENTER IN THE REFRESH DATE
	,'2018-01-16' AS REFRESH_DATE
	
	--ENTER THE USER INTERFACE URL
	,'http://synfunc/' AS URL

	--ENTER IN ANY NOTES FOR ENVIRONMENT
	,'Restore from Daily Per Andy' AS NOTES

		

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

SELECT *  FROM 
rev.UD_VER

--delete from rev.rev_ver
--where ver_gu = 'DE24DB4E-7AD2-4FAF-ACEB-E2C0679204E5'
--commit
--ROLLBACK

