begin tran
--rollback
--commit

--CREATE A TEMP TABLE OF ASSIGNMENTS TO DELETE
select gb.ID 
into #temp_dgb_to_delete
from rev.EGB_CLASS c
join rev.EGB_GRADEBOOK gb on gb.CLASSID = c.ID
where CLASSTYPEID = 4  ---IF YOU EVER CREATE ANOTHER DGB, SCOPE THIS FURTHER

--DELETE THE ASSIGNMENT(s) from the DISTRICT GRADE BOOK FIRST
delete from rev.EGB_GRADEBOOK
where id in (
	select id
	from #temp_dgb_to_delete
)

--DELETE THE RESULTS TIED TO THE DISTRICT GRADE BOOK ASSIGNMENTS INHERITED BY THE TEACHERS
delete from rev.EGB_GBRESULT
where id in (
	select r.ID 
	from rev.EGB_GRADEBOOK gb
	join rev.EGB_GBRESULT r on r.GRADEBOOKID = gb.ID
	where PARENTID in (
		select id
		from #temp_dgb_to_delete
	)
)

--DELETE THE GBPERIOD CORRELATIONS FOR THE DGB ASSIGNMENTS INHERITED BY THE TEACHERS
delete from rev.EGB_GBPERIODS
where id in (
	select per.ID
	from rev.EGB_GRADEBOOK gb
	join rev.EGB_GBPERIODS per on per.GRADEBOOKID = gb.ID
	where PARENTID in (
		select id
		from #temp_dgb_to_delete
	)
)

--FINALLY, DELETE THE DGB ASSIGNMENTS INHERITED BY THE TEACHERS
delete from rev.EGB_GRADEBOOK
where id in (
	select gb.ID 
	from rev.EGB_GRADEBOOK gb
	where PARENTID in (
		select id
		from #temp_dgb_to_delete
	)
)

