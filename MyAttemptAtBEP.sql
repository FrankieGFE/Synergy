DECLARE @AsOfDate datetime2 = getdate()		
				
;with Main as
(	
		SELECT 
		
				Organization.ORGANIZATION_NAME AS School
				,Staff.BADGE_NUM AS Badge
				,person.LAST_NAME + ', '+ person.FIRST_NAME + COALESCE(' ' +MIDDLE_NAME,'') AS TeacherName
				,Staff.HIRE_DATE

				,Schedules.COURSE_ID AS Course
				,Schedules.SECTION_ID AS Section
				,Schedules.COURSE_TITLE AS CourseTitle
				
				--Endorsements 
				,CASE WHEN BEP2.COURSE_LEVEL = 'ESL' AND BEP2.QUALIFIED = 'Y' THEN 'ESL' END AS ESL
				,CASE WHEN BEP2.COURSE_LEVEL = 'BEP' AND BEP2.QUALIFIED = 'Y' THEN 'BEP' END AS BEP
				,CASE WHEN BEP2.COURSE_LEVEL = 'BEP' AND BEP2.COURSE_LEVEL = 'ESL' AND BEP2.QUALIFIED = 'Y' THEN 'ESL/BEP' END AS ESL_BEP
				
				--Identify which students are Bilingual, if student exists in BEP table then bilingual
				,(CASE WHEN BEP.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS BilingualStudent
				
				--Identify which students are ESL, if student is ELL then ESL
				,(CASE WHEN  ELL.STUDENT_GU IS NOT NULL THEN 1 ELSE 0 END) AS ESLStudent

				--,Organization.ORGANIZATION_GU

		 FROM
	
			/**********************************************************************************************
			*	Pull ALL Sections and ALL teachers/staff assigned to sections where they are endorsed
			*  Identify which sections are LCE Classes
			***********************************************************************************************/
	
			APS.SectionsAndAllStaffAssignedAsOf(@AsOfDate) AS AllStaff
			INNER JOIN
			APS.LCETeacherEndorsements AS Endorsed
			on
			AllStaff.STAFF_GU = Endorsed.STAFF_GU

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
			APS.ELLCalculatedAsOf (@AsOfDate) AS ELL
			ON
			Schedules.STUDENT_GU = ELL.STUDENT_GU

			LEFT JOIN 
			rev.EPC_STU_PGM_ELL_BEP AS BEP 
			ON
			BEP.STUDENT_GU = Schedules.STUDENT_GU
			AND BEP.EXIT_DATE IS NULL

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

			inner join
			APS.NewBEPModelsAndHoursDetailsAsOf(GETDATE()) AS BEP2
			on
			Schedules.SIS_NUMBER = BEP2.SIS_NUMBER
			

			WHERE Organization.ORGANIZATION_NAME = 'East San Jose Elementary School'
)
,Sub 
as
(
SELECT
	row_number() over(partition by badge, course, section order by badge) as RN,
	school,
	badge,
	TeacherName,
	HIRE_DATE,
	course,
	section,
	CourseTitle,
	BilingualStudent,
	ESLStudent,
	xyz,
	abc
FROM
	Main
UNPIVOT
	(xyz for abc in ([ESL], [BEP])
	) as bus
)
select
	SCHOOL,
	BADGE,
	TeacherName,
	HIRE_DATE,
	COURSE,
	SECTION,
	--Course_Title,
	SUM(BilingualStudent),
	SUM(ESLStudent),
	XYZ,
	ABC
from 
	Sub
 where rn = 1
GROUP BY 
	SCHOOL 
	,Badge 
	,TeacherName
	,HIRE_DATE
	,Course
	,Section
	,xyz
	,abc
	,BilingualStudent
	,ESLStudent
	
				--,Organization.ORGANIZATION_GU





	