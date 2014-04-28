/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-04-28 
 *
 * This is the SchoolMessenger pull for Emergency contact.
 */

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SchoolMessenger].[EmergencyContact]'))
	EXEC ('CREATE VIEW SchoolMessenger.EmergencyContact AS SELECT 0 AS DUMMY')
GO

ALTER VIEW SchoolMessenger.EmergencyContact AS

with ParentContact AS
(
SELECT   
           stu.STUDENT_GU
         , stu.SIS_NUMBER
         , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY plist.CALL_ORDER) PGNum
         , plist.HomePhone
         , plist.CellPhone
         , plist.WorkPhone
         , plist.OtherPhone
         , plist.EMAIL
         , plist.CALL_ORDER
         , plist.PrimaryPhone
FROM rev.EPC_STU_YR syr
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU
JOIN rev.EPC_STU stu                ON stu.STUDENT_GU = syr.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN rev.REV_ORGANIZATION org       ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_YEAR yr                ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
JOIN (
      SELECT   
           stu.STUDENT_GU
         , stupar.ORDERBY CALL_ORDER
         , phone.H HomePhone
         , phone.C CellPhone
         , phone.W WorkPhone
         , phone.O OtherPhone
         , par.EMAIL
         , ParPriPhone.Y PrimaryPhone
      FROM rev.EPC_STU_PARENT  stupar
           JOIN rev.REV_PERSON par ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
           JOIN rev.EPC_STU stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C], [W], [O])) phone ON phone.PERSON_GU = par.PERSON_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PRIMARY_PHONE FROM rev.REV_PERSON_PHONE phn) ParPhn
                      PIVOT (min(phone) FOR PRIMARY_PHONE in ([Y])) ParPriPhone ON ParPriPhone.PERSON_GU = par.PERSON_GU

     ) plist on plist.STUDENT_GU = stu.STUDENT_GU
)
SELECT 
  S.SIS_NUMBER                 AS [STUDENT ID NUMBER]
, SP.FIRST_NAME                AS [FIRST NAME]
, SP.LAST_NAME                 AS [LAST NAME]
, SP.PRIMARY_PHONE             AS [PHONE]
, SCH.SCHOOL_CODE              AS [SCHOOL ID]
, LANG.VALUE_DESCRIPTION       AS [HOME LANGUAGE]
, GRADE.VALUE_DESCRIPTION      AS [GRADE LEVEL]
, SP.GENDER                    AS [GENDER]
-----------------
, Par1.HomePhone               AS [Parent1HomePhone]
, Par1.CellPhone               AS [Parent1CellPhone]
, Par1.WorkPhone               AS [Parent1WorkPhone]
, Par1.OtherPhone              AS [Parent1OtherPhone]
, Par1.EMAIL                   AS [Parent1Email]
, Par1.CALL_ORDER              AS [Parent1CallOrder]
, Par1.PrimaryPhone            AS [Parent1PrimaryPhone]
, Par2.HomePhone               AS [Parent2HomePhone]
, Par2.CellPhone               AS [Parent2CellPhone]
, Par2.WorkPhone               AS [Parent2WorkPhone]
, Par2.OtherPhone              AS [Parent2OtherPhone]
, Par2.EMAIL                   AS [Parent2Email]
, Par2.CALL_ORDER              AS [Parent2CallOrder]
, Par2.PrimaryPhone            AS [Parent2PrimaryPhone]
-----------------
FROM rev.EPC_STU               AS S 
JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SY.YEAR_GU 
                                            AND Y.EXTENSION = 'R' -- Comment if Summer scools are also required
JOIN rev.SIF_22_Common_CurrentYearGU CUR ON Y.YEAR_GU               = CUR.year_gu 
JOIN rev.REV_ORGANIZATION      AS O      ON O.ORGANIZATION_GU       = OY.ORGANIZATION_GU 
JOIN rev.EPC_SCH               AS SCH    ON SCH.ORGANIZATION_GU     = O.ORGANIZATION_GU 
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') GRADE ON GRADE.VALUE_CODE = ssy.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') lang ON lang.VALUE_CODE = s.HOME_LANGUAGE
------------------
LEFT JOIN ParentContact        AS Par1   ON par1.STUDENT_GU         = S.STUDENT_GU
                                            AND Par1.PGNum          = 1
LEFT JOIN ParentContact        AS Par2   ON par2.STUDENT_GU         = S.STUDENT_GU
                                            AND Par2.PGNum          = 2
-------------------

WHERE SCH.SCHOOL_CODE IS NOT NULL

GO