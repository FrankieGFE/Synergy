-- <APS - Transfer System – General Demographic and Enrollment Data>
-- List to include all student that have a record – regardless of whether a current enrollment 
-- exists as of date list is run (DL) (may be no School of Record for Current SY)
; with SumWdrw AS
(
select
  row_number() over(partition by stu.student_gu order by stu.student_gu) rn
, stu.STUDENT_GU
, ssyr.SUMMER_WITHDRAWL_CODE
, ssyr.SUMMER_WITHDRAWL_DATE
, sch.SCHOOL_CODE
FROM   rev.EPC_STU                         stu
       JOIN rev.EPC_STU_SCH_YR             ssyr ON ssyr.STUDENT_GU          = stu.STUDENT_GU
       JOIN rev.REV_YEAR                   yr    ON yr.YEAR_GU               = ssyr.YEAR_GU
                                                    AND yr.SCHOOL_YEAR       = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
       LEFT JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
	   LEFT JOIN rev.REV_ORGANIZATION      org   ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU      = org.ORGANIZATION_GU
where   (ssyr.SUMMER_WITHDRAWL_CODE is not null or ssyr.SUMMER_WITHDRAWL_DATE is not null)
), ConcEnr AS
(
select
  row_number() over(partition by stu.student_gu order by stu.student_gu) rn
, stu.STUDENT_GU
, ssyr.EXCLUDE_ADA_ADM
, ssyr.STUDENT_SCHOOL_YEAR_GU
FROM   rev.EPC_STU                         stu
       JOIN rev.EPC_STU_SCH_YR             ssyr ON ssyr.STUDENT_GU          = stu.STUDENT_GU
       JOIN rev.REV_YEAR                   yr    ON yr.YEAR_GU               = ssyr.YEAR_GU
                                                    AND yr.SCHOOL_YEAR       = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
where   ssyr.EXCLUDE_ADA_ADM is not null
)

SELECT
         stu.SIS_NUMBER                                           AS [Student ID]
       , stu.USER_CODE_1                                          AS [Prior Student ID Exists]
       , stu.STATE_STUDENT_NUMBER                                 AS [State ID]
       , per.FIRST_NAME                                           AS [Student First Name]
       , per.LAST_NAME                                            AS [Student Last Name]
       , per.MIDDLE_NAME                                          AS [Student Middle Name]
       , CONVERT(VARCHAR(10), per.BIRTH_DATE, 101)                AS [Student Date of Birth]
       , grd.VALUE_DESCRIPTION                                    AS [Current Enrollment Grade]
       , sch.SCHOOL_CODE                                          AS [Current Enrollment Location Number]
       , org.ORGANIZATION_NAME                                    AS [Current Enrollment Location Name]
       , COALESCE(hadr.ADDRESS, '')                               
         + ' ' + COALESCE(hadr.CITY, '')                          
         + ' ' + COALESCE(hadr.STATE, '')                         
         + ' ' + COALESCE(hadr.ZIP_5, '')                         AS [Student Address]
       , per.PRIMARY_PHONE                                        AS [Phone]
       , stu.GRID_CODE                                            AS [Grid Code]
       , CASE
            WHEN (sped.CURRENT_STUDENT_PROCESS_GU is not null
                  or strpt.STUDENT_GU is not null) THEN 'Y'
            ELSE 'N'
         END                                                      AS [Has Special Education History]
       , COALESCE(CONVERT(VARCHAR(10),sped.CURRENT_IEP_DATE,101),
                  CONVERT(VARCHAR(10),strpt.LAST_IEP_DATE, 101))  AS [Current IEP Date]
       , ' ' AS [Current Primary Eligibility]
       , ' ' AS [Current Special Ed Program Manager]
       , ' ' AS [Current Program Type]
       , ' ' AS [Current Setting]
       , ' ' AS [Current Program Start Date]
       , ' ' AS [Current Program End Date]
       , ' ' AS [McKinney Vento Type Current SY]
       , ' ' AS [McKinney Vento Start Date Current SY]
       , ' ' AS [McKinney Vento End Date Current SY]
       , ' ' AS [McKinney Vento Type Prior SY]
       , ' ' AS [McKinney Vento Start Date Prior SY]
       , ' ' AS [McKinney Vento End Date Prior SY]
       , CONVERT(VARCHAR(10), GETDATE(), 101)  AS [File Date]
	   , cenr.EXCLUDE_ADA_ADM                  AS [Concurrent]


FROM   rev.EPC_STU                         stu
       JOIN rev.EPC_STU_YR                 stuyr ON stuyr.STUDENT_GU         = stu.STUDENT_GU
       JOIN rev.REV_YEAR                   yr    ON yr.YEAR_GU               = stuyr.YEAR_GU
                                                    AND yr.SCHOOL_YEAR       = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
       JOIN rev.REV_PERSON                 per   ON per.PERSON_GU            = stu.STUDENT_GU
	   LEFT JOIN rev.REV_ADDRESS           hadr  ON hadr.ADDRESS_GU          = per.HOME_ADDRESS_GU
	   LEFT JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU          = stu.STUDENT_GU
	                                                AND ssyr.YEAR_GU         = yr.YEAR_GU
													AND ssyr.LEAVE_DATE        is null
													and ssyr.LEAVE_CODE        is null
	   LEFT JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
	   LEFT JOIN rev.REV_ORGANIZATION      org   ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU      = org.ORGANIZATION_GU
       LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssyr.GRADE
	   -- SpecialED
	   LEFT JOIN rev.EP_STUDENT_SPECIAL_ED sped  ON sped.STUDENT_GU          = stu.STUDENT_GU
	   LEFT JOIN (
	                SELECT 
					       ROW_NUMBER() over (partition by sr.student_gu order by sr.snapshot_type desc) rn
					     , sr.* 
					FROM rev.EPC_NM_STU_SPED_RPT sr
	             ) strpt                         ON strpt.STUDENT_GU         = stu.STUDENT_GU
				                                    AND strpt.rn             = 1
       LEFT JOIN ConcEnr                    cenr ON cenr.STUDENT_GU          = stu.STUDENT_GU 
													 and cenr.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
WHERE  not exists (select sw.student_gu from SumWdrw sw where sw.STUDENT_GU = stu.STUDENT_GU and sw.SCHOOL_CODE = sch.SCHOOL_CODE)