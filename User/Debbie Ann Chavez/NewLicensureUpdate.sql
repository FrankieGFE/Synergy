

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

	
	--FIRST WE DELETE EVERYTHING IN THE CREDENTIALS TABLE
	DELETE FROM rev.EPC_STAFF_CRD
	
	--INSERT CREDENTIALS INTO SYNERGY STAFF CREDENTIAL TABLE
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
		APS.License AS License

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



/**********************************************************************************************************************************

-- 5/18/17 DAC - UPDATE TO THE UD TABLE AS WELL 

***********************************************************************************************************************************/

INSERT INTO
		rev.UD_LICENSURE_DATA1
	SELECT
		NEWID() AS UDLICENSURE_DATA1_GU
		,GETDATE() AS ADD_DATE_TIME_STAMP
		,@CREDENTIALGU AS ADD_ID_STAMP
		,License.Certification_Area_Code AS CERT_AREA
		,License.Certification_Type_Code AS CERT_CODE
		,License.Certification_Effective_Date AS CERT_EFFEC_DT
		,License.Certification_Expiration_Date AS CERT_EXP_DT
		,License.Certificate_Number AS CERT_NUMBER
		,License.Certification_Status AS CERT_STATUS
		,NULL AS CHANGE_DATE_TIME_STAMP
		,NULL AS CHANGE_ID_STAMP
		,Staff.STAFF_GU AS STAFF_GU
		
	FROM
		APS.License AS License

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
GO


