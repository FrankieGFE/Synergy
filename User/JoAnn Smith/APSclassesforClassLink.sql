--On Roster  classes.csv --
declare  @vSchYr varchar(4)
set @vSchYr = '2017'  

SELECT distinct
	sch.SCHOOL_CODE + 
   crs.COURSE_ID + '.' +
   sect.SECTION_ID + '.' + @vSchYr						AS [sourcedId]
   , ''										AS [status]  --must be blank--
   , ''										AS [dateLastModified]  --must be blank--
    , crs.COURSE_TITLE						AS [title]
	, ''									AS [grades]  --will get info from courses.csv--
	, crs.COURSE_ID							AS [courseSourcedId]
	,sch.SCHOOL_CODE + 
   crs.COURSE_ID + '.' +
   sect.SECTION_ID							AS [classCode]
   , 'scheduled'							AS [classType]
   , ''										AS [location]  --leave blank--
   , sch.SCHOOL_CODE						AS [schoolSourcedId]
  , sect.TERM_CODE							AS [termSourcedIds]
  , ''										AS [subjects] --will get info from courses.csv--
  , ''										AS [subjectCodes]  --must be blank--
  , '"' + CAST(sect.PERIOD_BEGIN AS varchar)  + ','  +  CAST(sect.PERIOD_END AS varchar) + '"'		AS [periods] 
 
	
  

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                 ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL
                                                AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr           ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R' 
JOIN rev.REV_ORGANIZATION org                ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                         ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
JOIN rev.EPC_STU_CLASS scls                  ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
JOIN rev.EPC_SCH_YR_SECT sect                ON sect.SECTION_GU = scls.SECTION_GU
JOIN rev.EPC_SCH_YR_CRS ycrs                 ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS crs                         ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.REV_PERSON per                 ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
--LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1=1
AND scls.LEAVE_DATE is null
and stfp.EMAIL is not null
and scls.TEACHER_AIDE != 'Y'
and crs.COURSE_TITLE not like '%Homeroom%'
and crs.COURSE_TITLE not like '%Lunch%'
and crs.COURSE_TITLE not like '%AIDE%'
and crs.COURSE_TITLE not like '%Work Release%'
and crs.COURSE_TITLE not like '%Study Hall%'
and crs.COURSE_TITLE not like '%Sr Release%'
and crs.COURSE_TITLE not like '%Out of Building%'
and crs.COURSE_TITLE not like '%BCAT%'

