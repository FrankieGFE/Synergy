begin tran

--declare @Output table
--(
--	EMAIL_GU uniqueidentifier
--)

;with EMAIL_QUEUE
as
(
select
	 eq.EMAIL_QUEUE_GU,
	 e.EMAIL_gu,
	 e.FROM_ADDRESS,
	 e.TO_ADDRESS,
	 e.ADD_DATE_TIME_STAMP,
	 e.SUBJECT
from
	 rev.REV_EMAIL_QUEUE eq
join
	 rev.rev_email e
on
	 e.EMAIL_GU = eq.EMAIL_GU
where
	 e.ADD_DATE_TIME_STAMP between '2017-03-01' and '2017-08-31'
)
,EMAIL_QUEUE_RESULTS
as
(
select 
	*
from
	EMAIL_QUEUE
)
--select * from EMAIL_QUEUE_RESULTS
--select * into dbo.EMAIL_QUEUE_RESULTS from email_queue_results 



delete from rev.rev_email
where email_gu in
(select
	email_gu
from 
	dbo.EMAIL_QUEUE_RESULTS
)
--output deleted.* into @Output

delete from rev.rev_email_queue
where email_queue_gu in
(select
	email_queue_gu
from
	dbo.EMAIL_QUEUE_RESULTS)

commit
--select * from @Output
