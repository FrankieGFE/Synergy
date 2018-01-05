USE [SchoolNetDevelopment]
GO
/****** Object:  StoredProcedure [dbo].[code_program_sis_sp]    Script Date: 03/17/2014 08:37:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[code_program_sis_sp] as

truncate table code_program_sis;

insert into code_program_sis


/**
* 
* $LastChangedBy: Terri Christiansen
* $LastChangedDate: 9/20/2013 $
*
* Request By: SchoolNet
* InitialRequestDate: 
* 
* Version 14, fills PD Data Loading Worksheet for code_program
*
*
* Tables Referenced: CE020 for Grad Standard year, Indian Ed
*						CE030 for Home and Contact Language
*						CE085 for FRPLf
*						HE010 for ADA-504
*						NM021 for Indian Ed
*						NM080 for 506-CIB Indian Ed
*						SP080 for Special Ed
*						ST082 for TitleI
*						Union in hand builts like: ELL, ESL-R, Home Language Survey
*						3-17-2014 FLG added Assessment Exemption codes. Union in hand builts.
*/


/*Special Ed Program*/
SELECT
	SPED .DISAB_CD AS program_code
	,'Sped - ' + SPED.DISAB_DESC AS program_name
	,'SPED' AS program_type_code
	,CASE WHEN SPED.DISAB_CD = 'GI' THEN 'Y' 
		ELSE 'N'
	 END gifted_program
	,CASE WHEN SPED.DISAB_CD != 'GI' THEN 'Y' 
		ELSE 'N'
	 END special_ed_program
	,'N' AS lep_program
FROM
	SMAXDBPROD.PR .DBTSIS .SP080_V   AS SPED WITH (NOLOCK)
WHERE
	(SPED .DST_NBR = 1)

UNION
/*Title I program--no longer used, but must keep for history*/
SELECT
	TitleI .CODE_ABBR AS program_code
	,TitleI .CODE_DESCR AS program_name
	,'TitleI' AS program_type_name
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR .DBTSIS .ST082_V AS TitleI WITH (NOLOCK)
WHERE
	(TitleI .DST_NBR = 1 AND TitleI .CODE_TYPE = 'SERV-CD')

UNION
/*Home Language*/
SELECT
	CAST(Home.LANG_CD AS varchar) AS program_code
	,Home.LANG_DESCR + ' (H' + CAST(LANG_CD AS varchar) + ')' AS program_name
	,'Home' AS program_type_name
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR .DBTSIS .CE030_V AS Home WITH (NOLOCK)
WHERE
	(Home.DST_NBR = 1)

UNION	
/*Home Language No record*/
SELECT
	'999' AS program_code		--SDS 1/25/14 Changed 999-H to 999 to match RM code.
	,'No Record-H' AS  program_name
	,'Home' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program

UNION
/*Contact Language*/
SELECT
	CAST(Contact.LANG_CD AS varchar) + '-C'  AS program_code
	,Contact.LANG_DESCR + ' (C' + CAST(LANG_CD AS varchar) + ')' AS program_name
	,'Contact' AS program_type_name
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR .DBTSIS .CE030_V AS Contact WITH (NOLOCK)
WHERE
	(Contact.DST_NBR = 1)
	
UNION	
/*Contact Language No record*/
SELECT
	'999-C' AS program_code
	,'No Record-C' AS  program_name
	,'Contact' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program

UNION 
/*Grad Standard Year*/
SELECT
	DISTINCT
	'GSY' + CAST(GSTD_YR AS varchar) AS program_code
	,'Grad Standard Year ' + CAST(GSTD_YR AS varchar) AS program_name
	,'GSY' AS program_type_name
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR .DBTSIS .CE020_V AS GSY WITH (NOLOCK)
WHERE
	(GSY.DST_NBR = 1
		AND GSY.GSTD_YR > 0)

UNION
/*Indian Education Ethnicity*/
SELECT
	DISTINCT
	CASE WHEN IE.ETHN_CD = 4 THEN 'PE'
		ELSE
		CASE WHEN IE.ETHN_CD2 =  4 THEN 'SE'
			ELSE
			CASE
				WHEN IE.ETHN_CD3 =  4 THEN 'OE'
				WHEN IE.ETHN_CD4 =  4 THEN 'OE'
				WHEN IE.ETHN_CD5 =  4 THEN 'OE'
				WHEN IE.ETHN_CD6 =  4 THEN 'OE'

			END
		END	
	END AS program_code
	,CASE 
		WHEN IE.ETHN_CD = 4 THEN 'Primary Ethnicity: American Indian'
		ELSE
			CASE
				WHEN IE.ETHN_CD2 =  4 THEN 'Secondary Ethnicity: American Indian'
		ELSE
			CASE 
				WHEN IE.ETHN_CD3 =  4 THEN 'Other Ethnicity: American Indian'
				WHEN IE.ETHN_CD4 =  4 THEN 'Other Ethnicity: American Indian'
				WHEN IE.ETHN_CD5 =  4 THEN 'Other Ethnicity: American Indian'
				WHEN IE.ETHN_CD6 =  4 THEN 'Other Ethnicity: American Indian'
			END
		END	
	END AS program_name
	,'IE' AS program_type
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR .DBTSIS .CE020_V AS IE
WHERE
	(IE .DST_NBR = 1 AND
	(IE .ETHN_CD = 4 OR
		IE .ETHN_CD2 = 4
		OR IE .ETHN_CD3 = 4 
		OR IE .ETHN_CD4 = 4 
		OR IE .ETHN_CD5 = 4
		OR IE .ETHN_CD6 = 4))

UNION
--**Federal Tribes
SELECT
	TRIBE_CD + '_FED' AS program_code
	,TRIBE_CD + ' - ' + TRIBE_NM + ' (Fed)' AS program_name
	,'IE_FED' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR.DBTSIS.NM080_V AS Federal_Tribe
WHERE INDIGEN = 1

UNION
--**New Mexico Tribes
SELECT
	TRIBE_CD + '_NM' AS program_code
	,TRIBE_CD + ' - ' + TRIBE_NM + ' (NM)' AS program_name
	,'IE_NM' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR.DBTSIS.NM080_V AS NM_Tribe
WHERE PUEBLO = 1

UNION
--**Other Tribes
SELECT
	TRIBE_CD + '_OTH' AS program_code
	,TRIBE_CD + ' - ' + TRIBE_NM + ' (NM)' AS program_name
	,'IE_OTH' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR.DBTSIS.NM080_V AS Other_Tribe
WHERE 
	PUEBLO = ''
		AND INDIGEN = ''
		AND RIGHT(TRIBE_NM,1) != '_'

UNION
--SDS: Added 1/25/2014 Missing None-OTH code, added this record from the ReportMax CodeProgram file
--"None-OTH","Tribe IE (NM221) - Not Entered","IE_None","N","N","N"
SELECT
	'None-OTH' AS program_code
	,'Tribe IE (NM221) - Not Entered' AS program_name
	,'IE_None' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program

UNION
--**State Recognized Tribes	
SELECT
	TRIBE_CD + '_SRT' AS program_type_code
	,TRIBE_CD + '_' + TRIBE_NM AS program_name  
	,'IE_SRT' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
	SMAXDBPROD.PR.DBTSIS.NM080_V AS State_Recognized_Tribe
WHERE 
	RIGHT(TRIBE_NM,1) = '_'

UNION
--**CIB (certificate of Indian blood on file with the school and/or Indian Ed Department
--**506 (certificate of tribal membership on file with the school and/or Indian Ed Department
SELECT
	DISTINCT
	whats_on_file + permutation COLLATE DATABASE_DEFAULT AS  program_code 
	,CASE
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'CIB_SCH'  THEN 'CIB School - Not Entered' --No CIB entered at the school
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'CIB_SCHN' THEN 'CIB School - No' --No CIB on record at the school
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'CIB_SCHR' THEN 'CIB School - Parent Refused' --Parent refused to give CIB to school
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'CIB_SCHX' THEN 'CIB School - Not Enrolled in Tribe'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'CIB_SCHY' THEN 'CIB School - Yes'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_506'   THEN '506 IE - Not Entered'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_506N'  THEN '506 IE - No'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_506R'  THEN '506 IE - Parent Refused'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_506Y'  THEN '506 IE - YES'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_CIB'   THEN 'CIB IE - Not Entered'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_CIBN'  THEN 'CIB IE - No'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_CIBR'  THEN 'CIB IE - Parent Refused'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_CIBX'  THEN 'CIB IE - Not Enrolled in Tribe'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'IE_CIBY'  THEN 'CIB IE - Yes'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'SCH_506'  THEN '506 School - Not Entered'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'SCH_506N' THEN '506 School - No'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'SCH_506R' THEN '506 School - Parent Refused'
		WHEN whats_on_file + permutation COLLATE DATABASE_DEFAULT = 'SCH_506Y' THEN  '506 School - YES'
	END program_name
	,'IE' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program
FROM
	(SELECT
		*
	 FROM [SMAXDBPROD].[PR].[DBTSIS].[NM021_V]  AS CIB_506
	) AS T1
/*whats_on_file is what the NM221 screen has in the column name we used in the main select) 
permutation is what's possible on the NM221 screen will return the original column headers  */
UNPIVOT (permutation FOR whats_on_file IN 
	([SCH_506]
	,[IE_506]
	,[IE_CIB]
	,[CIB_SCH]
	 )) AS Unpvt

UNION
--No CIB record at the school
SELECT
	'CIB_SCHNo' AS program_code	
	,'No NM221' AS program_name	
	,'IE' AS program_type_code	
	,'N' AS gifted_program	
	,'N' AS special_ed_program	
	,'N' AS lep_program

UNION
--No CIB record with the Indian Ed department
SELECT
	'IE_CIBNo' AS program_code	
	,'No NM221' AS program_name	
	,'IE' AS program_type_code	
	,'N' AS gifted_program	
	,'N' AS special_ed_program	
	,'N' AS lep_program

UNION
--No 506 record with the Indian Ed department
SELECT
	'IE_506No' AS program_code	
	,'No NM221' AS program_name	
	,'IE' AS program_type_code	
	,'N' AS gifted_program	
	,'N' AS special_ed_program	
	,'N' AS lep_program

UNION
--No 506 record at the School
SELECT
	'SCH_506No' AS program_code	
	,'No NM221' AS program_name	
	,'IE' AS program_type_code	
	,'N' AS gifted_program	
	,'N' AS special_ed_program	
	,'N' AS lep_program
UNION
--There is no NM221 record - this was added 1/20/2014
--so that we don't need artificially add 4 records to the program_ie_indian_heritage_documentation_sis stored procedure
--each time we run into a student that has no NM221 record.  We can just decode the null into "No NM221"
SELECT
	'No_NM221' AS program_code	
	,'No NM221' AS program_name	
	,'IE' AS program_type_code	
	,'N' AS gifted_program	
	,'N' AS special_ed_program	
	,'N' AS lep_program


UNION
/*Free and Reduced Lunch--FRLP*/
SELECT
	FRPL.ECON_ABBR collate database_default AS program_code 
	,FRPL.ECON_DESCR collate database_default AS program_name
	,'FRPL' AS program_type
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program
FROM
    SMAXDBPROD.PR .DBTSIS .CE085 AS FRPL WITH (NOLOCK) 
WHERE
    (FRPL.DST_NBR = 1 AND FRPL.ECON_ABBR <> 'Prior2')

UNION
/*Read from a file to get House and Senate districts*/
SELECT
      CASE
            WHEN district_type = 'Senate District' COLLATE DATABASE_DEFAULT  THEN 'SD-' + CAST([district_number] AS VARCHAR)
            WHEN district_type = 'House District' COLLATE DATABASE_DEFAULT  THEN 'HD-' + CAST([district_number] AS VARCHAR)
      END program_code
      ,CASE
            WHEN district_type = 'Senate District' COLLATE DATABASE_DEFAULT  THEN 'Senate District - ' + CAST([district_number] AS VARCHAR)
            WHEN district_type = 'House District' COLLATE DATABASE_DEFAULT  THEN 'House District - ' + CAST([district_number] AS VARCHAR)
      END program_name
      ,CASE
            WHEN district_type = 'Senate District' COLLATE DATABASE_DEFAULT  THEN 'Senate'
            WHEN district_type = 'House District' COLLATE DATABASE_DEFAULT  THEN 'House'
      END program_type_code
      ,'N' AS gifted_program
      ,'N' AS special_ed_program
      ,'N' AS lep_program
FROM 
	(SELECT
      [House District] COLLATE DATABASE_DEFAULT AS [House District]
      ,[Senate District]  COLLATE DATABASE_DEFAULT AS [Senate District]
	 FROM
		[180-SMAXODS-01].SchoolNetDevelopment.dbo.CongresionalDistricts
) AS T1
UNPIVOT (district_number FOR district_type IN
	([House District]
	 ,[Senate District]
)) AS Unpvt

/*The following are not in Schoolmax.  They need to be added manually*/  
UNION
--English Language Learner
SELECT
	'ELL' AS program_code
	,'English Language Learner' AS program_name
	,'ELL' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'Y' As lep_program
UNION
--SDS: 1/24/2014
--Added this recrod from ReportMax Code Program:
--	"NotServed","LCE Not Served","LCENot","N","N","N"
SELECT
	'NotServed' AS program_code
	,'LCE Not Served' AS program_name
	,'LCENot' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program

UNION
--ESL services Provided
SELECT
	'ESL-Y' AS program_code
	,'ESL Services Provided-Y' AS program_name
	,'ESL' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
--English Language Services refused
SELECT
	'ESL-R' AS program_code
	,'ESL Services Refused' AS program_name
	,'ESL-R' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
--Home Language Survey on NM230
SELECT
	'HLS-Y' AS program_code
	,'Home Language Survey-Y' AS program_name
	,'HLS' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
--Marked Homeless on CE220
SELECT
	'HomeL' AS program_code
	,'Homelss-Y' AS program_name
	,'Homel' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
--Marked PHLOTE on NM230
SELECT
	'PHLOT-Y' AS program_code
	,'PHLOTE-Y' AS program_name
	,'PHLOT' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
--Retained previous year (withdrawal code)
SELECT
	'Ret' AS program_code
	,'Retained-Yes' AS program_name
	,'Ret' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

/* Math and Reading Quartiles based on previous year's SBA*/
UNION
SELECT
	'MQ1' AS program_code
	,'Math Q1' AS program_name
	,'QTLM' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
SELECT
	'MQ3' AS program_code
	,'Math Q3' AS program_name
	,'QTLM' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program

UNION
SELECT
	'RQ1' AS program_code
	,'Reading Q1' AS program_name
	,'QTLR' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 

UNION
SELECT
	'RQ3' AS program_code
	,'Reading Q3' AS program_name
	,'QTLR' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 
/*End Quartile Programs Codes*/  

UNION
--a special ed student who recieves equipment through the ADA-504 act
--marked on HE210
SELECT
	'ADA-504' AS program_code
	,'ADA-504' AS program_name
	,'ADA-504' AS program_type_code
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' As lep_program 
	
UNION
--Asssessment Exemptions codes
SELECT
	'AE-HSG' AS program_code
	,'HSGA' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program
	
UNION
SELECT
	'AE-EoC' AS program_code
	,'EoC' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program	
	
UNION
SELECT
	'AE-SBA' AS program_code
	,'SBA' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program	
	
UNION
SELECT
	'AE-ACC' AS program_code
	,'ACCESS' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program	
	
UNION
SELECT
	'AE-Int' AS program_code
	,'INTERIM' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program	
	
UNION
SELECT
	'AE-PAR' AS program_code
	,'PARCC' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program		
	
UNION
SELECT
	'AE-HSCA' AS program_code
	,'HSCA' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program					
	
UNION
SELECT
	'AE-HSGA' AS program_code
	,'HSGA' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program		
	
UNION
SELECT
	'AE-Dis' AS program_code
	,'District Math Assessment' AS program_name
	,'AssEx' AS program_type_code	
	,'N' AS gifted_program
	,'N' AS special_ed_program
	,'N' AS lep_program		
-- End Assessment Exemptions													