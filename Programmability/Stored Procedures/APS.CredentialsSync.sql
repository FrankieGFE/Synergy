/**
 * Debbie Ann Chavez
 * 8/21/2014
 * 
 * APS.CredentialsSync
 *
 * This stored procedure updates Synergy Credentials from the HELPER table licensures through
 * the APS.License view (which joings in Lawson for employeeID)
 */

-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[CredentialsSync]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].CredentialsSync AS SELECT 0')
GO

/**
 * STORED PROC APS.CredentialsSync
 * 
 */	
--Validation parameter must be passed, 1 to validate only, 0 to update
ALTER PROC [APS].[CredentialsSync](
	@ValidateOnly INT
)

AS
BEGIN

	BEGIN TRANSACTION

	DECLARE @CREDENTIALGU VARCHAR (128) 
	SELECT @CREDENTIALGU = USER_GU FROM rev.REV_USER WHERE LOGIN_NAME = 'APS.CREDENTIALSYNC'

	-- This one does nothing right now, because we don't track status or expiration date
	-- as Synergy does not have the fields... EVENTUALLY IT SHOULD
	/*
	UPDATE
		StaffCredentials
	SET
		1=2 -- This would update the expiration date
	FROM
		[180-SMAXODS-01.APS.EDU.ACTD].HELPER.APS.License 

		INNER JOIN
		rev.EPC_STAFF AS Staff
		ON License.EmployeeNumber = Staff.BADGE_NUM

		INNER JOIN
		rev.EPC_STAFF_CRD AS StaffCredentials
		ON
		Staff.STAFF_GU = StaffCredentials.STAFF_GU
		AND StaffCredentials.DOCUMENT_NUMBER = License.Certificate_Number
		AND StaffCredentials.CREDENTIAL_TYPE = License.Certification_Type_Code
		AND StaffCredentials.AUTHORIZED_TCH_AREA = License.Certification_Area_Code
		AND StaffCredentials.DATE_EARNED = License.Certification_Effective_Date
	WHERE
		License.Certification_Status IN('Approved', 'Approved Waiver', 'REINSTATED')
		AND 1=2 -- look for different expiration dates
	*/


	--FIRST WE DELETE EVERYTHING IN THE CREDENTIALS TABLE
	DELETE FROM rev.EPC_STAFF_CRD
	
	-- This one is for putting in new ones in not already there
	INSERT INTO
		rev.EPC_STAFF_CRD
	SELECT
		NEWID() AS STAFF_CREDENTIAL_GU
		,Staff.STAFF_GU
		,License.Certification_Area_Code AS AUTHORIZED_TCH_AREA
		,License.Certification_Type_Code AS CREDENTIAL_TYPE
		,License.Certification_Effective_Date AS DATE_EARNED
		,License.Certificate_Number AS DOCUMENT_NUMBER
		,NULL AS CHANGE_DATE_TIME_STAMP
		,NULL AS CHANGE_ID_STAMP
		,GETDATE() AS ADD_DATE_TIME_STAMP
		,@CREDENTIALGU AS ADD_ID_STAMP
	FROM
		[180-SMAXODS-01.APS.EDU.ACTD].HELPER.APS.License 

		INNER JOIN
		rev.EPC_STAFF AS Staff
		ON License.EmployeeNumber = Staff.BADGE_NUM

		LEFT JOIN
		rev.EPC_STAFF_CRD AS StaffCredentials
		ON
		Staff.STAFF_GU = StaffCredentials.STAFF_GU
		AND StaffCredentials.DOCUMENT_NUMBER = License.Certificate_Number
		AND StaffCredentials.CREDENTIAL_TYPE = License.Certification_Type_Code
		AND StaffCredentials.AUTHORIZED_TCH_AREA = License.Certification_Area_Code
		AND StaffCredentials.DATE_EARNED = License.Certification_Effective_Date
	WHERE
		-- only legit ones
		License.Certification_Status IN('Approved', 'Approved Waiver', 'REINSTATED')
		AND StaffCredentials.STAFF_GU IS NULL
		AND License.Certification_Expiration_Date >= CONVERT(DATE, GETDATE())--THis is only in here if we do not have


	--ACTUALLY REMOVE THE BAD ONES
	DELETE 
		StaffCredentials
	FROM
		[180-SMAXODS-01.APS.EDU.ACTD].HELPER.APS.License 

		INNER JOIN
		rev.EPC_STAFF AS Staff
		ON License.EmployeeNumber = Staff.BADGE_NUM

		INNER JOIN
		rev.EPC_STAFF_CRD AS StaffCredentials
		ON
		Staff.STAFF_GU = StaffCredentials.STAFF_GU
		AND StaffCredentials.DOCUMENT_NUMBER = License.Certificate_Number
		AND StaffCredentials.CREDENTIAL_TYPE = License.Certification_Type_Code
		AND StaffCredentials.AUTHORIZED_TCH_AREA = License.Certification_Area_Code
		AND StaffCredentials.DATE_EARNED = License.Certification_Effective_Date
	WHERE
		License.Certification_Status NOT IN ('Approved', 'Approved Waiver', 'REINSTATED')

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