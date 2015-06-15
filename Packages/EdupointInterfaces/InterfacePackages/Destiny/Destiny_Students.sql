---<APS - Destiny>
; with StuPhones AS
(
  SELECT
           phn.PHONE
		 , phn.PHONE_TYPE
		 , phn.PRIMARY_PHONE
		 , stu.STUDENT_GU
		 , ROW_NUMBER() OVER (partition by stu.student_gu order by stu.student_gu, phn.Primary_Phone desc) rn
  FROM   rev.REV_PERSON_PHONE           phn
         JOIN rev.EPC_STU               stu  ON stu.STUDENT_GU = phn.PERSON_GU
         JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL
												AND ssyr.EXCLUDE_ADA_ADM is null
         JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                                AND oyr.YEAR_GU = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
) , TeacherName AS
(
SELECT   stu.STUDENT_GU
       , row_number() over (partition by stu.student_gu order by stu.student_gu, symd.orderby) rn  
       , sect.PERIOD_BEGIN                      AS Period
       , stfp.LAST_NAME + ', ' + stfp.FIRST_NAME AS TeacherName
FROM   rev.EPC_STU                          stu
       JOIN rev.EPC_STU_SCH_YR              ssy  ON ssy.STUDENT_GU                 = stu.STUDENT_GU
                                                    and ssy.STATUS is NULL
												    AND ssy.EXCLUDE_ADA_ADM is null
       JOIN rev.REV_ORGANIZATION_YEAR       oyr  ON oyr.ORGANIZATION_YEAR_GU       = ssy.ORGANIZATION_YEAR_GU
	                                                and oyr.YEAR_GU                = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_ORGANIZATION            org  ON org.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH                     sch  ON sch.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS               cls  ON cls.STUDENT_SCHOOL_YEAR_GU     = ssy.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT             sect ON sect.SECTION_GU                = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS              scrs ON scrs.SCHOOL_YEAR_COURSE_GU     = sect.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_STAFF_SCH_YR            stfy ON stfy.STAFF_SCHOOL_YEAR_GU      = sect.STAFF_SCHOOL_YEAR_GU
       JOIN rev.REV_PERSON                  stfp ON stfp.PERSON_GU                 = stfy.STAFF_GU
       LEFT JOIN rev.EPC_SCH_YR_SECT_MET_DY smdy ON smdy.SECTION_GU                = sect.SECTION_GU
	   LEFT JOIN rev.EPC_SCH_YR_MET_DY      symd ON symd.SCH_YR_MET_DY_GU          = smdy.SCH_YR_MET_DY_GU
	   JOIN ##LibSchHomeroom                lhm  ON lhm.SCHOOL_CODE                = sch.SCHOOL_CODE 
	                                                and lhm.HOMEROOM_PERIOD_NUMBER = CAST(sect.PERIOD_BEGIN as char(02))
	   JOIN ##Terms                         trms ON trms.OrgGu                     = oyr.ORGANIZATION_GU
	                                                AND trms.TermCode              = sect.TERM_CODE 
--WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())
--       AND cls.ENTER_DATE <= GETDATE()
--	   AND GETDATE() between trms.TermStart and trms.TermEnd
), OnlySummer AS
(
  SELECT
     stu.student_gu
  FROM rev.EPC_STU                  stu
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                            AND ssyr.STATUS IS NULL
											AND ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssyr.YEAR_GU
                                            AND yr.SCHOOL_YEAR = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                            AND yr.EXTENSION   = 'S'
), SummerTchName AS
(
SELECT   stu.STUDENT_GU
       , row_number() over (partition by stu.student_gu order by stu.student_gu, symd.orderby) rn  
       , sect.PERIOD_BEGIN                      AS Period
       , stfp.LAST_NAME + ', ' + stfp.FIRST_NAME AS TeacherName
FROM   rev.EPC_STU                          stu
       JOIN rev.EPC_STU_SCH_YR              ssy  ON ssy.STUDENT_GU                 = stu.STUDENT_GU
                                                    and ssy.STATUS is NULL
												    AND ssy.EXCLUDE_ADA_ADM is null
       JOIN rev.REV_ORGANIZATION_YEAR       oyr  ON oyr.ORGANIZATION_YEAR_GU       = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR                     yr   ON yr.YEAR_GU = ssy.YEAR_GU
                                                   AND yr.SCHOOL_YEAR = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                                   AND yr.EXTENSION   = 'S'
       JOIN rev.REV_ORGANIZATION            org  ON org.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH                     sch  ON sch.ORGANIZATION_GU            = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS               cls  ON cls.STUDENT_SCHOOL_YEAR_GU     = ssy.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT             sect ON sect.SECTION_GU                = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS              scrs ON scrs.SCHOOL_YEAR_COURSE_GU     = sect.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_STAFF_SCH_YR            stfy ON stfy.STAFF_SCHOOL_YEAR_GU      = sect.STAFF_SCHOOL_YEAR_GU
       JOIN rev.REV_PERSON                  stfp ON stfp.PERSON_GU                 = stfy.STAFF_GU
       LEFT JOIN rev.EPC_SCH_YR_SECT_MET_DY smdy ON smdy.SECTION_GU                = sect.SECTION_GU
	   LEFT JOIN rev.EPC_SCH_YR_MET_DY      symd ON symd.SCH_YR_MET_DY_GU          = smdy.SCH_YR_MET_DY_GU
	   JOIN ##LibSchHomeroom                lhm  ON lhm.SCHOOL_CODE                = sch.SCHOOL_CODE 
	                                                and lhm.HOMEROOM_PERIOD_NUMBER = CAST(sect.PERIOD_BEGIN as char(02))
	   JOIN ##SummerTerms                   trms ON trms.OrgGu                     = oyr.ORGANIZATION_GU
	                                                AND trms.TermCode              = sect.TERM_CODE 

)
-- Only Regular enrollments
SELECT 
         stu.SIS_NUMBER           AS [ID Number]
       , sch.SCHOOL_CODE          AS [School Number]
       , stu.STATE_STUDENT_NUMBER AS [State ID]
       , per.LAST_NAME            AS [Last Name]
       , per.FIRST_NAME           AS [First Name]
       , per.MIDDLE_NAME          AS [Middle Name]
       , per.GENDER               AS [Gender]
       , grade.VALUE_DESCRIPTION  AS [Grade]
       , tnm.TeacherName          AS [Full Name]
       , stu.USER_CODE_1          AS [Prior ID Number]
       , ''                       AS [BirthDate]
       , CASE WHEN madr.STREET_EXTRA is not null then replace(madr.ADDRESS,madr.STREET_EXTRA,'')
	          ELSE madr.ADDRESS
		 END                      AS [Address 1]
       , madr.STREET_EXTRA        AS [Address 2]
       , madr.city                AS [City]
       , madr.STATE               AS [State]
       , madr.ZIP_5               AS [ZIP Code]
       , p1.PHONE                 AS [Telephone1]
       , p2.PHONE                 AS [Telephone2]
FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                            AND ssyr.STATUS IS NULL
											AND ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssyr.YEAR_GU
                                            AND yr.SCHOOL_YEAR = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                            AND yr.EXTENSION   = 'R'
     JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
     JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssyr.GRADE
     LEFT JOIN rev.REV_ADDRESS      madr ON madr.ADDRESS_GU = COALESCE(per.MAIL_ADDRESS_GU, per.HOME_ADDRESS_GU)
	 LEFT JOIN StuPhones            p1   ON p1.STUDENT_GU = stu.STUDENT_GU and p1.rn = 1
	 LEFT JOIN StuPhones            p2   ON p2.STUDENT_GU = stu.STUDENT_GU and p2.rn = 2
	 LEFT JOIN TeacherName          tnm  ON tnm.STUDENT_GU = stu.STUDENT_GU and tnm.rn = 1
	 LEFT JOIN OnlySummer         Summer ON Summer.STUDENT_GU = stu.STUDENT_GU
WHERE summer.STUDENT_GU is null
-- Only Summer
UNION
SELECT 
         stu.SIS_NUMBER           AS [ID Number]
       , sch.SCHOOL_CODE          AS [School Number]
       , stu.STATE_STUDENT_NUMBER AS [State ID]
       , per.LAST_NAME            AS [Last Name]
       , per.FIRST_NAME           AS [First Name]
       , per.MIDDLE_NAME          AS [Middle Name]
       , per.GENDER               AS [Gender]
       , grade.VALUE_DESCRIPTION  AS [Grade]
       , tnm.TeacherName          AS [Full Name]
       , stu.USER_CODE_1          AS [Prior ID Number]
       , ''                       AS [BirthDate]
       , CASE WHEN madr.STREET_EXTRA is not null then replace(madr.ADDRESS,madr.STREET_EXTRA,'')
	          ELSE madr.ADDRESS
		 END                      AS [Address 1]
       , madr.STREET_EXTRA        AS [Address 2]
       , madr.city                AS [City]
       , madr.STATE               AS [State]
       , madr.ZIP_5               AS [ZIP Code]
       , p1.PHONE                 AS [Telephone1]
       , p2.PHONE                 AS [Telephone2]
FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                            AND ssyr.STATUS IS NULL
											AND ssyr.EXCLUDE_ADA_ADM is null
     JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = ssyr.YEAR_GU
                                            AND yr.SCHOOL_YEAR = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
                                            AND yr.EXTENSION   = 'S'
     JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
     JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssyr.GRADE
     LEFT JOIN rev.REV_ADDRESS      madr ON madr.ADDRESS_GU = COALESCE(per.MAIL_ADDRESS_GU, per.HOME_ADDRESS_GU)
	 LEFT JOIN StuPhones            p1   ON p1.STUDENT_GU = stu.STUDENT_GU and p1.rn = 1
	 LEFT JOIN StuPhones            p2   ON p2.STUDENT_GU = stu.STUDENT_GU and p2.rn = 2
	 LEFT JOIN SummerTchName        tnm  ON tnm.STUDENT_GU = stu.STUDENT_GU and tnm.rn = 1
