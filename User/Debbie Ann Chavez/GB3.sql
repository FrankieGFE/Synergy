SELECT mt.ID
INTO #temp_unused_types
from rev.EGB_MEASURETYPE mt
left join rev.EGB_GRADEBOOK gb on gb.MEASURETYPEID = mt.ID
where gb.ID is NULL
and mt.COPIEDFROMID is not NULL
and TEACHERID in (
             select TEACHERID 
             from rev.EGB_MEASURETYPE mt
             group by TEACHERID
             having count(*) > 100
             )


SELECT * INTO #temp_unused_types_no_setup
FROM rev.EGB_GBSETUP
WHERE MEASURETYPEID IN (
       SELECT ID FROM #temp_unused_types
       )
AND WEIGHT > 0

--SELECT * INTO rev.aaa_egb_gbtypessecurity_bu_20151217
--FROM rev.EGB_GBTYPESSECURITY

--SELECT * INTO rev.aaa_rgb_gbsetup_bu_20151217
--FROM rev.EGB_GBSETUP

--SELECT * INTO rev.aaa_egb_measuretype_bu_20151217
--FROM rev.EGB_MEASURETYPE
---160774
BEGIN TRAN
---DELETE SECURITY FOR EXTRA TYPES
DELETE FROM rev.EGB_GBTYPESSECURITY  ts
WHERE MEASURETYPEID IN (
       SELECT id FROM #temp_unused_types t
	   join rev.EGB_MEASURETYPE mt on mt.id = t.ID
       WHERE mt.TEACHERID = 160774
	   and id NOT IN (
             SELECT MEASURETYPEID FROM #temp_unused_types_no_setup
             )
       )

---DELETE SETUP FOR UNUSED TYPES
select * from rev.EGB_GBSETUP
WHERE MEASURETYPEID IN (
       SELECT id FROM #temp_unused_types
       WHERE id NOT IN (
             SELECT MEASURETYPEID FROM #temp_unused_types_no_setup
             )
       )
	   and classid = 71146
order by MEASURETYPEID

select * from rev.EGB_CLASS
where id = 71146

select * from rev.EGB_PEOPLE
where id = 157187

select * from rev.EGB_MEASURETYPE
where TEACHERID = 157187

---DELETE UNUSED TYPES
DELETE FROM rev.EGB_MEASURETYPE
WHERE id IN (
       SELECT id FROM #temp_unused_types
       WHERE id NOT IN (
             SELECT MEASURETYPEID FROM #temp_unused_types_no_setup
             )
       )

ROLLBACK
--commit



             select TEACHERID, tch.LASTNAME, tch.FIRSTNAME, count(*) TYPE_COUNT
             from rev.EGB_MEASURETYPE mt
			 join rev.EGB_PEOPLE tch on tch.id = mt.TEACHERID
             group by TEACHERID, tch.LASTNAME, tch.FIRSTNAME
             having count(*) > 100
			 order by count(*) desc