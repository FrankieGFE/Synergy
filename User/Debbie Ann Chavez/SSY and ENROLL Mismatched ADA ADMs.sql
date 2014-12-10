
/*
*	MAKE A DI REPORT - SSY AND ENROLL MISMATCHED EXCLUDE ADA ADM'S
*/

SELECT * FROM 
(
SELECT
		ORGANIZATION_NAME
		,SIS_NUMBER
		,Enrollment.GRADE
		,Enrollment.ENTER_DATE
		,Enrollment.LEAVE_DATE
		,CASE WHEN Enrollment.EXCLUDE_ADA_ADM IS NULL THEN 0 ELSE Enrollment.EXCLUDE_ADA_ADM END AS ENR_EXCLUDE_ADA_ADM
		,CASE WHEN SSY.EXCLUDE_ADA_ADM IS NULL THEN 0 ELSE Enrollment.EXCLUDE_ADA_ADM END AS SSY_EXCLUDE_ADA_ADM
		-- We have to row number to make sure we only get one record per kid.  We noticed
		-- about 4 kids who have overlapping ADA enrollments.  This could have been caused
		-- by import + NYR, but regardless of reason, we can only count kids once
		,ROW_NUMBER() OVER (PARTITION BY SSY.STUDENT_GU ORDER BY ENROLLMENT.ENTER_DATE, ENROLLMENT.EXCLUDE_ADA_ADM) AS RN
	FROM
		--YearDates and OrgYears help us focus our search 
		APS.YearDates
		INNER JOIN
		rev.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		YearDates.YEAR_GU = OrgYear.YEAR_GU

		-- Student School Year - Everything flows through here
		INNER JOIN
		rev.EPC_STU_SCH_YR AS SSY
		ON
		OrgYear.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU


		INNER JOIN
		rev.REV_ORGANIZATION AS ORG
		ON
		OrgYear.ORGANIZATION_GU = ORG.ORGANIZATION_GU

		INNER JOIN
rev.EPC_STU AS STU
ON
STU.STUDENT_GU = SSY.STUDENT_GU

		-- Enrollment because enter and leave dates truly reside here, and not most recent as it is bubbled up to SSY
		INNER JOIN
		rev.EPC_STU_ENROLL AS Enrollment
		ON
		SSY.STUDENT_SCHOOL_YEAR_GU = Enrollment.STUDENT_SCHOOL_YEAR_GU

	--WHERE
		-- This is what narrows down the School Years (OrgYears) we need to be focusining on
		--GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE
		
		-- We are dealing with Enrollment enter/leaves because SSY only has **most recent** info, and not necessarily what it was on
		-- the date we are looking for.
		--AND 
		--GETDATE()  BETWEEN Enrollment.ENTER_DATE AND COALESCE(Enrollment.LEAVE_DATE, YearDates.END_DATE)
 ) AS T1

WHERE 
 T1.ENR_EXCLUDE_ADA_ADM != T1.SSY_EXCLUDE_ADA_ADM

 ORDER BY ORGANIZATION_NAME
 ,SIS_NUMBER