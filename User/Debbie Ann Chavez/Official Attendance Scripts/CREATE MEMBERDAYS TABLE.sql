
--DROP TABLE dbo.STUDENT_SCHOOL_MEMBERDAYS
--CREATE TABLE dbo.STUDENT_SCHOOL_MEMBERDAYS_2015

--(
--	SIS_NUMBER VARCHAR(9)
--	,FIRST_NAME VARCHAR(50)
--	,LAST_NAME VARCHAR(50)
--	,GRADE VARCHAR(2)
--	,ENTER_DATE VARCHAR(10)
--	,LEAVE_DATE VARCHAR(10)
--	,SCHOOL_YEAR VARCHAR(4)
--	,SCHOOL_CODE VARCHAR(4)
--	,EXCLUDE_ADA_ADM VARCHAR (3)
--	,MEMBERDAYS VARCHAR (3)
--)

--change dates and table

INSERT INTO dbo.STUDENT_SCHOOL_MEMBERDAYS

select
  stu.SIS_NUMBER                            as SIS_NUMBER
, per.FIRST_NAME                            as FirstName
, per.LAST_NAME                             as LastName
, grd.VALUE_DESCRIPTION                     as GradeLevel
, convert(varchar(10), enr.enter_date, 101) as EnterDate
, case 
     when enr.LEAVE_DATE is not null then convert(varchar(10), enr.LEAVE_DATE, 101) 
     when '20160525' > copt.END_DATE   then convert(varchar(10), copt.END_DATE, 101) 
     else convert(varchar(10), '20160525', 101)
  end 
as LeaveDate
, yr.SCHOOL_YEAR                            as SchoolYear
, sch.SCHOOL_CODE                           as SchoolCode
,ENR.EXCLUDE_ADA_ADM						AS EXCLUDE_ADA_ADM
, MembershipDays.MbDays                     as MembershipDays

from rev.EPC_STU               stu
join rev.REV_PERSON            per  on  per.PERSON_GU              = stu.STUDENT_GU
join rev.EPC_STU_SCH_YR        ssy  on  ssy.STUDENT_GU             = stu.STUDENT_GU
join rev.EPC_STU_ENROLL        enr  on  enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
join rev.REV_ORGANIZATION_YEAR oyr  on  oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
join rev.REV_ORGANIZATION      org  on  org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.REV_YEAR              yr   on  yr.YEAR_GU                 = oyr.YEAR_GU
join rev.EPC_SCH               sch  on  sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH_ATT_CAL_OPT   copt on  copt.ORG_YEAR_GU           = oyr.ORGANIZATION_YEAR_GU
left join rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE

join 
(
select distinct
       stu.STUDENT_GU
     , ct.OrgGu
     , ct.OrgYrGu
     , sum(cast(ct.Daytype as int)) over (partition by ct.OrgGu, ct.OrgYrGu, stu.student_gu) MbDays
from rev.EPC_STU               stu
join rev.EPC_STU_SCH_YR        ssy  on ssy.STUDENT_GU             = stu.STUDENT_GU
join rev.EPC_STU_ENROLL        enr  on enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
join rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
join rev.REV_ORGANIZATION      org  on org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH               sch  on sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH_ATT_CAL_OPT   copt on copt.ORG_YEAR_GU           = oyr.ORGANIZATION_YEAR_GU

--CHANGE THIS
join dbo.CalDayTable       ct   on ct.OrgGU                   = oyr.ORGANIZATION_GU
                                       and ct.OrgYrGu             = oyr.ORGANIZATION_YEAR_GU
where ct.caldate between enr.ENTER_DATE and coalesce(enr.leave_date, '20160525')

--AND SIS_NUMBER = 100015700
--and sch.SCHOOL_CODE = @School
) AS MembershipDays     

on  MembershipDays.OrgGu            = oyr.ORGANIZATION_GU
                                    and MembershipDays.OrgYrGU                 = oyr.ORGANIZATION_YEAR_GU
                                    and MembershipDays.STUDENT_GU              = stu.STUDENT_GU


