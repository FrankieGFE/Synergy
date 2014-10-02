
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEClassesUniqueAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEClassesUniqueAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.LCEClassesUniqueAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

SELECT 
	ORGANIZATION_GU
	,COURSE_GU
	,SECTION_GU
	,STAFF_GU
	,ORGANIZATION_YEAR_GU
	,SCHOOL_YEAR_COURSE_GU
	,STAFF_SCHOOL_YEAR_GU
	,ADD_STAFF
 FROM 
	(
 	SELECT 
		ORGANIZATION_GU
		,COURSE_GU
		,SECTION_GU
		,STAFF_GU
		,ORGANIZATION_YEAR_GU
		,SCHOOL_YEAR_COURSE_GU
		,STAFF_SCHOOL_YEAR_GU

		--need one record per school/course/sec, primary teacher first
		,ROW_NUMBER () OVER (PARTITION BY ORGANIZATION_GU, COURSE_GU, SECTION_GU ORDER BY ADD_STAFF) AS RN
		,ADD_STAFF

	 FROM 
		APS.LCEClassesAllAsOf (@AsOfDate)

) AS ROWNUMBERSTAFF

--GET ONE TEACHER PER COURSE/SEC
--PRIMARY TEACHER TRUMPS ADDITIONAL STAFF
WHERE
	RN = 1