USE [ST_Production]
GO


CREATE VIEW [APS].[ParentContact] AS


with ParentContact AS
(
SELECT DISTINCT 
           stu.STUDENT_GU
         , stu.SIS_NUMBER
         , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY plist.CALL_ORDER) PGNum
         , plist.HomePhone
         , plist.CellPhone
         , plist.OtherPhone
         , plist.EMAIL
         , plist.CALL_ORDER
         , plist.PrimaryPhone
		 , RELATION
		 , plist.FIRST_NAME
		 , plist.LAST_NAME
FROM rev.EPC_STU_YR syr
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU
JOIN rev.EPC_STU stu                ON stu.STUDENT_GU = syr.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
JOIN rev.REV_ORGANIZATION org       ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_YEAR yr                ON yr.YEAR_GU = oyr.YEAR_GU
									   AND (yr.YEAR_GU IN (SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=2016 AND [EXTENSION] IN ('N', 'R'))) --[APS].[YearDates] WHERE CAST(GETDATE() AS DATE) BETWEEN [START_DATE] AND [END_DATE])
									   --OR yr.SCHOOL_YEAR IN (SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear])
									   --AND [yr].[EXTENSION]!='S')
JOIN (
      SELECT  DISTINCT
           stu.STUDENT_GU
         , stupar.ORDERBY CALL_ORDER
         , phone.H HomePhone
         , phone.C CellPhone
         , phone.O OtherPhone
         , par.EMAIL
         , ParPriPhone.Y PrimaryPhone
		 , stupar.RELATION_TYPE RELATION
		 , PAR.FIRST_NAME
		 , PAR.LAST_NAME
      FROM rev.EPC_STU_PARENT  stupar
           JOIN rev.REV_PERSON par ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
           JOIN rev.EPC_STU stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C],  [O])) phone ON phone.PERSON_GU = par.PERSON_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PRIMARY_PHONE FROM rev.REV_PERSON_PHONE phn) ParPhn
                      PIVOT (min(phone) FOR PRIMARY_PHONE in ([Y])) ParPriPhone ON ParPriPhone.PERSON_GU = par.PERSON_GU

     ) plist on plist.STUDENT_GU = stu.STUDENT_GU

GROUP BY
           stu.STUDENT_GU
         , stu.SIS_NUMBER
         , plist.HomePhone
         , plist.CellPhone
         , plist.OtherPhone
         , plist.EMAIL
         , plist.CALL_ORDER
         , plist.PrimaryPhone
		 , plist.RELATION
		 , plist.FIRST_NAME
		 , plist.LAST_NAME

)

SELECT DISTINCT 
  S.SIS_NUMBER                 AS [STUDENT ID NUMBER]
, SP.FIRST_NAME                AS [FIRST NAME]
, SP.LAST_NAME                 AS [LAST NAME]
, SP.PRIMARY_PHONE             AS [PHONE]
, SCH.SCHOOL_CODE              AS [SCHOOL ID]
-----------------
, Par1.HomePhone               AS [Parent1HomePhone]
, Par1.CellPhone               AS [Parent1CellPhone]
, Par1.OtherPhone              AS [Parent1OtherPhone]
, Par1.EMAIL                   AS [Parent1Email]
, Par1.RELATION				   AS Parent1Relation
, Par1.CALL_ORDER              AS [Parent1CallOrder]
, Par1.PrimaryPhone            AS [Parent1PrimaryPhone]
, Par1.FIRST_NAME		       AS Parent1FirstName
, Par1.LAST_NAME			   AS Parent1LastName
, Par2.HomePhone               AS [Parent2HomePhone]
, Par2.CellPhone               AS [Parent2CellPhone]
, Par2.OtherPhone              AS [Parent2OtherPhone]
, Par2.EMAIL                   AS [Parent2Email]
, Par2.RELATION				   AS Parent2Relation
, Par2.CALL_ORDER              AS [Parent2CallOrder]
, Par2.PrimaryPhone            AS [Parent2PrimaryPhone]
, Par2.FIRST_NAME			   AS Parent2FirstName
, Par2.LAST_NAME			   AS Parent2LastName
-----------------
, ssy.STATUS
FROM rev.EPC_STU               AS S 
JOIN rev.REV_PERSON            AS SP     ON SP.PERSON_GU            = S.STUDENT_GU 
JOIN rev.EPC_STU_SCH_YR        AS SSY    ON SSY.STUDENT_GU          = S.STUDENT_GU 
                                            AND SSY.LEAVE_DATE IS NULL 
                                            AND SSY.STATUS IS NULL 
--JOIN rev.EPC_STU_YR            AS SY     ON SY.STU_SCHOOL_YEAR_GU   = SSY.STUDENT_SCHOOL_YEAR_GU
JOIN rev.REV_ORGANIZATION_YEAR AS OY     ON OY.ORGANIZATION_YEAR_GU = SSY.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              AS Y      ON Y.YEAR_GU               = SSY.YEAR_GU 
											AND (y.YEAR_GU IN (SELECT [YEAR_GU] FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=(SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear]) AND [EXTENSION] IN ('N', 'R'))
									   OR y.SCHOOL_YEAR IN (SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear])
									   AND [y].[EXTENSION]='S')
JOIN rev.REV_ORGANIZATION      AS O      ON O.ORGANIZATION_GU       = OY.ORGANIZATION_GU 
JOIN rev.EPC_SCH               AS SCH    ON SCH.ORGANIZATION_GU     = O.ORGANIZATION_GU
LEFT JOIN rev.EPC_STU_PGM_ELL  AS ell    ON ell.STUDENT_GU          = s.STUDENT_GU 

------------------
LEFT JOIN ParentContact        AS Par1   ON par1.STUDENT_GU         = S.STUDENT_GU
                                            AND Par1.PGNum          = 1
LEFT JOIN ParentContact        AS Par2   ON par2.STUDENT_GU         = S.STUDENT_GU
                                            AND Par2.PGNum          = 2
-------------------
-------------------
WHERE SCH.SCHOOL_CODE IS NOT NULL
--ORDER BY [STUDENT ID NUMBER]

