EXECUTE AS LOGIN='QueryFileUser'
GO

;with Student as
(

select 
	ROW_NUMBER() OVER(PARTITION BY BS.SIS_NUMBER ORDER BY BS.SIS_NUMBER) as RN,
	BS.SIS_NUMBER,
	BS.STUDENT_GU,
	bs.LAST_NAME,
	BS.FIRST_NAME + ' ' + BS.LAST_NAME AS STUDENT_NAME,
	O.ORGANIZATION_NAME AS SCHOOL,
	LU1.VALUE_DESCRIPTION AS GRADE,
	isnull(SSY.ACCESS_504, ' ') as ACCESS_504,
	BS.SPED_STATUS,
	--BS.PRIMARY_DISABILITY_CODE,
	lu.VALUE_DESCRIPTION as PRIMARY_DISABILITY
 
from OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from OCRStudentList.csv'
                ) AS [T1]
INNER JOIN
	APS.BasicStudentWithMoreInfo bs
ON
	BS.SIS_NUMBER = T1.[ID NUMBER]
left join
	aps.EnrollmentsForYear('F7D112F7-354D-4630-A4BC-65F586BA42EC') e
on
	bs.STUDENT_GU = e.STUDENT_GU
LEFT JOIN
	REV.EPC_STU_SCH_YR SSY
ON
	BS.STUDENT_GU = SSY.STUDENT_GU
left join
	rev.rev_organization O
on
	o.ORGANIZATION_GU = e.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12.SpecialEd','DISABILITY_CODE') as LU
on
	bs.PRIMARY_DISABILITY_CODE = lu.VALUE_CODE
LEFT JOIN
	APS.LookupTable('K12', 'GRADE') as LU1
on
	lu1.VALUE_CODE = ssy.GRADE

)

select * from Student where rn = 1
ORDER BY last_name

