


DECLARE @AsOfDate datetime = GETDATE()

SELECT
	[STUDENT].[STATE_STUDENT_NUMBER]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[GRADE]
	
	,[StudentSchoolYear].[CAME_FROM]
	,[StudentSchoolYear].[ENR_USER_DD_4] AS [HOME/CHARTER]
	
	,[TITLE_1_LOG].[DATE_FIRST_REFERRED]
	,[TITLE_1_LOG].[REFERRED_SCHOOL_LOCATION]
	,[TITLE_1_LOG].[REFERRAL_TAKEN_BY]
	,[TITLE_1_LOG].[ASSIGNED_OUTREACH]
	,[TITLE_1_LOG].[HOUSING_STATUS]
	,[HOUSING_STATUS].[VALUE_DESCRIPTION]
	,[HOUSING_STATUS].[ALT_CODE_1]
	,[HOUSING_STATUS].[ALT_CODE_2]
	,[HOUSING_STATUS].[ALT_CODE_3]
	,[TITLE_1_LOG].[EXPECTING]
	,[TITLE_1_LOG].[ADD_DATE_TIME_STAMP] AS [LOG_DATE]
	,[TITLE_1_LOG].[NOTES] AS [LOG_NOTES]
	,[TITLE_1_LOG].[OUTCOME] AS [LOG_OUTCOME]
	,[LOG_OUTCOME].[VALUE_DESCRIPTION] AS [LOG_OUTCOME_DESC]
	
	,[TITLE_1_CONTACT].[ADD_DATE_TIME_STAMP] AS [CONTACT_DATE]
	,[TITLE_1_CONTACT].[NOTES] AS [CONTACT_NOTES]
	,[TITLE_1_CONTACT].[OUTCOME] AS [CONTACT_OUTCOME]
	,[CONTACT_OUTCOME].[VALUE_DESCRIPTION] AS [CONTACT_OUTCOME_DESC]
	
	,[TITLE_1_FOLLOW_UP].[ADD_DATE_TIME_STAMP] AS [FOLLOW_UP_DATE]
	,[TITLE_1_FOLLOW_UP].[NOTES] AS [FOLLOW_UP_NOTES]
	,[TITLE_1_FOLLOW_UP].[OUTCOME] AS [FOLLOW_UP_OUTCOME]
	,[FOLLOW_UP_OUTCOME].[VALUE_DESCRIPTION]  AS [FOLLOW_UP_OUTCOME_DESC]
	
	,[TITLE_1_HISTORY].[ADD_DATE_TIME_STAMP] AS [HISTORY_DATE]
	,[TITLE_1_HISTORY].[HISTORY_NOTES]
	
	,[UD_STUDENT].[ADVOCACY_COLLABORATION_WITH]
	,[UD_STUDENT].[ASSISTANCE_WITH_OTHER_SCHOO]
	,[UD_STUDENT].[CAP_AND_GOWN_VOUCHER]
	,[UD_STUDENT].[CHILD_NUTRITION]
	,[UD_STUDENT].[COMMUNITY_RESOURCE_GUIDE]
	,[UD_STUDENT].[DISCUSSION_OF_MVRIGHTS]
	,[UD_STUDENT].[EMERGENCY_FOOD_BAG]
	,[UD_STUDENT].[EMERGENCY_CLOTHING_VOUCHER]
	,[UD_STUDENT].[ENROLLMENT_ASSISTANCE]
	,[UD_STUDENT].[EXPEDITED_EVALUATION]
	,[UD_STUDENT].[FAFSA_COLLEGE_FINANCIAL_AS]
	,[UD_STUDENT].[FAMILY_NUMBER]
	,[UD_STUDENT].[FOOD_SERVICES]
	,[UD_STUDENT].[HOLIDAY_ADOPTIONS]
	,[UD_STUDENT].[HOME_VISIT]
	,[UD_STUDENT].[HYGIENE_PRODUCTS]
	,[UD_STUDENT].[MEDICAL_DENTAL_SERVICES]
	,[UD_STUDENT].[MENTAL_HEALTH_SERVICES]
	,[UD_STUDENT].[OTHER_CLOTHING]
	,[UD_STUDENT].[SCHOOL_RECORDS]
	,[UD_STUDENT].[SCHOOL_SUPPLIES]
	,[UD_STUDENT].[SCHOOL_UNIFORMS]
	,[UD_STUDENT].[SUMMER_PROGRAM]
	,[UD_STUDENT].[SUMMER_SCHOOL_ASSISTANCE_FE]
	,[UD_STUDENT].[TUTORING_PROGRAM]
	,[UD_STUDENT].[TRANSPORTATION]
	
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS [ENROLLMENTS]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	rev.UD_TITLEI_LOG AS [TITLE_1_LOG]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [TITLE_1_LOG].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('Revelation.UD.TitleI','OUTCOME') AS [LOG_OUTCOME]
	ON
	[TITLE_1_LOG].[OUTCOME] = [LOG_OUTCOME].[VALUE_CODE]
	
	LEFT OUTER JOIN
	APS.LookupTable('Revelation.UD.TitleI','HOUSING_STATUS') AS [HOUSING_STATUS]
	ON
	[TITLE_1_LOG].[HOUSING_STATUS] = [HOUSING_STATUS].[VALUE_CODE]
	
	LEFT OUTER JOIN
	rev.UD_TITLEI_CONTACT AS [TITLE_1_CONTACT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [TITLE_1_CONTACT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('Revelation.UD.TitleI','OUTCOME') AS [CONTACT_OUTCOME]
	ON
	[TITLE_1_CONTACT].[OUTCOME] = [CONTACT_OUTCOME].[VALUE_CODE]
	
	LEFT OUTER JOIN
	rev.UD_TITLEI_FOLLOW_UP AS [TITLE_1_FOLLOW_UP]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [TITLE_1_FOLLOW_UP].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('Revelation.UD.TitleI','OUTCOME') AS [FOLLOW_UP_OUTCOME]
	ON
	[TITLE_1_FOLLOW_UP].[OUTCOME] = [FOLLOW_UP_OUTCOME].[VALUE_CODE]
	
	LEFT OUTER JOIN
	rev.UD_TITLEI_HISTORY AS [TITLE_1_HISTORY]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [TITLE_1_HISTORY].[STUDENT_GU]
	
	LEFT OUTER JOIN
	rev.UD_STU AS [UD_STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [UD_STUDENT].[STUDENT_GU]
	
--WHERE
----	[TITLE_1_LOG].[OUTCOME] IS NOT NULL
--	[ENROLLMENTS].[ORGANIZATION_GU] LIKE @School
	
	