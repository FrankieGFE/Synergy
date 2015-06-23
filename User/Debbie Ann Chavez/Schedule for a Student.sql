

SELECT        rev.EPC_STU.SIS_NUMBER, rev.EPC_STU.STATE_STUDENT_NUMBER, StudentSchoolYear.GRADE, rev.REV_ORGANIZATION.ORGANIZATION_NAME, 
                         rev.EPC_SCH.SCHOOL_CODE, rev.EPC_SCH.STATE_SCHOOL_CODE, rev.EPC_CRS.COURSE_ID, rev.EPC_CRS.STATE_COURSE_CODE, Section.SECTION_ID, 
                         rev.EPC_CRS.COURSE_TITLE, rev.EPC_CRS.COURSE_SHORT_TITLE, rev.EPC_CRS.DEPARTMENT, Section.TERM_CODE, Section.PERIOD_BEGIN, 
                         Section.PERIOD_END, StudentSchoolYear.ENTER_DATE AS ENROLLMENT_ENTER_DATE, StudentSchoolYear.LEAVE_DATE AS ENROLLMENT_LEAVE_DATE, 
                         rev.REV_PERSON.LAST_NAME, rev.REV_PERSON.FIRST_NAME, rev.EPC_STAFF.BADGE_NUM
FROM            rev.EPC_STAFF_SCH_YR AS StaffSchoolYear INNER JOIN
                         rev.REV_PERSON ON StaffSchoolYear.STAFF_GU = rev.REV_PERSON.PERSON_GU INNER JOIN
                         rev.EPC_STAFF ON StaffSchoolYear.STAFF_GU = rev.EPC_STAFF.STAFF_GU RIGHT OUTER JOIN
                         rev.EPC_STU_CLASS AS Class INNER JOIN
                         rev.EPC_SCH_YR_SECT AS Section ON Class.SECTION_GU = Section.SECTION_GU INNER JOIN
                         rev.EPC_SCH_YR_CRS AS SchoolYearCourse ON Section.SCHOOL_YEAR_COURSE_GU = SchoolYearCourse.SCHOOL_YEAR_COURSE_GU INNER JOIN
                         rev.REV_ORGANIZATION_YEAR AS OrgYear ON Section.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU INNER JOIN
                         rev.REV_YEAR ON OrgYear.YEAR_GU = rev.REV_YEAR.YEAR_GU INNER JOIN
                         rev.EPC_CRS ON SchoolYearCourse.COURSE_GU = rev.EPC_CRS.COURSE_GU ON 
                         StaffSchoolYear.STAFF_SCHOOL_YEAR_GU = Section.STAFF_SCHOOL_YEAR_GU LEFT OUTER JOIN
                         rev.EPC_SCH INNER JOIN
                         rev.REV_ORGANIZATION ON rev.EPC_SCH.ORGANIZATION_GU = rev.REV_ORGANIZATION.ORGANIZATION_GU ON 
                         OrgYear.ORGANIZATION_GU = rev.REV_ORGANIZATION.ORGANIZATION_GU LEFT OUTER JOIN
                         rev.EPC_STU_SCH_YR AS StudentSchoolYear INNER JOIN
                         rev.EPC_STU ON StudentSchoolYear.STUDENT_GU = rev.EPC_STU.STUDENT_GU ON rev.REV_YEAR.YEAR_GU = StudentSchoolYear.YEAR_GU AND 
                         Class.STUDENT_SCHOOL_YEAR_GU = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
WHERE        (Class.LEAVE_DATE IS NULL) AND (rev.REV_YEAR.SCHOOL_YEAR = 2015) AND (StudentSchoolYear.LEAVE_DATE IS NULL) 
			AND rev.EPC_STU.SIS_NUMBER = 102790268