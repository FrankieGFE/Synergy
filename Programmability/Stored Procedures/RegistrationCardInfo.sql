/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-07-18 $
 */

USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[RegistrationCardInfo]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].RegistrationCardInfo AS SELECT 0')
GO

ALTER PROC [APS].RegistrationCardInfo

AS
BEGIN

SET NOCOUNT ON

--<APS - Registration Card Extract File>
------------
IF OBJECT_ID('tempdb..##TempSiblings1') IS NOT NULL DROP TABLE ##TempSiblings1
CREATE TABLE ##TempSiblings1
  (
    SIS_Number                varchar(14),
    StudentName               varchar(40),
    sn                        varchar(4),
    dn                        varchar(4),
    SiblingSISNumber          varchar(14),
	SiblingName               varchar(40)
   )

IF OBJECT_ID('tempdb..##TempSiblings2') IS NOT NULL DROP TABLE ##TempSiblings2
CREATE TABLE ##TempSiblings2
  (
    rownum                    varchar(4),
    SIS_Number                varchar(14),
    StudentName               varchar(40),
    sn                        varchar(4),
    dn                        varchar(4),
    SiblingSISNumber          varchar(14),
	SiblingName               varchar(40)
   )

IF OBJECT_ID('tempdb..##TempSiblings') IS NOT NULL DROP TABLE ##TempSiblings
CREATE TABLE ##TempSiblings
  (
    orderby                   varchar(4),
    rownum                    varchar(4),
    SIS_Number                varchar(14),
    StudentName               varchar(40),
    sn                        varchar(4),
    dn                        varchar(4),
    SiblingSISNumber          varchar(14),
	SiblingName               varchar(40)
   )

insert into ##TempSiblings1
     (
    SIS_Number,     
    StudentName,    
    sn,               
    dn,              
    SiblingSISNumber,
	SiblingName
	 )
select 
           stu.SIS_NUMBER                          sSIS_Number
         , per.FIRST_NAME + ' ' + per.LAST_NAME    sStudentName
         , row_number() over(partition by stu.sis_number order by sibp.scroll_composite_key) ssn
		 , row_number() over(partition by sibs.sis_number order by sibp.scroll_composite_key) sdn
		 , sibs.SIS_NUMBER                         sSiblingSISNumber
		 , sibp.FIRST_NAME + ' ' + sibp.LAST_NAME  sSiblingName
from     rev.epc_stu               stu
         join rev.REV_PERSON       per  on per.PERSON_GU     = stu.STUDENT_GU
         join rev.EPC_STU_PARENT   spar on spar.STUDENT_GU   = stu.STUDENT_GU
		 join rev.EPC_PARENT       par  on par.PARENT_GU     = spar.PARENT_GU
		 join rev.EPC_STU_PARENT   ppar on ppar.PARENT_GU    = par.PARENT_GU
		 join rev.EPC_STU          sibs on sibs.STUDENT_GU   = ppar.STUDENT_GU
		 join rev.REV_PERSON       sibp on sibp.PERSON_GU    = sibs.STUDENT_GU
where    stu.STUDENT_GU <> ppar.STUDENT_GU


insert into ##TempSiblings2
     (
	rownum,
    SIS_Number,     
    StudentName,    
    sn,               
    dn,              
    SiblingSISNumber,
	SiblingName
	 )
select 
row_number() over (partition by t.sis_number, t.siblingsisnumber order by sn) dn
,* from ##TempSiblings1 t

delete from ##TempSiblings2 
where rownum != '1'


insert into ##TempSiblings
     (
	orderby,
	rownum,
    SIS_Number,     
    StudentName,    
    sn,               
    dn,              
    SiblingSISNumber,
	SiblingName
	 )
select 
row_number() over (partition by t.sis_number order by sn) dn
,* from ##TempSiblings2 t
;

-----------
declare @SchRunYear INT = (select school_year from rev.SIF_22_Common_CurrentYear) + 1
declare @SchRunExt  CHAR(1) = 'R'
;with StuRacesR AS
( SELECT ethlist.PERSON_GU
        , ROW_NUMBER() OVER(PARTITION BY ethlist.PERSON_GU ORDER BY ethlist.PERSON_GU) rn
        , ethlist.ETHNIC_CODE 
        , edes.VALUE_DESCRIPTION RaceDes
  FROM rev.REV_PERSON_SECONDRY_ETH_LST ethlist 
       join rev.EPC_STU                s  on s.STUDENT_GU = ethlist.PERSON_GU
       join rev.EPC_STU_SCH_YR         sy on sy.STUDENT_GU = s.student_gu
       join rev.REV_YEAR               y  on y.YEAR_GU = sy.YEAR_GU 
                                             and y.SCHOOL_YEAR = @SchRunYear 
                                             and y.EXTENSION = @SchRunExt
       left join rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') edes on edes.VALUE_CODE = ethlist.ETHNIC_CODE
), ParentContactR AS
(
SELECT   
       stu.STUDENT_GU
     , stu.SIS_NUMBER
     , coalesce(stupar.orderby, ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY stupar.orderby)) PGNum
     , stupar.ORDERBY CALL_ORDER
     , par.FIRST_NAME
     , par.MIDDLE_NAME
     , par.LAST_NAME
     , par.GENDER
     , rel.VALUE_DESCRIPTION Relation
     , par.EMAIL
     , par.PRIMARY_PHONE
     , par.PRIMARY_PHONE_TYPE
     , hadr.ADDRESS ha
     , hadr.city    hc
     , hadr.state   hs
     , hadr.ZIP_5   hz5
     , hadr.ZIP_4   hz4
     , madr.ADDRESS ma
     , madr.city    mc
     , madr.state   ms
     , madr.ZIP_5   mz5
     , madr.ZIP_4   mz4
     , stupar.HAS_CUSTODY
     , stupar.LIVES_WITH
     , p.EMPLOYER
     , phone.W PHONE
     , upar.FEDERAL_EMPLOYER
     , upar.ACTIVE_MILITARY
     , upar.MILITARY_RANK
FROM rev.EPC_STU_PARENT             stupar
     JOIN rev.REV_PERSON            par  ON par.PERSON_GU            = stupar.PARENT_GU 
                                            and stupar.LIVES_WITH = 'Y'
     JOIN rev.EPC_STU               stu  ON stu.STUDENT_GU           = stupar.STUDENT_GU
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU          = stu.STUDENT_GU
	                                        and ssyr.STATUS is null
											and ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
     JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU               = oyr.YEAR_GU 
                                         and yr.SCHOOL_YEAR          = @SchRunYear
										 and yr.EXTENSION            = @SchRunExt
     JOIN rev.EPC_PARENT            p    ON p.PARENT_GU              = stupar.PARENT_GU
     LEFT JOIN rev.REV_ADDRESS      hadr ON hadr.ADDRESS_GU          = par.HOME_ADDRESS_GU
     LEFT JOIN rev.REV_ADDRESS      madr ON madr.ADDRESS_GU          = par.MAIL_ADDRESS_GU
     LEFT JOIN rev.UD_PARENT        upar ON upar.PARENT_GU           = p.PARENT_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel on rel.VALUE_CODE = stupar.RELATION_TYPE 
     LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn where phn.CONTACT_PHONE = 'Y' ) pl
                      PIVOT (min(phone) FOR phone_type in ([W])) phone ON phone.PERSON_GU = par.PERSON_GU

), EmgContactsR AS
(
SELECT   
       stu.STUDENT_GU
     , stu.SIS_NUMBER
     , ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY ec.orderby, ec.stu_emg_contact_gu) ECNum
     , ec.NAME
     , rel.VALUE_DESCRIPTION  RELATIONSHIP
     , ec.HOME_PHONE
     , ec.HOME_PHONE_EXTN
     , ec.WORK_PHONE
     , ec.WORK_PHONE_EXTN
     , ec.OTHER_PHONE
     , ec.OTHER_PHONE_EXTN
     , ec.OTHER_PHONE_TYPE
FROM rev.EPC_STU_EMG_CONTACT        ec
     JOIN rev.EPC_STU               stu  ON stu.STUDENT_GU           = ec.STUDENT_GU
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU          = stu.STUDENT_GU
	                                        and ssyr.STATUS is null
											and ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
     JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU               = oyr.YEAR_GU 
                                         and yr.SCHOOL_YEAR          = @SchRunYear
										 and yr.EXTENSION            = @SchRunExt
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.Emergency', 'RELATIONSHIP') rel on rel.VALUE_CODE = ec.RELATIONSHIP_DD
), ParentWorkPhone AS
(
SELECT   
       stu.STUDENT_GU
     , stu.SIS_NUMBER
     , coalesce(stupar.orderby, ROW_NUMBER() OVER(PARTITION BY stu.STUDENT_GU ORDER BY stupar.orderby)) PGNum
     , pphw.PHONE
FROM rev.EPC_STU_PARENT             stupar
     JOIN rev.REV_PERSON            par  ON par.PERSON_GU            = stupar.PARENT_GU 
                                            and stupar.LIVES_WITH = 'Y'
     JOIN rev.EPC_STU               stu  ON stu.STUDENT_GU           = stupar.STUDENT_GU
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU          = stu.STUDENT_GU
	                                        and ssyr.STATUS is null
											and ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU 
     JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU               = oyr.YEAR_GU 
                                         and yr.SCHOOL_YEAR          = @SchRunYear
										 and yr.EXTENSION            = @SchRunExt
     LEFT JOIN rev.REV_PERSON_PHOne pphw ON pphw.PERSON_GU           = stupar.PARENT_GU 
	                                                                   and pphw.PHONE_TYPE = 'W'
)
SELECT 
        CONVERT(VARCHAR(10), GETDATE(), 101)      AS [Today]
      , per.LAST_NAME                             AS [LastName]
      , per.FIRST_NAME                            AS [FirstName]
      , per.MIDDLE_NAME                           AS [MiddleInitial]
      , stu.SIS_NUMBER                            AS [StudentID]
      , lorg.ORGANIZATION_NAME                    AS [LastLocation]
      , grd.VALUE_DESCRIPTION                     AS [GradeLevel]
      , per.GENDER                                AS [Gender]
      , shlng.VALUE_DESCRIPTION                   AS [PHLOTE_Q1]
      , CONVERT(VARCHAR(10), per.BIRTH_DATE, 101) AS [DateOfBirth]
      , stu.BIRTH_STATE                           AS [Birth_State]
      , stu.BIRTH_COUNTRY                         AS [Birth_Country]
      , per.EMAIL                                 AS [Student_Email]
      , per.HISPANIC_INDICATOR                    AS [HispanicIndicator]
      , src1.RaceDes                              AS [Race_Primary]
      , src2.RaceDes                              AS [Race_Secondary]
      , nam.TRIBAL_COMMUNITY                      AS [Tribe]
      , nam.CERT_INDIAN_BLOOD                     AS [IndianEdCIB]
      , nam.INDIAN_ED                             AS [IndianEd506]
      , hadr.ADDRESS                              AS [Primary_Family_Address]
      , hadr.CITY                                 AS [Primary_Family_City]
      , hadr.STATE                                AS [Secondary_Family_State]
      , hadr.ZIP_5                                AS [Primary_Family_Zip]
      , hadr.ZIP_4                                AS [Zip_Code_4]
      , stu.ENROLL_LESS_THREE_OVR                 AS [School_US3]

      , p1.LAST_NAME                              AS [Primary_Family_HoH1_LastName]
      , p1.FIRST_NAME                             AS [Primary_Family_HoH1_FirstName]
      , p1.GENDER                                 AS [Primary_Family_HoH1_Gender]
      , p1.Relation                               AS [Primary_Family_HoH1_Relationship]
      , p1.PRIMARY_PHONE_TYPE                     AS [Parent1_PhoneType]
      , p1.PRIMARY_PHONE                          AS [Primary_Family_HomePhone_1]
      , p1.EMAIL                                  AS [Primary_Family_HoH1_Email_1]
      , p1.ha                                     AS [Primary_Family_Address_1]
      , p1.hc                                     AS [Primary_Family_City_1]
      , p1.hs                                     AS [Primary_Family_State_1]
      , p1.hz5                                    AS [Primary_Family_Zip_1]
      , p1.hz4                                    AS [Primary_Parent1_Zip4_1]
      , p1.ma                                     AS [Primary_Family_MailingAddress1_1]
      , p1.mc                                     AS [Primary_Family_MailingCity_1]
      , p1.ms                                     AS [Primary_Family_MailingState_1]
      , p1.mz5                                    AS [Primary_Family_MailingZip_1]
      , p1.mz4                                    AS [Primary_Family_MailZip4_1]
      , p1.HAS_CUSTODY                            AS [Primary_Family_HoH1_Legal_1]
      , p1.LIVES_WITH                             AS [Primary_Family_Lives_With_1]
      , p1.EMPLOYER                               AS [Primary_Parent1_Employer_1]
      , p1.PHONE                                  AS [Primary_Family_HoH1_WorkPhone_1]
      , p1.FEDERAL_EMPLOYER                       AS [Primary_Family_HoH1_FederalEmploy_1]
      , p1.ACTIVE_MILITARY                        AS [Primary_Family_HoH1_Military_1]
      , p1.MILITARY_RANK                          AS [Primary_Family_HoH1_Rank_1]
  
      , p2.LAST_NAME                              AS [Primary_Family_HoH2_LastName_2]
      , p2.FIRST_NAME                             AS [Primary_Family_HoH2_FirstName_2]
      , p2.GENDER                                 AS [Primary_Family_HoH2_Gender_2]
      , p2.Relation                               AS [Primary_Family_HoH2_Relationship_2]
      , p2.PRIMARY_PHONE_TYPE                     AS [Parent2_PhoneType_2]
      , p2.PRIMARY_PHONE                          AS [Primary_Family_HomePhone2_2]
      , p2.EMAIL                                  AS [Primary_Family_HoH2_Email_2]
      , p2.ha                                     AS [Parent2_Home_Address_2]
      , p2.hc                                     AS [Parent2_Home_City_2]
      , p2.hs                                     AS [Parent2_Home_State_2]
      , p2.hz5                                    AS [Parent2_Home_ZipCode5_2]
      , p2.hz4                                    AS [Parent2_Home_ZipCode4_2]
      , p2.ma                                     AS [Parent2_Home_MailAddress_2]
      , p2.mc                                     AS [Parent2_Home_MailCity_2]
      , p2.ms                                     AS [Parent2_Home_MailState_2]
      , p2.mz5                                    AS [Parent2_Home_MailZipCode5_2]
      , p2.mz4                                    AS [Parent2_Home_MailZipCode4_2]
      , p2.HAS_CUSTODY                            AS [Primary_Family_HoH2_Legal_2]
      , p2.LIVES_WITH                             AS [Parent2_Lives_With_2]
      , p2.EMPLOYER                               AS [Parent2_Employer_2]
      , p2.PHONE                                  AS [Primary_Family_HoH2_WorkPhone_2]
      , p2.FEDERAL_EMPLOYER                       AS [Parent2_FederalEmploy_2]
      , p2.ACTIVE_MILITARY                        AS [Primary_Family_HoH2_Military_2]
      , p2.MILITARY_RANK                          AS [Parent2_MilitaryRank_2]
  
      , p3.LAST_NAME                              AS [Secondary_Family_HoH1_LastName_3]
      , p3.FIRST_NAME                             AS [Secondary_Family_HoH1_FirstName_3]
      , p3.GENDER                                 AS [Secondary_Family_HoH1_Gender_3]
      , p3.Relation                               AS [Secondary_Family_HoH1_Relationship_3]
      , p3.PRIMARY_PHONE_TYPE                     AS [Parent3_PhoneType_3]
      , p3.PRIMARY_PHONE                          AS [Secondary_Family_HomePhone_3]
      , p3.EMAIL                                  AS [Secondary_Family_HoH1_Email_3]
      , p3.ha                                     AS [Secondary_Family_Address_3]
      , p3.hc                                     AS [Secondary_Family_City_3]
      , p3.hs                                     AS [Secondary_Family_State_3]
      , p3.hz5                                    AS [Secondary_Family_Zip_3]
      , p3.hz4                                    AS [Parent3_HomeZipCode4_3]
      , p3.ma                                     AS [Secondary_Family_MailingAddress1_3]
      , p3.mc                                     AS [Secondary_Family_MailingCity_3]
      , p3.ms                                     AS [Secondary_Family_MailingState_3]
      , p3.mz5                                    AS [Secondary_Family_MailingZip_3]
      , p3.mz4                                    AS [Parent3_MailZipCode4_3]
      , p3.HAS_CUSTODY                            AS [Parent3_HasCustody_3]
      , p3.LIVES_WITH                             AS [Secondary_Family_Lives_With_3]
      , p3.EMPLOYER                               AS [Parent3_Employer_3]
      , p3.PHONE                                  AS [Secondary_Family_HoH1_WorkPhone_3]
      , p3.FEDERAL_EMPLOYER                       AS [Secondary_Family_HoH1_FederalEmploy_3]
      , p3.ACTIVE_MILITARY                        AS [Secondary_Family_HoH1_Military_3]
      , p3.MILITARY_RANK                          AS [Parent3_MilitaryRank_3]
  
      , p4.LAST_NAME                              AS [Secondary_Family_HoH2_LastName_4]
      , p4.FIRST_NAME                             AS [Secondary_Family_HoH2_FirstName_4]
      , p4.GENDER                                 AS [Secondary_Family_HoH2_Gender_4]
      , p4.Relation                               AS [Secondary_Family_HoH2_Relationship_4]
      , p4.PRIMARY_PHONE_TYPE                     AS [Parent4_PhoneType_4]
      , p4.PRIMARY_PHONE                          AS [Parent4_PrimaryPhone_4]
      , p4.EMAIL                                  AS [Secondary_Family_HoH2_Email_4]
      , p4.ha                                     AS [Parent4_HomeAddress_4]
      , p4.hc                                     AS [Parent4_HomeCity_4]
      , p4.hs                                     AS [Parent4_HomeState_4]
      , p4.hz5                                    AS [Parent4_HomeZipCode5_4]
      , p4.hz4                                    AS [Parent4_HomeZipCode4_4]
      , p4.ma                                     AS [Parent4_MailAddress_4]
      , p4.mc                                     AS [Parent4_MailCity_4]
      , p4.ms                                     AS [Parent4_MailState_4]
      , p4.mz5                                    AS [Parent4_MailZipCode5_4]
      , p4.mz4                                    AS [Parent4_MailZipCode4_4]
      , p4.HAS_CUSTODY                            AS [Secondary_Family_HoH2_Legal_4]
      , p4.LIVES_WITH                             AS [Parent4_LivesWith_4]
      , p4.EMPLOYER                               AS [Parent4_Employer_4]
      , p4.PHONE                                  AS [Secondary_Family_HoH2_WorkPhone_4]
      , p4.FEDERAL_EMPLOYER                       AS [Secondary_Family_HoH2_FederalEmploy_4]
      , p4.ACTIVE_MILITARY                        AS [Secondary_Family_HoH2_Military_4]
      , p4.MILITARY_RANK                          AS [Parent4_MilitaryRank_4]
  
      , ec1.NAME                                  AS [Contact1_Name]
      , ec2.NAME                                  AS [Contact2_Name]
      , ec3.NAME                                  AS [Contact3_Name]
      , ec4.NAME                                  AS [Contact4_Name]
      , ec1.RELATIONSHIP                          AS [Contact1_Relationship]
      , ec2.RELATIONSHIP                          AS [Contact2_Relationship]
      , ec3.RELATIONSHIP                          AS [Contact3_Relationship]
      , ec4.RELATIONSHIP                          AS [Contact4_Relationship]
      , ec1.HOME_PHONE                            AS [Contact1_Phone]
      , ec2.HOME_PHONE                            AS [Contact2_Phone]
      , ec3.HOME_PHONE                            AS [Contact3_Phone]
      , ec4.HOME_PHONE                            AS [Contact4_Phone]
      , ec1.HOME_PHONE_EXTN                       AS [Contact1_HomePhoneExtn]
      , ec2.HOME_PHONE_EXTN                       AS [Contact2_HomePhoneExtn]
      , ec3.HOME_PHONE_EXTN                       AS [Contact3_HomePhoneExtn]
      , ec4.HOME_PHONE_EXTN                       AS [Contact4_HomePhoneExtn]
      , ec1.WORK_PHONE                            AS [Contact1_WorkPhone]
      , ec2.WORK_PHONE                            AS [Contact2_WorkPhone]
      , ec3.WORK_PHONE                            AS [Contact3_WorkPhone]
      , ec4.WORK_PHONE                            AS [Contact4_WorkPhone]
      , ec1.WORK_PHONE_EXTN                       AS [Contact1_WorkPhoneExtn]
      , ec2.WORK_PHONE_EXTN                       AS [Contact2_WorkPhoneExtn]
      , ec3.WORK_PHONE_EXTN                       AS [Contact3_WorkPhoneExtn]
      , ec4.WORK_PHONE_EXTN                       AS [Contact4_WorkPhoneExtn]
      , ec1.OTHER_PHONE                           AS [Contact1_OtherPhone]
      , ec2.OTHER_PHONE                           AS [Contact2_OtherPhone]
      , ec3.OTHER_PHONE                           AS [Contact3_OtherPhone]
      , ec4.OTHER_PHONE                           AS [Contact4_OtherPhone]
      , ec1.OTHER_PHONE_EXTN                      AS [Contact1_OtherPhoneExtn]
      , ec2.OTHER_PHONE_EXTN                      AS [Contact2_OtherPhoneExtn]
      , ec3.OTHER_PHONE_EXTN                      AS [Contact3_OtherPhoneExtn]
      , ec4.OTHER_PHONE_EXTN                      AS [Contact4_OtherPhoneExtn]
      , ec1.OTHER_PHONE_TYPE                      AS [Contact1_OtherPhoneType]
      , ec2.OTHER_PHONE_TYPE                      AS [Contact2_OtherPhoneType]
      , ec3.OTHER_PHONE_TYPE                      AS [Contact3_OtherPhoneType]
      , ec4.OTHER_PHONE_TYPE                      AS [Contact4_OtherPhoneType]

      , phy.NAME                                  AS [Emergency_Physician_Name]
      , phy.PHONE                                 AS [Emergency_Physician_Phone]
      , phy.PHONE_EXTENSION                       AS [Emergency_Physician_PhoneExtension]
      , phy.HOSPITAL                              AS [Emergency_Physician_Hospital]

      , shlng.VALUE_DESCRIPTION                   AS [PHLOTE_Q01]
      , lfst.VALUE_DESCRIPTION                    AS [PHLOTE_Q2]
      , lbho.VALUE_DESCRIPTION                    AS [PHLOTE_Q31]
      , ltho.VALUE_DESCRIPTION                    AS [PHLOTE_Q41]
      , lbat.VALUE_DESCRIPTION                    AS [PHLOTE_Q51]
      , ''                                        AS [blank01]
      , ''                                        AS [blank02]
      , ''                                        AS [blank03]
      , ''                                        AS [blank04]
      , ''                                        AS [blank05]
      , ''                                        AS [blank06]
      , ustu.ATTENDED_PREK                        AS [PreK]
      , ustu.PREK_PROGRAM                         AS [PreK_Program]
      , ustu.EXCLUDE_MILITARY                     AS [Exclude_Military]
      , ustu.EXCLUDE_UNIVERSITY                   AS [Exclude_Universities]
      , ustu.EXCLUDE_BUSINESS                     AS [Exclude_Businesses]
      , ''                                        AS [blank07]
      , ''                                        AS [blank08]
      , ''                                        AS [blank09]
      , stu.CUSTODY_CODE                          AS [Student_CustodyCode]
      , CASE 
            WHEN ssy.DENY_PHOTO_INTERVIEW is not null THEN 'Y'
           ELSE 'N'
        END                                       AS [DenyPhotoInterview]

      , s1.SiblingName                            AS [Sibling1_Name]
      , s1.SiblingSISNumber                       AS [Sibling1_Id]
      , s2.SiblingName                            AS [Sibling2_Name]
      , s2.SiblingSISNumber                       AS [Sibling2_Id]
      , s3.SiblingName                            AS [Sibling3_Name]
      , s3.SiblingSISNumber                       AS [Sibling3_Id]
      , s4.SiblingName                            AS [Sibling4_Name]
      , s4.SiblingSISNumber                       AS [Sibling4_Id]
      , s5.SiblingName                            AS [Sibling5_Name]
      , s5.SiblingSISNumber                       AS [Sibling5_Id]
      , s6.SiblingName                            AS [Sibling6_Name]
      , s6.SiblingSISNumber                       AS [Sibling6_Id]
	  , sch.SCHOOL_CODE                           AS [SCH_NBR]
	  , org.ORGANIZATION_NAME                     AS [School_Name]
FROM  rev.EPC_STU                     stu
      JOIN rev.EPC_STU_SCH_YR         ssy  ON ssy.STUDENT_GU           = stu.STUDENT_GU
                                              AND ssy.STATUS is NULL
      JOIN rev.REV_ORGANIZATION_YEAR  oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR               yr   ON yr.YEAR_GU               = oyr.YEAR_GU
                                              AND yr.SCHOOL_YEAR       = @SchRunYear
                                              AND yr.EXTENSION         = @SchRunExt
      JOIN rev.EPC_SCH                sch  ON sch.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	  JOIN rev.REV_ORGANIZATION       org  ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	  LEFT JOIN rev.REV_ORGANIZATION  lorg ON lorg.ORGANIZATION_GU     = ssy.LAST_SCHOOL_GU
      LEFT JOIN rev.EPC_SCH           schr ON schr.ORGANIZATION_GU     = ssy.SCHOOL_RESIDENCE_GU
      JOIN rev.REV_PERSON             per  ON per.PERSON_GU            = stu.STUDENT_GU
      LEFT JOIN rev.REV_ADDRESS       hadr ON hadr.ADDRESS_GU          = per.HOME_ADDRESS_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'LANGUAGE') shlng on shlng.VALUE_CODE = stu.HOME_LANGUAGE
      LEFT JOIN rev.UD_STU            ustu ON ustu.STUDENT_GU          = stu.STUDENT_GU
      --Student Race
      LEFT JOIN StuRacesR             src1 ON src1.PERSON_GU           = stu.STUDENT_GU and src1.rn = 1
      LEFT JOIN StuRacesR             src2 ON src2.PERSON_GU           = stu.STUDENT_GU and src2.rn = 2
      --Demographic Info
      LEFT JOIN rev.EPC_STU_NATIVE_AMERICAN nam ON nam.STUDENT_GU      = stu.STUDENT_GU
      --Parents
      LEFT JOIN ParentContactR        p1   ON p1.STUDENT_GU            = stu.STUDENT_GU and p1.PGNum = 1
      LEFT JOIN ParentContactR        p2   ON p2.STUDENT_GU            = stu.STUDENT_GU and p2.PGNum = 2
      LEFT JOIN ParentContactR        p3   ON p3.STUDENT_GU            = stu.STUDENT_GU and p3.PGNum = 3
      LEFT JOIN ParentContactR        p4   ON p4.STUDENT_GU            = stu.STUDENT_GU and p4.PGNum = 4
      --EmgContacts
      LEFT JOIN EmgContactsR          ec1  ON ec1.STUDENT_GU           = stu.STUDENT_GU and ec1.ECNum = 1
      LEFT JOIN EmgContactsR          ec2  ON ec2.STUDENT_GU           = stu.STUDENT_GU and ec2.ECNum = 2
      LEFT JOIN EmgContactsR          ec3  ON ec3.STUDENT_GU           = stu.STUDENT_GU and ec3.ECNum = 3
      LEFT JOIN EmgContactsR          ec4  ON ec4.STUDENT_GU           = stu.STUDENT_GU and ec4.ECNum = 4
      --Physician
      LEFT JOIN rev.EPC_STU_PHYSICIAN phy  ON phy.STUDENT_GU           = stu.STUDENT_GU
      --ELL
      LEFT JOIN rev.EPC_STU_PGM_ELL   ell  ON ell.STUDENT_GU           = stu.STUDENT_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'LANGUAGE') lfst on lfst.VALUE_CODE = ell.LANGUAGE_FIRST_LEARN
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'LANGUAGE') lbho on lbho.VALUE_CODE = ell.LANGUAGE_BY_HOME
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'LANGUAGE') ltho on ltho.VALUE_CODE = ell.LANGUAGE_TO_HOME
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'LANGUAGE') lbat on lbat.VALUE_CODE = ell.LANGUAGE_BY_ADULT_HOME
      -- Siblings
      LEFT JOIN ##TempSiblings              s1   ON s1.SIS_Number = stu.SIS_NUMBER and s1.orderby = 1
      LEFT JOIN ##TempSiblings              s2   ON s2.SIS_Number = stu.SIS_NUMBER and s2.orderby = 2 
      LEFT JOIN ##TempSiblings              s3   ON s3.SIS_Number = stu.SIS_NUMBER and s3.orderby = 3 
      LEFT JOIN ##TempSiblings              s4   ON s4.SIS_Number = stu.SIS_NUMBER and s4.orderby = 4 
      LEFT JOIN ##TempSiblings              s5   ON s5.SIS_Number = stu.SIS_NUMBER and s5.orderby = 5 
      LEFT JOIN ##TempSiblings              s6   ON s6.SIS_Number = stu.SIS_NUMBER and s6.orderby = 6

IF OBJECT_ID('tempdb..##TempSiblings1') IS NOT NULL DROP TABLE ##TempSiblings1
IF OBJECT_ID('tempdb..##TempSiblings2') IS NOT NULL DROP TABLE ##TempSiblings2
IF OBJECT_ID('tempdb..##TempSiblings') IS NOT NULL DROP TABLE ##TempSiblings

SET NOCOUNT OFF

END --END STORED PROCEDURE

GO
