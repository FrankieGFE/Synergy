DECLARE @CREDENTIALGU VARCHAR (128) 

SELECT @CREDENTIALGU = USER_GU FROM rev.REV_USER WHERE LOGIN_NAME = 'APS.CREDENTIALSYNC'



/********************************************************************************************************************
*
*					WRITES OUT NEW CREDENTIALS TO SYNERGY
*
*********************************************************************************************************************/

/*
INSERT INTO rev.EPC_STAFF_CRD 
(
STAFF_CREDENTIAL_GU
, STAFF_GU
, AUTHORIZED_TCH_AREA
, CREDENTIAL_TYPE
, DATE_EARNED
, DOCUMENT_NUMBER
, CHANGE_DATE_TIME_STAMP
,CHANGE_ID_STAMP
, ADD_DATE_TIME_STAMP
, ADD_ID_STAMP
)
*/


 SELECT 
	
	STAFFCRED.CREDENTIAL_TYPE
	,STAFFCRED.AUTHORIZED_TCH_AREA
	,STAFFCRED.DATE_EARNED
	,STAFFCRED.DOCUMENT_NUMBER


	
		,NEWID() AS STAFF_CREDENTIAL_GU
		,STAFF.STAFF_GU AS STAFF_GU
		,License.Certification_Area_Code AS AUTHORIZED_TCH_AREA
		,License.Certification_Type_Code AS CREDENTIAL_TYPE
		,CONVERT(DATETIME, License.Certification_Effective_Date,120) AS DATE_EARNED
		,License.Certificate_Number AS DOCUMENT_NUMBER
		,NULL AS CHANGE_DATE_TIME_STAMP
		,NULL AS CHANGE_ID_STAMP
		,GETDATE() AS ADD_DATE_TIME_STAMP
		,@CREDENTIALGU AS ADD_ID_STAMP
		--,BADGE_NUMBER
		
		--,License.Certification_Expiration_Date

FROM
(
		SELECT 
					--need badge number to get user_gu
					'e' + RIGHT('000000'+ CONVERT (VARCHAR (6), CAST(Employee.EMPLOYEE AS VARCHAR)), 6) AS BADGE_NUMBER
					, License.* 
		  FROM
		  [180-SMAXODS-01.APS.EDU.ACTD].[HELPER].[dbo].[Licensure] AS License
		  --GET EMPLOYEE NUMBER FROM SSN ON FILE
		  INNER JOIN
		  [180-SMAXODS-01.APS.EDU.ACTD].[Lawson].[dbo].[EMPLOYEE] AS Employee
		  ON
		  License.Staff_ID = cast(replace(Employee.FICA_NBR, '-', '') as int)
  ) AS License
  
  --GET STAFF GU FROM SYNERGY
  INNER JOIN
  rev.EPC_STAFF AS STAFF
  ON
  STAFF.BADGE_NUM = License.BADGE_NUMBER

  LEFT JOIN
  rev.EPC_STAFF_CRD AS STAFFCRED
  ON
  STAFFCRED.STAFF_GU = STAFF.STAFF_GU


  WHERE
  License.Certification_Effective_Date > '2014-06-30'

/*
 WHERE

(STAFFCRED.STAFF_GU = STAFF.STAFF_GU
OR STAFFCRED.DOCUMENT_NUMBER != License.Certificate_Number
OR STAFFCRED.AUTHORIZED_TCH_AREA != License.Certification_Area_Code
)
*/



   ORDER BY BADGE_NUMBER