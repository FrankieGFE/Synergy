/*
Find summer school enrollmentsto delete for summer school 2016-2017
Written by:		JoAnn Smith
Date Modified:	8/2/2017
*/



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
--select * from Additional_Records

,Summer
as
(
SELECT 
	*
FROM
	DBO.SummerEnrollmentResults R
WHERE
	R.STUDENT_SCHOOL_YEAR_GU NOT IN
(select STUDENT_SCHOOL_YEAR_GU FROM Additional_Records)
)
--select * into dbo.SummerEnrollmentsToDelete from Summer

; with ClassRecordsWithConstraints
as
(

select distinct d.student_school_year_gu from dbo.SummerEnrollmentsToDelete d
inner join 
rev.epc_stu_class c
on
d.STUDENT_SCHOOL_YEAR_GU = c.STUDENT_SCHOOL_YEAR_GU
)
--select * from ClassRecordsWithConstraints

select * into dbo.FinalSummerEnrollmentsToDelete from dbo.SummerEnrollmentsToDelete where student_gu not in ('0261E548-EFD6-4C1A-82B4-0615BF719889', '0B17CC53-E49B-4BA1-8169-9C20B50EE0C4', '93E1090E-94F6-4028-AC14-40AC8A40DD16')

select * from dbo.FinalSummerEnrollmentsToDelete


--;with SummerEnrollments
--as
--(
--SELECT 
--	*
--FROM
--	DBO.SummerEnrollmentResults R
--WHERE
--	R.STUDENT_SCHOOL_YEAR_GU NOT IN
--(select STUDENT_SCHOOL_YEAR_GU FROM dbo.AdditionalRecordsToEliminateFromDeletion)
--)
--select * into dbo.SummerEnrollmentsToDelete from SummerEnrollments

--Msg 547, Level 16, State 0, Line 221
--The DELETE statement conflicted with the REFERENCE constraint "EPC_STU_SCHD_WALKIN_RESULT_F1". The conflict occurred in database "ST_Train_90", table "rev.EPC_STU_SCHD_WALKIN_RESULT", column 'STUDENT_SCHOOL_YEAR_GU'.

--get records that are causing constraint error
select * from dbo.FinalSummerEnrollmentsToDelete f
inner join
rev.epc_stu_schd_walkin_result w
on
f.STUDENT_SCHOOL_YEAR_GU = w.STUDENT_SCHOOL_YEAR_GU

--create a table with those records removed
--select * into dbo.FinalSummerEnrollmentsToDelete2 from dbo.FinalSummerEnrollmentsToDelete f
--where f.STUDENT_SCHOOL_YEAR_GU not in
--(select STUDENT_SCHOOL_YEAR_GU from rev.epc_stu_schd_walkin_result)

--this is the one record that was causing the constraint error

select * from rev.epc_stu_schd_walkin_result where STUDENT_SCHOOL_YEAR_GU = '65735776-5C8C-4A5E-9613-F1DDDD49F851'
select * from dbo.FinalSummerEnrollmentsToDelete