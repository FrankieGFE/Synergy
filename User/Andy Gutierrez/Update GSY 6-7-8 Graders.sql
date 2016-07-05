BEGIN TRANSACTION

UPDATE [REV].[EPC_STU]
SET
       EXPECTED_GRADUATION_YEAR = CASE
             WHEN GRADE = '06' THEN 2022
             WHEN GRADE = '07' THEN 2021
             WHEN GRADE = '08' THEN 2020
       END
FROM
(
select *
from
       (
       select
       row_number() over (partition by a.sis_number order by enter_date desc) as RowNum  --gets last enrollment record
       ,a.sis_number
       ,b.grade
       ,b.school_name
       ,a.EXPECTED_GRADUATION_YEAR
       ,B.STUDENT_GU
  from  [rev].[epc_stu] a
join [APS].[StudentEnrollmentDetails]  b
on a.student_gu=b.student_gu
where grade in ('06','07','08') 
and SCHOOL_YEAR = 2015 and EXTENSION = 'R'
and EXCLUDE_ADA_ADM  is null
) AS t
WHERE RowNum = 1
) AS T1
WHERE [REV].[EPC_STU].STUDENT_GU=T1.STUDENT_GU

COMMIT
--ROLLBACK
