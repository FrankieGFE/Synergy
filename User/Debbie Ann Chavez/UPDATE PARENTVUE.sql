/*
BEGIN TRANSACTION

UPDATE rev.REV_USER_NON_SYS
	SET LOGIN_ATTEMPTS = 0, DISABLED = 'N'
*/

SELECT 
	USER_ID, DISABLED, LOGIN_ATTEMPTS
FROM 
rev.REV_USER_NON_SYS AS SYSS
WHERE
--USER_ID = '104590245' 
--AND PERSON_GU = '350A4F92-97B8-4459-B2B9-304237D53247'
DISABLED = 'Y'
--COMMIT