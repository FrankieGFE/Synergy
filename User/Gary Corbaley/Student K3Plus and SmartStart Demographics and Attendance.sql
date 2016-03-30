



	SELECT --DISTINCT
		[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STATE_STUDENT_NUMBER]
		,[STUDENT].[LAST_NAME] AS [STUDENT FIRST NAME]
		,[STUDENT].[FIRST_NAME] AS [STUDENT LAST NAME]
		,[STUDENT].[GENDER] AS [STUDENT GENDER]
		--,[STUDENT].[HISPANIC_INDICATOR]
		--,[STUDENT].[RACE_1]
		--,[STUDENT].[RACE_2]
		--,[STUDENT].[RACE_3]
		--,[STUDENT].[RACE_4]
		--,[STUDENT].[RACE_5]
		,[STUDENT].[RESOLVED_RACE]
		,[STUDENT].[LUNCH_STATUS]
		,[STUDENT].[ELL_STATUS]
		,[STUDENT].[SPED_STATUS]
		,[STUDENT].[PRIMARY_DISABILITY_CODE]
		--,[StudentSchoolYear].[GRADE]
		,[ENROLLMENT_2010].[GRADE] AS [2010_GRADE_LEVEL]
		--,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
		,[CURRENT_ENROLLMENTS].[GRADE] AS [CURRENT_GRADE_LEVEL]
		--,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		,[CURRENT_ENROLLMENTS].[SCHOOL_CODE] --AS [SUMMER SCHOOL NUMBER]
		,[CURRENT_ENROLLMENTS].[SCHOOL_NAME]
		,[CURRENT_ENROLLMENTS].[SCHOOL_YEAR]
		,[CURRENT_ENROLLMENTS].[EXTENSION]
		,[StudentSchoolYear].[ENTER_DATE] AS [DATE ENROLLED]
		,[StudentSchoolYear].[LEAVE_DATE] AS [DATE DROPPED]
		,CASE WHEN [ATTENDANCE_TOTALS].[EXCUSED] IS NULL THEN 0 ELSE [ATTENDANCE_TOTALS].[EXCUSED] END AS [EXCUSED ABSENCES]
		,CASE WHEN [ATTENDANCE_TOTALS].[UNEXCUSED] IS NULL THEN 0 ELSE [ATTENDANCE_TOTALS].[UNEXCUSED] END AS [UNEXCUSED ABSENCES]
		,[DISTRICT_COURSE].[COURSE_ID] AS [SUMMER COURSE]
		,[DISTRICT_COURSE].[STATE_COURSE_CODE]
		,[SCHEDULE].[SECTION_ID] --AS [SUMMER SECTION]
		,[SCHEDULE].[TERM_CODE]
		,[DISTRICT_COURSE].[COURSE_TITLE] --AS [SUMMER COURSE NAME]
		,[DISTRICT_COURSE].[DEPARTMENT] --AS [SUMMER DEPARTMENT]
		--,[DISTRICT_COURSE].[SUBJECT_AREA_1]
		--,SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [SUMMER EMPLOYEE ID]
		--,[PERSON].[LAST_NAME] AS [SUMMER TEACHER FIRST NAME]
		--,[PERSON].[FIRST_NAME] AS [SUMMER SUMMER TEACHER LAST NAME]
		--,CASE 
		--	WHEN [School].[SCHOOL_CODE] IN ('207','228','339','236','219','230','273','336','260','307','309','275','363') AND [Grades].[VALUE_DESCRIPTION] IN ('02','03') THEN 'StartSmart Schools' 
		--	WHEN [School].[SCHOOL_CODE] IN ('228','339','236','273','336','309','275','363') AND [Grades].[VALUE_DESCRIPTION] IN ('K','01') THEN 'StartSmart school which added K3+ Program Summer 2013' 
		--	WHEN [School].[SCHOOL_CODE] IN ('206','210','225','244','249','252','262','255','258','261','270','395','279','231','282','285','288','297','300','324','330','370','376','379') AND [Grades].[VALUE_DESCRIPTION] IN ('K','01','02','03','04','05') THEN 'K3+ Schools (original)' 
		--	WHEN [School].[SCHOOL_CODE] IN ('215','291','250') AND [Grades].[VALUE_DESCRIPTION] IN ('K','01','02','03') THEN 'K3+ Schools new to program 2013' 
		--	WHEN [School].[SCHOOL_CODE] IN ('207','229','237','303','373','305','310','327','392','280','264') AND [Grades].[VALUE_DESCRIPTION] IN ('K','01','02','03') THEN 'K3+ Schools new to program 2014' 
		--	WHEN [School].[SCHOOL_CODE] IN ('329','216','276','317') THEN 'Exploritory Summer Learning Program' 
		--END AS [Summer Program]	
		
		--,CASE
		--  WHEN [SCHEDULE].[SECTION_ID] BETWEEN '2000' AND '2999' THEN 'K3+'   
  --        WHEN [SCHEDULE].[SECTION_ID] BETWEEN '3000' AND '3999' THEN 'Remedial'  
  --        WHEN [SCHEDULE].[SECTION_ID] BETWEEN '5000' AND '5999' THEN 'StartSmart'  	
  --      END AS [PROGRAM CHECK]
        
        ,[K3+] = CASE WHEN [CURRENT_ENROLLMENTS].[EXTENSION] IN ('S','N') AND [SCHEDULE].[SECTION_ID] BETWEEN '2000' AND '2999' THEN '1' ELSE '0' END
        ,[StartSmart] = CASE WHEN [CURRENT_ENROLLMENTS].[EXTENSION] IN ('S','N') AND [SCHEDULE].[SECTION_ID] BETWEEN '5000' AND '5999' THEN '1' ELSE '0' END
        --,[Remedial] = CASE WHEN [SCHEDULE].[SECTION_ID] BETWEEN '3000' AND '3999' OR [SCHEDULE].[SECTION_ID] BETWEEN '0000' AND '1999' OR ([SCHEDULE].[SECTION_ID] BETWEEN '4000' AND '4999' AND [School].[SCHOOL_CODE] = '288') THEN '1' ELSE '0' END
        --,[Into the Wild] = CASE WHEN [SCHEDULE].[SECTION_ID] BETWEEN '4000' AND '4999' AND [School].[SCHOOL_CODE] IN ('329','317') THEN '1' ELSE '0' END
        --,[Healthy Body Workshop] = CASE WHEN [SCHEDULE].[SECTION_ID] BETWEEN '4000' AND '4999' AND [School].[SCHOOL_CODE] IN ('216','276') THEN '1' ELSE '0' END
		
        --,[CurrentSPED].[PRIMARY_DISABILITY_CODE]
        --,[CurrentSPED].[SECONDARY_DISABILITY_CODE]
        
        --,CASE WHEN [ELL].[STUDENT_GU] IS NOT NULL THEN 'Y' ELSE 'N' END AS [ELL_STAT]
        --,[ELL].[ENTER_DATE] AS [ELL_ENTER_DATE]
		
		--,[School_Now].[SCHOOL_CODE] AS [2015 SCHOOL NUMBER]
		--,[Organization_Now].[ORGANIZATION_NAME] AS [2015 SCHOOL NAME]
		--,[Grades_Now].[VALUE_DESCRIPTION] AS [2015 GRADE LEVEL]
		
		--,[DISTRICT_COURSE].*
		
	FROM
		APS.PrimaryEnrollmentDetailsAsOf('05/20/2011') AS [ENROLLMENT_2010]
		---------------------------------------------------------------------
		-- Enrollment Information
		
		LEFT OUTER JOIN
		APS.StudentEnrollmentDetails AS [CURRENT_ENROLLMENTS]
		ON
		[ENROLLMENT_2010].[STUDENT_GU] = [CURRENT_ENROLLMENTS].[STUDENT_GU]
		
		LEFT OUTER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 
		ON
		[CURRENT_ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
				
		--LEFT OUTER JOIN 
		--rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		--ON 
		--[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		--LEFT OUTER JOIN 
		--rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		--ON 
		--[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		--LEFT OUTER JOIN 
		--rev.REV_YEAR AS [RevYear] -- Contains the School Year
		--ON 
		--[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		--LEFT OUTER JOIN 
		--rev.EPC_SCH AS [School] -- Contains the School Code / Number
		--ON 
		--[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]	
		
		--LEFT OUTER JOIN
		--rev.[EPC_SCH_YR_OPT] AS [SCHOOL_YEAR_OPTION]
		--ON
		--[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [SCHOOL_YEAR_OPTION].[ORGANIZATION_YEAR_GU]
		
		-----------------------------------------------------------------------------
		-- Student Demographics
		
		LEFT OUTER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[CURRENT_ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		--LEFT OUTER JOIN
		--APS.LookupTable('K12','Grade') AS [Grades]
		--ON
		--[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
		-----------------------------------------------------------------
		-- Student Schedules
		
		LEFT OUTER JOIN
		APS.BasicSchedule AS [SCHEDULE]
		ON
		[CURRENT_ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [SCHEDULE].[STUDENT_SCHOOL_YEAR_GU]		
		--AND ([SCHEDULE].[SECTION_ID] BETWEEN '2000' AND '2999' OR [SCHEDULE].[SECTION_ID] BETWEEN '5000' AND '5999')
		--OR [RevYear].[EXTENSION] IN ('S','N')
		
		LEFT OUTER JOIN
		rev.[EPC_CRS] AS [DISTRICT_COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [DISTRICT_COURSE].[COURSE_GU]
		
		--LEFT OUTER JOIN
		--rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
		--ON
		--[SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		
		--LEFT OUTER JOIN
		--rev.[EPC_STAFF] AS [STAFF]
		--ON
		--[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
	    
		--INNER JOIN
		--rev.[REV_PERSON] AS [PERSON]
		--ON
		--[STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
		
		---------------------------------------------------------------------------------------------
		-- Student Attendance
		LEFT OUTER JOIN
		(
		SELECT
			[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU]
			,SUM(CASE WHEN [ABSENCE_REASON_CODE].[TYPE] = 'EXC' THEN 1 ELSE 0 END) AS [EXCUSED]
			,SUM(CASE WHEN [ABSENCE_REASON_CODE].[TYPE] = 'UNV' OR [ABSENCE_REASON_CODE].[TYPE] = 'UNE' THEN 1 ELSE 0 END) AS [UNEXCUSED]
		FROM 
			rev.[EPC_STU_ENROLL] AS [EnrollmentDetails] -- Contains Grade and Start Date

			INNER JOIN
			rev.[EPC_STU_ATT_DAILY] AS [DAILY_ATTENDANCE]
			ON
			[EnrollmentDetails].[ENROLLMENT_GU] = [DAILY_ATTENDANCE].[ENROLLMENT_GU]
			
			LEFT OUTER JOIN
			rev.[EPC_CODE_ABS_REAS_SCH_YR] AS [ABSENCE_REASON]
			ON
			[DAILY_ATTENDANCE].[CODE_ABS_REAS1_GU] = [ABSENCE_REASON].[CODE_ABS_REAS_SCH_YEAR_GU]
			OR
			[DAILY_ATTENDANCE].[CODE_ABS_REAS2_GU] = [ABSENCE_REASON].[CODE_ABS_REAS_SCH_YEAR_GU]
			
			LEFT OUTER JOIN
			rev.[EPC_CODE_ABS_REAS] AS [ABSENCE_REASON_CODE]
			ON
			[ABSENCE_REASON].[CODE_ABS_REAS_GU] = [ABSENCE_REASON_CODE].[CODE_ABS_REAS_GU]
			
		WHERE
			[ABSENCE_REASON_CODE].[TYPE] IN ('EXC','UNV')
			
		GROUP BY
			[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU]
		) AS [ATTENDANCE_TOTALS]
		ON
		[CURRENT_ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [ATTENDANCE_TOTALS].[STUDENT_SCHOOL_YEAR_GU]
		
		---------------------------------
		-- GET CURRENT ENROLLMENT RECORDS
		
		--LEFT OUTER JOIN
		--APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments_Now]
		--ON
		--[StudentSchoolYear].[STUDENT_GU] = [Enrollments_Now].[STUDENT_GU]
		
		--LEFT OUTER JOIN 
		--rev.REV_ORGANIZATION_YEAR AS [OrgYear_Now] -- Links between School and Year
		--ON 
		--[Enrollments_Now].[ORGANIZATION_YEAR_GU] = [OrgYear_Now].[ORGANIZATION_YEAR_GU]
		
		--LEFT OUTER JOIN 
		--rev.REV_ORGANIZATION AS [Organization_Now] -- Contains the School Name
		--ON 
		--[OrgYear_Now].[ORGANIZATION_GU] = [Organization_Now].[ORGANIZATION_GU]
		
		--LEFT OUTER JOIN 
		--rev.EPC_SCH AS [School_Now] -- Contains the School Code / Number
		--ON 
		--[OrgYear_Now].[ORGANIZATION_GU] = [School_Now].[ORGANIZATION_GU]
		
		-- SPED STATUS
		--LEFT JOIN
  --      (
  --      SELECT
  --                 *
  --      FROM
  --                  REV.EP_STUDENT_SPECIAL_ED AS SPED
  --      WHERE
  --                  NEXT_IEP_DATE IS NOT NULL
  --                  AND (
  --                              EXIT_DATE IS NULL 
  --                              OR EXIT_DATE >= CONVERT(DATE, GETDATE())
  --                              )
  --      ) AS [CurrentSPED]
  --      ON
  --      [StudentSchoolYear].[STUDENT_GU] = [CurrentSPED].[STUDENT_GU]
        
        -- ELL STATUS
        --LEFT JOIN
        --APS.ELLCalculatedAsOf (GETDATE()) AS [ELL]
        --ON
        --[StudentSchoolYear].[STUDENT_GU] = [ELL].[STUDENT_GU]
        
        -- CURRENT GRADE LEVEL
  --      LEFT OUTER JOIN
		--APS.LookupTable('K12','Grade') AS [Grades_Now]
		--ON
		--[StudentSchoolYear].[GRADE] = [Grades_Now].[VALUE_CODE]

		
	WHERE
		(
		([CURRENT_ENROLLMENTS].[SCHOOL_YEAR] = '2013' AND [CURRENT_ENROLLMENTS].[EXTENSION] = 'S')
		OR
		([CURRENT_ENROLLMENTS].[SCHOOL_YEAR] = '2014' AND [CURRENT_ENROLLMENTS].[EXTENSION] = 'R')
		OR
		([CURRENT_ENROLLMENTS].[SCHOOL_YEAR] = '2015' AND [CURRENT_ENROLLMENTS].[EXTENSION] = 'N')
		)	
		AND [StudentSchoolYear].[NO_SHOW_STUDENT] = 'N'
		--AND [SCHOOL_YEAR_OPTION].[SCHOOL_TYPE] = 1
		AND [ENROLLMENT_2010].[GRADE] IN ('K','01','02','03')
		
		--AND [School].[SCHOOL_CODE] IN ('207','229','237','303')
		--AND [School].[SCHOOL_CODE] = '379'
		
		--AND [Grades].[VALUE_DESCRIPTION] = 'K'
		
		--AND ([SCHEDULE].[SECTION_ID] BETWEEN '2000' AND '2999' OR [SCHEDULE].[SECTION_ID] BETWEEN '5000' AND '5999')
		--AND [SCHEDULE].[COURSE_LEAVE_DATE] IS NULL
		--AND [StudentSchoolYear].[LEAVE_DATE] IS NULL
		
	ORDER BY
		[ENROLLMENT_2010].[LIST_ORDER]
		,[STUDENT].[SIS_NUMBER]