
/**************************************************************************************

UPDATE GRADEBOOK EGB_CLASS STANDARDSMODE AND OVERALLGRADE COLUMNS

***************************************************************************************/

--BEGIN TRAN
-- update rev.EGB_CLASS
-- set ISSTANDARDSMODEENABLED = 1
-- , OVERALLGRADEFROMSTANDARDS = 1  --Comment row out for elementary (sbrc) schools 


SELECT c.*FROM rev.EGB_CLASS C 
where id in (select distinct c.ID from rev.EGB_CLASS c join rev.egb_schoolyear sy on sy.ID = c.SCHOOLYEARID join rev.egb_school s on s.id = c.SCHOOLID where sy.SCHOOLYEAR = '2017-2018'  
--and s.SCHOOLNAME in ('Discovery Elementary School')
and c.CLASSTYPEID not in ('4', '6')
)
--COMMIT