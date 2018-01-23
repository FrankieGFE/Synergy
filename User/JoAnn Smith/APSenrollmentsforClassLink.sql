--One Roster enrollments.csv--
declare  @vSchYr varchar(4), @vBFY varchar (10), @vBS2 varchar (10), @vBQ2 varchar (10), @vBQ4 varchar (10), @vEFY varchar (10), @vES1 varchar (10), @vEQ1 varchar (10), @vEQ3 varchar (10)
set @vSchYr = '2017'  
--B = begining dates E = Ending dates--
/* changed these after querying aps.termdates jss */
set @vBFY = '2017-08-14'
set @vBS2 = '2018-01-04'
set @vBQ2 = '2017-10-16'
set @vBQ4 = '2018-03-13'
set @vEFY = '2018-05-23'
set @vES1 = '2018-12-15'
set @vEQ1 = '2017-10-11'
set @vEQ3 = '2018-03-10'

--students enrollments-- Placement is null
SELECT 
    sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID  + '.' + stu.SIS_NUMBER							AS [sourcedId]
	, ''									AS [status]
	, ''									AS [dateLastModified]
	, sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID + '.' + @vSchYr         AS [classSourcedId]
  , sch.SCHOOL_CODE							 AS [schoolSourcedId]
  , stu.SIS_NUMBER							 AS [userSourcedId]
  , 'student'								 AS [role]
  , ''										 AS [primary]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S1' or sect.TERM_CODE ='Q1') THEN @vBFY
         WHEN (sect.TERM_CODE = 'S2' or sect.TERM_CODE = 'Q3') THEN @vBS2
		 WHEN sect.TERM_CODE = 'Q2' THEN @vBQ2
		 WHEN sect.TERM_CODE = 'Q4' THEN @vBQ4	
		 ELSE ''	
		 END							 AS [beginDate]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S2' or sect.TERM_CODE ='Q4') THEN @vEFY
         WHEN (sect.TERM_CODE = 'S1' or sect.TERM_CODE = 'Q2') THEN @vES1
		 WHEN sect.TERM_CODE = 'Q1' THEN @vEQ1
		 WHEN sect.TERM_CODE = 'Q3' THEN @vEQ3	
		 ELSE ''	
		 END										 AS [endDate]
		
  
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
LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
--LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1
AND scls.LEAVE_DATE is null
and stfp.EMAIL is NOT NULL
and scls.TEACHER_AIDE != 'Y'
and crs.COURSE_TITLE not like '%Homeroom%'
and crs.COURSE_TITLE not like '%Lunch%'
and crs.COURSE_TITLE not like '%AIDE%'
and crs.COURSE_TITLE not like '%Work Release%'
and crs.COURSE_TITLE not like '%Study Hall%'
and crs.COURSE_TITLE not like '%Sr Release%'
and crs.COURSE_TITLE not like '%Out of Building%'
and crs.COURSE_TITLE not like '%BCAT%'


Union

--Placement is not RES, PVDS or PSS
SELECT 
    sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID  + '.' + stu.SIS_NUMBER							AS [sourcedId]
	, ''									AS [status]
	, ''									AS [dateLastModified]
	, sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID + '.' + @vSchYr         AS [classSourcedId]
  , sch.SCHOOL_CODE							 AS [schoolSourcedId]
  , stu.SIS_NUMBER							 AS [userSourcedId]
  , 'student'								 AS [role]
  , ''										 AS [primary]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S1' or sect.TERM_CODE ='Q1') THEN @vBFY
         WHEN (sect.TERM_CODE = 'S2' or sect.TERM_CODE = 'Q3') THEN @vBS2
		 WHEN sect.TERM_CODE = 'Q2' THEN @vBQ2
		 WHEN sect.TERM_CODE = 'Q4' THEN @vBQ4	
		 ELSE ''	
		 END							 AS [beginDate]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S2' or sect.TERM_CODE ='Q4') THEN @vEFY
         WHEN (sect.TERM_CODE = 'S1' or sect.TERM_CODE = 'Q2') THEN @vES1
		 WHEN sect.TERM_CODE = 'Q1' THEN @vEQ1
		 WHEN sect.TERM_CODE = 'Q3' THEN @vEQ3	
		 ELSE ''	
		 END										 AS [endDate]
		
  
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
LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
WHERE
1 = 1
AND scls.LEAVE_DATE is null
and stfp.EMAIL is NOT NULL
and scls.TEACHER_AIDE != 'Y'
and crs.COURSE_TITLE not like '%Homeroom%'
and crs.COURSE_TITLE not like '%Lunch%'
and crs.COURSE_TITLE not like '%AIDE%'
and crs.COURSE_TITLE not like '%Work Release%'
and crs.COURSE_TITLE not like '%Study Hall%'
and crs.COURSE_TITLE not like '%Sr Release%'
and crs.COURSE_TITLE not like '%Out of Building%'
and crs.COURSE_TITLE not like '%BCAT%'


Union

-- Teacher enrollments --

SELECT DISTINCT 
  sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID + '.' + 'T' + stfp.BADGE_NUM							AS [sourceId]
	, ''									AS [status]
	, ''									AS [dateLastModified]
	, sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID + '.' + @vSchYr        AS [classSourcedId]
  , sch.SCHOOL_CODE							 AS [schoolSourcedId]
  , 'T' + stfp.BADGE_NUM					 AS [userSourcedId]
  , 'teacher'								 AS [role]
  , 'true'									 AS [primary]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S1' or sect.TERM_CODE ='Q1') THEN @vBFY
         WHEN (sect.TERM_CODE = 'S2' or sect.TERM_CODE = 'Q3') THEN @vBS2
		 WHEN sect.TERM_CODE = 'Q2' THEN @vBQ2
		 WHEN sect.TERM_CODE = 'Q4' THEN @vBQ4	
		 ELSE ''	
		 END							 AS [beginDate]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S2' or sect.TERM_CODE ='Q4') THEN @vEFY
         WHEN (sect.TERM_CODE = 'S1' or sect.TERM_CODE = 'Q2') THEN @vES1
		 WHEN sect.TERM_CODE = 'Q1' THEN @vEQ1
		 WHEN sect.TERM_CODE = 'Q3' THEN @vEQ3	
		 ELSE ''	
		 END										 AS [endDate]


 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr              ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                             AND ssyr.STATUS IS NULL
                                             AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr        ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R'
JOIN rev.REV_ORGANIZATION org             ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                      ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
JOIN rev.EPC_STU_CLASS scls               ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
										  --and scls.ENTER_DATE IS NULL --added to not include classes with no students
JOIN rev.EPC_SCH_YR_SECT sect             ON sect.SECTION_GU = scls.SECTION_GU
JOIN rev.EPC_SCH_YR_CRS ycrs              ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS crs                      ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.EPC_STAFF_SCH_YR stf        ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.SIF_22_StaffPersonal stfp   ON stfp.STAFF_GU = stf.STAFF_GU

WHERE
1 = 1
and stfp.BADGE_NUM is not NULL
and stfp.EMAIL is not null
and crs.COURSE_TITLE not like '%Homeroom%'
and crs.COURSE_TITLE not like '%Lunch%'
and crs.COURSE_TITLE not like '%AIDE%'
and crs.COURSE_TITLE not like '%Work Release%'
and crs.COURSE_TITLE not like '%Study Hall%'
and crs.COURSE_TITLE not like '%Sr Release%'
and crs.COURSE_TITLE not like '%Out of Building%'
and crs.COURSE_TITLE not like '%BCAT%'


-- Additional staff enrollments --
UNION
SELECT DISTINCT 
   sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID + '.' + 'T' + astf.BADGE_NUM							AS [sourceId]
	, ''									AS [status]
	, ''									AS [dateLastModified]
	, sch.SCHOOL_CODE  + 
    + crs.COURSE_ID    + '.'
    + sect.SECTION_ID + '.' + @vSchYr        AS [classSourcedId]
  , sch.SCHOOL_CODE							 AS [schoolSourcedId]
  , 'T' + stfp.BADGE_NUM					 AS [userSourcedId]
  , 'teacher'								 AS [role]
  , 'false'									 AS [primary]
   , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S1' or sect.TERM_CODE ='Q1') THEN @vBFY
         WHEN (sect.TERM_CODE = 'S2' or sect.TERM_CODE = 'Q3') THEN @vBS2
		 WHEN sect.TERM_CODE = 'Q2' THEN @vBQ2
		 WHEN sect.TERM_CODE = 'Q4' THEN @vBQ4	
		 ELSE ''	
		 END							 AS [beginDate]
  , CASE WHEN(sect.TERM_CODE = 'FY' or sect.TERM_CODE ='S2' or sect.TERM_CODE ='Q4') THEN @vEFY
         WHEN (sect.TERM_CODE = 'S1' or sect.TERM_CODE = 'Q2') THEN @vES1
		 WHEN sect.TERM_CODE = 'Q1' THEN @vEQ1
		 WHEN sect.TERM_CODE = 'Q3' THEN @vEQ3	
		 ELSE ''	
		 END										 AS [endDate]
	

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr              ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                             AND ssyr.STATUS IS NULL
                                             AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr        ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R'
JOIN rev.REV_ORGANIZATION org             ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                      ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
JOIN rev.EPC_STU_CLASS scls               ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
											 --and scls.ENTER_DATE IS NULL
JOIN rev.EPC_SCH_YR_SECT sect             ON sect.SECTION_GU = scls.SECTION_GU
JOIN rev.EPC_SCH_YR_CRS ycrs              ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS crs                      ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.EPC_STAFF_SCH_YR stf        ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.SIF_22_StaffPersonal stfp   ON stfp.STAFF_GU = stf.STAFF_GU
--Additional staff teaching the section
LEFT JOIN rev.EPC_SCH_YR_SECT_STF sestf  ON sestf.SECTION_GU            = sect.SECTION_GU
                                            and (sestf.END_DATE is NULL or sestf.END_DATE >= cast(convert(varchar(10), getdate(),112) as smalldatetime))
LEFT JOIN REV.EPC_STAFF_SCH_YR    astssy ON astssy.STAFF_SCHOOL_YEAR_GU = sestf.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.EPC_STAFF           astf   ON astf.STAFF_GU               = astssy.STAFF_GU


WHERE
1 = 1
and astf.BADGE_NUM is not NULL
and stfp.EMAIL is not null
and crs.COURSE_TITLE not like '%Homeroom%'
and crs.COURSE_TITLE not like '%Lunch%'
and crs.COURSE_TITLE not like '%AIDE%'
and crs.COURSE_TITLE not like '%Work Release%'
and crs.COURSE_TITLE not like '%Study Hall%'
and crs.COURSE_TITLE not like '%Sr Release%'
and crs.COURSE_TITLE not like '%Out of Building%'
and crs.COURSE_TITLE not like '%BCAT%'




--