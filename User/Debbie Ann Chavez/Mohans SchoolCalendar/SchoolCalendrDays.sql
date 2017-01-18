-- Fill Calendar days for each school
IF OBJECT_ID('dbo.CalDayTable') IS NOT NULL DROP TABLE dbo.CalDayTable
CREATE TABLE dbo.CalDayTable(
   OrgGu            uniqueidentifier
 , OrgYrGu          uniqueidentifier
 , SchoolStartDt    smalldatetime
 , SchoolEndDt      smalldatetime
 , CalDate          smalldatetime null
 , DayType          varchar(10)
 , SchoolDayNumber  int
)
create index idx1 on dbo.CalDayTable (OrgGu)
create index idx2 on dbo.CalDayTable (OrgYrGu)
create index idx3 on dbo.CalDayTable (CalDate)
declare   @CurYear                varchar(4)    = (select school_year from rev.SIF_22_Common_CurrentYear) 
        , @SchoolYear             int           = (SELECT SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)   
        , @LoopDt                 smalldatetime
        , @TempOrgGU              uniqueidentifier
        , @TempOrgYrGU            uniqueidentifier
        , @TempStartDate          smalldatetime
        , @TempEndDate            smalldatetime
        , @Org_Cursor_FetchStatus INT
----
begin 
      declare Org_Cursor cursor for 
              select distinct 
                       org.ORGANIZATION_GU
                     , oyr.ORGANIZATION_YEAR_GU
                     , copt.START_DATE
                     , copt.END_DATE
              from rev.REV_ORGANIZATION       org
              join  rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_GU       = org.ORGANIZATION_GU
                                                      and oyr.YEAR_GU           = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
              join  rev.EPC_SCH               sch  on sch.ORGANIZATION_GU       = oyr.ORGANIZATION_GU
              join  rev.EPC_SCH_YR_OPT        sopt on sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
              join  rev.EPC_SCH_ATT_CAL_OPT   copt on copt.ORG_YEAR_GU          = oyr.ORGANIZATION_YEAR_GU
     open Org_Cursor
     NextFetchOrg_Cursor:
        fetch next from Org_Cursor into
                @TempOrgGu
              , @TempOrgYrGu
              , @TempStartDate
              , @TempEndDate
        set @Org_Cursor_FetchStatus = @@FETCH_STATUS
		IF @Org_Cursor_FetchStatus = 0
           begin
               set @LoopDt = @TempStartDate
               ---- Fill date table with working days based on district calendar
               while @LoopDt <= @TempEndDate
               begin
                   if (
                       DATEPART(dw, @LoopDt) != 1 and DATEPART(dw, @LoopDt) != 7
                       and @LoopDt <= @TempEndDate
                      )
                      begin
                          insert into dbo.CalDayTable
                          (OrgGu, OrgYrGu,  SchoolStartDt, SchoolEndDt, CalDate)
                          values (@TempOrgGU, @TempOrgYrGU,  @TempStartDate, @TempEndDate, @LoopDt)
                      end
                   set @LoopDt = @LoopDt + 1

               end
             goto NextFetchOrg_Cursor
           end
     Close Org_Cursor
     deallocate Org_cursor
end 
---- Update SchoolDayType
update dbo.CalDayTable
set DayType = (case
                   when scal.HOLIDAY is not null --Adjust this if any any specific calendar types like Hol, Stf, Non etc should be used insted of null
                   then '0'
                   else '1'
               end)
from dbo.CalDayTable         dt
join rev.REV_ORGANIZATION      org  on org.ORGANIZATION_GU  = dt.OrgGu
join rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_GU  = org.ORGANIZATION_GU
                                       and oyr.YEAR_GU      = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
left join rev.EPC_SCH_ATT_CAL  scal on scal.SCHOOL_YEAR_GU  = oyr.ORGANIZATION_YEAR_GU  
                                       and   dt.CalDate     = scal.CAL_DATE

where dt.OrgGu   = OrgGu
and   dt.CalDate = CalDate

--Update SchoolDayNumber 
; with SchDy as(
select 
* 
, row_number() over(partition by OrgGU order by Caldate) rn
from dbo.CalDayTable t
where DayType = 1
)
update dbo.CalDayTable
set SchoolDayNumber = sd.rn
from SchDy sd
where sd.CalDate = dbo.CalDayTable.CalDate
and sd.OrgGu     = dbo.CalDayTable.OrgGu

--select * from dbo.CalDayTable