



SELECT
	--[BADGE_NUM]
	--,MIN([GRADE_LOW]) AS [GRADE_LOW]
	--,MAX([GRADE_HIGH]) AS [GRADE_HIGH]
	--*
	[School Name]
	,[K] = SUM(CASE WHEN [MATCHES] = 'K' THEN 1 ELSE 0 END)
	,[01] = SUM(CASE WHEN [MATCHES] = '01' THEN 1 ELSE 0 END)
	,[02] = SUM(CASE WHEN [MATCHES] = '02' THEN 1 ELSE 0 END)
	,[03] = SUM(CASE WHEN [MATCHES] = '03' THEN 1 ELSE 0 END)
	,[04] = SUM(CASE WHEN [MATCHES] = '04' THEN 1 ELSE 0 END)
	,[05] = SUM(CASE WHEN [MATCHES] = '05' THEN 1 ELSE 0 END)
	,[ES OTHER] = SUM(CASE WHEN [NONMATCHES] IN ('K','01','02','03','04','05') THEN 1 ELSE 0 END)
	,[MS] = SUM(CASE WHEN [GRADE_LOW] = '06' AND [GRADE_HIGH] = '08' THEN 1 ELSE 0 END)
	,[HS] = SUM(CASE WHEN [GRADE_LOW] = '09' AND [GRADE_HIGH] = 'C4' THEN 1 ELSE 0 END)
	,[OTHERS] = SUM(CASE WHEN [NONMATCHES] IN ('06','07','08','09','10','11','12','C1','C2','C3','C4') AND NOT ([GRADE_LOW] = '06' AND [GRADE_HIGH] = '08') AND NOT ([GRADE_LOW] = '09' AND [GRADE_HIGH] = 'C4') THEN 1 ELSE 0 END)
	,[TOTAL] = COUNT(*)
FROM
	(
	SELECT 
		*
		--SUM([K]) AS [K]
		--,SUM([01]) AS [01]
		--,SUM([02]) AS [02]
		--,SUM([03]) AS [03]
		--,SUM([04]) AS [04]
		--,SUM([05]) AS [05]
		--,SUM([ES OTHER]) AS [ES OTHER]
		--,SUM([MS]) AS [MS]
		
		,CASE WHEN [GRADE_MATCH] = 1 THEN [GRADE_LOW] END AS [MATCHES]
		,CASE WHEN [GRADE_MATCH] = 0 THEN [GRADE_LOW] END AS [NONMATCHES]
		
		,ROW_NUMBER() OVER (PARTITION BY [BADGE_NUM] ORDER BY [GRADE_MATCH] DESC, [GRADE_LOW_ORDER]) AS RN
		
	FROM
		(
		SELECT DISTINCT
			--[DISTRICT_COURSE].[COURSE_ID]
			SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [BADGE_NUM]
			,[Grade_Low].[VALUE_DESCRIPTION] AS [GRADE_LOW]
			,[Grade_Low].[LIST_ORDER] AS [GRADE_LOW_ORDER]
			,[Grade_High].[VALUE_DESCRIPTION] AS [GRADE_HIGH]
			,[Grade_High].[LIST_ORDER] AS [GRADE_HIGH_ORDER]
			,[Organization].[ORGANIZATION_NAME] AS [School Name]
			,[PERSON].[LAST_NAME]
			,[PERSON].[FIRST_NAME]
			
			,CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = [Grade_High].[VALUE_DESCRIPTION] THEN 1 ELSE 0 END AS [GRADE_MATCH]
			
			--,ROW_NUMBER() OVER (PARTITION BY [STAFF].[BADGE_NUM] ORDER BY [DISTRICT_COURSE].[GRADE_RANGE_LOW] DESC) AS RN
			
		--	,[K] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = 'K' AND [Grade_High].[VALUE_DESCRIPTION] = 'K' THEN 1 ELSE 0 END
		--	,[01] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = '01' AND [Grade_High].[VALUE_DESCRIPTION] = '01' THEN 1 ELSE 0 END
		--	,[02] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = '02' AND [Grade_High].[VALUE_DESCRIPTION] = '02' THEN 1 ELSE 0 END
		--	,[03] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = '03' AND [Grade_High].[VALUE_DESCRIPTION] = '03' THEN 1 ELSE 0 END
		--	,[04] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = '04' AND [Grade_High].[VALUE_DESCRIPTION] = '04' THEN 1 ELSE 0 END
		--	,[05] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = '05' AND [Grade_High].[VALUE_DESCRIPTION] = '05' THEN 1 ELSE 0 END
		--	,[ES OTHER] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] BETWEEN '01' AND '05' AND [Grade_High].[VALUE_DESCRIPTION] BETWEEN '01' AND '05' AND [Grade_Low].[VALUE_DESCRIPTION] != [Grade_High].[VALUE_DESCRIPTION] THEN 1 ELSE 0 END
		--	,[MS] = CASE WHEN [Grade_Low].[VALUE_DESCRIPTION] = '06' AND [Grade_High].[VALUE_DESCRIPTION] = '08' THEN 1 ELSE 0 END
		--	,[HS] = ''
		--,[OTHERS] = ''
		FROM
			rev.[EPC_CRS] AS [DISTRICT_COURSE]
			
			INNER JOIN
			rev.[EPC_SCH_YR_CRS] AS [COURSE_SCHOOL_YEAR]
			ON
			[DISTRICT_COURSE].[COURSE_GU] = [COURSE_SCHOOL_YEAR].[COURSE_GU]
		    
			INNER JOIN
			rev.[EPC_SCH_YR_SECT] AS [SECTION_SCHOOL_YEAR]
			ON
			[SECTION_SCHOOL_YEAR].[SCHOOL_YEAR_COURSE_GU] = [COURSE_SCHOOL_YEAR].[SCHOOL_YEAR_COURSE_GU]
		    
			INNER JOIN
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			ON
			[SECTION_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		    
			INNER JOIN 
			[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		    
			INNER JOIN 
			[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
			ON 
			[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		    
			INNER JOIN
			rev.[EPC_STAFF] AS [STAFF]
			ON
			[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
		    
			INNER JOIN
			rev.[REV_PERSON] AS [PERSON]
			ON
			[STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
		    
			LEFT OUTER JOIN
			APS.LookupTable('K12','Grade') AS [Grade_Low]
			ON
			[DISTRICT_COURSE].[GRADE_RANGE_LOW] = [Grade_Low].[VALUE_CODE]
			
			LEFT OUTER JOIN
			APS.LookupTable('K12','Grade') AS [Grade_High]
			ON
			[DISTRICT_COURSE].[GRADE_RANGE_HIGH] = [Grade_High].[VALUE_CODE]
			
		WHERE
			[DISTRICT_COURSE].[INACTIVE] = 'N'
			--AND [Grade_Low].[VALUE_DESCRIPTION] BETWEEN '01' AND '05'
			
		) AS [TEACHER_COURSE]
		
	) AS [DISTINCT_TEACHERS]

WHERE
	[RN] = 1

GROUP BY
	[School Name]
	

