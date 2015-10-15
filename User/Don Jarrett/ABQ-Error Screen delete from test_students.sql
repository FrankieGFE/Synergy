BEGIN TRAN

delete from rev.egb_test_students where id in 
(
select ts.ID
from rev.egb_test_students ts
join 
(
select 
       studentid, 
       scheduledtestid, 
       classid, 
       count(*) [count]
from rev.egb_test_students 
group by studentid, scheduledtestid, classid
having count(*) > 1
) multi on ts.SCHEDULEDTESTID = multi.SCHEDULEDTESTID and ts.STUDENTID = multi.STUDENTID and ts.classid = multi.classid
where startdate is null)

ROLLBACK