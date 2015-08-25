--<APS - DIBELS Amplify - Class>
declare @SchYr INT
declare @SchExt varchar(1) = 'R'
set @SchYr = (select school_year from rev.SIF_22_Common_CurrentYear) 
--set @SchYr = 2014  -- remove tha add 1 post roll over
SELECT DISTINCT

   org.ORGANIZATION_NAME  AS [Institution]
 , LEFT(stfp.FIRST_NAME,1) + stfp.LAST_NAME         AS [Primary Class ID]
 , LEFT(stfp.FIRST_NAME,1) + stfp.LAST_NAME         AS [Class Name]
 , grd.VALUE_DESCRIPTION  AS [Grade]
 , ''                     AS [Course Code]

FROM  rev.EPC_STU                         stu
      JOIN rev.EPC_STU_SCH_YR             ssy   ON ssy.STUDENT_GU              = stu.STUDENT_GU
                                                   AND ssy.STATUS is NULL
      JOIN rev.REV_ORGANIZATION_YEAR      oyr   ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR                   yr    ON yr.YEAR_GU                  = oyr.YEAR_GU
                                                   AND (yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
														--OR yr.SCHOOL_YEAR = '2015'
														)
      JOIN rev.EPC_SCH                    sch   ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU
      JOIN rev.REV_ORGANIZATION           org   ON org.ORGANIZATION_GU         = oyr.ORGANIZATION_GU
      JOIN REV.EPC_STU_CLASS              cls   ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
      JOIN REV.EPC_SCH_YR_SECT            sec   ON cls.SECTION_GU              = sec.SECTION_GU
      LEFT JOIN rev.EPC_SCH_YR_SECT       sect  ON sect.SECTION_GU             = ssy.HOMEROOM_SECTION_GU
      LEFT JOIN rev.EPC_SCH_YR_CRS        ycrs  ON ycrs.SCHOOL_YEAR_COURSE_GU  = sect.SCHOOL_YEAR_COURSE_GU
      LEFT JOIN rev.EPC_CRS               crs   ON crs.COURSE_GU               = ycrs.COURSE_GU
	  LEFT JOIN rev.EPC_STAFF_SCH_YR      stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU  = sect.STAFF_SCHOOL_YEAR_GU
	  LEFT JOIN rev.EPC_STAFF             stf   ON stf.STAFF_GU                = stfsy.STAFF_GU
	  LEFT JOIN rev.REV_PERSON            stfp  ON stfp.PERSON_GU              = stf.STAFF_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = sect.GRADE_RANGE_LOW
WHERE grd.value_description in ('K', '01','02','03')
      AND crs.COURSE_ID is not null