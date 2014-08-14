/**
 * CREATED BY DEBBIE ANN CHAVEZ
 *	DATE:  8/7/2014
 *
 *	PULLS ALL THE SCHOOLMAX NM030 RECORDS THAT HAD A '999' IN ANY OF THE HLS FIELDS 
 */
 

 USE PR
 GO
-- SYnergy to Schoolmax Language Codes Crosswalk
DECLARE @LanguageCodeCrosswalk TABLE(
            SYNERGY_CODE VARCHAR(5)
            ,SMAX_CODE VARCHAR(4)
)

INSERT INTO
            @LanguageCodeCrosswalk 
VALUES
('999','999')


SELECT
	[Languages].[ID_NBR]
	,[Languages].DT_ASSGN
	--,[Languages].[PRM_LNG] AS [Primary Language SMAX]
	,[PrimaryLanguageCodeCrosswalk].[SYNERGY_CODE] AS [Primary Language Synergy]
	--,[Languages].[CON_LNG] AS [Contact Language SMAX]
	,[ContactLanguageCodeCrosswalk].[SYNERGY_CODE] AS [Contact Language Synergy]
	--,[Languages].[HLS_Q_1] AS [QUESTION 1 SMAX]
	,[Test1LanguageCodeCrosswalk].[SYNERGY_CODE] AS [QUESTION 1 SYNERGY]
	--,[Languages].[HLS_Q_2] AS [QUESTION 2 SMAX]
	,[Test2LanguageCodeCrosswalk].[SYNERGY_CODE] AS [QUESTION 2 SYNERGY]
	--,[Languages].[HLS_Q_3_1] AS [QUESTION 3 SMAX]
	,[Test3LanguageCodeCrosswalk].[SYNERGY_CODE] AS [QUESTION 3 SYNERGY]
	--,[Languages].[HLS_Q_4_1] AS [QUESTION 4 SMAX]
	,[Test4LanguageCodeCrosswalk].[SYNERGY_CODE] AS [QUESTION 4 SYNERGY]
	--,[Languages].[HLS_Q_5_1] AS [QUESTION 5 SMAX]
	,[Test5LanguageCodeCrosswalk].[SYNERGY_CODE] AS [QUESTION 5 SYNERGY]
	
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY [NM030].[ID_NBR] ORDER BY [NM030].[DT_ASSGN] DESC) AS RN
	FROM
		[DBTSIS].[NM030_V] AS [NM030]
	) AS [Languages]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [PrimaryLanguageCodeCrosswalk]
	
	ON
	[Languages].[PRM_LNG] = [PrimaryLanguageCodeCrosswalk].[SMAX_CODE]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [ContactLanguageCodeCrosswalk]
	
	ON
	[Languages].[CON_LNG] = [ContactLanguageCodeCrosswalk].[SMAX_CODE]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [Test1LanguageCodeCrosswalk]
	
	ON
	[Languages].[HLS_Q_1] = [Test1LanguageCodeCrosswalk].[SMAX_CODE]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [Test2LanguageCodeCrosswalk]
	
	ON
	[Languages].[HLS_Q_2] = [Test2LanguageCodeCrosswalk].[SMAX_CODE]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [Test3LanguageCodeCrosswalk]
	
	ON
	[Languages].[HLS_Q_3_1] = [Test3LanguageCodeCrosswalk].[SMAX_CODE]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [Test4LanguageCodeCrosswalk]
	
	ON
	[Languages].[HLS_Q_4_1] = [Test4LanguageCodeCrosswalk].[SMAX_CODE]
	
	LEFT JOIN
	@LanguageCodeCrosswalk AS [Test5LanguageCodeCrosswalk]
	
	ON
	[Languages].[HLS_Q_5_1] = [Test5LanguageCodeCrosswalk].[SMAX_CODE]
	
WHERE
	[Languages].[DST_NBR] = 1
	--AND [Languages].[RN] = 1
	--AND [Languages].[ID_NBR] = '970031860'
	AND (
	[PrimaryLanguageCodeCrosswalk].[SYNERGY_CODE]  = '999'
	OR
	[ContactLanguageCodeCrosswalk].[SYNERGY_CODE] = '999'
	OR
	[Test1LanguageCodeCrosswalk].[SYNERGY_CODE] = '999'
	OR
	[Test2LanguageCodeCrosswalk].[SYNERGY_CODE]  = '999'
	OR
	[Test3LanguageCodeCrosswalk].[SYNERGY_CODE] = '999'
	OR
	[Test4LanguageCodeCrosswalk].[SYNERGY_CODE]  = '999'
	OR
	[Test5LanguageCodeCrosswalk].[SYNERGY_CODE]  = '999'
	)
	
ORDER BY
	[Languages].[ID_NBR]