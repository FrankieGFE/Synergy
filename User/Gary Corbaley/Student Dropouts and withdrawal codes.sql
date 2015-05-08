



; WITH 
-- From Student School Year [EPC_STU_SCH_YR]
SSY_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[LEAVE_CODE]
	,[StudentSchoolYear].[WITHDRAWAL_REASON_CODE]
	,[LEAVE_CODE].[VALUE_DESCRIPTION] AS [LEAVE_DESCRIPTION]
	,[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]	
	,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].[STUDENT_GU] ORDER BY [StudentSchoolYear].[ENTER_DATE] DESC) AS RN
	
FROM
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	
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
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	LEFT JOIN
	APS.LookupTable('K12','LEAVE_CODE') AS [LEAVE_CODE]
	ON
	[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODE].[VALUE_CODE]
	
WHERE
	[RevYear].[SCHOOL_YEAR] >= '2012'
	AND [Grades].[VALUE_DESCRIPTION] BETWEEN '05' AND '11'
	--AND ([StudentSchoolYear].[SUMMER_WITHDRAWL_CODE] IN ('51','52') OR [StudentSchoolYear].[LEAVE_CODE] IN ('NAPS', 'GEI', 'WABS', 'WLTS', 'WEXP', 'WRET', 'WCORR', 'WNONC'))
)

--, SSY_CURRENT AS
--(
--SELECT DISTINCT
--	[StudentSchoolYear].[STUDENT_GU]
--FROM
--	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	
--	INNER JOIN 
--	rev.REV_YEAR AS [RevYear] -- Contains the School Year
--	ON 
--	[StudentSchoolYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
--WHERE
--	[RevYear].[SCHOOL_YEAR] IN ('2014','2015')
--	AND [StudentSchoolYear].[LEAVE_DATE] IS NULL

--)


--------------------------------------------------------------------------------------------------------------


SELECT DISTINCT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENTS].[GRADE]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_CODE]
	,[ENROLLMENTS].[SUMMER_WITHDRAWL_CODE]
	,[STUDENT].[HOME_LANGUAGE]
	,[STUDENT].[HOME_ADDRESS]
	,[STUDENT].[HOME_ADDRESS_2]
	,[STUDENT].[HOME_CITY]
	,[STUDENT].[HOME_STATE]
	,[STUDENT].[HOME_ZIP]
	,[STUDENT].[MAIL_ADDRESS]
	,[STUDENT].[MAIL_ADDRESS_2]
	,[STUDENT].[MAIL_CITY]
	,[STUDENT].[MAIL_STATE]
	,[STUDENT].[MAIL_ZIP]
FROM
	SSY_ENROLLMENTS AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	--LEFT OUTER JOIN
	--SSY_CURRENT AS [SSY_CURRENT]
	--ON
	--[ENROLLMENTS].[STUDENT_GU] = [SSY_CURRENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[RN] = 1
--	[ENROLLMENTS].[SCHOOL_YEAR] BETWEEN 2012 AND 2014
	
--	AND [ENROLLMENTS].[GRADE] BETWEEN '05' AND '11'
	AND ([ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IN ('51','52') OR [ENROLLMENTS].[LEAVE_CODE] IN ('NAPS', 'GEI', 'WABS', 'WLTS', 'WEXP', 'WRET', 'WCORR', 'WNONC'))
--	AND [SSY_CURRENT].[STUDENT_GU] IS NULL
	
ORDER BY
	--[ENROLLMENTS].[SCHOOL_YEAR]
	[STUDENT].[SIS_NUMBER]
	

--SELECT
--	[ALG_STUDENTS].*
--	,[STUDENT].[SIS_NUMBER]
--	,[STUDENT].[HOME_LANGUAGE]
--	,[STUDENT].[MAIL_ADDRESS]
--	,[STUDENT].[MAIL_CITY]
--	,[STUDENT].[MAIL_STATE]
--	,[STUDENT].[MAIL_ZIP]
--	,[ENROLLMENTS].[GRADE]
--	,[ENROLLMENTS].[SCHOOL_CODE]
--	--,[STU_ENROLL].*
--FROM
--	OPENQUERY ([011-SYNERGYDB.APS.EDU.ACTD],'
--	SELECT
--		*
--	FROM
--		-- Get Primary Enrollments
--		(
--		SELECT DISTINCT
--			_Id,
--			DST_NBR,
--			SCH_YR,
--			SCH_NBR,
--			GRDE,
--			ID_NBR,
--			BEG_ENR_DT,
--			END_ENR_DT,
--			END_STAT
--		FROM 
--			(
--			SELECT
--				ST010._Id,
--				ST010.DST_NBR,
--				ST010.SCH_NBR,
--				ST010.GRDE,
--				ST010.ID_NBR,
--				ST010.SCH_YR,
--				ST010.BEG_ENR_DT,
--				ST010.END_ENR_DT,
--				ST010.END_STAT,
--				ROW_NUMBER() OVER (PARTITION BY ST010.DST_NBR, ST010.ID_NBR ORDER BY ST010.BEG_ENR_DT DESC) AS RN
--			FROM
--				[PR].[DBTSIS].[ST010] WITH(NOLOCK) 
--			WHERE
--				  SCH_YR >= 2013
--				  AND NONADA_SCH != ''X''
--				  AND END_ENR_DT > BEG_ENR_DT

--			) AS ST010CURR
--		WHERE RN = 1
--		) AS [Enrollments]		
		
--	WHERE
--		[Enrollments].[DST_NBR] = 1
--		AND [Enrollments].[SCH_YR] >= 2013
		
--		AND [Enrollments].[END_STAT] IN (''67'')
		
--	') AS [ALG_STUDENTS]
	
--	--INNER JOIN
--	--APS.StudentTestHistory AS [TEST_HIST]
--	--ON
--	--[ALG_STUDENTS].[STUDENT_ID] = [TEST_HIST].[SIS_NUMBER]
	
--	LEFT OUTER HASH JOIN
--	APS.BasicStudent AS [STUDENT]
--	ON
--	[ALG_STUDENTS].[ID_NBR] = [STUDENT].[SIS_NUMBER]
	
--	LEFT OUTER JOIN
--	SSY_ENROLLMENTS AS [ENROLLMENTS]
--	ON
--	[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
--	--LEFT OUTER JOIN
--	--rev.EPC_STU_ENROLL AS [STU_ENROLL]
--	--ON
--	--[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [STU_ENROLL].[STUDENT_SCHOOL_YEAR_GU]
	
----WHERE
----	[ALG_STUDENTS].[END_STAT] = '52'
----	AND [STUDENT].[SIS_NUMBER] = '970061282'
	
--ORDER BY
--	[STUDENT].[SIS_NUMBER]
	
