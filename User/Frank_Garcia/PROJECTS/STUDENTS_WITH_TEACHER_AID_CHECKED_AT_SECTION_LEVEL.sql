

SELECT 
	PER.FIRST_NAME
	,PER.LAST_NAME
	--,STU.SIS_NUMBER
	,STU.STATE_STUDENT_NUMBER
	,CRS.COURSE_ID
	,grade.VALUE_DESCRIPTION AS GRADE
	,CRS.STATE_COURSE_CODE
	,TPER.FIRST_NAME AS TEACHER_FN
	,TPER.LAST_NAME AS TEACHER_LN
	,Section.SECTION_ID
	,ORG.ORGANIZATION_NAME
	,CLASS.TEACHER_AIDE

	
FROM
	-- Get all Scheduled Classes
	rev.[EPC_STU_CLASS] AS [Class]
	
	-- Get all Scheduled Sections
	INNER JOIN 
	rev.[EPC_SCH_YR_SECT] AS [Section]

	ON [Class].[SECTION_GU] = [Section].[SECTION_GU]
	
	-- Get all Courses for Each School Year
	INNER JOIN 
	rev.[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
	ON [Section].[SCHOOL_YEAR_COURSE_GU] = [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]

	JOIN
	REV.EPC_CRS AS CRS
	ON CRS.COURSE_GU = SchoolYearCourse.COURSE_GU
	
	-- Get all Schools for each Year
	INNER JOIN
	rev.[REV_ORGANIZATION_YEAR] AS [OrgYear]
	ON [Section].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	-- Get all Staff for each Year
	LEFT OUTER JOIN
	rev.[EPC_STAFF_SCH_YR] AS [StaffSchoolYear]
	ON
	[Section].[STAFF_SCHOOL_YEAR_GU] = [StaffSchoolYear].[STAFF_SCHOOL_YEAR_GU]
	
	-- Get all enrolled Students for each Year
	LEFT OUTER JOIN
	rev.[EPC_STU_SCH_YR] AS [StudentSchoolYear] -- Contains Grade and Start Date 	
	ON
	[Class].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]

	JOIN
	REV.EPC_STU AS STU
	ON STU.STUDENT_GU = [StudentSchoolYear].STUDENT_GU


	JOIN REV.REV_PERSON AS TPER
	ON TPER.PERSON_GU = StaffSchoolYear.STAFF_GU

       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR            SOR  ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE


	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--READ SCHOOL SETUP TO GET TEACHER AIDE COURSE NUMBER (INSTEAD OF CLASS COURSE NUMBER) FOR SCHOOL AND SCHOOL YEAR
	LEFT HASH JOIN
	rev.EPC_SCH_YR_OPT AS SYOPT
	ON
	SYOPT.ORGANIZATION_YEAR_GU = Section.ORGANIZATION_YEAR_GU

	LEFT HASH JOIN
	rev.EPC_SCH_YR_CRS AS TEACHERAIDE
	ON
	TEACHERAIDE.SCHOOL_YEAR_COURSE_GU = SYOPT.SCHOOL_YEAR_COURSE_GU


	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WHERE 1 = 1
AND SCHOOL_YEAR = '2016'
AND CLASS.TEACHER_AIDE = 'Y'

ORDER BY ORGANIZATION_NAME, STU.SIS_NUMBER

GO


