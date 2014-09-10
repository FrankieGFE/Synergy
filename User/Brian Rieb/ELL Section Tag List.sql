SELECT
	SECTION_GU
	,Stuff((
		SELECT 
			', ' + REPLACE(Lookups.VALUE_DESCRIPTION, 'ALS - ', '')
          FROM 
			rev.UD_SECTION_TAG AS XMLTags
			INNER JOIN
			APS.LookupTable('K12.ScheduleInfo','Section_Tag') AS Lookups
			ON
			XMLTags.TAG = Lookups.VALUE_CODE
          WHERE 
			XMLTags.SECTION_GU = SectionTags.SECTION_GU
		ORDER BY
			Lookups.LIST_ORDER
          FOR XML PATH('')), 1, 2, '') AS TagList
FROM
	rev.UD_SECTION_TAG AS SectionTags
GROUP BY
	SECTION_GU