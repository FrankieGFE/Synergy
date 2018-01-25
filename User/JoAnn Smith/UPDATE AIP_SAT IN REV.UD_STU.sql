BEGIN TRAN
EXECUTE AS LOGIN='QueryFileUser'
GO

--Get distinct student IDs from Excel file that Jude gave us
--and which didn't have a record in REV.UD_STU already
;with Students
as
(
SELECT
	*
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from AIP_SAT_Or.csv')
)

UPDATE REV.UD_STU
SET AIP = 'Y'
WHERE
	STUDENT_GU IN 
	(SELECT STUDENT_GU FROM STUDENTS WHERE LEFT(DOCUMENT_CATEGORY,3) = 'AIP')
--ROLLBACK
COMMIT

BEGIN TRAN
EXECUTE AS LOGIN='QueryFileUser'
GO

;with Students
as
(
SELECT
	*
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from AIP_SAT_Or.csv')
)
UPDATE REV.UD_STU
SET SAT = 'Y'
WHERE
	STUDENT_GU IN
	(SELECT STUDENT_GU FROM STUDENTS WHERE LEFT(DOCUMENT_CATEGORY,3) = 'SAT')


--ROLLBACK
commit

