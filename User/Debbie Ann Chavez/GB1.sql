select * from rev.EGB_PEOPLE
where LASTNAME = 'Kashmer'
and FIRSTNAME ='Megan'

select * from rev.EGB_MEASURETYPE
where TEACHERID = 150844

select * from rev.EGB_CLASS_OWNER
where CLASSID in (
select c.id
from rev.EGB_CLASS c
where c.teacherid = 254750
and c.SCHOOLYEARID = 9
)
order by classid, CHECKDATE desc

select * from rev.EGB_CLASS
where TEACHERID = 254750
and id in (79651, 79777)

select * from rev.EGB_CLASS_OWNER
where TEACHERID = 214849

select * from rev.EGB_CLASS_OWNER
where CLASSID in (79651, 79777)

update rev.EGB_CLASS_OWNER
set TEACHERID = 254750
where id in (75052, 76838)

select sect.SECTION_ID, c.TEACHERID
from rev.EPC_SCH_YR_SECT sect
join rev.EPC_STAFF_SCH_YR stf_sy on stf_sy.staff_school_year_gu = sect.staff_school_year_gu
join rev.REV_ORGANIZATION_YEAR roy on roy.ORGANIZATION_YEAR_GU = stf_sy.ORGANIZATION_YEAR_GU
join rev.EGB_SCHOOLYEAR sy on sy.GENESISGUID = roy.YEAR_GU
join rev.EGB_PEOPLE tch on tch.GENESISID = stf_sy.STAFF_GU
join rev.EGB_CLASS c on c.CLASSGUID = sect.SECTION_GU
where sy.SCHOOLYEAR = '2015-2016'
and tch.id = 74387


select * from rev.EGB_PEOPLE
where LASTNAME = 'Novich'

select gb.* from rev.EGB_CLASS c
join rev.EGB_GRADEBOOK gb on gb.CLASSID = c.ID
where TEACHERID = 150844
and (gb.MEASUREDATE is NULL
	or gb.DUEDATE is NULL)

	begin tran
	update rev.EGB_GRADEBOOK
	set MEASUREDATE = '2016-01-08', DUEDATE = '2016-01-08'
	where id = 1769072
	commit