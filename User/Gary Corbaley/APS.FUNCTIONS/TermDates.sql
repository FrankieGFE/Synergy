/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 06/17/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 06/15/2015
 * 
 * Initial Request: Pull a list of all Term Starting and Ending Dates for each school in the district.
 *
 * Description: This script loops through each school's term definition and calculates each term's begin and end dates.
 * One Record Per School Per Term Per Year
 *
 * Tables and Functions Referenced: APS.YearDates, EPC_SCH, REV_ORGANIZATION, REV_ORGANIZATION_YEAR, REV_YEAR, EPC_SCH_ATT_CAL_OPT, EPC_SCH_ATT_CAL, EPC_SCH_YR_TRM_DEF, EPC_SCH_YR_TRM_CODES, 
 */

CREATE VIEW [APS].[TermDates] AS

DECLARE @retTerms TABLE 
(
    OrgYearGU uniqueidentifier NULL,
    TermCode nvarchar(5) NULL,
    TermName nvarchar(50) NULL,
    TermBegin smalldatetime NULL,
    TermEnd smalldatetime NULL,
    TermCodeGU uniqueidentifier NULL
)

declare @numTracks int
declare @orgGU uniqueidentifier

declare @orgYrGu uniqueidentifier --= 'CDD8E033-D502-46DD-9C0E-855FD78FD9B5' -- APS Summer High School '2015-S'
declare @startTerm smalldatetime
declare @calendar table (holiday smalldatetime)
declare @smallestTerms table (termGu uniqueidentifier, termName varchar(50), beginDate smalldatetime, endDate smalldatetime)

declare @termGu uniqueidentifier
declare @termName varchar(50)
declare @endDate smalldatetime

-- Get all the Active School Year Definitions and all the Schools Active with those Years.
declare schoolDefs cursor local fast_forward read_only for
select 
	oyr.ORGANIZATION_YEAR_GU
	,(select 
		count(*) 
	from 
		rev.EPC_CODE_TRK_SCH_YR tsy
    where 
		tsy.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
	) NumTracks
from 
	rev.EPC_SCH sch
	
	inner join 
		rev.REV_ORGANIZATION org 
	on 
	(org.ORGANIZATION_GU = sch.ORGANIZATION_GU)
	
	inner join 
		rev.REV_ORGANIZATION_YEAR oyr 
	on 
	(oyr.ORGANIZATION_GU = sch.ORGANIZATION_GU)
	
	inner join 
		rev.REV_YEAR yr 
	on 
	(yr.YEAR_GU = oyr.YEAR_GU)
	
--where 
--	yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
	
-- Loop through ALL active schools
open schoolDefs
fetch next from schoolDefs into @orgYrGu,@numTracks
while @@FETCH_STATUS = 0
  begin
     --if @numTracks = 0
     
	--INSERT INTO @retTerms (OrgYearGU) SELECT @orgYrGu--,@numTracks	
     -----------------------------------------------------------------------
     -- START TERMS LOOP
     
		-- Set the start date for the currently selected school and year
        set @startTerm = (select [START_DATE] from rev.EPC_SCH_ATT_CAL_OPT where ORG_YEAR_GU = @orgYrGu)
        
        -- Get all the Holidays defined in the school calendar
        insert into @calendar (holiday)
		select CAL_DATE from rev.EPC_SCH_ATT_CAL
		where SCHOOL_YEAR_GU = @orgYrGu and HOLIDAY is not null
		
		-- Get Term definitions from the currently selected school and year
		declare termDefs cursor local fast_forward read_only for
		select SCHOOL_YEAR_TRM_DEF_GU,TERM_NAME,EVENT_DATE from rev.EPC_SCH_YR_TRM_DEF
		where ORGANIZATION_YEAR_GU = @orgYrGu and EVENT_DATE is not null
		order by EVENT_DATE,TERM_CODE_NUMBER
		
		-- Loop through Term definitions and calculate Start and End dates for each Term in the selected School and Year
		open termDefs
		fetch next from termDefs into @termGu,@termName,@endDate
		while @@FETCH_STATUS = 0
		begin
		  while datepart(weekday,@startTerm) in (1,7) or
				(select count(*) from @calendar where holiday = @startTerm) = 1
		  begin
			set @startTerm = dateadd(day,1,@startTerm)
		  end

		  insert into @smallestTerms values(@termGu,@termName,@startTerm,@endDate)

		  set @startTerm = dateadd(day,1,@endDate)

		  fetch next from termDefs into @termGu,@termName,@endDate
		end        
        close termDefs
		deallocate termDefs
		
		-- Add Term definitions to teh Return Table
		insert @retTerms
		select @orgYrGu,tcd.TERM_CODE TermCode,td.TERM_NAME,
			   min(tdf.beginDate) TermBegin,max(tdf.endDate) TermEnd,
			   (select top 1 tcd2.SCHOOL_YEAR_TRM_CODES_GU from rev.EPC_SCH_YR_TRM_DEF tdf2
				inner join rev.EPC_SCH_YR_TRM_CODES tcd2 on (tcd2.SCHOOL_YEAR_TRM_DEF_GU = tdf2.SCHOOL_YEAR_TRM_DEF_GU)
				where tdf2.ORGANIZATION_YEAR_GU = @orgYrGu
				and tcd2.TERM_CODE = tcd.TERM_CODE
				order by tdf2.EVENT_DATE,tdf2.TERM_CODE_NUMBER) TermCodeGu
		from @smallestTerms tdf
		inner join rev.EPC_SCH_YR_TRM_CODES tcd on (tcd.SCHOOL_YEAR_TRM_DEF_GU = tdf.termGu)
		inner join rev.EPC_SCH_YR_TRM_DEF td on (td.SCHOOL_YEAR_TRM_DEF_GU = tdf.termGu)
		group by tcd.TERM_CODE,td.TERM_NAME 
		order by tcd.TERM_CODE
		
		DELETE FROM @calendar
		DELETE FROM @smallestTerms
		
	 -- END TERMS LOOP
     -----------------------------------------------------------------------
     fetch next from schoolDefs into @orgYrGu,@numTracks
  end
close schoolDefs
deallocate schoolDefs

-- Return the List of Term Definitions and add the school year and school name for user readability
SELECT
	[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[RETTERMS].[TermCode]
	,[RETTERMS].[TermName]
	,[RETTERMS].[TermBegin]
	,[RETTERMS].[TermEnd]
	,[RETTERMS].[OrgYearGU]
	,[OrgYear].[YEAR_GU]
	,[OrgYear].[ORGANIZATION_GU]
FROM 
	@retTerms AS [RETTERMS]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[RETTERMS].[OrgYearGU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
ORDER BY
	[Organization].[ORGANIZATION_NAME]
	
GO