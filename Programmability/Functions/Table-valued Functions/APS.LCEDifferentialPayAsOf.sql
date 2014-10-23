

/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 */

 /***************************************************************************************************************************************
 THIS FUNCTION PULLS ALL TEACHERS FOR DIFF PAY THAT HAVE AN ESL OR BILINGUAL ENDORSEMENT
 *DIFF PAY TYPE VALUE IS NULL WHEN CLASS DOES NOT MEET CRITERIA (TAGS OR ENDORSEMENTS) FOR PAYMENT (A OR B)
 ****************************************************************************************************************************************/
 
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCEDifferentialPayAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCEDifferentialPayAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.LCEDifferentialPayAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN

--DECLARE @AsOfDate DATE = GETDATE()

SELECT
	School
	,Badge
	,TeacherName
	,PrimaryTeacher
	,Course
	,Section
	,CourseTitle

	--All the tags for each section
	,[ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV]

	,TeacherBilingual
	
	--use this as temporary because Teacher Endorsements is showing ESL 1 for teachers with no TESOL
	,TeacherTESOL AS TeacherESL
	,BilingualStudent
	,ESLStudent
	,PotentialTypeA
	,PotentialTypeB

FROM
(

SELECT 

	School
	,Badge
	,TeacherName
	,PrimaryTeacher
	,Course
	,Section
	,CourseTitle

	--All the tags for each section
	,[ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV]

	,TeacherBilingual
	,TeacherESL
	,TeacherTESOL

	,BilingualStudent
	,ESLStudent
		
	--Differential Pay Types
	,CASE 
		-- Diff Pay A are ESL Only teachers... must have an ESL endorsement and at least one qualified student. No waivers permitted
		WHEN MAX(TeacherTESOL) = 1 
			AND SUM(ESLStudent) > 0 
			AND MAX(TeacherTESOLWaiverOnly) != 1 
			--added where classes are tagged ESL for ESL
			AND (CASE WHEN ALSES = 'ALSES'  THEN 1 ELSE 0 END) = 1
			THEN 1
		ELSE 0
				END AS PotentialTypeA

	-- Diff Pay B are Bilingual teachers Only teachers... must have an Bilingual endorsement and at least one qualified student. No waivers permitted
	,CASE	
		WHEN MAX(TeacherBilingual) = 1 
			AND SUM(BilingualStudent) > 0 
			AND MAX(TeacherBilingualWaiverOnly) != 1 
			--added where classes are not tagged ELD, ESL or Sheltered Content for Bilingual
			AND (CASE WHEN ((ALSMA = 'ALSMA') OR (ALSMP = 'ALSMP') OR (ALS2W = 'ALS2W') OR (ALSSC = 'ALSSC') OR (ALSSS = 'ALSSS') OR (ALSLA = 'ALSLA') OR (ALSOT = 'ALSOT') OR (ALSNV = 'ALSNV')) THEN 1 ELSE 0 END)= 1
			THEN 1
	ELSE 0
				END AS PotentialTypeB

FROM

(
		SELECT 
		
				ORGANIZATION_NAME AS School
				,Staff.BADGE_NUM AS Badge
				,LAST_NAME + ', '+ FIRST_NAME + COALESCE(' ' +MIDDLE_NAME,'') AS TeacherName
				,PRIMARY_TEACHER AS PrimaryTeacher

				,Schedules.COURSE_ID AS Course
				,Schedules.SECTION_ID AS Section
				,Schedules.COURSE_TITLE AS CourseTitle

				--All the tags for each section
				,[ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV]
				
				--Endorsements need to be seperated by School Type for Elementary and Secondary
				,CASE WHEN (Endorsed.ElementaryBilingual=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryBilingual=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END AS TeacherBilingual				
				,CASE WHEN (Endorsed.ElementaryESL=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryESL=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END AS TeacherESL
				,CASE WHEN (Endorsed.ElementaryTESOL=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryTESOL=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END AS TeacherTESOL
				,CASE WHEN (Endorsed.ElementaryTESOLWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryTESOLWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END AS TeacherTESOLWaiverOnly
				,CASE WHEN (Endorsed.ElementaryBilingualWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryBilingualWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END AS TeacherBilingualWaiverOnly
				
				--Identify which students are Bilingual, if student exists in BEP table then bilingual
				,SUM(CASE WHEN BEP.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS BilingualStudent

				--Identify which students are ESL, if student is ELL then ESL
				,SUM(CASE WHEN  ELL.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS ESLStudent

		 FROM
	
			/**********************************************************************************************
			*	Pull ALL Sections and ALL teachers/staff assigned to sections where they are endorsed
			*  Identify which sections are LCE Classes
			***********************************************************************************************/
	
			APS.SectionsAndAllStaffAssigned AS AllStaff
			INNER JOIN
			APS.LCETeacherEndorsementsAsOf (@AsOfDate) AS Endorsed
			ON
			ALLSTAFF.STAFF_GU = ENDORSED.STAFF_GU
			--need to get qualified LCE Teacher credentials
			LEFT JOIN
			APS.SectionsAndAllTags AS Tags
			ON
			AllStaff.SECTION_GU = Tags.SECTION_GU

			/**********************************************************************************************
			*	Pull all Students schedules (to see if any ESL or BEP students are in those classes 
				that are not identified as an LCE Class)
			*  Identify which students are ELL
			*	Identify which students are BEP
			***********************************************************************************************/
	
			LEFT JOIN
			APS.ScheduleAsOf (@AsOfDate) AS Schedules
			ON
			Schedules.SECTION_GU = AllStaff.SECTION_GU
	
			LEFT JOIN
			APS.ELLAsOf (@AsOfDate) AS ELL
			ON
			Schedules.STUDENT_GU = ELL.STUDENT_GU

			LEFT JOIN 
			rev.EPC_STU_PGM_ELL_BEP AS BEP
			ON
			BEP.STUDENT_GU = Schedules.STUDENT_GU

			/***********************************************************************************************
			*Get additional data, school name, badge number, teacher name, school type		
			***********************************************************************************************/	
	
			INNER JOIN 
			rev.REV_ORGANIZATION AS Organization
			ON
			Schedules.ORGANIZATION_GU = Organization.ORGANIZATION_GU		

			LEFT JOIN
			rev.REV_PERSON AS Person
			ON
			Person.PERSON_GU = AllStaff.STAFF_GU

			LEFT JOIN
			rev.EPC_STAFF AS Staff
			ON
			Staff.STAFF_GU = AllStaff.STAFF_GU

			INNER JOIN
			rev.EPC_SCH_YR_OPT AS SchoolType
			ON
			SchoolType.ORGANIZATION_YEAR_GU = Schedules.ORGANIZATION_YEAR_GU


			/**********************************************************************************************
			*	Get one record per School and Section
			**********************************************************************************************/
				

			GROUP BY 
				ORGANIZATION_NAME 
				,Staff.BADGE_NUM 
				,LAST_NAME + ', '+ FIRST_NAME + COALESCE(' ' +MIDDLE_NAME,'') 
				,PRIMARY_TEACHER
			
				,Schedules.COURSE_ID
				,Schedules.SECTION_ID
				,Schedules.COURSE_TITLE

				,[ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV]

				,CASE WHEN (Endorsed.ElementaryBilingual=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryBilingual=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END 		
				,CASE WHEN (Endorsed.ElementaryESL=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryESL=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END 
				,CASE WHEN (Endorsed.ElementaryTESOL=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryTESOL=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END 
				,CASE WHEN (Endorsed.ElementaryTESOLWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryTESOLWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END 
				,CASE WHEN (Endorsed.ElementaryBilingualWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (1,2)) OR (Endorsed.SecondaryBilingualWaiverOnly=1 AND SchoolType.SCHOOL_TYPE IN (2,3,4)) THEN 1 ELSE 0 END


) AS AllSectionsEndorsed

GROUP BY
			School
			,Badge
			,TeacherName
			,PrimaryTeacher
			,Course
			,Section
			,CourseTitle

			,[ALSMA], [ALSMP],[ALS2W], [ALSED], [ALSSC], [ALSSS], [ALSSH], [ALSLA], [ALSES], [ALSOT], [ALSNV]

			,TeacherBilingual
			,TeacherESL

			,TeacherTESOL
			,BilingualStudent
			,ESLStudent

) AS PotentialDiffPay

	WHERE
	TeacherTESOL + TeacherBilingual > 0
		