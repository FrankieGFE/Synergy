--<APS - School Messenger >
-- *Parent data view*
--CREATE VIEW [SchoolMessenger].[Parent] AS

SELECT
  stu.SIS_NUMBER AS [ID Number]
, par.FIRST_NAME AS [Parent First Name]
, par.LAST_NAME  AS [Parent Last Name]

FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssyr   ON ssyr.STUDENT_GU = stu.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr    ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN rev.REV_YEAR              yr     ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
JOIN rev.EPC_STU_PARENT        stupar ON stupar.STUDENT_GU = stu.STUDENT_GU
JOIN rev.REV_PERSON            par    ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
