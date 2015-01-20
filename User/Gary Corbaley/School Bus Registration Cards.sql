


--SELECT
--	[PrimaryEnrollments].*
--FROM
--	OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.PrimaryEnrollmentsAsOf(GETDATE())') AS [PrimaryEnrollments]


SELECT
	--[Students].[School Number]
	--,[Students].[School Name]
	[School].[SCHOOL_CODE]
	,[PrimaryEnrollments].[STUDENT_GU]
	,[Organization].[ORGANIZATION_NAME]	AS [SCHOOL_NAME]
	,[Students].[Grd]
	,[Students].[Student Name]
	,[Students].[Perm ID]
	,[Students].[Course ID]
	,[Students].[Course Title]
	,[Students].[Staff Name]
	,[BasicStudent].[HOME_ADDRESS] AS [Address]
	,[BasicStudent].[HOME_CITY] AS [City]
	,[BasicStudent].[HOME_STATE] AS [State]
	,[BasicStudent].[HOME_ZIP] AS [Zip]
	--,[BasicStudent].*
	
	--,[StudentSchoolYear].*
FROM
	OPENROWSET (
				'MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=D:\SQLWorkingFiles;', 'SELECT * from "All ES homeroom only Andy.csv"'
				) AS [Students]
	
	LEFT OUTER JOIN			
	OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.BasicStudent') AS [BasicStudent]
	ON
	[Students].[Perm ID] = [BasicStudent].[SIS_NUMBER]
	
	LEFT OUTER JOIN			
	OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].APS.PrimaryEnrollmentsAsOf(GETDATE())') AS [PrimaryEnrollments]
	ON
	[BasicStudent].[STUDENT_GU] = [PrimaryEnrollments].[STUDENT_GU]
	
	--LEFT OUTER JOIN
	--(
	--SELECT
	--	[StudentSchoolofRecord].*
	--FROM
	--	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_STU_YR AS [StudentSchoolofRecord]
	--	INNER JOIN
	--	OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'SELECT * FROM  [ST_Production].rev.SIF_22_Common_CurrentYearGU') AS [CURRENT_YEAR_GU]
	--	ON
	--	[StudentSchoolofRecord].[YEAR_GU] = [CURRENT_YEAR_GU].[YEAR_GU]
	--) AS [StudentSchoolofRecord] -- Contains Grade and Start Date 	
	--ON
	--[BasicStudent].[STUDENT_GU] = [StudentSchoolofRecord].[STUDENT_GU]	
	
	--LEFT OUTER JOIN
	--[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	--ON
	--[StudentSchoolofRecord].[STU_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	-- Get location year
	LEFT OUTER JOIN 
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[PrimaryEnrollments].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	-- Get location details and name
	LEFT OUTER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	-- Get the location code
	LEFT OUTER JOIN
	[SYNERGYDBDC.APS.EDU.ACTD].[ST_Production].rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[School].[SCHOOL_CODE] IS NULL
	
--ORDER BY
--	[School].[SCHOOL_CODE]