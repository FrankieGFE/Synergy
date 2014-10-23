select t.* from ##TempFRMImport t
left join rev.SIF_22_Common_GetLookupValues('K12.ProgramInfo', 'FRM_CODE') fc on fc.VALUE_CODE = t.FRMCode
where fc.VALUE_CODE is null 
