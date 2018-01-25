SELECT
		CAL_DT
		,MEMTODT
	FROM
		DBTSIS.CA005_V AS Calendar
where SCH_YR = 2014		

		and DST_NBR = 1
		AND SCH_NBR = '525'
		and DAY_CD != ''
		and DAY_CD != 'NS'
		and MEMTODT < '175'
		and CAL_DT = '20130816'
		order by MEMTODT