/*
Delete summer school student fees 
Written by:	JoAnn Smith
Date:		7/17/2017
Commented out waivers because Jude wants to leave those records in.

--Please proceed with developing a script to delete the 2016.S enrollment for the students in the attached file. 
 Some of these students may already have data in 2016.S (other summer classes, etc.) so we may not be able to delete them,
  but set those aside and we can evaluate how to remove them.  Test this in Training also.
*/


/* This query has been saved to a file called WaiversToDelete.csv in TempQuery.
These records are related to the student fee records and must be deleted before the
fee records can be deleted. 
*/
--select * from dbo.TempResults t inner join rev.epc_stu_fee_waiver w on t.student_fee_gu = w.STUDENT_FEE_GU

/* This query has been saved to a file called PaymentsToDelete.csv in TempQuery.
These records are related to the student fee payment records and must be deleted before the
fee records can be deleted.  31 records  NO LONGER NEEDED */  

--select t.student_fee_gu, t.SIS_NUMBER, p.stu_fee_payment_gu from dbo.TempResults t inner join rev.epc_stu_fee_payment p on t.student_fee_gu = p.STU_FEE_GU

/* This query has been saved to a file called BalancesToDelete.csv in TempQuery.
Have to delete balances from rev.epc_stu_fee_sum so they don't show up on screen*/

--select distinct t.student_school_year_gu FROM dbo.TempResults t inner join
--rev.epc_stu_fee_sum s 
--on t.STUDENT_SCHOOL_YEAR_GU = s.STUDENT_SCHOOL_YEAR_GU


/* First delete waivers */
EXECUTE AS LOGIN='QueryFileUser'
GO

--BEGIN TRAN
--DELETE FROM REV.EPC_STU_FEE_WAIVER 
--WHERE STUDENT_FEE_GU IN
--(SELECT STUDENT_FEE_GU 
--from OPENROWSET (
--		'Microsoft.ACE.OLEDB.12.0', 
--		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
--		'SELECT * from WaiversToDeleteGU.csv'
--                ) AS [T1])
--commit
--rollback

/* Next delete fee records */
BEGIN TRAN
delete from rev.epc_stu_fee 
where student_fee_gu in
(select student_fee_gu 
from OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from FeesToDelete.csv'
                ) AS [T1])
--commit
--rollback

/* Finally, delete balances */
BEGIN TRAN
delete from rev.epc_stu_fee_sum
where student_school_year_gu in 
(select STUDENT_SCHOOL_YEAR_GU
from OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from BalancesToDelete.csv') as [T1])
--commit
--rollback








