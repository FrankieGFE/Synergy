/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 * $Author$
 * $Date$
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEClassesAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEClassesAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.LCEClassesAsOf
 * Returns a list of properly tagged and credentialed sections as it applies to LCE
 *
 * Tables Used: APS.LCEClassesAsOf,  EPC_STU_PGM_ELL_HIS
 *
 * #param DATE @AsOfDate date to look for credentials
 * 
 * #return TABLE one record per section.  Includes credential and basic course information
 */
ALTER FUNCTION APS.LCEClassesAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
-- This with is used 2 places (unioned together) and is essentially just 
-- joining sections with tags (one record per section per tag)
-- and adding the school type in
WITH SectionPlusTag AS 
(
SELECT
	Section.SECTION_GU
	,Section.SECTION_ID
	,Section.SCHOOL_YEAR_COURSE_GU
	,Section.STAFF_SCHOOL_YEAR_GU
	,SchoolType.SCHOOL_TYPE
	,Tag.TAG
FROM
	rev.EPC_SCH_YR_SECT AS Section
	INNER JOIN
	rev.UD_SECTION_TAG AS Tag
	ON
	Section.SECTION_GU = Tag.SECTION_GU
	INNER JOIN
	rev.EPC_SCH_YR_OPT AS SchoolType
	ON
	Section.ORGANIZATION_YEAR_GU = SchoolType.ORGANIZATION_YEAR_GU
WHERE
	Tag.TAG LIKE 'ALS%'
) -- end with definition
SELECT
	SECTION_GU
	,SECTION_ID
	,ORGANIZATION_YEAR_GU
	,COURSE_GU
	,COURSE_ID
	,COURSE_TITLE
	,STAFF_GU
	,SCHOOL_TYPE
	,AdditionalStaff
	,ElementaryTESOL
	,ElementaryBilingual
	,ElementaryESL
	,SecondaryTESOL
	,SecondaryBilingual
	,SecondaryESL
	,Navajo
	,ElementaryTESOLWaiverOnly
	,ElementaryBilingualWaiverOnly
	,SecondaryTESOLWaiverOnly
	,SecondaryBilingualWaiverOnly
FROM
	-- this subselect is so we can narrow to one record per section.
	(
	SELECT
		SectionTagsAndStaff.*
		,Course.COURSE_ID
		,Course.COURSE_TITLE
		,Course.COURSE_GU
		,SchoolYearCourse.ORGANIZATION_YEAR_GU
		-- This row numbers by section giving preference for primary teacher.  Remember the WHERE condition
		-- narrows it down to nly records that meet credentials to tags
		,ROW_NUMBER() OVER (PARTITION BY SectionTagsAndStaff.SECTION_GU ORDER BY SectionTagsAndStaff.AdditionalStaff) AS RN
	FROM
		-- This is a union of 2 similar queries... one pulls credentials for primary staff, one for addiitional
		-- it returns one record per section per tag per staff
		(
		-- This is for primary staff (one record per section per tag)
		SELECT 
			SectionPlusTag.SECTION_GU
			,SectionPlusTag.SCHOOL_YEAR_COURSE_GU
			,SectionPlusTag.SCHOOL_TYPE
			,SectionPlusTag.TAG
			,SectionPlusTag.SECTION_ID
			,Endorsement.*
			,0 AS AdditionalStaff
		FROM
			SectionPlusTag
			INNER JOIN
			rev.EPC_STAFF_SCH_YR AS StaffSchoolYear
			ON
			SectionPlusTag.STAFF_SCHOOL_YEAR_GU = StaffSchoolYear.STAFF_SCHOOL_YEAR_GU
	
			INNER JOIN
			APS.LCETeacherEndorsementsAsOf(@asOfDate) AS Endorsement
			ON
			StaffSchoolYear.STAFF_GU = Endorsement.STAFF_GU

		UNION ALL

		-- This is for additional Staff One record per section per tag per additional staff
		SELECT 
			SectionPlusTag.SECTION_GU
			,SectionPlusTag.SCHOOL_YEAR_COURSE_GU
			,SectionPlusTag.SCHOOL_TYPE
			,SectionPlusTag.TAG
			,SectionPlusTag.SECTION_ID
			,Endorsement.*
			,1 AS AdditionalStaff
		FROM
			SectionPlusTag
			INNER JOIN
			rev.EPC_SCH_YR_SECT_STF AS AdditionalStaff
			ON
			SectionPlusTag.SECTION_GU = AdditionalStaff.SECTION_GU

			INNER JOIN
			rev.EPC_STAFF_SCH_YR AS StaffSchoolYear
			ON
			AdditionalStaff.STAFF_SCHOOL_YEAR_GU = StaffSchoolYear.STAFF_SCHOOL_YEAR_GU
	
			INNER JOIN
			APS.LCETeacherEndorsementsAsOf(@asOfDate) AS Endorsement
			ON
			StaffSchoolYear.STAFF_GU = Endorsement.STAFF_GU
		) AS SectionTagsAndStaff

		INNER JOIN
		rev.EPC_SCH_YR_CRS AS SchoolYearCourse
		ON
		SectionTagsAndStaff.SCHOOL_YEAR_COURSE_GU = SchoolYearCourse.SCHOOL_YEAR_COURSE_GU

		INNER JOIN
		rev.EPC_CRS AS Course
		ON
		SchoolYearCourse.COURSE_GU = Course.COURSE_GU

		WHERE
		--Elementary
		(
			SectionTagsAndStaff.SCHOOL_TYPE IN (1,2)
			AND SectionTagsAndStaff.ElementaryESL = 1
		)
		OR 
		--Secondary
		(
			SectionTagsAndStaff.SCHOOL_TYPE IN (2,3,4)
			AND 
			(
				--secondary ESL
				(
					SectionTagsAndStaff.SecondaryESL = 1 
					AND SectionTagsAndStaff.TAG= 'ALSES'
				)
				OR
				-- Secondary Bilingual
				(
					SectionTagsAndStaff.SecondaryBilingual= 1 
					--Maintenance or 2WayDual Codes
					AND SectionTagsAndStaff.TAG IN('ALSMP','ALS2W')
				)
			)
		)
		OR
		--Navajo endorsements
		(			
			SectionTagsAndStaff.Navajo = 1 
			AND 
			(
				--elementary navajo
				Course.COURSE_ID ='12748008'
				OR
				--secondary navajo
				Course.COURSE_ID LIKE '6111%'
			)
		)
	) AS RowNumberedQualifiedSections
WHERE
	RowNumberedQualifiedSections.RN = 1