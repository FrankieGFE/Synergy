-- APS FRM Import
-- Load incoming file into a temp table
--
IF OBJECT_ID('tempdb..##TempFRMImport') IS NOT NULL DROP TABLE ##TempFRMImport
CREATE TABLE ##TempFRMImport(
   SIS_Number  NVARCHAR(20) null
 , FRMCode     NVARCHAR(05) null
 , SchoolCode  NVARCHAR(20) null
 , LastName    NVARCHAR(30) null
 , FirstName   NVARCHAR(30) null
 , StatusCode  NVARCHAR(20) null
)

BULK INSERT ##TempFRMImport
    FROM 'C:\temp\APS FRM Import test.txt'
    WITH
    (
    FIELDTERMINATOR = ','
	, ROWTERMINATOR = '\n'
    )

alter table ##TempFRMImport add StudentGU  uniqueidentifier null
alter table ##TempFRMImport add CurrentFRM NVARCHAR(05)     null

-- drop leading zeros in sis_number
update ##TempFRMImport
       set ##tempFRMImport.SIS_Number = convert(int, SIS_Number)
--
update ##TempFRMImport
set ##tempFRMImport.StudentGU = stu.student_gu
  , ##tempFRMImport.CurrentFRM = frm.FRM_CODE
from ##TempFRMImport t
left join rev.EPC_STU stu on stu.SIS_NUMBER = t.SIS_Number
left join rev.EPC_STU_PGM_FRM frm on frm.STUDENT_GU = stu.STUDENT_GU

select 
 *
from ##TempFRMImport t
--where t.SIS_Number = '106500'

--IF OBJECT_ID('tempdb..##TempFRMImport') IS NOT NULL DROP TABLE ##TempFRMImport

update rev.EPC_STU_PGM_FRM_HIS 
  set EXIT_DATE = getdate()
  , CHANGE_DATE_TIME_STAMP = getdate()
from ##TempFRMImport t
join rev.EPC_STU             stu  on stu.SIS_NUMBER  = t.SIS_Number
join rev.EPC_STU_PGM_FRM     frm  on frm.STUDENT_GU  = stu.STUDENT_GU
join rev.EPC_STU_PGM_FRM_HIS frmh on frmh.STUDENT_GU = stu.STUDENT_GU
where t.StatusCode = '1'
      and t.FRMCode != 'N'
	  and frmh.EXIT_DATE is null
	  and exists (select l.value_code from rev.SIF_22_Common_GetLookupValues('K12.ProgramInfo', 'FRM_CODE') l where l.VALUE_CODE = t.FRMcode)
--
-- Insert row for rows in temp table != N, Status = 1 
--
insert rev.EPC_STU_PGM_FRM_HIS
      (STU_PGM_FRM_HIS_GU
      ,STUDENT_GU
      ,FRM_CODE
      ,ENTER_DATE
	  ,ADD_DATE_TIME_STAMP
	  )
select
       newid()
	 , t.studentGU
	 , t.FRMCode
	 , getdate()
	 , getdate() 
from ##TempFRMImport t
where t.StatusCode = '1'
      and t.FRMCode != 'N'
	  and t.StudentGU is not NULL
	  and exists (select l.value_code from rev.SIF_22_Common_GetLookupValues('K12.ProgramInfo', 'FRM_CODE') l where l.VALUE_CODE = t.FRMcode)
