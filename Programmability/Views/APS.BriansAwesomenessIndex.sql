/**
 * $Revision: 181 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-02 07:50:52 -0600 (Thu, 02 Oct 2014) $
 *
 *  This view calculates the Awesomeness of Brian on a scale from 0-1 (percentages)
 *  It is super complicated.
 *
 *
 *
 *  Behold
 *
 *
 *  It's Awesomness
 */

-- Drop view if it exists
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[BriansAwesomenessIndex]'))
	EXEC ('CREATE VIEW APS.BriansAwesomenessIndex AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.BriansAwesomenessIndex AS
	SELECT 1 AS AwesomnessIndex