/*
update script to change grad year and grad month
*/

EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRANSACTION

SET NOCOUNT ON;
DECLARE @ROWCOUNT INTEGER

UPDATE REV.EPC_STU
     SET 
            EXPECTED_GRADUATION_YEAR = 2017,
            EXPECTED_GRADUATION_MONTH = 07,
			CHANGE_ID_STAMP = '9F899E44-0472-4F9E-AC07-2D234400337B',
			CHANGE_DATE_TIME_STAMP = getdate()
FROM
       REV.EPC_STU AS STU
       INNER JOIN
       OPENROWSET (
              'Microsoft.ACE.OLEDB.12.0', 
              'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
              'SELECT * from Summer_Grad_update.csv'
                ) AS [T1]
              ON
                      T1.[PERM ID] = STU.SIS_NUMBER

SELECT @ROWCOUNT = @@ROWCOUNT

SELECT @rOWCOUNT     

rollback

/*
check
*/

--SELECT sis_number, expected_graduation_month, expected_graduation_year, CHANGE_ID_STAMP, CHANGE_DATE_TIME_STAMP FROM REV.EPC_STU stu
--inner join
--OPENROWSET (
--              'Microsoft.ACE.OLEDB.12.0', 
--              'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
--              'SELECT * from Summer_Grad_update.csv'
--                ) AS [T1]
--              ON
--                      T1.[PERM ID] = STU.SIS_NUMBER

