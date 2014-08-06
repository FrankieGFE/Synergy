/* Brian Rieb 
 * 8/6/2014
 *
 * Sets COURSE_ID in course history to lowercase where applicable.
 */

BEGIN TRAN

UPDATE
	rev.EPC_STU_CRS_HIS
SET
	COURSE_ID = LOWER(COURSE_ID)
WHERE
	COURSE_ID COLLATE Latin1_General_CS_AS != LOWER(COURSE_ID) COLLATE Latin1_General_CS_AS

COMMIT