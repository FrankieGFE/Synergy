/**
 * $Revision: 270 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-11-04 10:01:32 -0700 (Tue, 04 Nov 2014) $
 *
 * This view returns a nicely formatted set of meeting days for a section
 * Be very careful when joining this view in as it may slow down your query considerably 
 */

-- Drop view if it exists
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[SectionMeetingDays]'))
	EXEC ('CREATE VIEW APS.SectionMeetingDays AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.SectionMeetingDays AS
SELECT
	Section.SECTION_GU
	-- Stuff is used to remove the leading comma
     ,STUFF(
			(
			-- this subselect in the columns list uses the XML_PATH function
			-- to convert row results to a big long string
			-- having subselects in the column list CAN make things REALLLY slow!
			SELECT 
				','+ left(symd.MEET_DAY_CODE,1)
               FROM 
				rev.EPC_SCH_YR_SECT				sec    
				JOIN rev.EPC_SCH_YR_SECT_MET_DY	sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
				JOIN rev.EPC_SCH_YR_MET_DY		symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
			WHERE 
				sec.SECTION_GU  = [SECTION].SECTION_GU   
			ORDER BY 
				symd.ORDERBY  
			FOR XML PATH('')
			)
		,1,1,'') AS [MEETING_DAYS]

FROM
      rev.EPC_SCH_YR_SECT AS [SECTION]
