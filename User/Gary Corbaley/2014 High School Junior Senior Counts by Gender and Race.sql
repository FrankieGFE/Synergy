/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/26/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 08/26/2014
 * 
 * This script will get a count of Juniors and Seniors from the set of given high schools and group the counts by male, female, and ethnicity
 */

--USE [ST_Experiment]

SELECT
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	--,SUM([JUNIOR]) AS [JUNIOR]
	--,SUM([SENIOR]) AS [SENIOR]
	,SUM([MALE]) AS [MALE]
	,SUM([FEMALE]) AS [FEMALE]
	,SUM([HISPANIC]) AS [HISPANIC]
	,SUM([WHITE]) AS [WHITE]
	,SUM([NATIVE AMERICAN]) AS [NATIVE AMERICAN]
	,SUM([ASIAN]) AS [ASIAN]
	,SUM([PACIFIC ISLANDER]) AS [PACIFIC ISLANDER]
	,SUM([AFRICAN AMERICAN]) AS [AFRICAN AMERICAN]
FROM
	(
	SELECT
		[Student].[SIS_NUMBER]
		,[Person].[LAST_NAME]
		,[Person].[FIRST_NAME]
		,[Person].[MIDDLE_NAME]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]	AS [SCHOOL_NAME]
		,[Person].[GENDER]
		,[Grades].[ALT_CODE_1] AS [GRADE]
		,CASE WHEN [Grades].[ALT_CODE_1] = '11' THEN 'JUNIOR'
			WHEN [Grades].[ALT_CODE_1] = '12' THEN 'SENIOR'
		END AS [CLASS_GRADE]
		,[Person].[HISPANIC_INDICATOR]
		,[Ethnic_1].[ETHNIC_CODE] AS [ETHNIC_CODE_1]	
		,CASE WHEN [Ethnic_1].[ETHNIC_CODE] = 1 THEN 'WHITE'
			WHEN [Ethnic_1].[ETHNIC_CODE] = 600 THEN 'AFRICAN'
			WHEN [Ethnic_1].[ETHNIC_CODE] = 299 THEN 'ASIAN'
			WHEN [Ethnic_1].[ETHNIC_CODE] = 399 THEN 'PACIFIC'
			WHEN [Ethnic_1].[ETHNIC_CODE] = 100 THEN 'NATIVE'
		END AS [RACE_1]
		,[Ethnic_2].[ETHNIC_CODE] AS [ETHNIC_CODE_2]
		,CASE WHEN [Ethnic_2].[ETHNIC_CODE] = 1 THEN 'WHITE'
			WHEN [Ethnic_2].[ETHNIC_CODE] = 600 THEN 'AFRICAN'
			WHEN [Ethnic_2].[ETHNIC_CODE] = 299 THEN 'ASIAN'
			WHEN [Ethnic_2].[ETHNIC_CODE] = 399 THEN 'PACIFIC'
			WHEN [Ethnic_2].[ETHNIC_CODE] = 100 THEN 'NATIVE'
		END AS [RACE_2]
		,CASE WHEN [Grades].[ALT_CODE_1] = '11' THEN 1 ELSE 0 END AS [JUNIOR]
		,CASE WHEN [Grades].[ALT_CODE_1] = '12' THEN 1 ELSE 0 END AS [SENIOR]
		,CASE WHEN [Person].[GENDER] = 'F' THEN 1 ELSE 0 END AS [FEMALE]
		,CASE WHEN [Person].[GENDER] = 'M' THEN 1 ELSE 0 END AS [MALE]
		,CASE WHEN [Person].[HISPANIC_INDICATOR] = 'Y' THEN 1 ELSE 0 END AS [HISPANIC]
		,CASE WHEN ([Ethnic_1].[ETHNIC_CODE] = 1 OR [Ethnic_2].[ETHNIC_CODE] = 1) AND [Person].[HISPANIC_INDICATOR] = 'N' THEN 1 ELSE 0 END AS [WHITE]
		,CASE WHEN ([Ethnic_1].[ETHNIC_CODE] = 100 OR [Ethnic_2].[ETHNIC_CODE] = 100) AND [Person].[HISPANIC_INDICATOR] = 'N' THEN 1 ELSE 0 END AS [NATIVE AMERICAN]
		,CASE WHEN ([Ethnic_1].[ETHNIC_CODE] = 299 OR [Ethnic_2].[ETHNIC_CODE] = 299) AND [Person].[HISPANIC_INDICATOR] = 'N' THEN 1 ELSE 0 END AS [ASIAN]
		,CASE WHEN ([Ethnic_1].[ETHNIC_CODE] = 399 OR [Ethnic_2].[ETHNIC_CODE] = 399) AND [Person].[HISPANIC_INDICATOR] = 'N' THEN 1 ELSE 0 END AS [PACIFIC ISLANDER]
		,CASE WHEN ([Ethnic_1].[ETHNIC_CODE] = 600 OR [Ethnic_2].[ETHNIC_CODE] = 600) AND [Person].[HISPANIC_INDICATOR] = 'N' THEN 1 ELSE 0 END AS [AFRICAN AMERICAN]
		
	FROM
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [EnrollmentsAsOf]
		
		INNER JOIN
		rev.EPC_STU AS [Student]
		ON
		[EnrollmentsAsOf].[STUDENT_GU] = [Student].[STUDENT_GU]
		
		INNER JOIN
		rev.REV_PERSON AS [Person]
		ON
		[Student].[STUDENT_GU] = [Person].[PERSON_GU]
		
		INNER JOIN
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [Eth].[PERSON_GU] ORDER BY [Eth].[ETHNIC_CODE]) AS RN
		FROM
			rev.REV_PERSON_SECONDRY_ETH_LST AS [Eth]
		) AS [Ethnic_1]
		ON
		[Person].[PERSON_GU] = [Ethnic_1].[PERSON_GU]
		AND [Ethnic_1].[RN] = 1
		
		LEFT OUTER JOIN
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY [Eth].[PERSON_GU] ORDER BY [Eth].[ETHNIC_CODE]) AS RN
		FROM
			rev.REV_PERSON_SECONDRY_ETH_LST AS [Eth]
		) AS [Ethnic_2]
		ON
		[Person].[PERSON_GU] = [Ethnic_2].[PERSON_GU]
		AND [Ethnic_2].[RN] = 2
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
		ON
		[EnrollmentsAsOf].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		-- Get location year
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[EnrollmentsAsOf].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		-- Get location details and name
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		-- Get the location code
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		LEFT OUTER JOIN
		(
		SELECT
			  Val.[ALT_CODE_1]
			  ,Val.VALUE_CODE
		FROM
			  [rev].[REV_BOD_LOOKUP_DEF] AS [Def]
			  INNER JOIN
			  [rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
			  ON
			  [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
			  AND [Def].[LOOKUP_NAMESPACE]='K12'
			  AND [Def].[LOOKUP_DEF_CODE]='Grade'
		) AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[School].[SCHOOL_CODE] IN ('590','580','514','515','520','525','530','540','550','570')
		--[Student].[SIS_NUMBER] IN ('970082533','100068790','484689989','970104989','970053939')
		--[Ethnic].[ETHNIC_CODE] NOT IN ('1','100','299','600')
		--AND [Grades].[ALT_CODE_1] IN ('11','12')
		AND [Grades].[ALT_CODE_1] = '12'
	) AS [STUDENT_DETAILS]
	
GROUP BY
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	
