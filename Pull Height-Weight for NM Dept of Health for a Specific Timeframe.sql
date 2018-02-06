/*
Description:

We’re requesting data from the beginning of the school year in August 2017 through November 22nd, 2017.
We only need selected APS school-level data for the annual statewide analysis and report, not all APS elementary schools.

The breakdown of needed data is:
•	Measurement Date (all measurements from the beginning of school in August through November 22nd)
•	Grade (K and 3rd)
•	Birth Date
•	Gender
•	Race/ethnicity

Regarding race/ethnicity, we’d like to get the same breakdown Wendy gave us in previous years. This is the breakdown: 
•	Resolved race (applies all of the trumping rules to arrive at one race/ethnicity category; makes calculating population distributions by race/ethnicity possible). The resolved race categories are African American, Asian, Hispanic, Native American, Pacific Islander, White, and Two or More.
•	Hispanic Indicator
•	Race1
•	Race2
•	Race3
•	Race4
•	Race5


For schools: APS Elementary Schools Selected for Statewide BMI Surveillance in SY17-18 
1. Bandelier Elementary
2. Bellehaven Elementary
3. Chelwood Elementary
4. Collet Park Elementary
5. Dolores Gonzales Elementary
6. Edmund G Ross Elementary
7. Eubank Elementary
8. Inez Elementary
9. Matheson Park Elementary
10. Montessori Of The Rio Grande
11. North Star Elementary
12. Painted Sky Elementary
13. San Antonito Elementary
14. Sunset View Elementary
15. Susie R. Marmon Elementary
16. Wherry Elementary
17. Zia Elementary 

Written by:		JoAnn Smith
Date Written:	2/1/2018
*/



declare @AsOfDate datetime2 = '2017-08-14'
declare @BeginScreenDate datetime2 = '2017-08-14'
declare @EndScreenDate datetime2 = '2017-11-22'


;WITH Health_Data
as
(
select
	 h.STUDENT_GU,
	 E.SCHOOL_NAME,
	 E.SCHOOL_CODE,
	 e.GRADE,
	 h.HEIGHT,
	 h.WEIGHT,
	 h.SCREEN_DATE
from
	 rev.[EPC_STU_HEALTH_SCR_GEN] AS h
INNER JOIN
	APS.PRIMARYENROLLMENTdetailsasof('2017-08-14') e
ON
	H.STUDENT_GU = E.STUDENT_GU
WHERE
	E.GRADE IN ('K', '03')
AND
	 SCREEN_DATE >= @BeginScreenDate AND SCREEN_DATE <= @EndScreenDate
)
--select * from Health_Data 
,Student_Details
as
(
select 
	row_number() over (partition by sis_number order by SIS_NUMBER) as rn,
	bs.SIS_NUMBER,
	H.SCHOOL_NAME,
	H.SCHOOL_CODE,
	H.GRADE,
	convert(varchar(10), bs.BIRTH_DATE, 101) as BIRTH_DATE,
	bs.GENDER,
	bs.HISPANIC_INDICATOR,
	bs.RESOLVED_RACE,
	bs.RACE_1,
	bs.RACE_2,
	bs.RACE_3,
	bs.RACE_4,
	bs.RACE_5,
	h.HEIGHT,
	h.WEIGHT,
	convert(varchar(10), h.SCREEN_DATE, 101) as SCREEN_DATE
from
	Health_Data h
left join
	aps.BasicStudentWithMoreInfo bs
on
	h.STUDENT_GU = bs.STUDENT_GU
)
select
	*
from
	Student_Details d
where
	SCHOOL_CODE in ('222', '229', '236', '240', '244', '219', '258', '276', '305', '268', '275', '345', '393', '280', '376', '385')
and
	rn = 1
order by SCHOOL_NAME, GRADE, SIS_NUMBER