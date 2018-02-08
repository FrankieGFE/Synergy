--On Roster demographics.csv--
declare  @vSchYr varchar(4)
set @vSchYr = '2017'  




SELECT distinct
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	,  CONVERT(VARCHAR(10), per.BIRTH_DATE,20)						AS [birthDate]
	, CASE WHEN per.GENDER = 'F' THEN 'female'
		   WHEN per.GENDER = 'M' THEN 'male'
		   ELSE ''
		   END								AS [sex]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '01' THEN 'true'
			ELSE 'false'
			END 								AS [americanIndianOrAlaskaNative]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '02' THEN 'true'
			ELSE 'false'
			END 								AS [asian]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '03' THEN 'true'
			ELSE 'false'
			END 								AS [blackOrAfricanAmerican]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '06' THEN 'true'
			ELSE 'false'
			END 								AS [nativeHawaiianOrOtherPacificIslander]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '05' THEN 'true'
			ELSE 'false'
			END 								AS [white]
    , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' and per.RESOLVED_ETHNICITY_RACE <> '__HIS' THEN 'true'
			ELSE 'false'
			END 								AS [demographicRaceTwoOrMoreRaces]
	, CASE WHEN per.RESOLVED_ETHNICITY_RACE <> '__TWO' and per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'true'
			ELSE 'false'
			END									AS [hispanicOrLatinoEthnicity]
	, ''										AS [countryOfBirthCode]
	, ''										AS [stateOfBirthAbbreviation]
	, ''										AS [cityOfBirth]
	, ''										AS [publicSchoolResidenceStatus]

	 
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
LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1 = 1
AND scls.LEAVE_DATE is null
and scls.TEACHER_AIDE != 'Y'

Union

SELECT distinct
	stu.SIS_NUMBER						    AS [sourcedId]
	, ''									AS [status] --must be blank--
	, ''									AS [dateLastModified] --must be blank--
	,  CONVERT(VARCHAR(10), per.BIRTH_DATE,20)						AS [birthDate]
	, CASE WHEN per.GENDER = 'F' THEN 'female'
		   WHEN per.GENDER = 'M' THEN 'male'
		   ELSE ''
		   END								AS [sex]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '01' THEN 'true'
			ELSE 'false'
			END 								AS [americanIndianOrAlaskaNative]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '02' THEN 'true'
			ELSE 'false'
			END 								AS [asian]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '03' THEN 'true'
			ELSE 'false'
			END 								AS [blackOrAfricanAmerican]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '06' THEN 'true'
			ELSE 'false'
			END 								AS [nativeHawaiianOrOtherPacificIslander]
	, CASE WHEN (per.RESOLVED_ETHNICITY_RACE = '__TWO' OR per.RESOLVED_ETHNICITY_RACE = '__HIS') THEN 'false'
			WHEN (per.RESOLVED_ETHNICITY_RACE <> '__TWO' OR per.RESOLVED_ETHNICITY_RACE <> '__HIS') and per.RESOLVED_ETHNICITY_RACE = '05' THEN 'true'
			ELSE 'false'
			END 								AS [white]
    , CASE WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO' and per.RESOLVED_ETHNICITY_RACE <> '__HIS' THEN 'true'
			ELSE 'false'
			END 								AS [demographicRaceTwoOrMoreRaces]
	, CASE WHEN per.RESOLVED_ETHNICITY_RACE <> '__TWO' and per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN 'true'
			ELSE 'false'
			END									AS [hispanicOrLatinoEthnicity]
	, ''										AS [countryOfBirthCode]
	, ''										AS [stateOfBirthAbbreviation]
	, ''										AS [cityOfBirth]
	, ''										AS [publicSchoolResidenceStatus]

	 
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
LEFT JOIN rev.UD_STU_SCH_YR ud				 ON ud.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE
1= 1
AND scls.LEAVE_DATE is null
and scls.TEACHER_AIDE != 'Y'

