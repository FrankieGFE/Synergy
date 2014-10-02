
/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 */

 /*********************************************************************************************************************************
 THIS FUNCTION PULLS ALL TAGGED LCE CLASSES THAT HAVE A TEACHER WITH THE PROPER CREDENTIALS
	- this pulls one record per school, course, section
	- primary teacher trumps additional staff
	-As Of Date is for the Credentials only
 **********************************************************************************************************************************/
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEClassesAllDetailAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEClassesAllDetailAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.LCEClassesAllDetailAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

 	SELECT 
			ORGANIZATION_NAME
			,COURSE_ID
			,SECTION_ID
			,BADGE_NUM

		--need one record per school/course/sec, primary teacher first
		,ROW_NUMBER () OVER (PARTITION BY ORGANIZATION_NAME, COURSE_ID, SECTION_ID ORDER BY ADD_STAFF) AS RN
		,ADD_STAFF

		
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
			

	 FROM 
		APS.LCEClassesAllAsOf (GETDATE()) AS LCE
		
		INNER JOIN
		rev.EPC_SCH_YR_SECT AS SEC
		ON
		LCE.SECTION_GU = SEC.SECTION_GU
		
		INNER JOIN
		rev.EPC_CRS AS CRS
		ON
		CRS.COURSE_GU = LCE.COURSE_GU
		
		INNER JOIN
		rev.EPC_STAFF AS STAFF
		ON
		LCE.STAFF_GU = STAFF.STAFF_GU

			INNER JOIN
		rev.REV_ORGANIZATION AS ORG
		ON
		LCE.ORGANIZATION_GU = ORG.ORGANIZATION_GU

		INNER JOIN
		APS.LCETeacherEndorsementsAsOf(GETDATE()) AS Creds
		ON
		Creds.STAFF_GU = LCE.STAFF_GU

		INNER JOIN
		rev.EPC_SCH_YR_OPT AS SCHTYP
		ON
		SCHTYP.ORGANIZATION_YEAR_GU = LCE.ORGANIZATION_YEAR_GU
		
