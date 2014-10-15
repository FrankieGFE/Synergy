
/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-10-14 $
 *
 */

 IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[SectionsAndAllTags]'))
	EXEC ('CREATE VIEW APS.SectionsAndAllTags AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.SectionsAndAllTags AS

SELECT 
	SECTION_GU
	,[ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV]

 FROM
		rev.UD_SECTION_TAG AS Tag

	PIVOT
		(
		MAX(TAG)
		FOR TAG IN ([ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV])
		)
	AS PivotedTable

	GO