-- <APS - Transfer System – Siblings Extract>
-- List to include all sibling records associated with all Parents in the Parent extract
; with Siblings AS
(
select 
           stu.SIS_NUMBER                          SIS_Number
		 , stu.STUDENT_GU
		 , spar.PARENT_GU
         , per.FIRST_NAME + ' ' + per.LAST_NAME    StudentName
         , row_number() over(partition by stu.student_gu order by spar.parent_gu) sn
		 , sibp.FIRST_NAME + ' ' + sibp.LAST_NAME  SiblingName
		 , sch.SCHOOL_CODE                         SiblingSchoolNumber
		 , org.ORGANIZATION_NAME                   SiblingSchoolName
		 , grd.VALUE_DESCRIPTION                   SiblingGrade
		 , CONVERT(VARCHAR(10), sibp.BIRTH_DATE, 101) SiblingDOB

from     rev.EPC_STU                    stu
         join rev.REV_PERSON            per  on per.PERSON_GU     = stu.STUDENT_GU
         join rev.EPC_STU_PARENT        spar on spar.STUDENT_GU   = stu.STUDENT_GU
		 join rev.EPC_PARENT            par  on par.PARENT_GU     = spar.PARENT_GU
         join rev.REV_PERSON            pper on pper.PERSON_GU    = spar.PARENT_GU
		 join rev.EPC_STU_PARENT        ppar on ppar.PARENT_GU    = par.PARENT_GU
         left join rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel on rel.VALUE_CODE = spar.RELATION_TYPE
		 --SiblingInfo
		 join rev.EPC_STU               sibs on sibs.STUDENT_GU   = ppar.STUDENT_GU
		 join rev.REV_PERSON            sibp on sibp.PERSON_GU           = sibs.STUDENT_GU
		 join rev.EPC_STU_SCH_YR        ssyr on ssyr.STUDENT_GU          = sibs.STUDENT_GU
		 join rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
		                                        and oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		 join rev.REV_ORGANIZATION      org  on org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
		 join rev.EPC_SCH               sch  on sch.ORGANIZATION_GU      = org.ORGANIZATION_GU
		 left join rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssyr.GRADE

where    stu.STUDENT_GU <> ppar.STUDENT_GU
)
SELECT
         STU.SIS_NUMBER                        AS [Student ID]
       , CONVERT(VARCHAR(10), GETDATE(), 101)  AS [File Date]
       , pper.FIRST_NAME                       AS [Parent First Name]
       , pper.LAST_NAME                        AS [Parent Last Name]
       , rel.VALUE_DESCRIPTION                 AS [Parent Relationship]
       , sbs.SiblingName                       AS [Sibling Student Name]
       , sbs.SiblingSchoolNumber               AS [Current Enrollment Location Number]
       , sbs.SiblingSchoolName                 AS [Current Enrollment Location Name]
       , sbs.SiblingGrade                      AS [Current Enrollment Grade]
       , sbs.SiblingDOB                        AS [Student Date of Birth]

FROM   rev.EPC_STU                  stu
       JOIN rev.EPC_STU_YR          stuyr ON stuyr.STUDENT_GU   = stu.STUDENT_GU
       JOIN rev.REV_YEAR            yr    ON yr.YEAR_GU         = stuyr.YEAR_GU
	                                         AND yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
	   LEFT JOIN rev.EPC_STU_PARENT stpar ON stpar.STUDENT_GU   = stu.STUDENT_GU
	   LEFT JOIN rev.REV_PERSON     pper  ON pper.PERSON_GU     = stpar.PARENT_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel ON rel.VALUE_CODE = stpar.RELATION_TYPE
	   LEFT JOIN Siblings           sbs   ON sbs.STUDENT_GU = stu.STUDENT_GU and sbs.PARENT_GU = stpar.PARENT_GU

