select TEACHERID, COPIEDFROMID, count(*) n_count 
from rev.EGB_MEASURETYPE
where COPIEDFROMID is not NULL
group by TEACHERID, COPIEDFROMID
having count(*) > 1
order by TEACHERID 


select c.classname, gb.* from rev.EGB_GRADEBOOK gb
join rev.EGB_CLASS c on c.id = gb.classid
where gb.measuretypeid in (
select id from rev.EGB_MEASURETYPE
where TEACHERID = 124561
)