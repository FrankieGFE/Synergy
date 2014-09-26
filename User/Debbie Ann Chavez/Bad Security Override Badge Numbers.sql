
/*
	Created By: Debbie Ann Chavez
	Date:  9/17/2014

	Find Bad Badge Numbers, these give errors in Unity Sync, users will not get security groups 

*/

SELECT *
 FROM
APS.SynergyGroupPull
WHERE
BADGE_NUMBER < 'A'
OR
(LEFT(BADGE_NUMBER,1) =  'E' Collate SQL_Latin1_General_CP1_CS_AS
AND LEN(BADGE_NUMBER) < = 7) 