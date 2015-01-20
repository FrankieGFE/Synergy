--<APS - DIBELS Amplify - Student>
declare @SchYr INT
declare @SchExt varchar(1) = 'R'
set @SchYr = (select school_year from rev.SIF_22_Common_CurrentYear) 
--set @SchYr = 2014 -- remove tha add 1 post roll over
;with SpedRpt AS
(
  select 
      srpt.DISABILITY_PRIMARY
	, row_number() over(partition by s.student_gu order by s.student_gu) rn
	, srpt.STUDENT_GU
  from rev.EPC_NM_STU_SPED_RPT  srpt 
  join rev.EPC_STU               s    on s.STUDENT_GU = srpt.STUDENT_GU
  JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU           = s.STUDENT_GU
                                         AND ssy.STATUS is NULL
  JOIN rev.REV_ORGANIZATION_YEAR  oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU  
  JOIN rev.REV_YEAR               yr   ON yr.YEAR_GU               = oyr.YEAR_GU
                                          and yr.SCHOOL_YEAR       = @SchYr
										  and yr.EXTENSION         = @SchExt
   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
   WHERE grd.value_description in ('K', '01','02','03')
)

SELECT
        org.ORGANIZATION_NAME                                         AS [Institution]
      , stu.STATE_STUDENT_NUMBER                                      AS [State ID]
      , stu.SIS_NUMBER                                                AS [District ID]
      , ''                                                            AS [School ID]
/*K-3 Plus schools reporting Student State Number by Sean McMurray 1/20/2015*/
      , CASE WHEN org.ORGANIZATION_NAME = 'A. Montoya Elementary School'             THEN 'K3' + stu.STATE_STUDENT_NUMBER
	         WHEN org.ORGANIZATION_NAME = 'Acoma Elementary School'                  THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Alvarado Elementary School'               THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Apache Elementary School'                 THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Arroyo Del Oso Elementary School'         THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Atrisco Elementary School'                THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Bandelier Elementary School'              THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Chamiza Elementary School'                THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Chaparral Elementary School'              THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Collett Park Elementary School'           THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Comanche Elementary School'               THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Coronado Elementary School'               THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Corrales Elementary School'				 THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Dennis Chavez Elementary School'          THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Desert Willow Family Elementary School'   THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Double Eagle Elementary School'           THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'E.G. Ross Elementary School'              THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME LIKE '%Georgia%'                             THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Governor Bent Elementary School'          THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Griegos Primary School'                   THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Hubert Humphrey Elementary School'        THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Inez Elementary School'                   THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'John Baker Elementary School'             THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Manzano Mesa Elementary School'           THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Marie M. Hughes Elementary School'        THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Mark Twain Elementary School'             THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Matheson Park Elementary School'          THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'McCollum Elementary School'               THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Monte Vista Elementary School'            THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Montezuma Elementary School'              THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Navajo Elementary School'                 THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'North Star Elementary School'             THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Onate Elementary School'                  THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Osuna Elementary School'                  THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Pajarito Elementary School'               THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Petroglyph Elementary School'             THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Seven Bar Elementary School'              THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'S.Y. Jackson Elementary School'           THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'San Antonio Elementary School'            THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Sandia Base Elementary School'            THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Sierra Vista Elementary School'           THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Sombra Del Monte Elementary School'       THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Sunset View School'                       THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'The Family School'                        THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME	= 'Tierra Antigua Elementary School'         THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Zia Elementary School'                    THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 WHEN org.ORGANIZATION_NAME = 'Zuni Elementary'                          THEN 'K3' + stu.STATE_STUDENT_NUMBER
			 ELSE ''
	    END                                                           AS [K-3 Plus ID]



      , per.LAST_NAME                                                 AS [Student Last Name]
      , per.FIRST_NAME                                                AS [Student First Name]
      , per.MIDDLE_NAME                                               AS [Middle Name]
      , ''                                                            AS [Suffix]
      , grd.VALUE_DESCRIPTION                                         AS [Grade]
      , crs.COURSE_TITLE                                              AS [Homeroom]
      , CONVERT(VARCHAR(10), per.BIRTH_DATE,101)                      AS [DOB]
	  , ''                                                            AS [Student Email]
      , per.GENDER                                                    AS [Gender]
      , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'H'
             WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' THEN 'M'
	         WHEN per.RESOLVED_ETHNICITY_RACE = '1'     THEN 'W'
             WHEN per.RESOLVED_ETHNICITY_RACE = '100'   THEN 'AI'
             WHEN per.RESOLVED_ETHNICITY_RACE = '299'   THEN 'AS'
             WHEN per.RESOLVED_ETHNICITY_RACE = '399'   THEN 'J'
             WHEN per.RESOLVED_ETHNICITY_RACE = '600'   THEN 'B'
        END                                                           AS [Race/Ethnicity]
      , ''                                                            AS [Eligible for Special Education]
      , ''                                                            AS [Student with Disabilities]
      , COALESCE(sped.PRIMARY_DISABILITY_CODE, sr.DISABILITY_PRIMARY) AS [Specific Disability]
      , ''                                                            AS [Section 504]
      , ''                                                            AS [Economically Disadvantaged]
      , fr.VALUE_CODE + '-' + fr.VALUE_DESCRIPTION                    AS [Eligible for Free/Reduced Lunch]
      , ''                                                            AS [Title I]
      , ''                                                            AS [Migrant]
      , ''                                                            AS [English Proficiency]
      , ''                                                            AS [ESL (English as a Second Language)]
      , hlng.VALUE_DESCRIPTION                                        AS [Language Spoken at Home]
      , ''                                                            AS [Eligible for Alternate Assessment]
      , ''                                                            AS [Approved Accommodations]
      , ''                                                            AS [Number of Absences]
FROM  rev.EPC_STU                         stu
      JOIN rev.EPC_STU_SCH_YR             ssy  ON ssy.STUDENT_GU             = stu.STUDENT_GU
                                                  AND ssy.STATUS is NULL
      JOIN rev.REV_ORGANIZATION_YEAR      oyr  ON oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR                   yr   ON yr.YEAR_GU                 = oyr.YEAR_GU
                                                  AND yr.SCHOOL_YEAR         = @SchYr
												  AND yr.EXTENSION           = @SchExt
      JOIN rev.EPC_SCH                    sch  ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
      JOIN rev.REV_ORGANIZATION           org  ON org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
      JOIN rev.REV_PERSON                 per  ON per.PERSON_GU              = stu.STUDENT_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
	  LEFT JOIN rev.EPC_SCH_YR_SECT       sect ON sect.SECTION_GU            = ssy.HOMEROOM_SECTION_GU
	  LEFT JOIN rev.EPC_SCH_YR_CRS        ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
	  LEFT JOIN rev.EPC_CRS               crs  ON crs.COURSE_GU              = ycrs.COURSE_GU
	  LEFT JOIN rev.EP_STUDENT_SPECIAL_ED sped ON sped.STUDENT_GU            = stu.STUDENT_GU
      LEFT JOIN SpedRpt                   sr   ON sr.STUDENT_GU              = stu.STUDENT_GU and sr.rn = 1
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'LANGUAGE') hlng on hlng.VALUE_CODE = stu.HOME_LANGUAGE
	  LEFT JOIN rev.EPC_STU_PGM_FRM       frm  ON frm.STUDENT_GU             = stu.STUDENT_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.ProgramInfo', 'FRM_CODE') fr on fr.VALUE_CODE = frm.FRM_CODE
WHERE grd.value_description in ('K', '01','02','03')