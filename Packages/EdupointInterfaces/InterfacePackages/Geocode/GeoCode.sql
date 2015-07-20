--<APS - Capital Master Planning (CMP) Geocode File>
--Only active students in current school year at the time of each pull 
--(no future dated Enter Date enrollments)
--Column headers are from the sample output file not SpecDoc
--
--Concurrent Enrollment
; with ConcEnr AS
(
SELECT
ROW_NUMBER() over (partition by stu.student_gu order by stu.student_gu) rn
, stu.STUDENT_GU
, sch.SCHOOL_CODE
, STUFF((SELECT [*]= ', ' + sch1.SCHOOL_CODE 
                    FROM rev.EPC_STU               stu1
                    JOIN rev.EPC_STU_SCH_YR        ssy1  ON ssy1.STUDENT_GU = stu1.STUDENT_GU
                                                           and ssy1.STATUS is NULL
									                       and ssy1.EXCLUDE_ADA_ADM is not null --only concurrent enrollment
                    JOIN rev.REV_ORGANIZATION_YEAR oyr1  ON oyr1.ORGANIZATION_YEAR_GU = ssy1.ORGANIZATION_YEAR_GU
                                                           and oyr1.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
                    JOIN rev.EPC_SCH               sch1  ON sch1.ORGANIZATION_GU = oyr1.ORGANIZATION_GU 
					where stu1.STUDENT_GU = stu.STUDENT_GU
	                FOR XML PATH('')
	     ),1,1,'')
			AS ConcSchools
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
									   and ssy.EXCLUDE_ADA_ADM is not null --only concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
)
--Ethnicity code
, EthCodes AS 
(
select 
  pvt.PERSON_GU
, ROW_NUMBER() OVER(PARTITION by pvt.PERSON_GU order by pvt.person_gu) rno
, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[1]) as Race1
, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[2]) as Race2
, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[3]) as Race3
, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[4]) as Race4
, (select e.ALT_CODE_3 from  rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') e where e.VALUE_CODE = pvt.[5]) as Race5
from 
  (select
       ROW_NUMBER() OVER(PARTITION by seth.PERSON_GU order by seth.Ethnic_code) rn
    ,  seth.PERSON_GU
    , seth.ETHNIC_CODE
   from rev.REV_PERSON_SECONDRY_ETH_LST seth
  ) pt
   pivot (min(ETHNIC_CODE) FOR rn in ([1],[2],[3],[4],[5])) pvt
)
--ParentNames
, ParentNames AS
(
SELECT
   PNm.STUDENT_GU
 , ROW_NUMBER() OVER(PARTITION BY PNm.STUDENT_GU order by PNm.STUDENT_GU) rno
 , Parents = STUFF(  COALESCE(', ' + Pnm.[1], '')
                   + COALESCE(', ' + Pnm.[2], '') 
                   + COALESCE(', ' + Pnm.[3], '') 
                   + COALESCE(', ' + Pnm.[4], '') 
                   , 1, 1,'')
FROM
  (
    SELECT 
        stu.STUDENT_GU
      , COALESCE(spar.ORDERBY, (ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU))) rn
      , pper.FIRST_NAME + ' ' +  pper.LAST_NAME [pname]
    FROM rev.EPC_STU stu
    JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.CONTACT_ALLOWED = 'Y'
    JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
  ) 
  pn PIVOT (min(pname) for rn in ([1], [2], [3], [4])) PNm
)
--StudentSecPhone
, StuSecPhone AS
(
SELECT
  ROW_NUMBER() OVER (PARTITION BY phn.person_gu order by phn.phone_type) rn
, stu.STUDENT_GU
, phn.PHONE


FROM rev.REV_PERSON_PHONE phn
JOIN rev.EPC_STU               stu   ON stu.STUDENT_GU           = phn.PERSON_GU
JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU          = stu.STUDENT_GU 
JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                        AND oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_PERSON            per   ON per.PERSON_GU            = phn.PERSON_GU
WHERE phn.PRIMARY_PHONE = 'N'
), FRMHistory AS
(
SELECT
      ROW_NUMBER() OVER (PARTITION BY stu.student_gu order by f.ENTER_DATE,stu.STUDENT_gu) rn
    , stu.STUDENT_GU
	, f.FRM_CODE
    FROM rev.EPC_STU stu
	LEFT JOIN rev.EPC_STU_PGM_FRM_HIS f on f.STUDENT_GU = stu.STUDENT_GU
	AND f.ENTER_DATE is not null and (f.EXIT_DATE is null or f.EXIT_DATE > getdate())
)
SELECT
   sch.SCHOOL_CODE                           AS [SOR School Number]
 , stu.SIS_NUMBER                            AS [Student ID Number]
 , stu.STATE_STUDENT_NUMBER                  AS [State ID Number]
 , per.LAST_NAME                             AS [Student Last Name]
 , per.FIRST_NAME                            AS [First Name]
 , per.MIDDLE_NAME                           AS [Student Middle Name]
 , grd.VALUE_DESCRIPTION                     AS [Student Current SOR Enrollment Grade Level]
 , '(' + left(per.PRIMARY_PHONE,3) + ')' 
       + substring(per.PRIMARY_PHONE, 4,3)+ '-'
	   + RIGHT(per.PRIMARY_PHONE,4)          AS [Student Home Phone Number]
 ,  '(' + left(sph.PHONE,3) + ')' 
       + substring(sph.PHONE, 4,3)+ '-'
	   + RIGHT(sph.PHONE,4)                  AS [Student Secondary Phone Number]
 , REPLACE(hadr.ADDRESS, COALESCE(hadr.STREET_EXTRA,''),'')                             AS [Student Address]
 , hadr.CITY                                 AS [Student Home Address City]
 , hadr.STATE                                AS [Student Home Address State]
 , hadr.STREET_EXTRA                         AS [Apartment Number]
 , hadr.ZIP_5 + COALESCE(hadr.ZIP_4, '0000') AS [Student Home Zip Code]
 , per.GENDER                                AS [Student Gender]
 , rcd.Race1                                 AS [Race]
 , rcd.Race2                                 AS [Race2]
 , rcd.Race3                                 AS [Race3]
 , rcd.Race4                                 AS [Race4]
 , rcd.Race5                                 AS [Race5]
 , per.HISPANIC_INDICATOR                    AS [Student Hispanic Indicator]
 , CONVERT(VARCHAR(8), per.BIRTH_DATE,112)   AS [Student Birthdate]
 , stu.HOME_LANGUAGE + ' - ' + lang.VALUE_DESCRIPTION  AS [Home Language]
 , frm.FRM_CODE                              AS [FRM Code]
 , CASE WHEN ell.PROGRAM_CODE is not NULL THEN 'ELL' END
                                             AS [ELL Status] --TBD.  
 , sped.PRIMARY_DISABILITY_CODE              AS [PRIM_DISAB] --TBD
 , rpt.ROLE_NAME_LARGE	   			     AS [Program Involvment]
 , rpt.LEVEL_INTEGRATION			 	     AS [Level Of Service]
 , stu.GRID_CODE                             AS [Grid Code]
 , COALESCE(madr.ADDRESS, hadr.ADDRESS)      AS [Student Mailing Address]
 , COALESCE(madr.CITY, hadr.city)            AS [Student Mailing Address City]
 , COALESCE(madr.STATE, hadr.STATE)          AS [Student Mailing Address State]
 , COALESCE(madr.ZIP_5, hadr.zip_5)          AS [Student Mailing Address Zip Code]
 , pnm.Parents                               AS [Parent Name(s)]
 , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 101) AS [SOR Enrollment Enter Date]
 , cnr.ConcSchools                           AS [Concurrent Enrollment Location Numbers]
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
									   and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.REV_ADDRESS      hadr ON hadr.ADDRESS_GU = per.HOME_ADDRESS_GU
LEFT JOIN rev.REV_ADDRESS      madr ON madr.ADDRESS_GU = per.MAIL_ADDRESS_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.AddressInfo','STREET_TYPE') hatyp on hatyp.VALUE_CODE = hadr.STREET_TYPE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','LANGUAGE') lang ON lang.VALUE_CODE = stu.HOME_LANGUAGE
--FRM
LEFT JOIN FRMHistory           frm  ON frm.STUDENT_GU = stu.STUDENT_GU and frm.rn = 1
--Disability
LEFT JOIN 
(
SELECT
               *
    FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
    WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                            EXIT_DATE IS NULL 
                            OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                            )
) sped ON sped.STUDENT_GU = stu.STUDENT_GU
--ELL
LEFT JOIN rev.EPC_STU_PGM_ELL  ell  ON ell.STUDENT_GU = stu.STUDENT_GU
--Concurrent Enrollment
LEFT JOIN ConcEnr              cnr  ON cnr.STUDENT_GU = stu.STUDENT_GU and cnr.rn = 1
--Ethnicity code
LEFT JOIN EthCodes             rcd  ON rcd.PERSON_GU = stu.STUDENT_GU and rcd.rno = 1
--ParentNames
LEFT JOIN ParentNames          pnm  ON pnm.STUDENT_GU = stu.STUDENT_GU and pnm.rno = 1
--StuSecPhone
LEFT JOIN StuSecPhone          sph  ON sph.STUDENT_GU = stu.STUDENT_GU and sph.rn = 1
LEFT JOIN 
    (
	   SELECT 
		  rpt.[STUDENT_GU]
		  ,rpt.[LEVEL_INTEGRATION]
		  ,rol.ROLE_NAME_LARGE
		  ,ROW_NUMBER() OVER (PARTITION BY rpt.[STUDENT_GU] ORDER BY rpt.[CHANGE_DATE_TIME_STAMP] DESC) AS [rn] 
	   FROM 
		  [rev].[EPC_NM_STU_SPED_RPT] rpt
    
		  LEFT JOIN
		  [rev].[EP_STAFF_ROLE_SPED] sprl
		  ON
		  rpt.CASE_MANAGER_GU=sprl.STAFF_GU
    
		  LEFT JOIN
		  [rev].[REV_ROLE] rol
		  ON
		  sprl.ROLE_GU=rol.ROLE_GU

	   WHERE 
		  [SCHOOL_YEAR]=2014

    ) rpt
    ON
    stu.STUDENT_GU=rpt.STUDENT_GU
    AND rpt.rn=1

WHERE ssy.ENTER_DATE <= GETDATE()