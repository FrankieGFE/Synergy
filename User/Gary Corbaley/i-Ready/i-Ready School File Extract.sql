USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[iReadySchool]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].iReadySchool AS SELECT 0')
GO

ALTER PROC [APS].[iReadySchool]

AS
BEGIN

SELECT
	'nm-albuq87774' AS [Client ID]
	,[School].[SCHOOL_CODE] AS [School ID]
	,[Organization].[ORGANIZATION_NAME] AS [School Name]
	,'Albuquerque Public School District' AS [District Name]
	,'NM' AS [State]
	,'' AS [NCES ID]
	,'' AS [Partner ID]
	,'' AS [Action]
	,'' AS [Reserved1]
	,'' AS [Reserved2]
	,'' AS [Reserved3]
	,'' AS [Reserved4]
	,'' AS [Reserved5]
	,'' AS [Reserved6]
	,'' AS [Reserved7]
	,'' AS [Reserved8]
	,'' AS [Reserved9]
	,'' AS [Reserved10]
	
FROM
	rev.REV_ORGANIZATION AS [Organization]

	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
ORDER BY
	[School].[SCHOOL_CODE]

END
GO