/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 05/05/2011
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 05/05/2015
 * 
 * Initial Request: .  Can you please craft an update script to change all of the ‘T-Tuition’ Not Paid to ‘R-Repeat no impact’.
 *
 * Description: Replaces any occurance of 'Tuition not paid' with 'Repeat no impact'
 *
 * Tables Referenced: rev.[EPC_STU_CRS_HIS]
 */
 
BEGIN TRAN

UPDATE [COURSE_HISTORY]

	SET [COURSE_HISTORY].[REPEAT_TAG_GU] = '92E81AF7-962A-4D66-ADF9-5FD3FD88FA7D'
	
FROM
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	
WHERE
	[COURSE_HISTORY].[REPEAT_TAG_GU] = '2FD0A98A-9175-44BA-9B17-55FE11A56B51'
	
ROLLBACK