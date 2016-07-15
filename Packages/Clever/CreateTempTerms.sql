-- ===================================================================
-- Author     :	mlm - EduPoint                                      --
-- Create date: 12/17/2015                                          --
-- Description:	Temp table to store the terms, start and end dates  --
-- this temp table is used in enrollments and sections query        -- 
-- Revision   :                                                     --
-- ===================================================================
IF OBJECT_ID('tempdb..##Terms') IS NOT NULL DROP TABLE ##Terms
CREATE TABLE ##Terms(
     OrgGu     uniqueidentifier not null
   , SchYr     varchar(4)       not null
   , TermCode  varchar(4)       not null
   , TermStart smalldatetime    not null
   , TermEnd   smalldatetime    not null
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
	                                       and oyr.YEAR_GU     = (select year_gu from rev.SIF_22_Common_CurrentYearGU)