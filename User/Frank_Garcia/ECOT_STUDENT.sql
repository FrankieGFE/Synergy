USE [ST_Production]
GO

/****** Object:  View [APS].[EKOTStudent]    Script Date: 6/8/2017 9:43:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*this view selects all P1, P2, PK and K grade students in the year specified */
ALTER VIEW [APS].[EKOTStudent] AS

SELECT
	'001' AS [DistrictCode]
	,[ENROLLMENT].[SCHOOL_CODE] AS [LocationCode]
	,[STUDENT].[FIRST_NAME] AS [FirstName]
	,CASE WHEN [STUDENT].[MIDDLE_NAME] IS NULL THEN '' ELSE LEFT([STUDENT].[MIDDLE_NAME],1) END AS [MiddleInitial]
	,[STUDENT].[LAST_NAME] AS [LastName]
	,[STUDENT].[STATE_STUDENT_NUMBER] AS [STARSID]
	,[STUDENT].[SIS_NUMBER] AS [StudentAltID]
	,CONVERT(VARCHAR(4),YEAR([STUDENT].[BIRTH_DATE])) + '-' + RIGHT('000' + CONVERT(VARCHAR(2),DATEPART(MM,[STUDENT].[BIRTH_DATE])),2) + '-' + RIGHT('000' + CONVERT(VARCHAR(2),DATEPART(DD,[STUDENT].[BIRTH_DATE])),2) AS [Birthdate]
	,[STUDENT].[GENDER] AS [Gender]
	,'' AS [Statement]
	,'' AS [ErrorDesc]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENT]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENT].[GRADE] IN ('P1','P2','PK','K')
	AND [ENROLLMENT].[ENTER_DATE] IS NOT NULL
	AND [ENROLLMENT].[LEAVE_DATE] IS NULL
	AND [ENROLLMENT].[EXCLUDE_ADA_ADM] IS NULL
	AND [ENROLLMENT].[SCHOOL_YEAR] = '2017'
	AND [ENROLLMENT].[EXTENSION] = 'N'
	--AND [ENROLLMENT].[SCHOOL_CODE] IN ('315','321','207','329','229','203','241','244','350','219','255','328','267','270','395','276','217','300','317','360','389','363','370','264')
GO


