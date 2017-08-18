/*
Find students with questionable fee balances for summer school 2016-2017
Written by:		JoAnn Smith
Date Modified:	7/6/2017

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
	CASE
		WHEN f.CREDIT_AMOUNT >= ISNULL(SUM(P.AMOUNT),0) THEN F.CREDIT_AMOUNT - ISNULL(SUM(P.AMOUNT),0) + isnull(-1 * w.WAIVER_AMOUNT,0) 
		WHEN F.CREDIT_AMOUNT < ISNULL(SUM(P.AMOUNT),0) THEN F.CREDIT_AMOUNT - ISNULL(SUM(P.AMOUNT),0) + ISNULL(W.WAIVER_AMOUNT,0)
		WHEN f.credit_amount IS NULL THEN F.CREDIT_AMOUNT
	END AS BALANCE,
	f.FEE_CATEGORY
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
	rev.epc_stu_fee_waiver w
on
	f.STUDENT_FEE_GU = w.STUDENT_FEE_GU
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
	w.WAIVER_AMOUNT

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
	balance > 0
anD
	PAYMENT = 0
AND
	PAYMENT_DATE IS NULL
and
	WAIVER_AMOUNT = 0
AND
	 @Year = YEAR_GU

)
select * from Results
/* note:  These records were not picked up in the original delete of students with fees
and balances greater than zero, so going to delete these records and see if I can
delete enrollments */

;with Additional_Records
as
(
select 

	r.STUDENT_GU,
	r.YEAR_GU,
	r.ORGANIZATION_GU,
	r.STUDENT_FEE_GU,
	r.STUDENT_SCHOOL_YEAR_GU,
	r.STU_FEE_PAYMENT_GU,
	r.SCHOOL_NAME,
	r.STUDENT_NAME,
	r.SIS_NUMBER,
	r.grade,
	r.GENDER,
	r.TRANSACTION_DATE,
	r.DESCRIPTION,
	r.FEES,
	R.PAYMENT,
	R.PAYMENT_DATE,
	R.WAIVER_AMOUNT,
	R.WAIVER_REASON,
	R.BALANCE,
	R.FEE_CATEGORY,
	R.REFUND_AMOUNT
from dbo.SummerEnrollmentResults r
inner join
rev.epc_stu_fee f
on
r.student_school_year_gu = f.student_school_year_gu
)

select * from dbo.finalSummerEnrollmentsToDelete









