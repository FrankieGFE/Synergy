

declare @studentid varchar(9) = '970029835'
--select * from aps_xfer_request where aps_id = @studentid


SELECT --TOP 1 
ssy.enter_date, ssy.leave_date, stu.student_gu,
stu.SIS_NUMBER
AS [aps_id]
, CONVERT(VARCHAR(10), per.BIRTH_DATE, 120)     AS [student_dob]
, pper.LAST_NAME                                AS [parent_last_name]
, pper.FIRST_NAME                               AS [parent_first_name]
, pper.MIDDLE_NAME                              AS [parent_middle_name]
, per.LAST_NAME                                 AS [student_last_name]
, per.FIRST_NAME                                AS [student_first_name]
, per.GENDER
AS [student_gender]
, sys.ACTIVATE_KEY                              AS [key]
, sys.USER_ID                                   AS [user_id]
, spar.CONTACT_ALLOWED                          AS [contact_allowed]
--, sch.school_code
AS [current_school_code]
, case
when yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU) then sch.school_code
else null
  end as [current_school_code]
--, org.organization_name
AS [current_school_name]
, case
when yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU) then org.organization_name
else null
  end as [current_school_name]
, case 
when sch.school_code = 'TRAN' and enr_user_dd_6 is not null then 'Y'
when sch.school_code = 'TRAN' and enr_user_dd_6 is null then 'N'
else stu.indicator_speced
 
  end  AS [sped]
--, grade.value_description
AS [current_grade]
--, case grade.value_description
--
when 'P1' then 'K'
--
when 'P2' then 'K'
--  else grade.alt_code_sif
-- end
as next_grade  --Ensure P1, P2, and PK go to K as next grade.
, case
when yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU) then grade.value_description
else null
  end as [current_grade]
, case
when yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU) then 
case grade.value_description
when 'P1' then 'K'
when 'P2' then 'K'
else grade.alt_code_sif
end
 
else null
  end as next_grade
, SPED_PRIM_DISABILITY.primary_disability_code
as primary_disability_code
, case sch.school_code
when 'TRAN' then enr_user_dd_6
--For the new TRAN school they have entered SPED level in enr_user_dd_6
else left(right(LEVELS.VALUE_DESCRIPTION,2),1)
  end
AS sped_level_of_integration

, grid.grid_gu
, case
when yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU) then 
case 
when grade.alt_code_sif in ('P1','P2','PK','K','01','02','03','04','05') then 
(select ORGANIZATION_NAME from [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION 
where ORGANIZATION_GU = grid.elem_school_gu)
when grade.alt_code_sif in ('06','07','08') then 
(select ORGANIZATION_NAME from [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION 
where ORGANIZATION_GU = grid.jr_high_school_gu)
when grade.alt_code_sif in ('09','10','11','12','T1','T2','T3','T4','C1','C2','C3','C4') then 
(select ORGANIZATION_NAME from [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION 
where ORGANIZATION_GU = grid.sr_high_school_gu)
end
  else null
end as next_school
, spar.educational_rights
, spar.contact_allowed
FROM   [SYNERGYDBDC].ST_Production.rev.EPC_STU
  stu WITH (NOLOCK)
JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR        ssy  WITH (NOLOCK) ON ssy.STUDENT_GU = stu.STUDENT_GU
JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR oyr  WITH (NOLOCK) ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
JOIN [SYNERGYDBDC].ST_Production.rev.REV_YEAR              yr   WITH (NOLOCK) ON yr.YEAR_GU = oyr.YEAR_GU
JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT        spar WITH (NOLOCK) ON spar.STUDENT_GU = stu.STUDENT_GU
JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            pper WITH (NOLOCK) ON pper.PERSON_GU  = spar.PARENT_GU
--remove as per Shelly/Frank - address not needed JOIN [SYNERGYDBDC].ST_Production.rev.REV_ADDRESS           hadrWITH (NOLOCK) ON hadr.ADDRESS_GU = pper.HOME_ADDRESS_GU
JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            per WITH (NOLOCK) ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_USER_NON_SYS sys WITH (NOLOCK) ON sys.PERSON_GU = pper.PERSON_GU
LEFT JOIN [LookupTable]('K12','Grade') grade  ON grade.VALUE_CODE = ssy.GRADE
 
JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH               sch  WITH (NOLOCK) ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION      org  WITH (NOLOCK) ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
left join [SYNERGYDBDC].[ST_Production].[rev].[EPC_GRID] grid WITH (NOLOCK) ON stu.grid_code = grid.grid_code
left join [SYNERGYDBDC].[ST_Production].[rev].UD_SPED_SERVICE_LEVEL sped WITH (NOLOCK) ON SPED.STUDENT_GU = STU.STUDENT_GU
left join LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LEVELS  ON LEVELS.VALUE_CODE = SPED.LEVEL_INTEGRATION
LEFT JOIN [SYNERGYDBDC].[ST_Production].rev.EP_STUDENT_SPECIAL_ED AS SPED_PRIM_DISABILITY
WITH (NOLOCK) ON SPED_PRIM_DISABILITY.STUDENT_GU = STU.STUDENT_GU
 
 
WHERE 1=1
--and
stu.sis_number = @studentid
--and stu.student_gu in ('6E711C0C-56A5-4717-835A-C3062D779ACA',
--
'CC305BBE-C852-4FE0-936D-7AD303D0A215',
--
'3C6EED75-83EF-4AEB-93E3-DA6C1C722476',
--
'E5B32D73-1794-4CFE-A8E3-6AC37CA4B14C')
--and sch.school_code = '490'  --MS 
--and sch.school_code = '590'  --HS 
--and grade.value_description = '05'
--and yr.year_gu = (select year_gu from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU)  --Find a current enrollment
--and stu.sis_number <> @StudentID
and contact_allowed = 'N'

