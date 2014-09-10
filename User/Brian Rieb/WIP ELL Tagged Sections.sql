DECLARE @Year UNIQUEIDENTIFIER = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
DECLARE @School VARCHAR(MAX) = '%'

SELECT
	*
FROM
	(
	SELECT
		Organization.ORGANIZATION_NAME
		,Course.COURSE_ID
		,Course.COURSE_TITLE
		,Section.SECTION_ID
		,Course.CREDIT
		,SectionTag.TAG
	FROM
		rev.EPC_SCH_YR_SECT AS Section
		INNER JOIN
		rev.EPC_SCH_YR_CRS AS SchoolYearCourse
		ON
		Section.SCHOOL_YEAR_COURSE_GU = SchoolYearCourse.SCHOOL_YEAR_COURSE_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		SchoolYearCourse.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.EPC_CRS AS Course
		ON
		SchoolYearCourse.COURSE_GU = Course.COURSE_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS Organization
		ON
		OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

		INNER JOIN
		rev.UD_SECTION_TAG AS SectionTag
		ON
		Section.SECTION_GU = SectionTag.SECTION_GU
	WHERE
		OrgYear.ORGANIZATION_GU LIKE @School
		AND OrgYear.YEAR_GU = @Year
		AND SectionTag.TAG LIKE 'ALS%'
	) AS FullSectionInfo
	PIVOT
	(
		COUNT(TAG)
		FOR
		TAG
		IN (
			 [ALS2W]
			,[ALSED]
			,[ALSES]
			,[ALSLA]
			,[ALSMA]
			,[ALSMP]
			,[ALSOT]
			,[ALSSC]
			,[ALSSH]
			,[ALSSS]
		)

	) AS PivotedSectionData