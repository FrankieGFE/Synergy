
Tables that sync from Synergy:
EGB_PERIODS ---has guids to join to EPC_SCH_YR_GRD_PRD and EPC_SCH_YR_GRD_PRD_MK
EGB_PEOPLE --  has guid to join to REV_PERSON
EGB_CLASS --  has guid to join to EPC_SCH_YR_SECT
EGB_ENROLLMENT -- this is the student enrollments in a given class (similar to EPC_STU_CLASS).
EGB_SCHOOL -- has guid to join to REV_ORGANIZATION
EGB_SCHOOLYEAR -- has guid to join to REV_YEAR
EGB_SCHOOLSCHEDULE  -- this is basically Grading Setup for a school (mark periods – can be joined to egb_periods)
EGB_SECONDARYCOMMENTS  -- comments that can be added to report card
EGB_SECONDARYCOMMENTDETAIL -- comments that can be added to report card
EGB_GRADE – grade levels for students that have been sync’d from Synergy.  This comes from K12.Grade lookup table.
EGB_USERS – this record joins to EGB_PEOPLE and is created for teachers/admins.
EGB_REPORTCARDSCORETYPES/EGB_REPORTCARDSCOREDETAILS  -- this is basically mark definition (GenesisGrading/GenesisProgressPeriod)

Query to get course for class:
SELECT CRS.COURSE_ID, CRS.COURSE_TITLE, C.* 
FROM REV.EGB_CLASS C
JOIN REV.EPC_SCH_YR_SECT SECT ON SECT.SECTION_GU = C.CLASSGUID
JOIN REV.EPC_SCH_YR_CRS SCRS ON SCRS.SCHOOL_YEAR_COURSE_GU = SECT.SCHOOL_YEAR_COURSE_GU
JOIN REV.EPC_CRS CRS ON CRS.COURSE_GU = SCRS.COURSE_GU
WHERE C.ID = 42223

Query to get grade book info:
select s.SCHOOLNAME, c.classname, gb.MEASURE, gb.DESCRIPTION, gb.DUEDATE, gb.MEASUREDATE, mt.MEASURETYPE, gb.MAXVALUE, sct.SCORETYPE, stu.LASTNAME, stu.FIRSTNAME, gbr.* 
from rev.EGB_GRADEBOOK gb  --assignments
join rev.EGB_GBRESULT gbr on gbr.GRADEBOOKID = gb.ID  --student results
join rev.EGB_PEOPLE stu on stu.id = gbr.studentid
join rev.EGB_CLASS c on c.id = gb.CLASSID
join rev.EGB_SCHOOL s on s.id = c.SCHOOLID
join rev.EGB_GBSCORETYPES sct on sct.id = gb.SCORETYPEID
join rev.EGB_MEASURETYPE mt on mt.id = gb.MEASURETYPEID
where gb.id = 3

--To get secondary grades (lastpost_date_time_stamp and lastpost_results indicate the grade has been posted to synergy.  marks can be found there at epc_stu_sch_yr_grd_prd_mk)
select s.SCHOOLNAME, c.CLASSNAME, stu.LASTNAME, stu.FIRSTNAME, per.PERIOD, rcsc.*
from rev.EGB_REPORTCARDSCORECHANGES rcsc
join rev.EGB_PERIODS per on per.id = rcsc.PERIODID
join rev.EGB_CLASS c on c.id = rcsc.CLASSID
join rev.EGB_SCHOOL s on s.id = c.SCHOOLID
join rev.EGB_PEOPLE stu on stu.id = rcsc.STUDENTID
join rev.EGB_SCHOOLYEAR sy on sy.id = rcsc.SCHOOLYEARID
where sy.SCHOOLYEAR = '2015-2016'
and rcsc.CLASSID = 54853
order by stu.LASTNAME, per.SEQ

--To get elementary report card grades by report card item
select per.period, stu.lastname, stu.firstname, rci.ITEM, rcs.* 
from rev.EGB_REPORTCARDSCORES rcs
join rev.EGB_REPORTCARDITEMS rci on rci.id = rcs.REPORTCARDITEMID
join rev.EGB_SCHOOLYEAR sy on sy.id = rcs.SCHOOLYEARID
join rev.EGB_PERIODS per on per.id = rcs.PERIODID
join rev.EGB_PEOPLE stu on stu.id = rcs.STUDENTID
where sy.SCHOOLYEAR = '2015-2016'
and rcs.STUDENTID = 229120

--This query identifies teachers with a lot of Measure Types, which may indicate a problem with copied types
select TEACHERID, count(*) 
from rev.EGB_MEASURETYPE
group by teacherid
order by count(*) desc
