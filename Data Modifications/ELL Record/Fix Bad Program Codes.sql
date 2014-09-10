/* Brian Rieb
 * 9/9/2014
 *
 * Fixing initial import of home contact language accidentaly setting program_code field.
 */
BEGIN TRANSACTION
	UPDATE
		rev.EPC_STU_PGM_ELL
	SET
		PROGRAM_CODE = NULL
		,CHANGE_DATE_TIME_STAMP = GETDATE()
		,CHANGE_ID_STAMP = '3C724A0A-1415-4A9B-93B3-70651D77F7D5' -- Brian's GU
	WHERE
		ENTRY_DATE IS NULL
		AND EXIT_DATE IS NULL
ROLLBACK