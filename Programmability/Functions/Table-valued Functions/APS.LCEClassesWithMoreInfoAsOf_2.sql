USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[LCEClassesWithMoreInfoAsOf_2]    Script Date: 5/24/2017 2:18:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/******************************************************************

CREATED BY DEBBIE ANN CHAVEZ
DATE 5/23/2017

--FUNCTION FOR 2017-2018 AND FORWARD
--NEW ESL AND BEP RULES 

*******************************************************************/


ALTER FUNCTION [APS].[LCEClassesWithMoreInfoAsOf_2](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
SELECT
	*
FROM
	(
	SELECT
		LCEClasses.*
		,CASE 
			WHEN SCHOOL_TYPE = 1 THEN ElementaryTESOL 
			WHEN SCHOOL_TYPE = 2 AND (ElementaryTESOL = 1 OR SecondaryTESOL = 1) THEN 1
			WHEN SCHOOL_TYPE IN (3,4) THEN SecondaryTESOL 
			ELSE 0
		END 
		AS TeacherTESOL

		,CASE 
			WHEN SCHOOL_TYPE = 1 THEN ElementaryBilingual 
			WHEN SCHOOL_TYPE= 2 AND (ElementaryBilingual = 1 OR SecondaryBilingual = 1) THEN 1
			WHEN SCHOOL_TYPE  IN (3,4) THEN SecondaryBilingual 
			ELSE 0
		END 
		AS TeacherBilingual

		,CASE 
			WHEN SCHOOL_TYPE  = 1 THEN ElementaryESL 
			WHEN SCHOOL_TYPE= 2 AND (ElementaryESL = 1 OR SecondaryESL = 1) THEN 1
			WHEN SCHOOL_TYPE  IN (3,4)THEN SecondaryESL 
			ELSE 0
		END 
		AS TeacherESL

		,Navajo AS TeacherNavajo

		,CASE 
			WHEN SCHOOL_TYPE  = 1 THEN ElementaryBilingualWaiverOnly
			WHEN SCHOOL_TYPE = 2 AND (ElementaryBilingualWaiverOnly = 1 OR SecondaryBilingualWaiverOnly = 1) THEN 1
			WHEN SCHOOL_TYPE  IN (3,4) THEN SecondaryBilingualWaiverOnly 
			ELSE 0
		END 
		AS TeacherBilingualWaiverOnly

		,CASE 
			WHEN SCHOOL_TYPE  = 1 THEN ElementaryTESOLWaiverOnly 
			WHEN SCHOOL_TYPE = 2 AND (ElementaryTESOLWaiverOnly = 1 OR SecondaryTESOLWaiverOnly= 1) THEN 1
			WHEN SCHOOL_TYPE  IN (3,4) THEN SecondaryTESOLWaiverOnly 
			ELSE 0
		END 
		AS TeacherTESOLWaiverOnly
		,Tag.TAG
	FROM
		APS.LCEClassesAsOf_2(@asOfDate) AS LCEClasses
		INNER JOIN
		(
		SELECT 
				SECTION_GU
				,COURSE_LEVEL AS TAG
			 FROM 
			rev.EPC_CRS AS CRS
			INNER JOIN 
			rev.EPC_SCH_YR_CRS AS CRSYR
			ON
			CRS.COURSE_GU = CRSYR.COURSE_GU
			INNER JOIN 
			rev.EPC_SCH_YR_SECT AS SECT
			ON
			CRSYR.SCHOOL_YEAR_COURSE_GU = SECT.SCHOOL_YEAR_COURSE_GU
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS ORGYR
			ON
			CRSYR.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
			INNER JOIN 
			rev.REV_ORGANIZATION AS ORG
			ON
			ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
			INNER JOIN 
			rev.EPC_CRS_LEVEL_LST AS LST
			ON
			LST.COURSE_GU = CRS.COURSE_GU 
			INNER JOIN 
			rev.REV_YEAR AS YRS
			ON
			ORGYR.YEAR_GU = YRS.YEAR_GU
			INNER JOIN 
			REV.EPC_SCH_YR_OPT AS SCHSETUP
			ON
			SCHSETUP.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU

			WHERE
			LST.COURSE_LEVEL IN ('BEP', 'ESL')
			AND SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM 
	[APS].[YearDates] AS [yr] 
	INNER JOIN 
	REV.REV_YEAR AS YRS
	ON
	YR.YEAR_GU = YRS.YEAR_GU
	WHERE 
	(@AsOfDate BETWEEN [yr].[START_DATE] AND [yr].[END_DATE])
	AND [yr].EXTENSION = 'R')
		) AS TAG
		ON
		LCEClasses.SECTION_GU = Tag.SECTION_GU
	) AS ReadyForPivotTable

	PIVOT
		(
		MAX(TAG)
		FOR TAG IN ([ESL], [BEP])
		)
	AS PivotedTable



GO


