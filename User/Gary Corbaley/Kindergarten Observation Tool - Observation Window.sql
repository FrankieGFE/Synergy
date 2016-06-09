

	SELECT
		'K3P' AS [WindowName]
		,'001' AS [DistrictCode]
		,[School].[SCHOOL_CODE] AS [LocationCode]
		,CONVERT(VARCHAR(10),CalendarOptions.START_DATE,126) AS START_DATE
		,CONVERT(VARCHAR(10),CalendarOptions.END_DATE,126) AS END_DATE
		,'' AS [Statement]
		,'' AS [ErrorDesc]
	FROM
		rev.EPC_SCH_ATT_CAL_OPT AS CalendarOptions
		INNER JOIN
		REV.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		CalendarOptions.ORG_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU
		
		LEFT OUTER JOIN
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		OrgYear.[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		LEFT OUTER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]

		INNER JOIN 
		rev.REV_YEAR AS YEARS
		ON
		OrgYear.YEAR_GU = YEARS.YEAR_GU
	WHERE
		-- Exclude Child Find and Early Childhood
		OrgYear.ORGANIZATION_GU != '02D7B4ED-495A-4617-83FD-834AF27BDD15'
		AND YEARS.[SCHOOL_YEAR] = '2016'
		AND EXTENSION = 'N'
	--GROUP BY
	--	OrgYear.YEAR_GU
	--	,EXTENSION