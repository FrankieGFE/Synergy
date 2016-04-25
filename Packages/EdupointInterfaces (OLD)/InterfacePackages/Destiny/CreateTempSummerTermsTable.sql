--<APS - Destiny - TempTerms file>
IF OBJECT_ID('tempdb..##SummerTerms') IS NOT NULL DROP TABLE ##SummerTerms
CREATE TABLE ##SummerTerms(
     OrgGu uniqueidentifier null
   , SchYr varchar(4) null
   , TermCode varchar(4) null
   , TermStart smalldatetime
   , TermEnd smalldatetime
)
--
insert into ##SummerTerms
select 
       org.ORGANIZATION_GU
     , yr.SCHOOL_YEAR
	 , tcd.TERM_CODE
	 , acalo.START_DATE
	 , tdef.EVENT_DATE
from rev.rev_organization      org
join rev.REV_ORGANIZATION_YEAR oyr   on oyr.ORGANIZATION_GU = org.ORGANIZATION_GU
join rev.REV_YEAR              yr    on yr.YEAR_GU = oyr.YEAR_GU
									 AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
join rev.EPC_SCH_YR_TRM_DEF    tdef  on tdef.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
join rev.EPC_SCH_YR_TRM_CODES  tcd   on tcd.SCHOOL_YEAR_TRM_DEF_GU = tdef.SCHOOL_YEAR_TRM_DEF_GU
join rev.EPC_SCH_ATT_CAL_OPT   acalo on acalo.ORG_YEAR_GU = oyr.ORGANIZATION_YEAR_GU