BEGIN TRAN

UPDATE [AIMS].[dbo].[SPED_RPT_Import_Template_6 17 14 (2)]
SET RESOLVED = 
CASE
	WHEN [SPECIAL EDUCATION] = 'Y' AND [GIFTED] = 'N' AND [59_Primary_Exceptionality] = 'SE' THEN 'SPED ONLY'
	WHEN [SPECIAL EDUCATION] = 'N' AND [GIFTED] = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN 'GIFTED ONLY'
	WHEN [SPECIAL EDUCATION] = 'Y' AND [GIFTED] = 'Y' AND [59_Primary_Exceptionality] = 'SE' THEN 'GIFTED SECONDARY'
	WHEN [SPECIAL EDUCATION] = 'Y' AND [GIFTED] = 'Y' AND [59_Primary_Exceptionality] = '' THEN 'GIFTED PRIMARY SPED SECONDARY'
	ELSE ''
END

,[RESOLVED CODE] =
CASE
	WHEN [SPECIAL EDUCATION] = 'Y' AND [GIFTED] = 'N' AND [59_Primary_Exceptionality] = 'SE' THEN '1'
	WHEN [SPECIAL EDUCATION] = 'N' AND [GIFTED] = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN '2'
	WHEN [SPECIAL EDUCATION] = 'Y' AND [GIFTED] = 'Y' AND [59_Primary_Exceptionality] = 'SE' THEN '4'
	WHEN [SPECIAL EDUCATION] = 'Y' AND [GIFTED] = 'Y' AND [59_Primary_Exceptionality] = 'G' THEN '5'
	ELSE ''
END

ROLLBACK