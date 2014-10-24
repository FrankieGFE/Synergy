
/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-10-14 $
 *
 */

 /***************************************************************************************************************
 *Pulls all Sections and any Tags associated with the section.  (Right now we only have LCE tags)
 ****************************************************************************************************************/


 IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[SectionsAndAllTags]'))
	EXEC ('CREATE VIEW APS.SectionsAndAllTags AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.SectionsAndAllTags AS

SELECT 
	SECTION_GU
	,MAX([ALSMA]) AS [ALSMA]
	,MAX( [ALSMP]) AS [ALSMP]
	,MAX([ALS2W]) AS [ALS2W]
	,MAX( [ALSED]) AS [ALSED]
	,MAX( [ALSSC]) AS [ALSSC]
	, MAX([ALSSS]) AS [ALSSS]
	, MAX([ALSSH]) AS [ALSSH]
	,MAX( [ALSLA]) AS [ALSLA]
	,MAX( [ALSES]) AS [ALSES]
	,MAX( [ALSOT]) AS [ALSOT]
	, MAX([ALSNV]) AS [ALSNV]

 FROM
		rev.UD_SECTION_TAG AS Tag

	PIVOT
		(
		MAX(TAG)
		FOR TAG IN ([ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV])
		)
	AS PivotedTable

GROUP BY SECTION_GU

	GO