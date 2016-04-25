--<APS - Naviance Parent Data>
--Parent data for all students in the Student Data File, 
--the first two parents listed in the order by with Lives With checked.
; with ParentContact AS
(
SELECT   
       stu.STUDENT_GU
     , stu.SIS_NUMBER
     , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY plist.CALL_ORDER) PGNum
     , plist.HomePhone
     , plist.CellPhone
     , plist.WorkPhone
     , plist.EMAIL
     , plist.ADULT_ID
     , plist.LAST_NAME
     , plist.FIRST_NAME
     , plist.FINANCIAL_RESPONSIBILITY
     , plist.HAS_CUSTODY
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
         , par.EMAIL
         , pr.ADULT_ID
         , par.LAST_NAME
         , par.FIRST_NAME
         , stupar.FINANCIAL_RESPONSIBILITY
         , stupar.HAS_CUSTODY
      FROM rev.EPC_STU_PARENT  stupar
           JOIN rev.REV_PERSON par ON par.PERSON_GU  = stupar.PARENT_GU and stupar.LIVES_WITH = 'Y'
           JOIN rev.EPC_STU    stu ON stu.STUDENT_GU = stupar.STUDENT_GU
           JOIN rev.EPC_PARENT pr  ON pr.PARENT_GU   = stupar.PARENT_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C], [W])) phone ON phone.PERSON_GU = par.PERSON_GU
     ) plist on plist.STUDENT_GU = stu.STUDENT_GU
)
SELECT
       stu.SIS_NUMBER                     AS [Student_ID]
     , pc.ADULT_ID                        AS [Parent_ID]
     , pc.FIRST_NAME                      AS [First Name]
     , pc.LAST_NAME                       AS [Last Name]
     , pc.FIRST_NAME + ' ' +pc.LAST_NAME  AS [Full Name]
     , ''                                 AS [Nav_Student_ID]
     , ''                                 AS [FC_Reg_Code]
     , stu.SIS_NUMBER                     AS [Student_Address]
     , ''                                 AS [Add_1]
     , ''                                 AS [Add_2]
     , ''                                 AS [City]
     , ''                                 AS [State]
     , ''                                 AS [Zip]
     , ''                                 AS [Country]
     , ''                                 AS [Occupation]
     , pc.EMAIL                           AS [Parent_email]
     , pc.HomePhone                       AS [Home_phone]
     , pc.WorkPhone                       AS [Work_phone]
     , pc.CellPhone                       AS [Mobile_phone]
     , pc.FINANCIAL_RESPONSIBILITY        AS [Has_Financial_Responsibility]
     , pc.HAS_CUSTODY                     AS [Custodial]
     , ''                                 AS [Communications]
     , ''                                 AS [Alma_Mater]
FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU            = stu.STUDENT_GU 
                                            AND ssyr.STATUS              IS NULL
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU   = ssyr.ORGANIZATION_YEAR_GU
                                            AND oyr.YEAR_GU            = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
     JOIN ParentContact             pc   ON pc.STUDENT_GU              = stu.STUDENT_GU 
                                            and pc.PGNum in (1,2)
     JOIN rev.EPC_SCH_YR_OPT        sopt ON sopt.ORGANIZATION_YEAR_GU          = oyr.ORGANIZATION_YEAR_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') AS grade ON grade.VALUE_CODE = SSYR.GRADE
order by stu.SIS_NUMBER
