

--declare
--@student_id varchar (9) = '100126192'
--select * from aps.BasicStudent
--where STATE_STUDENT_NUMBER = @student_id or SIS_NUMBER = @student_id



select * from aps.BasicStudent
where LAST_NAME like '%SAENZ%' --AND FIRST_NAME LIKE 'Y%'
--WHERE BIRTH_DATE = '1993-07-14'
ORDER BY LAST_NAME, FIRST_NAME

