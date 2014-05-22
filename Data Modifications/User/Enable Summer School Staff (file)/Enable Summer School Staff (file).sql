/**
 * 
 * $LastChangedBy: Brian Rieb
 * $LastChangedDate: 5/22/2014 $
 *
 * Request By: Christine/Jude
 * InitialRequestDate: 5/32/2014
 * 
 * Initial Request:
 * Enable all Summer School Staff (from a file) This was done on the training environment only.
 *
 */


BEGIN TRAN

UPDATE
	SynergyUser
SET
	DISABLED = 'N'
	,EXEMPT_FROM_LDAP = 'N'
FROM
	(
	SELECT 
		BADGE COLLATE DATABASE_DEFAULT AS BADGE
	FROM 
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=D:\SQLWorkingFiles; ', 
			'SELECT * from [SS-Staff.csv]'
			) 
	) AS SSStaff
	INNER JOIN

	rev.REV_USER AS SynergyUser

	ON

	'e' + SSStaff.BADGE = SynergyUser.LOGIN_NAME

ROLLBACK
