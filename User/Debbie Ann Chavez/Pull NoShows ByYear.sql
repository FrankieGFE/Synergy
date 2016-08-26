

SELECT DISTINCT
		SIS_NUMBER
		--,SSY.STUDENT_GU
		--,SSY.ORGANIZATION_YEAR_GU
		--,SSY.STUDENT_SCHOOL_YEAR_GU
		--,Enrollment.ENROLLMENT_GU
		--,SSY.GRADE
		--,Enrollment.ENTER_DATE
		--,Enrollment.LEAVE_DATE
		-- We have to row number to make sure we only get one record per kid.  We noticed
		-- about 4 kids who have overlapping ADA enrollments.  This could have been caused
		-- by import + NYR, but regardless of reason, we can only count kids once
		--,ROW_NUMBER() OVER (PARTITION BY SSY.STUDENT_GU ORDER BY ENROLLMENT.ENTER_DATE) AS RN
		
		,SSY.ENTER_DATE
		,SUMMER_WITHDRAWL_CODE
		,SUMMER_WITHDRAWL_DATE
	FROM
		
		/*
		--YearDates and OrgYears help us focus our search 
		APS.YearDates
		
		INNER JOIN*/
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		--ON
		--YearDates.YEAR_GU = OrgYear.YEAR_GU
		
		-- Student School Year - Everything flows through here
		INNER JOIN
		rev.EPC_STU_SCH_YR AS SSY
		ON
		OrgYear.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU

		/*
		-- Enrollment because enter and leave dates truly reside here, and not most recent as it is bubbled up to SSY
		INNER JOIN
		rev.EPC_STU_ENROLL AS Enrollment
		ON
		SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU
		*/
		INNER JOIN 
		REV.REV_YEAR AS YRS
		ON SSY.YEAR_GU = YRS.YEAR_GU

		INNER JOIN 
		rev.EPC_STU AS STU
		ON
		SSY.STUDENT_GU = STU.STUDENT_GU

	WHERE
		-- This is what narrows down the School Years (OrgYears) we need to be focusining on
		--GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE
		
		-- We are dealing with Enrollment enter/leaves because SSY only has **most recent** info, and not necessarily what it was on
		-- the date we are looking for.
		--AND GETDATE() BETWEEN Enrollment.ENTER_DATE AND COALESCE(Enrollment.LEAVE_DATE, YearDates.END_DATE)

		-- only show ADA students not excluded from ADA/ADM
		--AND Enrollment.EXCLUDE_ADA_ADM IS NULL
		 SUMMER_WITHDRAWL_CODE IS NOT NULL
		 AND YRS.EXTENSION = 'R'
		 AND YRS.SCHOOL_YEAR = '2016'
	
	ORDER BY ENTER_DATE