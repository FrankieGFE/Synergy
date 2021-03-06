

--SELECT DISTINCT
--	--COUNT(DISTINCT [SIS_NUMBER]) AS [STUDENTS]
--	*
--FROM
--	(
	SELECT DISTINCT
		--COUNT(DISTINCT [STUDENT].[SIS_NUMBER]) AS [STUDENTS]
		--[COURSE].[STATE_COURSE_CODE]
		--[STUDENT].[SIS_NUMBER]
		[ENROLLMENT].[SCHOOL_CODE]
		,[ENROLLMENT].[SCHOOL_NAME]
		,[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[STUDENT].[GENDER]
		,[STUDENT].[BIRTH_DATE]
		,[STUDENT].[CLASS_OF]
		,[STUDENT].[LUNCH_STATUS]
		,[STUDENT].[SPED_STATUS]
		,[STUDENT].[ELL_STATUS]
		,[STUDENT].[HISPANIC_INDICATOR]
		,[STUDENT].[RESOLVED_RACE]
		,[ENROLLMENT].[GRADE]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[SECTION_ID]
		,[SCHEDULE].[TERM_CODE]
		,[SCHEDULE].[COURSE_ENTER_DATE]
		,[SCHEDULE].[COURSE_LEAVE_DATE]
		--,ROW_NUMBER() OVER(PARTITION BY [STUDENT].[SIS_NUMBER] order by [STUDENT].[SIS_NUMBER]) AS [RN]
		
		,[CTE_PROGRAM].[CODE]
		,[CTE_PROGRAM].[TITLE]
		
		--,[SCHEDULE].*
	FROM
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo [STUDENT]
		ON
		[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
		ON
		[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
		AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		LEFT OUTER JOIN
		rev.EPC_CTE_PROGRAM_CRS AS [CTE_PGM_CRS]
		ON
		[SCHEDULE].[COURSE_GU] = [CTE_PGM_CRS].[COURSE_GU]
		
		LEFT OUTER JOIN
		rev.EPC_CTE_PROGRAM AS [CTE_PROGRAM]
		ON
		[CTE_PGM_CRS].[CTE_PROGRAM_GU] = [CTE_PROGRAM].[CTE_PROGRAM_GU]
		
	
WHERE
	[SCHEDULE].[TERM_CODE] NOT IN ('S2','Q3','Q4')
	--AND [STUDENT].[SIS_NUMBER] = '171196652'
	--AND [SCHEDULE].[COURSE_ID] = '51000'
	AND [COURSE].[STATE_COURSE_CODE] IN
	
	
--/*	
('01449200', 
'01999200', 
'02037253', 
'02044150', 
'02049200', 
'02257235', 
'02277217', 
'02297253', 
'02329200', 
'02549200', 
'02769250', 
'03012150', 
'03014050', 
'03014150', 
'03019050', 
'03019250', 
'03019500', 
'03022157', 
'03024050', 
'03024150', 
'03027150', 
'03028258', 
'03029200', 
'03029250', 
'03039250', 
'03044258', 
'03054150', 
'03067225', 
'03077227', 
'03087227', 
'03097227', 
'03139250', 
'03149250', 
'03149700', 
'03157153', 
'03157227', 
'03157821', 
'03159250', 
'03167153', 
'03169250', 
'03169900', 
'03174253', 
'03187151', 
'03189250', 
'03197151', 
'03239250', 
'03247157', 
'03249250', 
'03267157', 
'03269100', 
'03275157', 
'03309250', 
'03319250', 
'03407250', 
'03409250', 
'03429250', 
'03439250', 
'03957155', 
'03969250', 
'04027251', 
'04029250', 
'04037251', 
'04147157', 
'04149250', 
'04169000', 
'04172150', 
'04267257', 
'04389200', 
'04419250', 
'04429250', 
'04459250', 
'04529250', 
'04539250', 
'05029250', 
'05034150', 
'05044155', 
'05047155', 
'05049209', 
'05049250', 
'05057252', 
'05059000', 
'05059250', 
'05087157', 
'05089250', 
'05099250', 
'05114257', 
'05117257', 
'05127257', 
'05134150', 
'05137157', 
'05144257', 
'05159250', 
'05174150', 
'05177151', 
'05197252', 
'05199250', 
'05287257', 
'05289200', 
'05307257', 
'05327257', 
'05337257', 
'05339200', 
'05359200', 
'05397235', 
'05397237', 
'05409229', 
'05507252', 
'05517252', 
'05527252', 
'05537252', 
'05547252', 
'05557252', 
'05567356', 
'06037254', 
'06069000', 
'06079000', 
'06990000', 
'07019200', 
'07027354', 
'07029250', 
'07037257', 
'07037354', 
'07039000', 
'07039250', 
'07047257', 
'07079200', 
'07079250', 
'07129200', 
'07129250', 
'07139200', 
'07157257', 
'07167257', 
'07174257', 
'07177257', 
'07187257', 
'07189901', 
'07197257', 
'07207257', 
'07987235', 
'08032000', 
'08033000', 
'08034000', 
'08034100', 
'08174000', 
'08414100', 
'08514100', 
'08626000', 
'08626100', 
'08626952', 
'08734000', 
'08744100', 
'08877235', 
'08909100', 
'08914100', 
'08962100', 
'08966100', 
'08994000', 
'08994100', 
'08999000', 
'08999100', 
'09019250', 
'09127257', 
'09129250', 
'09139250', 
'09149250', 
'09159250', 
'09169250', 
'09187157', 
'09189250', 
'09207257', 
'09217257', 
'09639034', 
'09987235', 
'10719930', 
'10729920', 
'10749940', 
'11124118', 
'11124128', 
'11657821', 
'11659901', 
'11674821', 
'11714821', 
'11719901', 
'11724100', 
'11724123', 
'11724821', 
'11727821', 
'11727900', 
'11729900', 
'11754821', 
'11757821', 
'11777821', 
'11787821', 
'11814821', 
'11835821', 
'11845928', 
'11954111', 
'11990000', 
'13139250', 
'13959250', 
'15024357', 
'15027357', 
'15029200', 
'15039200', 
'15044200', 
'15047357', 
'15049200', 
'15054357', 
'15057244', 
'15057357', 
'15077357', 
'15177200', 
'15179200', 
'15179250', 
'15239250', 
'15404200', 
'15607001', 
'15607051', 
'15957200', 
'15959200', 
'16032150', 
'16034000', 
'16042150', 
'16044150', 
'16052245', 
'16054245', 
'16056245', 
'16057245', 
'16117257', 
'16209250', 
'16269250', 
'16289258', 
'16299200', 
'16959250', 
'16994050', 
'18027253', 
'18037253', 
'18267253', 
'18347255', 
'18509220', 
'18974243', 
'18977243', 
'18987235', 
'19024911', 
'19034821', 
'19034921', 
'19034941', 
'19054932', 
'19059973', 
'19114941', 
'19214163', 
'19214952', 
'19214963', 
'19214973', 
'19219900', 
'19992270', 
'24039200', 
'24049200', 
'24127157', 
'24159222', 
'24167251', 
'24167257', 
'24959200', 
'24967257', 
'24999251')
--*/
--) AS [CTE_STUDENTS]

--WHERE
--	RN = 2