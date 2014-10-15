

/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-09-04 $
 *
 */

 /*********************************************************************************************************************************
 THIS FUNCTION PULLS ALL TAGGED LCE CLASSES THAT HAVE A TEACHER WITH THE PROPER CREDENTIALS
	- this pulls all records for each school, course, section
	- all records for primary teacher and additional staff assigned
	- 0= primary staff, 1= additional staff
	-As Of Date is for the Credentials only
 **********************************************************************************************************************************/
  
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEClassesForBEPAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEClassesForBEPAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.LCEClassesForBEPAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT 
	ORGANIZATION_GU, COURSE_GU, SECTION_GU, STAFF_GU, ORGANIZATION_YEAR_GU, SCHOOL_YEAR_COURSE_GU, STAFF_SCHOOL_YEAR_GU, ADD_STAFF, TeacherESL,
	TeacherTESOL, TeacherBilingual, TeacherNavajo, TeacherBilingualWaiverOnly, TeacherTESOLWaiverOnly, ALSMA, ALSMP, ALS2W, ALSED,ALSSC, ALSSS, ALSSH, ALSLA, ALSES, ALSOT, ALSNV
 FROM (

 	SELECT 
		ORGANIZATION_GU
		,COURSE_GU
		,SECTION_GU
		,STAFF_GU
		,ORGANIZATION_YEAR_GU
		,SCHOOL_YEAR_COURSE_GU
		,STAFF_SCHOOL_YEAR_GU
		,ADD_STAFF

		,TeacherTESOL
		,TeacherESL
		,TeacherBilingual
		,TeacherNavajo
		,TeacherBilingualWaiverOnly
		,TeacherTESOLWaiverOnly

		,PIVOTME.ALSMA
		,PIVOTME.ALSMP
		,PIVOTME.ALS2W
		,PIVOTME.ALSED
		,PIVOTME.ALSSC
		,PIVOTME.ALSSS
		,PIVOTME.ALSSH
		,PIVOTME.ALSLA
		,PIVOTME.ALSES
		,PIVOTME.ALSOT
		,PIVOTME.ALSNV

		,ROW_NUMBER () OVER (PARTITION BY ORGANIZATION_GU, COURSE_GU, SECTION_GU ORDER BY ADD_STAFF) AS RN

	 FROM 
	 (
		SELECT 	
			ORGANIZATION_NAME
			,CRS.COURSE_ID
			,	SEC.SECTION_ID
			, TAGS.TAG
			,STAFF.BADGE_NUM
			,SCHTYP.SCHOOL_TYPE	
			,0 AS ADD_STAFF

			--FOR ELEMENTARY GRADE K-5, AN ELEMENTARY CREDENTIAL IS REQUIRED
			--FOR MIDDLE, EITHER AN ELEMENTARY OR SECONDARY APPLIES
			--FOR HIGH SCHOOL, ONLY SECONDARY APPLIES
			,CASE 
					WHEN SCHTYP.SCHOOL_TYPE = 1 THEN Creds.ElementaryTESOL 
					WHEN SCHTYP. SCHOOL_TYPE = 2 AND (Creds.ElementaryTESOL = 1 OR Creds.SecondaryTESOL = 1) THEN 1
					WHEN SCHTYP.SCHOOL_TYPE IN (3,4) THEN Creds.SecondaryTESOL 
					ELSE 0
			END 
			 AS TeacherTESOL

			 ,CASE 
					WHEN SCHTYP.SCHOOL_TYPE = 1 THEN Creds.ElementaryBilingual 
					WHEN SCHTYP.SCHOOL_TYPE= 2 AND (Creds.ElementaryBilingual = 1 OR Creds.SecondaryBilingual = 1) THEN 1
					WHEN SCHTYP.SCHOOL_TYPE  IN (3,4) THEN Creds.SecondaryBilingual 
					ELSE 0
				END 
				AS TeacherBilingual

			,CASE 
					WHEN SCHTYP.SCHOOL_TYPE  = 1 THEN Creds.ElementaryESL 
					WHEN SCHTYP.SCHOOL_TYPE= 2 AND (Creds.ElementaryESL = 1 OR Creds.SecondaryESL = 1) THEN 1
					WHEN SCHTYP.SCHOOL_TYPE  IN (3,4)THEN Creds.SecondaryESL 
					ELSE 0
				END 
				AS TeacherESL
			,Creds.Navajo AS TeacherNavajo
			,CASE 
					WHEN SCHTYP.SCHOOL_TYPE  = 1 THEN Creds.ElementaryBilingualWaiverOnly
					WHEN SCHTYP.SCHOOL_TYPE = 2 AND (Creds.ElementaryBilingualWaiverOnly = 1 OR Creds.SecondaryBilingualWaiverOnly = 1) THEN 1
					WHEN SCHTYP.SCHOOL_TYPE  IN (3,4) THEN Creds.SecondaryBilingualWaiverOnly 
					ELSE 0
			END 
			AS TeacherBilingualWaiverOnly

			,CASE 
					WHEN SCHTYP.SCHOOL_TYPE  = 1 THEN Creds.ElementaryTESOLWaiverOnly 
					WHEN SCHTYP.SCHOOL_TYPE = 2 AND (Creds.ElementaryTESOLWaiverOnly = 1 OR Creds.SecondaryTESOLWaiverOnly= 1) THEN 1
					WHEN SCHTYP.SCHOOL_TYPE  IN (3,4) THEN Creds.SecondaryTESOLWaiverOnly 
					ELSE 0
			END 
			AS TeacherTESOLWaiverOnly

			,CRS.COURSE_GU
			,SEC.SECTION_GU
			,STAFF.STAFF_GU
			,SECYR.ORGANIZATION_YEAR_GU
			,ORG.ORGANIZATION_GU
			,CRSYR.SCHOOL_YEAR_COURSE_GU
			,STAFFYR.STAFF_SCHOOL_YEAR_GU

	 FROM
		rev.UD_SECTION_TAG AS TAGS
		INNER JOIN
		rev.EPC_SCH_YR_SECT AS SEC
		ON
		TAGS.SECTION_GU = SEC.SECTION_GU
	
		INNER JOIN
		rev.EPC_SCH_YR_CRS AS CRSYR
		ON
		SEC.SCHOOL_YEAR_COURSE_GU = CRSYR.SCHOOL_YEAR_COURSE_GU
	
		INNER JOIN
		rev.EPC_CRS AS CRS
		ON
		CRSYR.COURSE_GU = CRS.COURSE_GU

		INNER JOIN
		rev.EPC_SCH_YR_SECT AS SECYR
		ON
		SECYR.ORGANIZATION_YEAR_GU = CRSYR.ORGANIZATION_YEAR_GU
		AND 
		SECYR.SECTION_GU = SEC.SECTION_GU

		INNER JOIN
		rev.EPC_STAFF_SCH_YR AS STAFFYR
		ON
		STAFFYR.STAFF_SCHOOL_YEAR_GU = SECYR.STAFF_SCHOOL_YEAR_GU
	
		INNER JOIN
		rev.EPC_STAFF AS STAFF
		ON
		STAFFYR.STAFF_GU = STAFF.STAFF_GU
	
		INNER JOIN
		rev.EPC_SCH_YR_OPT AS SCHTYP
		ON
		SCHTYP.ORGANIZATION_YEAR_GU = SECYR.ORGANIZATION_YEAR_GU

		INNER JOIN
		APS.LCETeacherEndorsementsAsOf(@AsOfDate) AS Creds
		ON
		Creds.STAFF_GU = STAFF.STAFF_GU

		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS ORGYR
		ON
		ORGYR.ORGANIZATION_YEAR_GU = CRSYR.ORGANIZATION_YEAR_GU

		INNER JOIN
		rev.REV_ORGANIZATION AS ORG
		ON
		ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

		WHERE
			--Elementary
			(
				SCHTYP.SCHOOL_TYPE IN (1,2)
				AND Creds.ElementaryESL = 1
			)
			OR 
			--Secondary
			(
			SCHTYP.SCHOOL_TYPE IN (2,3,4)
			AND (
			--secondary ESL
			(Creds.SecondaryESL = 1 AND TAG= 'ALSES')
			OR
			-- Secondary Bilingual
			(Creds.SecondaryBilingual= 1 AND (
			--Maintenance or 2WayDual Codes
			TAG= 'ALSMP' OR TAG= 'ALS2W'))
						)		
			)
			OR
			--Navajo endorsements
			(			
			Creds.Navajo = 1 
			AND 
				(
			--elementary navajo
			CRS.COURSE_ID ='12748008'
			OR
			--secondary navajo
			CRS.COURSE_ID LIKE '6111%'
					)
			)

	/**********************************************************************************************************************************************************************
	GET ADDITIONAL STAFF - same logic as above except different table for additional staff
	***********************************************************************************************************************************************************************/
	UNION
	
	SELECT 	
	
		ORGANIZATION_NAME
		,CRS.COURSE_ID
		,	SEC.SECTION_ID
		, TAGS.TAG
		,STAFF2.BADGE_NUM
		,SCHTYP.SCHOOL_TYPE	
		,1 

		--FOR ELEMENTARY GRADE K-5, AN ELEMENTARY CREDENTIAL IS REQUIRED
		--FOR MIDDLE, EITHER AN ELEMENTARY OR SECONDARY APPLIES
		--FOR HIGH SCHOOL, ONLY SECONDARY APPLIES
		,CASE 
				WHEN SCHTYP.SCHOOL_TYPE = 1 THEN Creds.ElementaryTESOL 
				WHEN SCHTYP. SCHOOL_TYPE = 2 AND (Creds.ElementaryTESOL = 1 OR Creds.SecondaryTESOL = 1) THEN 1
				WHEN SCHTYP.SCHOOL_TYPE IN (3,4) THEN Creds.SecondaryTESOL 
				ELSE 0
		END 
		 AS TeacherTESOL

		 ,CASE 
				WHEN SCHTYP.SCHOOL_TYPE = 1 THEN Creds.ElementaryBilingual 
				WHEN SCHTYP.SCHOOL_TYPE= 2 AND (Creds.ElementaryBilingual = 1 OR Creds.SecondaryBilingual = 1) THEN 1
				WHEN SCHTYP.SCHOOL_TYPE  IN (3,4) THEN Creds.SecondaryBilingual 
				ELSE 0
			END 
			AS TeacherBilingual

		,CASE 
				WHEN SCHTYP.SCHOOL_TYPE  = 1 THEN Creds.ElementaryESL 
				WHEN SCHTYP.SCHOOL_TYPE= 2 AND (Creds.ElementaryESL = 1 OR Creds.SecondaryESL = 1) THEN 1
				WHEN SCHTYP.SCHOOL_TYPE  IN (3,4)THEN Creds.SecondaryESL 
				ELSE 0
			END 
			AS TeacherESL


		,Creds.Navajo AS TeacherNavajo

			,CASE 
				WHEN SCHTYP.SCHOOL_TYPE  = 1 THEN Creds.ElementaryBilingualWaiverOnly
				WHEN SCHTYP.SCHOOL_TYPE = 2 AND (Creds.ElementaryBilingualWaiverOnly = 1 OR Creds.SecondaryBilingualWaiverOnly = 1) THEN 1
				WHEN SCHTYP.SCHOOL_TYPE  IN (3,4) THEN Creds.SecondaryBilingualWaiverOnly 
				ELSE 0
			END 
			AS TeacherBilingualWaiverOnly

			,CASE 
				WHEN SCHTYP.SCHOOL_TYPE  = 1 THEN Creds.ElementaryTESOLWaiverOnly 
				WHEN SCHTYP.SCHOOL_TYPE = 2 AND (Creds.ElementaryTESOLWaiverOnly = 1 OR Creds.SecondaryTESOLWaiverOnly= 1) THEN 1
				WHEN SCHTYP.SCHOOL_TYPE  IN (3,4) THEN Creds.SecondaryTESOLWaiverOnly 
				ELSE 0
			END 
			AS TeacherTESOLWaiverOnly
		
		,CRS.COURSE_GU
		,SEC.SECTION_GU
		,STAFF2.STAFF_GU
		,SECYR.ORGANIZATION_YEAR_GU
		,ORG.ORGANIZATION_GU
		,CRSYR.SCHOOL_YEAR_COURSE_GU
		,ADDSTAFF.STAFF_SCHOOL_YEAR_GU

	FROM
	rev.UD_SECTION_TAG AS TAGS
	INNER JOIN
	rev.EPC_SCH_YR_SECT AS SEC
	ON
	TAGS.SECTION_GU = SEC.SECTION_GU
	
	INNER JOIN
	rev.EPC_SCH_YR_CRS AS CRSYR
	ON
	SEC.SCHOOL_YEAR_COURSE_GU = CRSYR.SCHOOL_YEAR_COURSE_GU
	
	INNER JOIN
	rev.EPC_CRS AS CRS
	ON
	CRSYR.COURSE_GU = CRS.COURSE_GU

	INNER JOIN
	rev.EPC_SCH_YR_SECT AS SECYR
	ON
	SECYR.ORGANIZATION_YEAR_GU = CRSYR.ORGANIZATION_YEAR_GU
	AND 
	SECYR.SECTION_GU = SEC.SECTION_GU
	
	INNER JOIN
	rev.EPC_SCH_YR_SECT_STF AS ADDSTAFF
	ON
	ADDSTAFF.SECTION_GU = SEC.SECTION_GU

	INNER JOIN
	rev.EPC_STAFF_SCH_YR AS STAFFYR2
	ON
	STAFFYR2.STAFF_SCHOOL_YEAR_GU = ADDSTAFF.STAFF_SCHOOL_YEAR_GU

	INNER JOIN
	rev.EPC_STAFF AS STAFF2
	ON
	STAFF2.STAFF_GU = STAFFYR2.STAFF_GU
	
	
	INNER JOIN
	rev.EPC_SCH_YR_OPT AS SCHTYP
	ON
	SCHTYP.ORGANIZATION_YEAR_GU = SECYR.ORGANIZATION_YEAR_GU

	INNER JOIN
	APS.LCETeacherEndorsementsAsOf(@AsOfDate) AS Creds
	ON
	Creds.STAFF_GU = STAFF2.STAFF_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS ORGYR
	ON
	ORGYR.ORGANIZATION_YEAR_GU = CRSYR.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS ORG
	ON
	ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	WHERE
		--Elementary
		  (
			SCHTYP.SCHOOL_TYPE IN (1,2)
			AND Creds.ElementaryESL = 1
			)
	
	OR 
			--Secondary
			(
			SCHTYP.SCHOOL_TYPE IN (2,3,4)
			AND (
			--secondary ESL
			(Creds.SecondaryESL = 1 AND TAG= 'ALSES')
			OR
			-- Secondary Bilingual
			(Creds.SecondaryBilingual= 1 AND (
			--Maintenance or 2WayDual Codes
			TAG= 'ALSMP' OR TAG= 'ALS2W'))
						)		
			)
	OR
			--Navajo endorsements
			(			
			Creds.Navajo = 1 
			AND 
				(
			--elementary navajo
			CRS.COURSE_ID ='12748008'
			OR
			--secondary navajo
			CRS.COURSE_ID LIKE '6111%'
				)
			)

	) AS ALLQUALIFIEDSTAFF


PIVOT
(
MAX(TAG)
FOR TAG IN ([ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV])
)
AS PIVOTME

) AS QUALTEACH
--only need 1 record, the qualifying teacher, if both are qualified choose primary teacher
WHERE
RN = 1