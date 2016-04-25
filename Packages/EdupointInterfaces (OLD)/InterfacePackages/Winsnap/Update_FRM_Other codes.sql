-- APS FRM Import
--
-- Update exit date for rows in temp table != N, Status = 1 
--
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
