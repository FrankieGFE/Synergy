/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-10-14 $
 *
 */

 /****************************************************************************************************************************************************************************
 THIS VIEW PULLS ALL SECTIONS *EVER* (ALL YEARS, ALL SCHOOLS) AND THEIR TEACHERS ASSIGNED TO THEIR SECTIONS.  THIS INCLUDES PRIMARY 
 TEACHERS AND ADDITIONAL STAFF.

 THIS READS rev.EPC_SCH_YR_SECT AND  rev.EPC_STAFF_SCH_YR TABLES TWICE.

 *NOTE -- WHEN USING THIS VIEW A HASH JOIN MAY BE NEEDED

 ****************************************************************************************************************************************************************************/
		
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[SectionsAndAllStaffAssigned]'))
	EXEC ('CREATE VIEW APS.SectionsAndAllStaffAssigned AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.SectionsAndAllStaffAssigned AS
	SELECT
		*
	FROM
		APS.SectionsAndAllStaffAssignedAsOf(GETDATE())
GO