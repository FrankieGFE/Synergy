--<APS - DIBELS Amplify - Student>
--Pulls DIBELS based on ORGANIZATION_NAME
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
      , CASE WHEN org.ORGANIZATION_NAME = 'Adobe Acres Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Alameda Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Alamosa Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Armijo Elementary' THEN '1'
		     WHEN org.ORGANIZATION_NAME = 'Barcelona Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Bel-Air Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Carlos Rey Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Chelwood Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Cochiti Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Dolores Gonzales Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Douglas MacArthur Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Duranes Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'East San Jose Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Edward Gonzales Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Emerson Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Eubank Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Eugene Field Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Hawthorne Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Helen Cordero Primary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Hodgin Elementary' THEN '1'
			 WHEN org.ORGANIZATION_NAME = 'Kirtland Elementary' THEN '1'
   			 WHEN org.ORGANIZATION_NAME = 'Kit Carson Elementary' THEN '1'

		END							                                  AS [K-3 Plus ID]
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