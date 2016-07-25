/*********************************************************************

Created by Debbie Ann Chavez
Date 2/19/2016

This pulls course duration in the DCM that are equal to SEM and QTR,
and checks Sections Term Codes that do not match based on the 1st character, ex:  SEM in DCM, Q1 in Section
SEM =  S1, S2
QTR =  Q1-Q4

Patti will receive a notification and will determine which semester or quarter they need or contact the school.

/***********************************************************************/
 * 
 	Created by: Debbie Ann Chavez
	Created on: 3/3/2016
 *
 */
 
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[MismatchTerms]'))
	EXEC ('CREATE VIEW APS.MismatchTerms AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.MismatchTerms AS


SELECT T1.*, T2.[ROWCOUNT] FROM 

(
SELECT
	[Org].[ORGANIZATION_NAME]
	,[Course].[COURSE_GU]
	,[SYSect].[SCHOOL_YEAR_COURSE_GU]
	,[Course].[COURSE_TITLE]
	,[Course].[COURSE_ID]
	,SECTION_ID
	,[Course].[COURSE_DURATION]
	,[SYSect].[TERM_CODE]
	,1 AS DST
FROM
	[rev].[EPC_CRS] AS [Course]

	INNER JOIN
	[rev].[EPC_SCH_YR_CRS] AS [SYCrs]
	ON
	[Course].[COURSE_GU]=[SYCrs].[COURSE_GU]
	AND [Course].[COURSE_DURATION] IN ('Sem','Qrtr')

	INNER JOIN
	[rev].[EPC_SCH_YR_SECT] AS [SYSect]
	ON
	[SYCrs].[SCHOOL_YEAR_COURSE_GU]=[SYSect].[SCHOOL_YEAR_COURSE_GU]

	INNER JOIN
	[rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON
	[SYSect].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

	INNER JOIN
	[rev].[REV_ORGANIZATION] AS [Org]
	ON
	[OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

	INNER JOIN
	[rev].[EPC_SCH] AS [School]
	ON
	[Org].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

	INNER JOIN
	[rev].[REV_YEAR] AS [Year]
	ON
	[OrgYear].[YEAR_GU]=[Year].[YEAR_GU]

WHERE
	LEFT([Course].[COURSE_DURATION],1)!=LEFT([SYSect].[TERM_CODE],1)
	AND [SYSect].[TERM_CODE] NOT IN ('EYR')
	AND ([School].[SCHOOL_CODE] BETWEEN '400' AND '499' AND [School].[SCHOOL_CODE]!='496')
	AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
	AND [Year].[EXTENSION]='R'
	AND Course.COURSE_ID NOT IN ('08330', '08375')
	--AND SCHOOL_CODE = '425'
	)AS T1

	LEFT JOIN 


	(SELECT
	COUNT(*) AS [ROWCOUNT]
	,1 AS DST
FROM
	[rev].[EPC_CRS] AS [Course]

	INNER JOIN
	[rev].[EPC_SCH_YR_CRS] AS [SYCrs]
	ON
	[Course].[COURSE_GU]=[SYCrs].[COURSE_GU]
	AND [Course].[COURSE_DURATION] IN ('Sem','Qrtr')

	INNER JOIN
	[rev].[EPC_SCH_YR_SECT] AS [SYSect]
	ON
	[SYCrs].[SCHOOL_YEAR_COURSE_GU]=[SYSect].[SCHOOL_YEAR_COURSE_GU]

	INNER JOIN
	[rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON
	[SYSect].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

	INNER JOIN
	[rev].[REV_ORGANIZATION] AS [Org]
	ON
	[OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

	INNER JOIN
	[rev].[EPC_SCH] AS [School]
	ON
	[Org].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

	INNER JOIN
	[rev].[REV_YEAR] AS [Year]
	ON
	[OrgYear].[YEAR_GU]=[Year].[YEAR_GU]

WHERE
	LEFT([Course].[COURSE_DURATION],1)!=LEFT([SYSect].[TERM_CODE],1)
	AND [SYSect].[TERM_CODE] NOT IN ('EYR')
	AND ([School].[SCHOOL_CODE] BETWEEN '400' AND '499' AND [School].[SCHOOL_CODE]!='496')
	AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
	AND [Year].[EXTENSION]='R'
	AND Course.COURSE_ID NOT IN ('08330', '08375')
	--AND SCHOOL_CODE = '425'

	) AS T2

	ON
	T1.DST = T2.DST



GO


