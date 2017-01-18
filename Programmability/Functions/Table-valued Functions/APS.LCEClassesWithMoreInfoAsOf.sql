/**
 * $Revision: 190 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-02 08:20:18 -0600 (Thu, 02 Oct 2014) $
 */
  
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEClassesWithMoreInfoAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEClassesWithMoreInfoAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.LCEClassesWithMoreInfoAsOf
 * Returns a list of properly tagged and credentialed sections as it applies to LCE and pivoted tags as well as resolved credentials
 *
 * #param DATE @AsOfDate date to look for credentials
 * 
 * #return TABLE one record per section.  Includes credential and basic course information, resolved credentials and pivoted tags
 */
ALTER FUNCTION APS.LCEClassesWithMoreInfoAsOf(@AsOfDate DATE)
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
		APS.LCEClassesAsOf(@asOfDate) AS LCEClasses
		INNER JOIN
		rev.UD_SECTION_TAG AS Tag
		ON
		LCEClasses.SECTION_GU = Tag.SECTION_GU
	) AS ReadyForPivotTable

	PIVOT
		(
		MAX(TAG)
		FOR TAG IN ([ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV])
		)
	AS PivotedTable
