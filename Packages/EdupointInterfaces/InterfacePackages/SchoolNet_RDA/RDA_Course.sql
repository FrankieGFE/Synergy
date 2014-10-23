--<APS - SchoolNet - RDA - Course>
declare @SchYr INT
declare @SchExt varchar(1) = 'R'
declare @RunDate smalldatetime = getdate()
set @SchYr = (select school_year from rev.SIF_22_Common_CurrentYear) 
----**********  Comment out these post year roll over *******
--set @RunDate = '08/04/2014'
--set @SchYr = 2014  
------------------------------------------------------------
SELECT distinct

   stu.SIS_NUMBER                   AS [ID_NBR]
 , replace(stf.BADGE_NUM, 'e', '')  AS [EMP_NBR]
 , sch.SCHOOL_CODE                  AS [SCH_NBR]
 , @RunDate                         AS [DATE_CREATE]
 , crs.COURSE_ID                    AS [CRS_ASG]

FROM  rev.EPC_STU                         stu
      JOIN rev.EPC_STU_SCH_YR             ssy   ON ssy.STUDENT_GU              = stu.STUDENT_GU
                                                   AND ssy.STATUS is NULL
      JOIN rev.REV_ORGANIZATION_YEAR      oyr   ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR                   yr    ON yr.YEAR_GU                  = oyr.YEAR_GU
                                                   AND yr.SCHOOL_YEAR          = @SchYr
                                                   AND yr.EXTENSION            = @SchExt
      JOIN rev.EPC_SCH                    sch   ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU
      JOIN REV.EPC_STU_CLASS              cls   ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
      JOIN REV.EPC_SCH_YR_SECT            sec   ON cls.SECTION_GU              = sec.SECTION_GU
      LEFT JOIN rev.EPC_SCH_YR_SECT       sect  ON sect.SECTION_GU             = ssy.HOMEROOM_SECTION_GU
      LEFT JOIN rev.EPC_SCH_YR_CRS        ycrs  ON ycrs.SCHOOL_YEAR_COURSE_GU  = sect.SCHOOL_YEAR_COURSE_GU
      LEFT JOIN rev.EPC_CRS               crs   ON crs.COURSE_GU               = ycrs.COURSE_GU
      LEFT JOIN rev.EPC_STAFF_SCH_YR      stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU  = sect.STAFF_SCHOOL_YEAR_GU
      LEFT JOIN rev.EPC_STAFF             stf   ON stf.STAFF_GU                = stfsy.STAFF_GU
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= @RunDate)
       AND cls.ENTER_DATE <= @RunDate
       AND cls.ENTER_DATE <= @RunDate