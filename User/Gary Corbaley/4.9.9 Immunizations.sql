/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 6/10/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 5/15/2014
 * 
 * Initial Request: Pull all records from HE020 and format them to be imported into Synergy Immunization table.
 *
 * Description: Convert all Immunization entries into a format that can be uploaded to Synergy.
 * One Record Per Entry
 *
 * Tables Referenced: HE020
 */



SELECT
	[Immunizations].[ID_NBR] AS [SIS_NUMBER]
	,'' AS [SCHOOL_YEAR]
	,'' AS [SCHOOL_CODE]
	,CASE 
		WHEN[Immunizations].[IMMTYPE] = 'DTP' THEN '01'
		WHEN[Immunizations].[IMMTYPE] = 'Tdap' THEN '02'
		WHEN[Immunizations].[IMMTYPE] = 'Td' THEN '03'
		WHEN[Immunizations].[IMMTYPE] = 'IPV/OPV' THEN '04'
		WHEN[Immunizations].[IMMTYPE] = 'MMR' THEN '05'
		WHEN[Immunizations].[IMMTYPE] = 'HepB 0.5' THEN '06'
		WHEN[Immunizations].[IMMTYPE] = 'HepB 1.0' THEN '07'
		WHEN[Immunizations].[IMMTYPE] = 'Varicella' THEN '08'
		WHEN[Immunizations].[IMMTYPE] = 'HAV' THEN '09'
		WHEN[Immunizations].[IMMTYPE] = 'PCV 7' THEN '10'
		WHEN[Immunizations].[IMMTYPE] = 'PCV 13' THEN '11'
		WHEN[Immunizations].[IMMTYPE] = 'Meningocoo' OR [Immunizations].[IMMTYPE] = 'Meningocoo' THEN '12'
		WHEN[Immunizations].[IMMTYPE] = 'HPV' THEN '13'
		WHEN[Immunizations].[IMMTYPE] = 'Hib' THEN '14'
		WHEN[Immunizations].[IMMTYPE] = 'Flu' OR [Immunizations].[IMMTYPE] = 'Influenza' THEN '15'
		WHEN[Immunizations].[IMMTYPE] = 'H1N1' THEN '16'
		WHEN[Immunizations].[IMMTYPE] = 'Pneumonia' THEN '17'
		WHEN[Immunizations].[IMMTYPE] = 'Measles' THEN '18'
		WHEN[Immunizations].[IMMTYPE] = 'Mumps' THEN '19'
		WHEN[Immunizations].[IMMTYPE] = 'Rubella' OR [Immunizations].[IMMTYPE] = 'Rubeola' THEN '20'
	END AS [VACCINATION]
	,CASE WHEN [Immunizations].[IMMDATE] = '0' THEN '' ELSE CONVERT(VARCHAR,[Immunizations].[IMMDATE]) END AS [DOSAGE_DATE]
	,'' AS [COMMENT]
	,[Immunizations].[IMMEXMPT] AS [EXEMPT_REASON]
	,'' AS [SOURCE]
	,'' AS [FEEDER_DISTRICT_ID]
	,'' AS [FEEDER_STUDENT_ID]
	,'' AS [EXEMPT_GRANTED]
	,'' AS [VACCINE_COMPLIANCE]
	,'' AS [DOSAGE_COMPLIANCE]
FROM
	[DBTSIS].[HE020_V] AS [Immunizations]
	
WHERE
	[Immunizations].[IMMDATE] BETWEEN '19610000' AND '19939999'
	--AND [Immunizations].[ID_NBR] = '102963691'
