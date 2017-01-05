SELECT
		School.SCHOOL_CODE
		,SchoolYearOptions.SCHOOL_ATT_TYPE
	FROM
		REV.EPC_SCH AS School

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR As OrganizationYear

		ON School.ORGANIZATION_GU = OrganizationYear.ORGANIZATION_GU

		INNER JOIN
		rev.REV_YEAR AS SchoolYear

		ON 
		OrganizationYear.YEAR_GU = SchoolYear.YEAR_GU
		AND SchoolYear.SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
		AND SchoolYear.EXTENSION = 'R'

		INNER JOIN
		rev.EPC_SCH_YR_OPT AS SchoolYearOptions
		ON
		OrganizationYear.ORGANIZATION_YEAR_GU = SchoolYearOptions.ORGANIZATION_YEAR_GU