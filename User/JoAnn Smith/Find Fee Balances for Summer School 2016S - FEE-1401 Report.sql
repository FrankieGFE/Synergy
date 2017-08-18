/*
--Find students with fee balances for summer school 2016-2017
--Written by:		JoAnn Smith
--Date Modified:	7/6/2017
					7/19/2017 - Jude does not want any students with
					waivers to be deleted.  Only zero 
					balances and zero waivers.

*/




declare @Year uniqueidentifier = 'C501E5D9-1742-4ABC-9E84-0E46C28D2A05'
;with Student_Fee
as
(

select distinct
	e.STUDENT_GU,
	e.YEAR_GU,
	o.ORGANIZATION_GU,
	f.STUDENT_FEE_GU,
	f.STUDENT_SCHOOL_YEAR_GU,
	p.STU_FEE_PAYMENT_GU,
	o.ORGANIZATION_NAME AS SCHOOL_NAME,
	bs.FIRST_NAME + ' ' + bs.LAST_NAME as STUDENT_NAME,
	BS.SIS_NUMBER,
	lu.VALUE_DESCRIPTION as GRADE,
	bs.GENDER,
	f.TRANSACTION_DATE as TRANSACTION_DATE,
	f.DESCRIPTION,
	f.CREDIT_AMOUNT AS FEES,
	ISNULL(SUM(p.AMOUNT), 0.00) as PAYMENT,
	p.PAYMENT_DATE,
	isnull(w.waiver_amount,0) as WAIVER_AMOUNT,
	W.WAIVER_REASON,
	CASE
		WHEN f.CREDIT_AMOUNT >= ISNULL(SUM(P.AMOUNT),0) THEN F.CREDIT_AMOUNT - ISNULL(SUM(P.AMOUNT),0) + isnull(-1 * w.WAIVER_AMOUNT,0) + isnull(-1 * r.REFUND_AMOUNT,0)
		WHEN F.CREDIT_AMOUNT < ISNULL(SUM(P.AMOUNT),0) THEN F.CREDIT_AMOUNT - ISNULL(SUM(P.AMOUNT),0) + ISNULL(W.WAIVER_AMOUNT,0) + ISNULL(R.REFUND_AMOUNT,0)
	END AS BALANCE,
	f.FEE_CATEGORY,
	r.REFUND_AMOUNT

from
	aps.EnrollmentsForYear(@Year) e
left join
	rev.epc_stu_fee f
on
	f.STUDENT_GU = e.STUDENT_GU
and
	f.STUDENT_SCHOOL_YEAR_GU = e.STUDENT_SCHOOL_YEAR_GU
left join
	rev.epc_stu_fee_payment p
on
	f.STUDENT_FEE_GU = p.STU_FEE_GU
left join
	rev.epc_stu_fee_waiver W
on
	F.STUDENT_FEE_GU = W.STUDENT_FEE_GU
left join
	rev.epc_stu_fee_refund r
on
	F.student_fee_gu = R.STUDENT_FEE_GU
left join
	aps.BasicStudentWithMoreInfo bs
on
	bs.STUDENT_GU = e.STUDENT_GU
left join
	aps.LookupTable('K12', 'Grade') lu
on
	lu.VALUE_CODE = e.GRADE
left join
	rev.rev_organization o
on
	o.ORGANIZATION_GU = E.ORGANIZATION_GU
GROUP BY
	E.STUDENT_GU,
	E.YEAR_GU,
	O.ORGANIZATION_GU,
	F.STUDENT_SCHOOL_YEAR_GU,
	p.STU_FEE_PAYMENT_GU,
	F.STUDENT_FEE_GU,
	O.ORGANIZATION_NAME,
	BS.LAST_NAME,
	BS.FIRST_NAME,
	BS.SIS_NUMBER,
	LU.VALUE_DESCRIPTION,
	GENDER,
	TRANSACTION_DATE,
	DESCRIPTION,
	DEBIT_AMOUNT,
	CREDIT_AMOUNT,
	P.PAYMENT_DATE,
	F.FEE_CATEGORY,
	w.WAIVER_AMOUNT,
	W.WAIVER_REASON,
	r.REFUND_AMOUNT

)
,Results
as
(
select
	 *
from
	 Student_Fee
where 1 = 1
AND
	PAYMENT_DATE is null
AND
	balance > 0
AND
	WAIVER_amount = 0
AND
	ORGANIZATION_GU = 'F9ED2CBB-D65B-4A59-A4D2-36FCFDC56946'
)
--SELECT * FROM RESULTS
--order by SIS_NUMBER

--select * from rev.epc_stu_fee_payment where stu_fee_gu = '851AF9D2-E257-47C0-9786-4B6626194A32'
/* Created a table to store the results of
the above query
*/
--select * into dbo.TempResults
--from
--Results
--drop table dbo.TempResults
select * from dbo.TempResults
ORDER BY SIS_NUMBER












