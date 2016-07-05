

;WITH
EthCodes AS 
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
)



SELECT --TOP 100
	
	[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[PERSON].[FIRST_NAME]
	,[PERSON].[LAST_NAME]
	,[PERSON].[MIDDLE_NAME]
	
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[BASIC_SCHEDULE].[SECTION_ID]
	,[BASIC_SCHEDULE].[TERM_CODE]
	,[TEACHER_PERSON].[FIRST_NAME]
	,[TEACHER_PERSON].[LAST_NAME]
	
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
	,[ETHNIC_CODES].[Race1]
    ,[ETHNIC_CODES].[Race2]
    ,[ETHNIC_CODES].[Race3]
    ,[ETHNIC_CODES].[Race4]
    ,[ETHNIC_CODES].[Race5]
    ,[PERSON].[HISPANIC_INDICATOR]
	,[PERSON].[GENDER]
	
	--,[BASIC_SCHEDULE].*
FROM
	APS.ScheduleAsOf('04/25/2016') AS [BASIC_SCHEDULE]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[BASIC_SCHEDULE].[ENROLLMENT_GRADE_LEVEL] = [Grades].[VALUE_CODE]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[BASIC_SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN	 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[BASIC_SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_STU AS [STUDENT]
	ON
	[BASIC_SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [PERSON]
	ON
	[BASIC_SCHEDULE].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	LEFT JOIN
	EthCodes AS [ETHNIC_CODES]
	ON
	[BASIC_SCHEDULE].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
	
	LEFT JOIN
    rev.[REV_PERSON] AS [TEACHER_PERSON]
    ON
    [BASIC_SCHEDULE].[STAFF_GU] = [TEACHER_PERSON].[PERSON_GU]
    
    -- Get school name
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[BASIC_SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
    
    -- Get school number
	LEFT JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[BASIC_SCHEDULE].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2015'
	AND [RevYear].[EXTENSION] = 'R'
--	COURSE_ID = '110131'
	
	AND [COURSE].[AP_INDICATOR] = 'Y'