--DROP TABLE STUDENT_SCHOOL_MEMBERDAYS_80D


--CREATE TABLE STUDENT_SCHOOL_MEMBERDAYS_80D
--(
-- startDate datetime,
-- endDate datetime,
-- org_year_gu VARCHAR (200),
-- STUID VARCHAR (9),
-- ORIGENTERDATE DATE,
-- SCHOOL VARCHAR (50),
--SCHOOL_CODE VARCHAR (3),
--EXCLUDE_ADA_ADM VARCHAR(5), 
--MEMBER_DAYS VARCHAR (3)
-- )
 

declare @startDate datetime;
declare @endDate datetime;
declare @org_year_gu uniqueidentifier;
DECLARE @STUID VARCHAR (9);
DECLARE @ORIGENTERDATE DATE;
DECLARE @SCHOOL VARCHAR (50);
DECLARE @SCHOOL_CODE VARCHAR (3)
DECLARE @EXCLUDE_ADA_ADM VARCHAR(5)

deallocate x_cur;  --after the first time running you'll need this to avoid warning
declare x_cur cursor for



SELECT                    --ENR.ENTER_DATE 
					--'2016-02-03' 
					case when ENROLL.enter_date < '20161013' then '20161013' else ENROLL.ENTER_DATE end as new_enter_date
                    ,CASE WHEN ENROLL.LEAVE_DATE IS NULL OR ENROLL.LEAVE_DATE > '20161201' THEN '20161201' 
					ELSE ENROLL.LEAVE_DATE END AS NEWLEAVE
                    ,ORGANIZATION_YEAR_GU
					,ENR.SIS_NUMBER
					,ENROLL.ENTER_DATE
					,SCHOOL_NAME
					,SCHOOL_CODE
					,ENROLL.EXCLUDE_ADA_ADM
             FROM
             APS.StudentEnrollmentDetails AS ENR
			 INNER JOIN 
			 rev.EPC_STU AS STU
			 ON 
			 STU.STUDENT_GU = ENR.STUDENT_GU
			 --TAKE THIS OUT
			 --AND EXCLUDE_ADA_ADM IS NULL

			--ADDED THIS TO INCLUDE ENROLLMENTS WHERE A STUDENT LEFT AND RETURNED TO SAME SCHOOL, NOT IN SSY
			LEFT JOIN 
			rev.EPC_STU_ENROLL AS ENROLL
			ON
			ENR.STUDENT_SCHOOL_YEAR_GU = ENROLL.STUDENT_SCHOOL_YEAR_GU

             WHERE
             SCHOOL_YEAR = '2016'
             AND EXTENSION = 'R'
             --AND SCHOOL_CODE BETWEEN '200' AND '599'
             AND SCHOOL_CODE != '533'
             AND (ENROLL.ENTER_DATE <= '20161201' AND ENROLL.LEAVE_DATE IS NULL OR ENROLL.LEAVE_DATE BETWEEN '20161013' AND '20161201' or ENROLL.LEAVE_DATE > '20161201')
			

open x_cur
 fetch next from x_cur into
@startDate,
@endDate,
@org_year_gu,
@STUID
,@ORIGENTERDATE
,@SCHOOL
,@SCHOOL_CODE
,@EXCLUDE_ADA_ADM
--select 'first', @startDate as startdate, @endDate as enddate, @org_year_gu org_gu

--print @@fetch_status
while @@FETCH_STATUS = 0 
begin

INSERT INTO STUDENT_SCHOOL_MEMBERDAYS_80D

SELECT
	@startDate
	,@endDate
	,@org_year_gu
	,@STUID
	,@ORIGENTERDATE
	,@SCHOOL
	,@SCHOOL_CODE
	,@EXCLUDE_ADA_ADM
,CASE 
-- if the passed date is large than the last day, then return zero as invalid
WHEN @endDate < @startDate THEN 0
-- else we calculate the difference between the passed date and the first day an each orgYear
-- stripping out weekends and holidays
ELSE
(DATEDIFF(dd, (CASE WHEN @startDate<START_DATE THEN START_DATE ELSE @startDate END), @endDate) + 1) -- Number of days difference between 2 dates (start date and day looked up)
-(DATEDIFF(wk, (CASE WHEN @startDate<START_DATE THEN START_DATE ELSE @startDate END), @endDate) * 2) -- Number of weeks difference (*2) - removes weekends
-(CASE WHEN DATENAME(dw, @endDate) IN ('Saturday','Sunday') THEN 1 ELSE 0 END) -- subtract one if the end day is on a (weekend) Not sure what we want to do hear
- NumNonDays -- number of holidays 
END
AS MemberDay


FROM
-- this subselect gives you first and last day of calendar along with number of holidays before passed date
(
SELECT
CalOption.ORG_YEAR_GU
,CASE WHEN @startDate<MIN(CalOption.START_DATE) THEN MIN(CalOption.START_DATE) ELSE @startDate END AS START_DATE
,CASE WHEN @endDate<MIN(CalOption.END_DATE) THEN MIN(CalOption.END_DATE) ELSE @endDate END AS END_DATE
,COUNT(*) * CASE WHEN SchoolCal.SCHOOL_YEAR_GU IS NULL THEN 0 ELSE 1 END AS NumNonDays
FROM
REV.EPC_SCH_ATT_CAL_OPT AS CalOption

LEFT JOIN
REV.EPC_SCH_ATT_CAL AS SchoolCal
ON
SchoolCal.SCHOOL_YEAR_GU = CalOption.ORG_YEAR_GU
AND SchoolCal.HOLIDAY IN ('Hol','Sta')
AND CAL_DATE <= @endDate
AND CAL_DATE >= @startDate
where ORG_YEAR_GU = @org_year_gu
GROUP BY
CalOption.ORG_YEAR_GU
-- used to identify calendars with no holidays between start and passed date
,CASE WHEN SchoolCal.SCHOOL_YEAR_GU IS NULL THEN 0 ELSE 1 END
)NumDays

--print 'after'
--print @org_year_gu
--print @startDate
--print @endDate

 fetch next from x_cur into
@startDate,
@endDate,
@org_year_gu,
@STUID
,@ORIGENTERDATE
,@SCHOOL
,@SCHOOL_CODE
,@EXCLUDE_ADA_ADM
--select @startDate as startdate, @endDate as enddate, @org_year_gu org_gu

end

close x_cur
go



