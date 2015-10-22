--<APS Medicaid System – Student/Physician (PCP)>
--Only Active students with completed IEPs

DECLARE  @vDistrict_Number VARCHAR(20)
SET @vDistrict_Number = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')
; with SpedStudents AS
(
SELECT
         stu.STUDENT_GU
	   , ROW_NUMBER() over (partition by stu.student_gu order by stu.student_gu) rn
	   , iep.PRIMARY_DISABILITY_CODE
	   , iep.SECONDARY_DISABILITY_CODE
	   , iep.TERTIARY_DISABILITY_CODE
	   , iep.QUATERNARY_DISABILITY_CODE
	   , iep.IEP_DATE
	   , iep.NEXT_IEP_DATE
	   , au.au_min
	   , au.au_freq
	   , sw.sw_min
	   , sw.sw_freq
	   , sh.sh_min
	   , sh.sh_freq
	   , ot.ot_min
	   , ot.ot_freq
	   , pt.pt_min
	   , pt.pt_freq
	   , ss.ss_min
	   , ss.ss_freq
	   , CASE WHEN (aiep.SERV_TRANSPORT_YN = 'Y' and aiep.SERV_TRANSPORT_ADULT_YN = 'Y') THEN 'Y' ELSE 'N' END SplTrans
	   , iep.PARENT_CONSENT
	   , sped.MEDI_CARE_NUMBER
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy   ON ssy.STUDENT_GU = stu.STUDENT_GU
                                               and ssy.STATUS is NULL
                                               and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
       JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                               and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.EP_STUDENT_SPECIAL_ED sped  ON sped.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.EP_STUDENT_IEP        iep   ON iep.STUDENT_GU = sped.STUDENT_GU 
                                               and iep.IEP_STATUS = 'CU' 
					                           and iep.IEP_VALID = 'Y' 
											   --and iep.PRIMARY_DISABILITY_CODE != 'GI'
       -- Special Transportation on IEP
       -- This will need to be determined by the drop downs the Services Tab.  Both will need to be YES to be included for Medicaid billing.
       LEFT JOIN rev.EP_AZ_STUDENT_IEP aiep ON aiep.IEP_GU = iep.IEP_GU
									           and iep.NEXT_IEP_DATE <= getdate()
        -- AU - Audiology on IEP
        LEFT JOIN
		   (
		     select 
			     row_number() over(partition by iep.student_gu order by iep.student_gu) rn
               , iep.STUDENT_GU
	           , ieps.NUM_MINUTES au_min
	           , freq.VALUE_DESCRIPTION au_freq
			 from  rev.EP_STUDENT_IEP        iep   
			       JOIN rev.EP_STU_IEP_SERVICE ieps ON ieps.IEP_GU = iep.IEP_GU 
	               JOIN rev.EP_SPECIAL_ED_SERVICE isrv ON (isrv.SERVICE_GU = ieps.SERVICE_GU
															   )
                   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ieps.FREQUENCY_UNIT_DD
				   JOIN rev.EP_SPECIAL_ED_SERVICE ssrv on ssrv.SERVICE_GU = ieps.SERVICE_GU and ssrv.STATE_REPORTING_CODE = 'AU'
			 where iep.IEP_STATUS = 'CU' 
                   and iep.IEP_VALID = 'Y' 
		   ) au on au.student_gu = stu.STUDENT_GU and au.rn = 1
          -- SW - Mental Health-Counseling on IEP - Social Work Services
          LEFT JOIN
		   (
		     select 
			     row_number() over(partition by iep.student_gu order by iep.student_gu) rn
               , iep.STUDENT_GU
	           , ieps.NUM_MINUTES sw_min
	           , freq.VALUE_DESCRIPTION sw_freq
			 from  rev.EP_STUDENT_IEP        iep   
			       JOIN rev.EP_STU_IEP_SERVICE ieps ON ieps.IEP_GU = iep.IEP_GU 
	               JOIN rev.EP_SPECIAL_ED_SERVICE isrv ON (isrv.SERVICE_GU = ieps.SERVICE_GU
															   )
                   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ieps.FREQUENCY_UNIT_DD
                   JOIN rev.EP_SPECIAL_ED_SERVICE ssrv on ssrv.SERVICE_GU = ieps.SERVICE_GU and ssrv.STATE_REPORTING_CODE = 'SW'
			 where iep.IEP_STATUS = 'CU' 
                   and iep.IEP_VALID = 'Y' 
		   ) sw on sw.student_gu = stu.STUDENT_GU and sw.rn = 1
          -- SH - Nursing Services on IEP
		  -- Nursing Services will be included on the service schedule under “School Health” with code “SH”
		  LEFT JOIN
		   (
		     select 
			     row_number() over(partition by iep.student_gu order by iep.student_gu) rn
               , iep.STUDENT_GU
	           , ieps.NUM_MINUTES sh_min
	           , freq.VALUE_DESCRIPTION sh_freq
			 from  rev.EP_STUDENT_IEP        iep   
			       JOIN rev.EP_STU_IEP_SERVICE ieps ON ieps.IEP_GU = iep.IEP_GU 
	               JOIN rev.EP_SPECIAL_ED_SERVICE isrv ON (isrv.SERVICE_GU = ieps.SERVICE_GU
															   )
                   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ieps.FREQUENCY_UNIT_DD
				   JOIN rev.EP_SPECIAL_ED_SERVICE ssrv on ssrv.SERVICE_GU = ieps.SERVICE_GU and ssrv.STATE_REPORTING_CODE = 'SH'
			 where iep.IEP_STATUS = 'CU' 
                   and iep.IEP_VALID = 'Y' 
		   ) sh on sh.student_gu = stu.STUDENT_GU and sh.rn = 1
          -- OT - Occupational Therapy on IEP
          LEFT JOIN
		   (
		     select 
			     row_number() over(partition by iep.student_gu order by iep.student_gu) rn
               , iep.STUDENT_GU
	           , ieps.NUM_MINUTES ot_min
	           , freq.VALUE_DESCRIPTION ot_freq
			 from  rev.EP_STUDENT_IEP        iep   
			       JOIN rev.EP_STU_IEP_SERVICE ieps ON ieps.IEP_GU = iep.IEP_GU 
	               JOIN rev.EP_SPECIAL_ED_SERVICE isrv ON (isrv.SERVICE_GU = ieps.SERVICE_GU
															   )
                   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ieps.FREQUENCY_UNIT_DD
				   JOIN rev.EP_SPECIAL_ED_SERVICE ssrv on ssrv.SERVICE_GU = ieps.SERVICE_GU and ssrv.STATE_REPORTING_CODE = 'OT'
			 where iep.IEP_STATUS = 'CU' 
                   and iep.IEP_VALID = 'Y' 
		   ) ot on ot.student_gu = stu.STUDENT_GU and ot.rn = 1
           -- PT - Physical Therapy on IEP
          LEFT JOIN
		   (
		     select 
			     row_number() over(partition by iep.student_gu order by iep.student_gu) rn
               , iep.STUDENT_GU
	           , ieps.NUM_MINUTES pt_min
	           , freq.VALUE_DESCRIPTION pt_freq
			 from  rev.EP_STUDENT_IEP        iep   
			       JOIN rev.EP_STU_IEP_SERVICE ieps ON ieps.IEP_GU = iep.IEP_GU 
	               JOIN rev.EP_SPECIAL_ED_SERVICE isrv ON (isrv.SERVICE_GU = ieps.SERVICE_GU
															   )
                   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ieps.FREQUENCY_UNIT_DD
				   JOIN rev.EP_SPECIAL_ED_SERVICE ssrv on ssrv.SERVICE_GU = ieps.SERVICE_GU and ssrv.STATE_REPORTING_CODE = 'PT'
			 where iep.IEP_STATUS = 'CU' 
                   and iep.IEP_VALID = 'Y' 
		   ) pt on pt.student_gu = stu.STUDENT_GU and pt.rn = 1
           -- SS - SO - Speech Therapy and Speech Only on IEP
          LEFT JOIN
		   (
		     select 
			     row_number() over(partition by iep.student_gu order by iep.student_gu) rn
               , iep.STUDENT_GU
	           , ieps.NUM_MINUTES ss_min
	           , freq.VALUE_DESCRIPTION ss_freq
			 from  rev.EP_STUDENT_IEP        iep   
			       JOIN rev.EP_STU_IEP_SERVICE ieps ON ieps.IEP_GU = iep.IEP_GU 
	               JOIN rev.EP_SPECIAL_ED_SERVICE isrv ON (isrv.SERVICE_GU = ieps.SERVICE_GU
															   )
                   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ieps.FREQUENCY_UNIT_DD
				   JOIN rev.EP_SPECIAL_ED_SERVICE ssrv on ssrv.SERVICE_GU = ieps.SERVICE_GU and ssrv.STATE_REPORTING_CODE IN ( 'SS', 'SO')
			 where iep.IEP_STATUS = 'CU' 
                   and iep.IEP_VALID = 'Y' 
		   ) ss on ss.student_gu = stu.STUDENT_GU and ss.rn = 1
)
,
MEDICAID_STUDENTS
AS (
-- From SE
SELECT
   @vDistrict_Number                         AS [District CD]
 , sch.SCHOOL_CODE                           AS [School CD]
 , org.ORGANIZATION_NAME                     AS [School Name]
 , stu.SIS_NUMBER                            AS [Student ID]
 , ss.MEDI_CARE_NUMBER                       AS [Medicaid ID] ---??
 , per.LAST_NAME                             AS [Last Name]
 , per.FIRST_NAME                            AS [First Name]
 , per.MIDDLE_NAME                           AS [Middle Name]
 , CONVERT(VARCHAR(10), per.birth_date, 101) AS [DOB (MM/DD/YYYY)]
 , ''                                        AS [SSN]
 , per.GENDER                                AS [Gender CD]
 , hadr.ADDRESS                              AS [Student Address1]
 , hadr.ADDRESS2                             AS [Student Address2]
 , hadr.CITY                                 AS [City]
 , hadr.STATE                                AS [State]
 , hadr.ZIP_5                                AS [Zip Code]
 , ss.PRIMARY_DISABILITY_CODE                AS [Primary Diagnosis CD]
 , ss.SECONDARY_DISABILITY_CODE              AS [Secondary Diagnosis CD]
 , ss.TERTIARY_DISABILITY_CODE               AS [Tertiary Diagnosis CD]
 , ss.QUATERNARY_DISABILITY_CODE             AS [Fourth Diagnosis CD]
 , CONVERT(VARCHAR(10),ss.IEP_DATE,101)      AS [IEP Start Date]
 , CONVERT(VARCHAR(10),ss.NEXT_IEP_DATE,101) AS [IEP End Date]
 , '' AS [PCP Prescription Start Date]
 , '' AS [PCP Prescription End Date]
 , '' AS [PCP Prescription Exempt(E)/In Process(P)]
 , '' AS [PCP Last Name]
 , '' AS [PCP First Name]
 , CASE WHEN ss.au_min is not null THEN 'Y' ELSE 'N' END AS [Audiology on IEP?]
 , ''                                                    AS [Case Management on IEP?]
 , CASE WHEN ss.sw_min is not null THEN 'Y' ELSE 'N' END AS [Mental Health-Counseling on IEP?]
 , CASE WHEN ss.sw_min is not null THEN 'Y' ELSE 'N' END AS [Nursing Services on IEP?]
 , ''                                                    AS [Nutritional Services on IEP?]
 , CASE WHEN ss.ot_min is not null THEN 'Y' ELSE 'N' END AS [Occupational Therapy on IEP?]
 , CASE WHEN ss.pt_min is not null THEN 'Y' ELSE 'N' END AS [Physical Therapy on IEP?]
 , CASE WHEN ss.ss_min is not null THEN 'Y' ELSE 'N' END AS [Speech Therapy on IEP?]
 , ss.SplTrans                                           AS [Special Transportation on IEP?]
 , ss.PARENT_CONSENT                                     AS [Parent Consent]
 , COALESCE(CAST(CAST((ss.sw_min/60) as numeric(6,2)) as varchar(10)),'')  AS [MHC Hours]
 , COALESCE(CAST(CAST((ss.ot_min/60) as numeric(6,2)) as varchar(10)),'')  AS [OT Hours]
 , COALESCE(CAST(CAST((ss.pt_min/60) as numeric(6,2)) as varchar(10)),'')  AS [PT Hours]
 , COALESCE(CAST(CAST((ss.ss_min/60) as numeric(6,2)) as varchar(10)),'')  AS [SP Hours]
 , ss.sw_freq                                            AS [MHC Frequency]
 , ss.ot_freq                                            AS [OT Frequency]
 , ss.pt_freq                                            AS [PT Frequency]
 , ss.ss_freq                                            AS [SP Frequency]
 , ''                                                    AS [Inactive?]
 , ''                                                    AS [Override Ind]
 , STU.STUDENT_GU
 
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       --and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.REV_ADDRESS      hadr ON hadr.ADDRESS_GU = per.HOME_ADDRESS_GU
-- SpedStudents
JOIN SpedStudents              ss   ON ss.STUDENT_GU = stu.STUDENT_GU

-- only if have a Y in any one of the following
where
 (
     ss.au_min is not null
  or ss.sw_min is not null
  or ss.sw_min is not null
  or ss.ot_min is not null
  or ss.pt_min is not null
  or ss.ss_min is not null
)
-- From SIS
UNION
SELECT
   @vDistrict_Number                         AS [District CD]
 , sch.SCHOOL_CODE                           AS [School CD]
 , org.ORGANIZATION_NAME                     AS [School Name]
 , stu.SIS_NUMBER AS [Student ID]
 , ''                                        AS [Medicaid ID] ---??
 , per.LAST_NAME                             AS [Last Name]
 , per.FIRST_NAME                            AS [First Name]
 , per.MIDDLE_NAME                           AS [Middle Name]
 , CONVERT(VARCHAR(10), per.birth_date, 101) AS [DOB (MM/DD/YYYY)]
 , ''                                        AS [SSN]
 , per.GENDER                                AS [Gender CD]
 , hadr.ADDRESS                              AS [Student Address1]
 , hadr.ADDRESS2                             AS [Student Address2]
 , hadr.CITY                                 AS [City]
 , hadr.STATE                                AS [State]
 , hadr.ZIP_5                                AS [Zip Code]
 , srpt.DISABILITY_PRIMARY                   AS [Primary Diagnosis CD]
 , srpt.DISABILITY_SECONDARY                 AS [Secondary Diagnosis CD]
 , srpt.DISABILITY_TERTIARY                  AS [Tertiary Diagnosis CD]
 , srpt.DISABILITY_QUATERNARY                AS [Fourth Diagnosis CD]
 , CONVERT(VARCHAR(10), srpt.LAST_IEP_DATE,101)  AS [IEP Start Date]
 , CONVERT(VARCHAR(10), dateadd(day,-1,(dateadd(year,1,srpt.LAST_IEP_DATE))),101) AS [IEP End Date]
 , '' AS [PCP Prescription Start Date]
 , '' AS [PCP Prescription End Date]
 , '' AS [PCP Prescription Exempt(E)/In Process(P)]
 , '' AS [PCP Last Name]
 , '' AS [PCP First Name]
 , CASE WHEN au.SERVICE_CODE is not null THEN 'Y' ELSE 'N' END AS [Audiology on IEP?]
 , '' AS [Case Management on IEP?]
 , CASE WHEN ps.SERVICE_CODE is not null THEN 'Y' ELSE 'N' END AS [Mental Health-Counseling on IEP?]
 , CASE WHEN sh.SERVICE_CODE is not null THEN 'Y' ELSE 'N' END AS [Nursing Services on IEP?]
 , '' AS [Nutritional Services on IEP?]
 , CASE WHEN ot.SERVICE_CODE is not null THEN 'Y' ELSE 'N' END AS [Occupational Therapy on IEP?]
 , CASE WHEN pt.SERVICE_CODE is not null THEN 'Y' ELSE 'N' END AS [Physical Therapy on IEP?]
 , CASE WHEN ss.SERVICE_CODE is not null THEN 'Y' ELSE 'N' END AS [Speech Therapy on IEP?]
 , COALESCE(transp.trans,'')                                   AS [Special Transportation on IEP?]
 , '' AS [Parent Consent]
 , COALESCE(CAST(CAST(ps.SERVICE_FREQ/60 as numeric (6,2)) as varchar(10)),'') AS [MHC Hours]
 , COALESCE(CAST(CAST(ot.SERVICE_FREQ/60 as numeric (6,2)) as varchar(10)),'') AS [OT Hours]
 , COALESCE(CAST(CAST(pt.SERVICE_FREQ/60 as numeric (6,2)) as varchar(10)),'') AS [PT Hours]
 , COALESCE(CAST(CAST(ss.SERVICE_FREQ/60 as numeric (6,2)) as varchar(10)),'') AS [SP Hours]
 , COALESCE(ps.VALUE_DESCRIPTION,'') AS [MHC Frequency]
 , COALESCE(ot.VALUE_DESCRIPTION,'') AS [OT Frequency]
 , COALESCE(pt.VALUE_DESCRIPTION,'') AS [PT Frequency]
 , COALESCE(ss.VALUE_DESCRIPTION,'') AS [SP Frequency]
 , '' AS [Inactive?]
 , '' AS [Override Ind]
 , STU.STUDENT_GU

FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       --and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.REV_ADDRESS      hadr ON hadr.ADDRESS_GU = per.HOME_ADDRESS_GU
-- Join on SPED snapshot for 40th day
JOIN rev.EPC_NM_STU_SPED_RPT srpt  ON srpt.STUDENT_GU = stu.STUDENT_GU
                                           AND srpt.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
										   AND srpt.SNAPSHOT_TYPE = 1 -- Select only the 40th day for now
-- AU - Audiology on IEP
LEFT JOIN 
(
select 
	     row_number() over(partition by rp.student_gu order by rp.snapshot_type) rn
       , rp.STUDENT_GU
       , ssrv.STU_SPED_RPT_GU
	   , ssrv.SERVICE_CODE
	   , ssrv.SERVICE_FREQ
	   , ssrv.SERVICE_CYCLE
	   , freq.VALUE_DESCRIPTION
from 
rev.EPC_NM_STU_SPED_RPT_SRV ssrv 
JOIN rev.EPC_NM_STU_SPED_RPT rp on rp.STU_SPED_RPT_GU = ssrv.STU_SPED_RPT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ssrv.SERVICE_CYCLE
where ssrv.SERVICE_CODE = 'AU'
) au on au.STUDENT_GU = stu.STUDENT_GU and au.rn = 1
-- ?? Case Management on IEP
-- PS - Mental Health-Counseling on IEP – This should be SW for Social Work
LEFT JOIN 
(
select 
	     row_number() over(partition by rp.student_gu order by rp.snapshot_type) rn
       , rp.STUDENT_GU
       , ssrv.STU_SPED_RPT_GU
	   , ssrv.SERVICE_CODE
	   , ssrv.SERVICE_FREQ
	   , ssrv.SERVICE_CYCLE
	   , freq.VALUE_DESCRIPTION
from 
rev.EPC_NM_STU_SPED_RPT_SRV ssrv 
JOIN rev.EPC_NM_STU_SPED_RPT rp on rp.STU_SPED_RPT_GU = ssrv.STU_SPED_RPT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ssrv.SERVICE_CYCLE
where ssrv.SERVICE_CODE = 'SW'
) ps on ps.STUDENT_GU = stu.STUDENT_GU and ps.rn = 1
-- SH Nursing Services on IEP
LEFT JOIN 
(
select 
	     row_number() over(partition by rp.student_gu order by rp.snapshot_type) rn
       , rp.STUDENT_GU
       , ssrv.STU_SPED_RPT_GU
	   , ssrv.SERVICE_CODE
	   , ssrv.SERVICE_FREQ
	   , ssrv.SERVICE_CYCLE
	   , freq.VALUE_DESCRIPTION
from 
rev.EPC_NM_STU_SPED_RPT_SRV ssrv 
JOIN rev.EPC_NM_STU_SPED_RPT rp on rp.STU_SPED_RPT_GU = ssrv.STU_SPED_RPT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ssrv.SERVICE_CYCLE
where ssrv.SERVICE_CODE = 'SH'
) sh on sh.STUDENT_GU = stu.STUDENT_GU and sh.rn = 1
-- ?? Nutritional Services on IEP
-- OT - Occupational Therapy on IEP
LEFT JOIN 
(
select 
	     row_number() over(partition by rp.student_gu order by rp.snapshot_type) rn
       , rp.STUDENT_GU
       , ssrv.STU_SPED_RPT_GU
	   , ssrv.SERVICE_CODE
	   , ssrv.SERVICE_FREQ
	   , ssrv.SERVICE_CYCLE
	   , freq.VALUE_DESCRIPTION
from 
rev.EPC_NM_STU_SPED_RPT_SRV ssrv 
JOIN rev.EPC_NM_STU_SPED_RPT rp on rp.STU_SPED_RPT_GU = ssrv.STU_SPED_RPT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ssrv.SERVICE_CYCLE
where ssrv.SERVICE_CODE = 'OT'
) ot on ot.STUDENT_GU = stu.STUDENT_GU and ot.rn = 1
-- PT - Physical Therapy on IEP
LEFT JOIN 
(
select 
	     row_number() over(partition by rp.student_gu order by rp.snapshot_type) rn
       , rp.STUDENT_GU
       , ssrv.STU_SPED_RPT_GU
	   , ssrv.SERVICE_CODE
	   , ssrv.SERVICE_FREQ
	   , ssrv.SERVICE_CYCLE
	   , freq.VALUE_DESCRIPTION
from 
rev.EPC_NM_STU_SPED_RPT_SRV ssrv 
JOIN rev.EPC_NM_STU_SPED_RPT rp on rp.STU_SPED_RPT_GU = ssrv.STU_SPED_RPT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ssrv.SERVICE_CYCLE
where ssrv.SERVICE_CODE = 'PT'
) pt on pt.STUDENT_GU = stu.STUDENT_GU and pt.rn = 1
-- SS Speech Therapy on IEP
LEFT JOIN 
(
select 
	     row_number() over(partition by rp.student_gu order by rp.snapshot_type) rn
       , rp.STUDENT_GU
       , ssrv.STU_SPED_RPT_GU
	   , ssrv.SERVICE_CODE
	   , ssrv.SERVICE_FREQ
	   , ssrv.SERVICE_CYCLE
	   , freq.VALUE_DESCRIPTION
from 
rev.EPC_NM_STU_SPED_RPT_SRV ssrv 
JOIN rev.EPC_NM_STU_SPED_RPT rp on rp.STU_SPED_RPT_GU = ssrv.STU_SPED_RPT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.SpecialEd.IEP', 'SERVICE_FREQUENCY') freq on freq.VALUE_CODE = ssrv.SERVICE_CYCLE
where ssrv.SERVICE_CODE IN ('SS', 'SO')
) SS on ss.STUDENT_GU = stu.STUDENT_GU and ss.rn = 1
-- Special Transportation on IEP
-- This will need to be determined by the drop downs the Services Tab.  Both will need to be YES to be included for Medicaid billing.  
LEFT JOIN 
(
select
  row_number() over(partition by iep.student_gu order by iep.student_gu) rn
  , iep.STUDENT_GU
  , CASE WHEN (aiep.SERV_TRANSPORT_YN = 'Y' and aiep.SERV_TRANSPORT_ADULT_YN = 'Y') THEN 'Y' ELSE 'N' END trans
from rev.ep_student_iep iep
join rev.EP_AZ_STUDENT_IEP aiep on aiep.IEP_GU = iep.IEP_GU
where iep.IEP_STATUS = 'CU' and iep.IEP_VALID = 'Y'

) transp on transp.student_gu = stu.STUDENT_GU and transp.rn = 1

WHERE stu.STUDENT_GU NOT IN (select student_gu from rev.EP_STUDENT_IEP iep  
                             where iep.IEP_STATUS = 'CU' 
					               and iep.IEP_VALID = 'Y')
      and 
	  (
	       au.SERVICE_CODE is not null
        or ps.SERVICE_CODE is not null 
        or sh.SERVICE_CODE is not null
        or ot.SERVICE_CODE is not null
        or pt.SERVICE_CODE is not null
        or ss.SERVICE_CODE is not null
	  )
)

SELECT
	[MEDICAID_STUDENTS].*
FROM
	APS.PrimaryEnrollmentsAsOf('10/14/2015') AS [ENROLLMENTS]
	
	INNER JOIN
	MEDICAID_STUDENTS AS [MEDICAID_STUDENTS]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [MEDICAID_STUDENTS].[STUDENT_GU]