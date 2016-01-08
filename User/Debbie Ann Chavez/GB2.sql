--SELECT * INTO rev.aaa_egb_gbtypessecurity_bu_20160108
--FROM rev.EGB_GBTYPESSECURITY

--SELECT * INTO rev.aaa_egb_gbsetup_bu_20160108
--FROM rev.EGB_GBSETUP

--SELECT * INTO rev.aaa_egb_measuretype_bu_20160108
--FROM rev.EGB_MEASURETYPE

select TEACHERID, tch.LASTNAME, tch.FIRSTNAME, count(*) TYPE_COUNT
from rev.EGB_MEASURETYPE mt
join rev.EGB_PEOPLE tch on tch.id = mt.TEACHERID
group by TEACHERID, tch.LASTNAME, tch.FIRSTNAME
having count(*) > 100
order by LASTNAME


--drop table #temp_unused_types
SELECT mt.ID
INTO #temp_unused_types
from rev.EGB_MEASURETYPE mt
left join rev.EGB_GRADEBOOK gb on gb.MEASURETYPEID = mt.ID
where gb.ID is NULL
and mt.COPIEDFROMID is not NULL
and TEACHERID = 255263

select * from rev.EGB_GBSETUP
where MEASURETYPEID in (
	select id from #temp_unused_types
	)

select * from rev.EGB_GBSETUP
where weight > 0
and MEASURETYPEID in (
	select id from #temp_unused_types
	)

begin tran
delete from rev.EGB_GBSETUP
where MEASURETYPEID in (
	select id from #temp_unused_types
	)

DELETE FROM rev.EGB_GBTYPESSECURITY  
where MEASURETYPEID in (
	select id from #temp_unused_types
	)

DELETE FROM rev.EGB_MEASURETYPE
WHERE id IN (
select id from #temp_unused_types
	)

--commit