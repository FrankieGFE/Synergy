/* Brian Rieb
 * 8/13/2014
 *
 * Request By: Shayne Kendall
 *
 * Add the following grades to the gradebook grade table: PK, C2, C3, C4, T1, T2, T3, T4
 *
 * Note that production and sped have different starting values. SO if this script is
 * to be run on production, it needs to be modified or it will cause errors
 */

-- we will be specifying the ID number directly on insert (for cross-DB compatability)
BEGIN TRANSACTION

	INSERT INTO
		rev.EGB_GRADE
		(ID, GRADE) -- have to specify columns, as we are inserting on the identity field
	VALUES
	-- These are values missing from both
	(20,'Grade PK')
	,(21,'Grade T1')
	,(22,'Grade T2')
	,(23,'Grade T3')
	,(24,'Grade T4')
	-- CAREFUL: These are values missing from SPED but not in Production
	,(17,'Grade C4')
	,(18,'Grade C2')
	,(19,'Grade C3')

ROLLBACK

-- Check the values
SELECT
	*
FROM
	rev.EGB_GRADE