



SELECT
	[Student].[SIS_NUMBER]
	,[Student].[STATE_STUDENT_NUMBER]
	,[Student].[FIRST_NAME]
	,[Student].[LAST_NAME]
	,[Student].[MIDDLE_NAME]
	,[Student].[BIRTH_DATE]
	,[Student].[GENDER]
	,[Student].[CLASS_OF]
	,[FRMHistory].[FRM_CODE]
	,[Student].[HISPANIC_INDICATOR]
	,[ETHNIC_CODES].[Race1]
	,[SCHOOL_OF_RECORD].[GRADE]
	,[SCHOOL_OF_RECORD].[SCHOOL_CODE]
	,[SCHOOL_OF_RECORD].[SCHOOL_NAME]
	,[SCHOOL_OF_RECORD].[EXCLUDE_ADA_ADM]
	,[SCHOOL_OF_RECORD].[ENR_USER_DD_4] AS [HOME OR CHARTER]
	,[SCHEDULE].[COURSE_ID]
	,[SCHEDULE].[COURSE_TITLE]
	,[SCHEDULE].[TERM_CODE]
	
FROM
	APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
	
	INNER JOIN
	APS.BasicStudent AS [Student]
	ON
	[SCHEDULE].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		[StudentSchoolYear].[STUDENT_GU]
		,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
		,[Organization].[ORGANIZATION_GU]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[StudentSchoolYear].[ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE]
		,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
		,[StudentSchoolYear].[ENR_USER_DD_4]
		,[RevYear].[SCHOOL_YEAR]
		,[RevYear].[EXTENSION]
	FROM
		rev.EPC_STU_YR AS [StudentYear] -- School of record
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[StudentYear].[STU_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[StudentYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
	WHERE
		[RevYear].[SCHOOL_YEAR] = '2014'
		AND [RevYear].[EXTENSION] = 'R'
	) AS [SCHOOL_OF_RECORD]
	ON
	[Student].[STUDENT_GU] = [SCHOOL_OF_RECORD].[STUDENT_GU]
	
	-- Get lunch status history
	LEFT HASH JOIN
	(
	SELECT
		  ROW_NUMBER() OVER (PARTITION BY stu.student_gu order by f.ENTER_DATE,stu.STUDENT_gu) rn
		, stu.STUDENT_GU
					, f.FRM_CODE
		FROM rev.EPC_STU stu
					LEFT JOIN rev.EPC_STU_PGM_FRM_HIS f on f.STUDENT_GU = stu.STUDENT_GU
					AND f.ENTER_DATE is not null and (f.EXIT_DATE is null or f.EXIT_DATE > GETDATE())
	) AS [FRMHistory]
	ON
	[Student].[STUDENT_GU] = [FRMHistory].[STUDENT_GU]
	AND [FRMHistory].[rn] = 1
	
	-- Get a list of ethnic codes pivoted into 5 columns
	LEFT HASH JOIN
	(
	select 
	  pvt.PERSON_GU
	, ROW_NUMBER() OVER(PARTITION by pvt.PERSON_GU order by pvt.person_gu) rno
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[1]) as Race1
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[2]) as Race2
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[3]) as Race3
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[4]) as Race4
	, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[5]) as Race5
	from 
	  (select
		   ROW_NUMBER() OVER(PARTITION by seth.PERSON_GU order by seth.Ethnic_code) rn
		,  seth.PERSON_GU
		, seth.ETHNIC_CODE
	   from rev.REV_PERSON_SECONDRY_ETH_LST seth
	  ) pt
	   pivot (min(ETHNIC_CODE) FOR rn in ([1],[2],[3],[4],[5])) pvt
	) AS [ETHNIC_CODES]
	ON
	[STUDENT].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	AND [ETHNIC_CODES].[rno] = 1
	
WHERE
	[SCHEDULE].[COURSE_ID] LIKE '99999%' 
	AND [SCHEDULE].[COURSE_LEAVE_DATE] IS NULL