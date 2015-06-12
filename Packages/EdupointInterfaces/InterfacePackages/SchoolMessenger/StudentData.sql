--<APS - School Messenger >
-- *StudentContact data view*
/*
06/30/2014
1)	Please add school location name as well as the number.
2)	Only include data in the views for students active in the current term (in this case summer terms only).  
Once the regular SY term starts the views would need to pull that data and no longer the summer term and so forth. 
07/02/14
an additional field called ‘Some SCH Attendance’ with a value of ‘summer’ for all summer school students.  
The other change would be to please start including next year’s 2014-2015 students 
09/16/14
modify the SchoolMessenger student contact view to never pull a phone number of Work type
*/
IF OBJECT_ID('SchoolMessenger.StudentContact') IS NOT NULL DROP VIEW SchoolMessenger.StudentContact
GO
CREATE VIEW SchoolMessenger.StudentContact AS
with ParentContact AS
(
SELECT   
           stu.STUDENT_GU
         , stu.SIS_NUMBER
         , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY plist.CALL_ORDER) PGNum
         , plist.HomePhone
         , plist.CellPhone
         , plist.OtherPhone
         , plist.EMAIL
         , plist.CALL_ORDER
         , plist.PrimaryPhone
FROM rev.EPC_STU_YR syr
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU
JOIN rev.EPC_STU stu                ON stu.STUDENT_GU = syr.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN rev.REV_ORGANIZATION org       ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_YEAR yr                ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR >= (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
JOIN (
      SELECT   
           stu.STUDENT_GU
         , stupar.ORDERBY CALL_ORDER
         , phone.H HomePhone
         , phone.C CellPhone
         , phone.O OtherPhone
         , par.EMAIL
         , ParPriPhone.Y PrimaryPhone
      FROM rev.EPC_STU_PARENT  stupar
           JOIN rev.REV_PERSON par ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
           JOIN rev.EPC_STU stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C],  [O])) phone ON phone.PERSON_GU = par.PERSON_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PRIMARY_PHONE FROM rev.REV_PERSON_PHONE phn) ParPhn
                      PIVOT (min(phone) FOR PRIMARY_PHONE in ([Y])) ParPriPhone ON ParPriPhone.PERSON_GU = par.PERSON_GU

     ) plist on plist.STUDENT_GU = stu.STUDENT_GU
), StuClasses AS 
(
   select 
        s.student_gu
		, row_number() over (partition by s.student_gu order by s.student_gu) rn
   FROM rev.EPC_STU               AS S 
   JOIN rev.REV_PERSON            AS SP  ON SP.PERSON_GU            = S.STUDENT_GU 
   JOIN rev.EPC_STU_SCH_YR        AS SSY ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
   JOIN rev.EPC_STU_YR            AS SY  ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
   JOIN rev.REV_ORGANIZATION_YEAR AS OY  ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
   JOIN rev.REV_YEAR              AS Y   ON Y.YEAR_GU               = SY.YEAR_GU 
                                            AND y.SCHOOL_YEAR       >= (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
   JOIN rev.EPC_STU_CLASS         cls    ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
   JOIN rev.EPC_SCH_YR_SECT       sec    ON cls.SECTION_GU              = sec.SECTION_GU
   JOIN rev.EPC_SCH_YR_CRS        sycrs  ON sycrs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU
   WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())  AND cls.ENTER_DATE <= GETDATE()
), SummarSchoolStu AS
(
   select 
        stu.student_gu
   FROM rev.EPC_STU                    stu
        JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
                                            and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
											and ssy.LEAVE_DATE is null
        JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
        JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
                                               and yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
                                               and yr.EXTENSION = 'S'

), RaceCodes as
(
select 
ROW_NUMBER() over (partition by s.student_gu order by s.student_gu, r.list_order) rn
, s.STUDENT_GU
, r.ALT_CODE_3
FROM rev.EPC_STU               AS S 
JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SY.YEAR_GU 
                                            and y.YEAR_GU           = (select year_gu from rev.SIF_22_Common_CurrentYearGU)
join rev.REV_PERSON_SECONDRY_ETH_LST seth on seth.PERSON_GU         = sp.PERSON_GU
left join (SELECT VALUE_CODE, LIST_ORDER,ALT_CODE_3
           FROM   rev.REV_BOD_LOOKUP_DEF def
           JOIN   rev.REV_BOD_LOOKUP_VALUES lang ON (def.LOOKUP_DEF_GU = lang.LOOKUP_DEF_GU)
           WHERE  def.LOOKUP_NAMESPACE  = 'Revelation'
                  AND def.LOOKUP_DEF_CODE   = 'ETHNICITY') r on r.VALUE_CODE = seth.ETHNIC_CODE
)
SELECT 
  S.SIS_NUMBER                 AS [STUDENT ID NUMBER]
, SP.FIRST_NAME                AS [FIRST NAME]
, SP.LAST_NAME                 AS [LAST NAME]
, SP.PRIMARY_PHONE             AS [PHONE]
, SCH.SCHOOL_CODE              AS [SCHOOL ID]
, CASE WHEN 
  (ell.LANGUAGE_TO_HOME is null and s.HOME_LANGUAGE = '54') THEN 'English'
  ELSE coalesce(LANG.VALUE_DESCRIPTION, sLANG.VALUE_DESCRIPTION)
  END                          AS [HOME LANGUAGE]
, GRADE.VALUE_DESCRIPTION      AS [GRADE LEVEL]
, SP.GENDER                    AS [GENDER]
-----------------
, Par1.HomePhone               AS [Parent1HomePhone]
, Par1.CellPhone               AS [Parent1CellPhone]
, ''                           AS [Parent1WorkPhone]
, Par1.OtherPhone              AS [Parent1OtherPhone]
, Par1.EMAIL                   AS [Parent1Email]
, Par1.CALL_ORDER              AS [Parent1CallOrder]
, Par1.PrimaryPhone            AS [Parent1PrimaryPhone]
, Par2.HomePhone               AS [Parent2HomePhone]
, Par2.CellPhone               AS [Parent2CellPhone]
, ''                           AS [Parent2WorkPhone]
, Par2.OtherPhone              AS [Parent2OtherPhone]
, Par2.EMAIL                   AS [Parent2Email]
, Par2.CALL_ORDER              AS [Parent2CallOrder]
, Par2.PrimaryPhone            AS [Parent2PrimaryPhone]
-----------------
, o.ORGANIZATION_NAME          AS [SchoolName]
, ''                           AS [Some SCH Attendance]
, r1.ALT_CODE_3                AS [Race1]
, r2.ALT_CODE_3                AS [Race2]
, r3.ALT_CODE_3                AS [Race3]
, r4.ALT_CODE_3                AS [Race4]
, r5.ALT_CODE_3                AS [Race5]

, sp.HISPANIC_INDICATOR        AS [HispanicInidcator]
FROM rev.EPC_STU               AS S 
JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SY.YEAR_GU 
                                            AND y.SCHOOL_YEAR       >= (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
											AND y.EXTENSION         = 'R'
JOIN rev.REV_ORGANIZATION      AS O      ON O.ORGANIZATION_GU       = OY.ORGANIZATION_GU 
JOIN rev.EPC_SCH               AS SCH    ON SCH.ORGANIZATION_GU     = O.ORGANIZATION_GU
LEFT JOIN rev.EPC_STU_PGM_ELL  AS ell    ON ell.STUDENT_GU          = s.STUDENT_GU 
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') GRADE ON GRADE.VALUE_CODE = ssy.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') lang  ON lang.VALUE_CODE = ell.LANGUAGE_TO_HOME
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') slang ON slang.VALUE_CODE = s.HOME_LANGUAGE

------------------
LEFT JOIN ParentContact        AS Par1   ON par1.STUDENT_GU         = S.STUDENT_GU
                                            AND Par1.PGNum          = 1
LEFT JOIN ParentContact        AS Par2   ON par2.STUDENT_GU         = S.STUDENT_GU
                                            AND Par2.PGNum          = 2
-------------------
left join RaceCodes            as r1     on r1.STUDENT_GU           = s.STUDENT_GU and r1.rn =1
left join RaceCodes            as r2     on r2.STUDENT_GU           = s.STUDENT_GU and r2.rn =2
left join RaceCodes            as r3     on r3.STUDENT_GU           = s.STUDENT_GU and r3.rn =3
left join RaceCodes            as r4     on r4.STUDENT_GU           = s.STUDENT_GU and r4.rn =4
left join RaceCodes            as r5     on r5.STUDENT_GU           = s.STUDENT_GU and r5.rn =5
-------------------
WHERE SCH.SCHOOL_CODE IS NOT NULL
AND exists (select sc.student_gu from StuClasses sc where sc.STUDENT_GU = s.STUDENT_GU and rn = 1)
	 -- to exclude those students who have a summar school enrollment
	 and not exists (select ss.student_gu from SummarSchoolStu ss where ss.STUDENT_GU = s.STUDENT_GU)
-- Only Summer School enrollments
UNION
SELECT 
  S.SIS_NUMBER                 AS [STUDENT ID NUMBER]
, SP.FIRST_NAME                AS [FIRST NAME]
, SP.LAST_NAME                 AS [LAST NAME]
, SP.PRIMARY_PHONE             AS [PHONE]
, SCH.SCHOOL_CODE              AS [SCHOOL ID]
,  CASE WHEN 
  (ell.LANGUAGE_TO_HOME is null and s.HOME_LANGUAGE = '54') THEN 'English'
  ELSE coalesce(LANG.VALUE_DESCRIPTION, sLANG.VALUE_DESCRIPTION)
  END                          AS [HOME LANGUAGE]
, GRADE.VALUE_DESCRIPTION      AS [GRADE LEVEL]
, SP.GENDER                    AS [GENDER]
-----------------
, Par1.HomePhone               AS [Parent1HomePhone]
, Par1.CellPhone               AS [Parent1CellPhone]
, ''                           AS [Parent1WorkPhone]
, Par1.OtherPhone              AS [Parent1OtherPhone]
, Par1.EMAIL                   AS [Parent1Email]
, Par1.CALL_ORDER              AS [Parent1CallOrder]
, Par1.PrimaryPhone            AS [Parent1PrimaryPhone]
, Par2.HomePhone               AS [Parent2HomePhone]
, Par2.CellPhone               AS [Parent2CellPhone]
, ''                           AS [Parent2WorkPhone]
, Par2.OtherPhone              AS [Parent2OtherPhone]
, Par2.EMAIL                   AS [Parent2Email]
, Par2.CALL_ORDER              AS [Parent2CallOrder]
, Par2.PrimaryPhone            AS [Parent2PrimaryPhone]
-----------------
, o.ORGANIZATION_NAME          AS [SchoolName]
, 'summer'                     AS [Some SCH Attendance]
, r1.ALT_CODE_3                AS [Race1]
, r2.ALT_CODE_3                AS [Race2]
, r3.ALT_CODE_3                AS [Race3]
, r4.ALT_CODE_3                AS [Race4]
, r5.ALT_CODE_3                AS [Race5]
, sp.HISPANIC_INDICATOR        AS [HispanicInidcator]

FROM rev.EPC_STU               AS S 
JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SY.YEAR_GU 
                                            AND y.SCHOOL_YEAR       = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
											AND y.EXTENSION         = 'S'
JOIN rev.REV_ORGANIZATION      AS O      ON O.ORGANIZATION_GU       = OY.ORGANIZATION_GU 
JOIN rev.EPC_SCH               AS SCH    ON SCH.ORGANIZATION_GU     = O.ORGANIZATION_GU
LEFT JOIN rev.EPC_STU_PGM_ELL  AS ell    ON ell.STUDENT_GU          = s.STUDENT_GU 
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') GRADE ON GRADE.VALUE_CODE = ssy.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') lang ON lang.VALUE_CODE = ell.LANGUAGE_TO_HOME
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') slang ON slang.VALUE_CODE = s.HOME_LANGUAGE

------------------
LEFT JOIN ParentContact        AS Par1   ON par1.STUDENT_GU         = S.STUDENT_GU
                                            AND Par1.PGNum          = 1
LEFT JOIN ParentContact        AS Par2   ON par2.STUDENT_GU         = S.STUDENT_GU
                                            AND Par2.PGNum          = 2
-------------------
left join RaceCodes            as r1     on r1.STUDENT_GU           = s.STUDENT_GU and r1.rn =1
left join RaceCodes            as r2     on r2.STUDENT_GU           = s.STUDENT_GU and r2.rn =2
left join RaceCodes            as r3     on r3.STUDENT_GU           = s.STUDENT_GU and r3.rn =3
left join RaceCodes            as r4     on r4.STUDENT_GU           = s.STUDENT_GU and r4.rn =4
left join RaceCodes            as r5     on r5.STUDENT_GU           = s.STUDENT_GU and r5.rn =5
-------------------
WHERE SCH.SCHOOL_CODE IS NOT NULL
--AND exists (select sc.student_gu from StuClasses sc where sc.STUDENT_GU = s.STUDENT_GU and rn = 1)
-- Next Years Regular Students
UNION
SELECT 
  S.SIS_NUMBER                 AS [STUDENT ID NUMBER]
, SP.FIRST_NAME                AS [FIRST NAME]
, SP.LAST_NAME                 AS [LAST NAME]
, SP.PRIMARY_PHONE             AS [PHONE]
, SCH.SCHOOL_CODE              AS [SCHOOL ID]
,  CASE WHEN 
  (ell.LANGUAGE_TO_HOME is null and s.HOME_LANGUAGE = '54') THEN 'English'
  ELSE coalesce(LANG.VALUE_DESCRIPTION, sLANG.VALUE_DESCRIPTION)
  END                          AS [HOME LANGUAGE]
, GRADE.VALUE_DESCRIPTION      AS [GRADE LEVEL]
, SP.GENDER                    AS [GENDER]
-----------------
, Par1.HomePhone               AS [Parent1HomePhone]
, Par1.CellPhone               AS [Parent1CellPhone]
, ''                           AS [Parent1WorkPhone]
, Par1.OtherPhone              AS [Parent1OtherPhone]
, Par1.EMAIL                   AS [Parent1Email]
, Par1.CALL_ORDER              AS [Parent1CallOrder]
, Par1.PrimaryPhone            AS [Parent1PrimaryPhone]
, Par2.HomePhone               AS [Parent2HomePhone]
, Par2.CellPhone               AS [Parent2CellPhone]
, ''                           AS [Parent2WorkPhone]
, Par2.OtherPhone              AS [Parent2OtherPhone]
, Par2.EMAIL                   AS [Parent2Email]
, Par2.CALL_ORDER              AS [Parent2CallOrder]
, Par2.PrimaryPhone            AS [Parent2PrimaryPhone]
-----------------
, o.ORGANIZATION_NAME          AS [SchoolName]
, ''                           AS [Some SCH Attendance]
, r1.ALT_CODE_3                AS [Race1]
, r2.ALT_CODE_3                AS [Race2]
, r3.ALT_CODE_3                AS [Race3]
, r4.ALT_CODE_3                AS [Race4]
, r5.ALT_CODE_3                AS [Race5]
, sp.HISPANIC_INDICATOR        AS [HispanicInidcator]
FROM rev.EPC_STU               AS S 
JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SY.YEAR_GU 
                                            AND y.SCHOOL_YEAR       = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 1
											AND y.EXTENSION         = 'R'
JOIN rev.REV_ORGANIZATION      AS O      ON O.ORGANIZATION_GU       = OY.ORGANIZATION_GU 
JOIN rev.EPC_SCH               AS SCH    ON SCH.ORGANIZATION_GU     = O.ORGANIZATION_GU 
LEFT JOIN rev.EPC_STU_PGM_ELL  AS ell    ON ell.STUDENT_GU          = s.STUDENT_GU 
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') GRADE ON GRADE.VALUE_CODE = ssy.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') lang ON lang.VALUE_CODE = ell.LANGUAGE_TO_HOME
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') slang ON slang.VALUE_CODE = s.HOME_LANGUAGE

------------------
LEFT JOIN ParentContact        AS Par1   ON par1.STUDENT_GU         = S.STUDENT_GU
                                            AND Par1.PGNum          = 1
LEFT JOIN ParentContact        AS Par2   ON par2.STUDENT_GU         = S.STUDENT_GU
                                            AND Par2.PGNum          = 2
-------------------
left join RaceCodes            as r1     on r1.STUDENT_GU           = s.STUDENT_GU and r1.rn =1
left join RaceCodes            as r2     on r2.STUDENT_GU           = s.STUDENT_GU and r2.rn =2
left join RaceCodes            as r3     on r3.STUDENT_GU           = s.STUDENT_GU and r3.rn =3
left join RaceCodes            as r4     on r4.STUDENT_GU           = s.STUDENT_GU and r4.rn =4
left join RaceCodes            as r5     on r5.STUDENT_GU           = s.STUDENT_GU and r5.rn =5
-------------------
WHERE SCH.SCHOOL_CODE IS NOT NULL
