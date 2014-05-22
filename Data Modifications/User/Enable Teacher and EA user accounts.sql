/**
 * 
 * $LastChangedBy: Brian Rieb
 * $LastChangedDate: 05/22/2014 $
 *
 * Request By: Christine
 * InitialRequestDate: 2/15/2013
 * 
 * Initial Request:
 * Christine wants all teachers and EA's user accounts turned on in training.
 *
 */

BEGIN TRAN

UPDATE
	[User]
SET
	DISABLED = 'N'
	,EXEMPT_FROM_LDAP = 'N'
FROM
	rev.EPC_STAFF AS Staff

	INNER JOIN

	rev.REV_USER AS [User]

	ON

	Staff.STAFF_GU = [User].USER_GU

WHERE
	Staff.TYPE IN ('TE','ED')

ROLLBACK