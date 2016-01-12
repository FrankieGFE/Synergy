SELECT * INTO rev.aaa_egb_gbtypessecurity_bu_20160111
FROM rev.EGB_GBTYPESSECURITY

SELECT * INTO rev.aaa_egb_gbsetup_bu_20160111
FROM rev.EGB_GBSETUP

SELECT * INTO rev.aaa_egb_measuretype_bu_20160111
FROM rev.EGB_MEASURETYPE

select TEACHERID, tch.LASTNAME, tch.FIRSTNAME, count(*) TYPE_COUNT
from rev.EGB_MEASURETYPE mt
join rev.EGB_PEOPLE tch on tch.id = mt.TEACHERID
group by TEACHERID, tch.LASTNAME, tch.FIRSTNAME
having count(*) > 50
order by LASTNAME


--drop table #temp_unused_types
SELECT mt.ID
INTO #temp_unused_types
from rev.EGB_MEASURETYPE mt
left join rev.EGB_GRADEBOOK gb on gb.MEASURETYPEID = mt.ID
where gb.ID is NULL
and mt.COPIEDFROMID is not NULL

select measuretypeid 
into #temp_used_types 
from rev.EGB_GBSETUP
where MEASURETYPEID in (
	select id from #temp_unused_types
	)
group by measuretypeid
having sum(weight) > 0


select id into #temp_types_to_delete
from #temp_unused_types
where id not in (
	select measuretypeid from #temp_used_types
	)

--FOR A CHECK
select * from rev.EGB_GBSETUP
where MEASURETYPEID in (
	select id from #temp_types_to_delete
	)
	and weight > 0

begin tran
delete from rev.EGB_GBSETUP
where MEASURETYPEID in (
	select id from #temp_types_to_delete
	)

DELETE FROM rev.EGB_GBTYPESSECURITY  
where MEASURETYPEID in (
	select id from #temp_types_to_delete
	)

DELETE FROM rev.EGB_MEASURETYPE
WHERE id IN (
select id from #temp_types_to_delete
	)

--commit