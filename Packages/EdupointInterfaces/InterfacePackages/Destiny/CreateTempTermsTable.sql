--<APS - Destiny - TempTerms file>
IF OBJECT_ID('tempdb..##Terms') IS NOT NULL DROP TABLE ##Terms
CREATE TABLE ##Terms(
   OrgGu uniqueidentifier null
   , SchYr varchar(4) null
   , TermCode varchar(4) null
   , TermStart smalldatetime
   , TermEnd smalldatetime
)
--
insert into ##Terms
select 
       t.OrgGU
     , t.SchoolYear
	 , t.TermCode
	 , TermBegin
	 , TermEnd
from rev.SIF_22_TermInfo() t 
     join rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_GU = t.OrgGU
     join rev.REV_YEAR              y   on y.YEAR_GU = oyr.YEAR_GU 
	                                       and y.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
--select * from ##Terms
 