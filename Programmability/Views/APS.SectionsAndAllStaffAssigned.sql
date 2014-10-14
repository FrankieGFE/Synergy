
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

			/****************************************************************************************
			*	SELECT1 --READ ALL SECTIONS EVER AND PRIMARY TEACHER ASSIGNED		   	*
			****************************************************************************************/
			
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

GO