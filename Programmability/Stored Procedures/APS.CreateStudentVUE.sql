
/*
	Created by: Debbie Ann Chavez
	Date:  7/30/2015

	This reads the stored procedure that is run every night by Technology to create AD student users.
	It then checks to see if the student has a StudentVUE record, if not it creates it.

	--The UPDATE is a one time process only for the first time to correct all of the existing accounts.

*/

-- Add Procedure if it does not exist
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[CreateStudentVUE]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].CreateStudentVUE AS SELECT 0')
GO


ALTER PROC [APS].[CreateStudentVUE](
	@ValidateOnly INT
)

AS
BEGIN

BEGIN TRANSACTION


DECLARE @TEMP TABLE
(
DistrictNumber VARCHAR (3), 
SchoolYear VARCHAR (8),
StudentIDNumber VARCHAR (9),
SORSchoolNumber VARCHAR(3),
SchoolName VARCHAR (100),
Grade VARCHAR (2),
EnterDate VARCHAR (8),
AddDelStatus VARCHAR (1),
LastName VARCHAR (100),
FirstName VARCHAR (100),
StudentMiddleName VARCHAR (100),
SchooLOfRecord VARCHAR (1)
)

INSERT INTO 
	@TEMP
EXEC APS.ActiveDirectoryStudents

----------------------------------------------------------------------------------------------
--UPDATE IF THEY EXIST
--this will only be run once, if they exist, update their userid

/*
UPDATE rev.REV_USER_NON_SYS
SET USER_ID = SIS_NUMBER

--SELECT *

FROM 
(
SELECT DISTINCT 
	STUDENT_GU,
	SIS_NUMBER
FROM 
 @TEMP AS TEMP
 INNER JOIN
 rev.EPC_STU AS STU
 ON
 TEMP.StudentIDNumber = STU.SIS_NUMBER
 INNER JOIN
 rev.REV_USER_NON_SYS AS SYSUSER
 ON
 STU.STUDENT_GU = SYSUSER.PERSON_GU
 ) AS FOUNDSTUDENTVUEKIDS

  WHERE
  rev.REV_USER_NON_SYS.PERSON_GU = FOUNDSTUDENTVUEKIDS.STUDENT_GU
*/
-----------------------------------------------------------------------------------------------
--INSERT IF THEY DON'T EXIST


INSERT INTO rev.REV_USER_NON_SYS

SELECT 
NEWSTUDENTVUEKIDS.STUDENT_GU AS PERSON_GU
,NEWSTUDENTVUEKIDS.SIS_NUMBER AS USER_ID
,NULL AS ACTIVATE_KEY
, NULL AS PASSWORD
,NULL AS LAST_ACCESSED
,NULL AS LAST_ACCESSED_IP
,NULL AS ACTIVATION_DATE_TIME
,NULL AS ACTIVATE_KEY_DATETIME
,1 AS USER_TYPE
,'N' AS DISABLED
,NULL AS LOGIN_ATTEMPTS
,NULL AS PREFERENCES
,'N' AS ACTIVATED_VIA_REG

FROM 
(
SELECT DISTINCT 
	STUDENT_GU,
	SIS_NUMBER

FROM 
 @TEMP AS TEMP
 INNER JOIN
 rev.EPC_STU AS STU
 ON
 TEMP.StudentIDNumber = STU.SIS_NUMBER
 LEFT JOIN
 rev.REV_USER_NON_SYS AS SYSUSER
 ON
 STU.STUDENT_GU = SYSUSER.PERSON_GU

 WHERE
 SYSUSER.PERSON_GU IS NULL

 ) AS NEWSTUDENTVUEKIDS

 --Validation Check to see how many records will be processed, 0 = INSERT AND UPDATE, 1 = ROLLBACK - WILL NOT - UPDATE/INSERT
IF @ValidateOnly = 0
	BEGIN
		COMMIT 
	END
ELSE
	BEGIN
		ROLLBACK
	END
END -- END SPROC