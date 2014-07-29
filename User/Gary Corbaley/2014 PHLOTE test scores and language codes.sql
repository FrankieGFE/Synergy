/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 07/29/2014
 *
 * Request By: Debbie Chavez
 * InitialRequestDate: 07/29/2014
 *
 * Description: Pull most recent PHLOTE test scores and convert to Synergy language codes
 * One Record Per Student
 *
 * Note: Script can take over a minute to run.
 *
 * Tables Referenced: NM030
 */


USE [PR]

-- SYnergy to Schoolmax Language Codes Crosswalk
DECLARE @LanguageCodeCrosswalk TABLE(
            SYNERGY_CODE VARCHAR(5)
            ,SMAX_CODE VARCHAR(4)
)

INSERT INTO
            @LanguageCodeCrosswalk 
VALUES
('00','000')
,('01','001')
,('02','002')
,('03','003')
,('04','004')
,('05','005')
,('06','006')
,('07','007')
,('08','008')
,('09','009')
,('10','010')
,('11','011')
,('12','012')
,('13','013')
,('14','014')
,('15','015')
,('16','016')
,('17','017')
,('18','018')
,('19','019')
,('20','020')
,('21','021')
,('22','022')
,('23','023')
,('24','024')
,('25','025')
,('26','026')
,('27','027')
,('28','028')
,('29','029')
,('30','030')
,('31','031')
,('32','032')
,('33','033')
,('34','034')
,('35','035')
,('36','036')
,('37','037')
,('38','038')
,('39','039')
,('40','040')
,('41','041')
,('42','042')
,('43','043')
,('44','044')
,('45','045')
,('46','046')
,('47','047')
,('48','048')
,('49','049')
,('50','050')
,('51','051')
,('52','052')


SELECT
	[Languages].[ID_NBR]
	,[Languages].[PRM_LNG] AS [Primary Language SMAX]
	,[PrimaryLanguageCodeCrosswalk].[SYNERGY_CODE] AS [Primary Language Synergy]
	,[Languages].[CON_LNG] AS [Contact Language SMAX]
	,[ContactLanguageCodeCrosswalk].[SYNERGY_CODE] AS [Contact Language Synergy]
	,[Languages].[HLS_Q_1]
	,[Languages].[HLS_Q_2]
	,[Languages].[HLS_Q_3_1]
	,[Languages].[HLS_Q_4_1]
	,[Languages].[HLS_Q_5_1]
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [NM030].[ID_NBR] ORDER BY [NM030].[DT_ASSGN] DESC) AS RN
	FROM
		[DBTSIS].[NM030_V] AS [NM030]
	) AS [Languages]
	
	INNER JOIN
	@LanguageCodeCrosswalk AS [PrimaryLanguageCodeCrosswalk]
	
	ON
	[Languages].[PRM_LNG] = [PrimaryLanguageCodeCrosswalk].[SMAX_CODE]
	
	INNER JOIN
	@LanguageCodeCrosswalk AS [ContactLanguageCodeCrosswalk]
	
	ON
	[Languages].[PRM_LNG] = [ContactLanguageCodeCrosswalk].[SMAX_CODE]
	
WHERE
	[Languages].[DST_NBR] = 1
	AND [Languages].[RN] = 1
	--AND [Languages].[ID_NBR] = '970031860'
	
ORDER BY
	[Languages].[ID_NBR]

