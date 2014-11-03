/**
 * $Revision: 181 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-02 07:50:52 -0600 (Thu, 02 Oct 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[SectionsAndAllStaffAssignedAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.SectionsAndAllStaffAssignedAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.SectionsAndAllStaffAssignedAsOf
 * Pulls All Sections, primary teacher, and any additional staff as of a certain date
 *
 * #param DATE @AsOfDate date to look for additional assignments
 * 
 * #return TABLE Staff GU, Section GU, and Primary Teacher Flag
 */
ALTER FUNCTION APS.SectionsAndAllStaffAssignedAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT 											
	Section.SECTION_GU
	,StaffYear.STAFF_GU
	,'Y' AS PRIMARY_TEACHER

FROM

	--PRIMARY TEACHER
	rev.EPC_SCH_YR_SECT AS Section
	--GET STAFF_GU
	INNER JOIN
	rev.EPC_STAFF_SCH_YR AS StaffYear
	ON
	StaffYear.STAFF_SCHOOL_YEAR_GU = Section.STAFF_SCHOOL_YEAR_GU

UNION ALL

/**********************************************************************************************
*	SELECT2 -	READ ALL SECTIONS THAT HAVE AN ADDITIONAL STAFF ASSIGNED		    	*
**********************************************************************************************/
							
SELECT 
	Section.SECTION_GU
	,StaffYear.STAFF_GU
	,'N'

FROM
	--READ ALL SECTIONS
	rev.EPC_SCH_YR_SECT AS Section
			
	--GET ONLY SECTIONS WITH AN ADDITIONAL TEACHER
	INNER JOIN
	rev.EPC_SCH_YR_SECT_STF AS AdditionalStaff
	ON
	AdditionalStaff.SECTION_GU = Section.SECTION_GU
			
	--NEED TO READ STAFF SCHOOL YEAR TO GET STAFF_GU
	INNER JOIN
	rev.EPC_STAFF_SCH_YR AS StaffYear
	ON
	AdditionalStaff.STAFF_SCHOOL_YEAR_GU = StaffYear.STAFF_SCHOOL_YEAR_GU
WHERE
	@asOfDate BETWEEN AdditionalStaff.START_DATE AND COALESCE(AdditionalStaff.END_DATE,@asOfDate)
