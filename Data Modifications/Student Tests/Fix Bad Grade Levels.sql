/* Brian Rieb
 * 9/9/2014
 *
 * FIx bad grade levels set to the string 'NULL'
 */
BEGIN TRANSACTION
	UPDATE
		rev.EPC_STU_TEST
	SET
		GRADE = NULL
	WHERE
		GRADE = 'NULL'
ROLLBACK