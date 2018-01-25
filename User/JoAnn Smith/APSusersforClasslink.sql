--On Roster users.csv--
declare  @vSchYr varchar(4)
set @vSchYr = '2017'  


; with SchoolList as
(
  select distinct 
    stf.BADGE_NUM
,  CAST (stuff(( select ','+ sc.SCHOOL_CODE 
     from rev.epc_staff                   st
     join rev.rev_person                  stp  on stp.PERSON_GU           = st.STAFF_GU
     left join rev.EPC_STAFF_SCH_YR       stsy on stsy.STAFF_GU           = st.STAFF_GU
     left join rev.REV_ORGANIZATION_YEAR  oy   on oy.ORGANIZATION_YEAR_GU = stsy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oy.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R'                                              
     left join rev.EPC_STAFF_ROLE         srl  on srl.STAFF_GU            = st.STAFF_GU
     left join rev.EPC_SCH                sc   on sc.ORGANIZATION_GU      = oy.ORGANIZATION_GU
     where (sc.SCHOOL_CODE not in ('533') or sc.SCHOOL_CODE is null)
     and st.STAFF_GU = stf.STAFF_GU
     for xml path('')),1,1,'') as varchar(max)) 

     AS [SchoolCodesList]


from rev.epc_staff                   stf
join rev.rev_person                  stfp  on stfp.PERSON_GU           = stf.STAFF_GU
left join rev.EPC_STAFF_SCH_YR       stfsy on stfsy.STAFF_GU           = stf.STAFF_GU
left join rev.REV_ORGANIZATION_YEAR  oyr   on oyr.ORGANIZATION_YEAR_GU = stfsy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
left join rev.EPC_STAFF_ROLE         srol  on srol.STAFF_GU            = stf.STAFF_GU
left join rev.EPC_SCH                sch   on sch.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
where (sch.SCHOOL_CODE not in ('533') or sch.SCHOOL_CODE is null)

)

--Placement is not RES, PVDS or PSS--
SELECT 
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	, 'true'								AS [enabledUser]
	, CAST(sch.SCHOOL_CODE as varchar(max))						AS [orgSourcedIds]
	, 'student'								AS [role]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20)			AS [username]
   , '{Fed' + ':' +   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20) + '}'		AS [userIds]
	, per.FIRST_NAME						AS [givenName]
	, per.LAST_NAME							AS [familyName]
	, per.MIDDLE_NAME						AS [middleName]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20)			AS [identifier]
	, substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20) + '@student.rcs.k12.nm.us'								AS [email]
	, ''									AS [sms]
	, ''									AS [phone]
	, ''									AS [agentSourcedIds]
	,  tblgrd.VALUE_DESCRIPTION  			AS [grades]
	, ''									AS [password]
	
	

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                 ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL AND EXCLUDE_ADA_ADM IS NULL
                                                AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr           ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R' 
JOIN rev.REV_ORGANIZATION org                ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                         ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
--JOIN rev.EPC_STU_CLASS scls                  ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
--JOIN rev.EPC_SCH_YR_SECT sect                ON sect.SECTION_GU = scls.SECTION_GU
--JOIN rev.EPC_SCH_YR_CRS ycrs                 ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
--JOIN rev.EPC_CRS crs                         ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.REV_PERSON per                 ON per.PERSON_GU = stu.STUDENT_GU
--LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
--LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd ON tblgrd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1

UNION
--Placement is null--
SELECT 
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	, 'true'								AS [enabledUser]
	, CAST(sch.SCHOOL_CODE as varchar(max))						AS [orgSourcedIds]
	, 'student'								AS [role]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20)			AS [username]
   , '{Fed' + ':' +   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20) + '}'		AS [userIds]
	, per.FIRST_NAME						AS [givenName]
	, per.LAST_NAME							AS [familyName]
	, per.MIDDLE_NAME						AS [middleName]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20)			AS [identifier]
	, substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,20) + '@student.rcs.k12.nm.us'								AS [email]
	, ''									AS [sms]
	, ''									AS [phone]
	, ''									AS [agentSourcedIds]
	,  tblgrd.VALUE_DESCRIPTION  			AS [grades]
	, ''									AS [password]
	
	

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                 ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL AND EXCLUDE_ADA_ADM IS NULL
                                                AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr           ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R' 
JOIN rev.REV_ORGANIZATION org                ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                         ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
--JOIN rev.EPC_STU_CLASS scls                  ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
--JOIN rev.EPC_SCH_YR_SECT sect                ON sect.SECTION_GU = scls.SECTION_GU
--JOIN rev.EPC_SCH_YR_CRS ycrs                 ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
--JOIN rev.EPC_CRS crs                         ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.REV_PERSON per                 ON per.PERSON_GU = stu.STUDENT_GU
--LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
--LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd ON tblgrd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1

Union
--No SIS number on username

SELECT 
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	, 'true'								AS [enabledUser]
	, CAST(sch.SCHOOL_CODE as varchar(max))						AS [orgSourcedIds]
	, 'student'								AS [role]
	,   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME),1,20)			AS [username]
   , '{Fed' + ':' +   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME),1,20) + '}'		AS [userIds]
	, per.FIRST_NAME						AS [givenName]
	, per.LAST_NAME							AS [familyName]
	, per.MIDDLE_NAME						AS [middleName]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME),1,20)			AS [identifier]
	, substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME),1,20) + '@student.rcs.k12.nm.us'								AS [email]
	, ''									AS [sms]
	, ''									AS [phone]
	, ''									AS [agentSourcedIds]
	,  tblgrd.VALUE_DESCRIPTION  			AS [grades]
	, ''									AS [password]
	
	

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                 ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL AND EXCLUDE_ADA_ADM IS NULL
                                                AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr           ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R' 
JOIN rev.REV_ORGANIZATION org                ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                         ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
--JOIN rev.EPC_STU_CLASS scls                  ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
--JOIN rev.EPC_SCH_YR_SECT sect                ON sect.SECTION_GU = scls.SECTION_GU
--JOIN rev.EPC_SCH_YR_CRS ycrs                 ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
--JOIN rev.EPC_CRS crs                         ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.REV_PERSON per                 ON per.PERSON_GU = stu.STUDENT_GU
--LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
--LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd ON tblgrd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1

--Username shortened to 19
UNION

SELECT 
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	, 'true'								AS [enabledUser]
	, CAST(sch.SCHOOL_CODE as varchar(max))						AS [orgSourcedIds]
	, 'student'								AS [role]
	,   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,19)			AS [username]
   , '{Fed' + ':' +   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,19) + '}'		AS [userIds]
	, per.FIRST_NAME						AS [givenName]
	, per.LAST_NAME							AS [familyName]
	, per.MIDDLE_NAME						AS [middleName]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,19)			AS [identifier]
	, substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,4),1,19) + '@student.rcs.k12.nm.us'								AS [email]
	, ''									AS [sms]
	, ''									AS [phone]
	, ''									AS [agentSourcedIds]
	,  tblgrd.VALUE_DESCRIPTION  			AS [grades]
	, ''									AS [password]
	
	

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                 ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL AND EXCLUDE_ADA_ADM IS NULL
                                                AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr           ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R' 
JOIN rev.REV_ORGANIZATION org                ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                         ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
--JOIN rev.EPC_STU_CLASS scls                  ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
--JOIN rev.EPC_SCH_YR_SECT sect                ON sect.SECTION_GU = scls.SECTION_GU
--JOIN rev.EPC_SCH_YR_CRS ycrs                 ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
--JOIN rev.EPC_CRS crs                         ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.REV_PERSON per                 ON per.PERSON_GU = stu.STUDENT_GU
--LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
--LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd ON tblgrd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1

--Only last 3 of student ID--

UNION

SELECT 
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	, 'true'								AS [enabledUser]
	, CAST(sch.SCHOOL_CODE as varchar(max))						AS [orgSourcedIds]
	, 'student'								AS [role]
	,   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,3),1,20)			AS [username]
   , '{Fed' + ':' +   substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,3),1,20) + '}'		AS [userIds]
	, per.FIRST_NAME						AS [givenName]
	, per.LAST_NAME							AS [familyName]
	, per.MIDDLE_NAME						AS [middleName]
	,  substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,3),1,20)			AS [identifier]
	, substring(lower(SUBSTRING(per.FIRST_NAME,1,1) +
   per.LAST_NAME) +
   RIGHT(stu.sis_number,3),1,20) + '@student.rcs.k12.nm.us'								AS [email]
	, ''									AS [sms]
	, ''									AS [phone]
	, ''									AS [agentSourcedIds]
	,  tblgrd.VALUE_DESCRIPTION  			AS [grades]
	, ''									AS [password]
	
	

 
FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr                 ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL AND EXCLUDE_ADA_ADM IS NULL
                                                AND ssyr.LEAVE_DATE IS NULL 
JOIN rev.REV_ORGANIZATION_YEAR oyr           ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR yr						ON yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @vSchYr
												and yr.EXTENSION = 'R' 
JOIN rev.REV_ORGANIZATION org                ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH sch                         ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
--JOIN rev.EPC_STU_CLASS scls                  ON scls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
--JOIN rev.EPC_SCH_YR_SECT sect                ON sect.SECTION_GU = scls.SECTION_GU
--JOIN rev.EPC_SCH_YR_CRS ycrs                 ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
--JOIN rev.EPC_CRS crs                         ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.REV_PERSON per                 ON per.PERSON_GU = stu.STUDENT_GU
--LEFT JOIN rev.EPC_STAFF_SCH_YR stf           ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
--LEFT JOIN rev.SIF_22_StaffPersonal stfp      ON stfp.STAFF_GU = stf.STAFF_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') tblgrd ON tblgrd.VALUE_CODE = ssyr.GRADE
--LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1 

--Teachers--
UNION

SELECT distinct 
  CAST('T' + stfp.BADGE_NUM as varchar)						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	, 'true'								AS [enabledUser]
	, CAST('"' + sl.SchoolCodesList + '"'  as varchar(max))					AS [orgSourcedIds]
	, 'teacher'								AS [role]
	, SUBSTRING(stfp.EMAIL, 1, (CHARINDEX('@', stfp.EMAIL)-1)) 			AS [username]
   , '{Fed' +  ':' + SUBSTRING(stfp.EMAIL, 1, (CHARINDEX('@', stfp.EMAIL)-1)) + '}'		AS [userIds]
	, stfp.FIRST_NAME						AS [givenName]
	, stfp.LAST_NAME						AS [familyName]
	, stfp.MIDDLE_NAME						AS [middleName]
	, SUBSTRING(stfp.EMAIL, 1, (CHARINDEX('@', stfp.EMAIL)-1))						AS [identifier]
	, stfp.EMAIL							AS [email]
	, ''									AS [sms]
	, ''									AS [phone]
	, ''									AS [agentSourcedIds]
	, ''									AS [grades]
	, ''									AS [password]  

 
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
JOIN rev.EPC_SCH_YR_SECT sect             ON sect.SECTION_GU = scls.SECTION_GU
JOIN rev.EPC_SCH_YR_CRS ycrs              ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS crs                      ON crs.COURSE_GU = ycrs.COURSE_GU
LEFT JOIN rev.EPC_STAFF_SCH_YR stf        ON stf.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
LEFT JOIN rev.SIF_22_StaffPersonal stfp   ON stfp.STAFF_GU = stf.STAFF_GU
left join SchoolList sl					  ON sl.BADGE_NUM = stfp.BADGE_NUM
WHERE
1 = 1 
and stfp.EMAIL IS NOT NULL
