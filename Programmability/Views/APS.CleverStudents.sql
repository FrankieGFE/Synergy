-- =================================================================
-- Author     :	mlm - EduPoint                                    --
-- Create date: 12/17/2015                                        --
-- Description:	Clever – Students Data Extract - students.csv     --
-- Using a common table expression for Parent phone numbers       --
-- and student race codes from ethnicity table                    --
-- Revision   :                                                   --
-- =================================================================
 

 ALTER VIEW APS.CleverStudents AS 

 with Parents AS
(
SELECT  stu.STUDENT_GU
      , ROW_NUMBER() OVER (PARTITION BY stu.student_gu order by stupar.orderby) rn
      , stupar.ORDERBY CALL_ORDER
	  , par.FIRST_NAME + ' ' + par.LAST_NAME ParentName
	  , rel.VALUE_DESCRIPTION Relation
      , COALESCE(ParPriPhone.Y, phone.H,  phone.C, phone.W, phone.O) Phone
      , par.EMAIL
FROM  rev.EPC_STU_PARENT             stupar
      JOIN rev.REV_PERSON            par ON par.PERSON_GU  = stupar.PARENT_GU 
      JOIN rev.EPC_STU               stu ON stu.STUDENT_GU = stupar.STUDENT_GU
      JOIN rev.EPC_STU_SCH_YR        ssy ON ssy.STUDENT_GU = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
      JOIN rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                            and oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
      LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                 PIVOT (min(phone) FOR phone_type in ([H], [C], [W], [O])) phone ON phone.PERSON_GU = par.PERSON_GU
      LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PRIMARY_PHONE FROM rev.REV_PERSON_PHONE phn) ParPhn
                 PIVOT (min(phone) FOR PRIMARY_PHONE in ([Y])) ParPriPhone ON ParPriPhone.PERSON_GU = par.PERSON_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel ON rel.VALUE_CODE = stupar.RELATION_TYPE
WHERE stupar.CONTACT_ALLOWED = 'Y'
), HispanicRace AS
(
select
       ROW_NUMBER() over(partition by seth.person_gu order by seth.person_gu)  rn
     , count(seth.ethnic_code)  over(partition by seth.person_gu) rc
     , seth.PERSON_GU
     , seth.ETHNIC_CODE
from rev.REV_PERSON_SECONDRY_ETH_LST seth
     join rev.rev_person p on p.PERSON_GU = seth.PERSON_GU and p.HISPANIC_INDICATOR = 'Y'
)
SELECT
        sch.SCHOOL_CODE                           AS [School_id]
      , stu.SIS_NUMBER                            AS [Student_id]
      , stu.SIS_NUMBER                            AS [Student_number]
      , stu.STATE_STUDENT_NUMBER                  AS [State_id]
      , per.LAST_NAME                             AS [Last_name]
      , per.MIDDLE_NAME                           AS [Middle_name]
      , per.FIRST_NAME                            AS [First_name]
           , CASE
	       WHEN grd.VALUE_DESCRIPTION in ('P3', 'P4', '5C', '8C') THEN 'Prekindergarten'
	       WHEN grd.VALUE_DESCRIPTION = 'K'                       THEN 'Kindergarten'
	       WHEN grd.VALUE_DESCRIPTION in ('PG', 'Grad', '12+')    THEN 'Postgraduate'
		   WHEN grd.VALUE_DESCRIPTION = '01'                      THEN '1'
		   WHEN grd.VALUE_DESCRIPTION = '02'                      THEN '2'
		   WHEN grd.VALUE_DESCRIPTION = '03'                      THEN '3'
		   WHEN grd.VALUE_DESCRIPTION = '04'                      THEN '4'
		   WHEN grd.VALUE_DESCRIPTION = '05'                      THEN '5'
		   WHEN grd.VALUE_DESCRIPTION = '06'                      THEN '6'
		   WHEN grd.VALUE_DESCRIPTION = '07'                      THEN '7'
		   WHEN grd.VALUE_DESCRIPTION = '08'                      THEN '8'
		   WHEN grd.VALUE_DESCRIPTION = '09'                      THEN '9'
		   ELSE grd.VALUE_DESCRIPTION
		  END                                     AS [Grade] 
	, per.GENDER                                AS [Gender]
      , CONVERT(VARCHAR(20), per.BIRTH_DATE, 101) AS [Dob]

      , CASE
	        WHEN per.RESOLVED_ETHNICITY_RACE = '__HIS' THEN
			     CASE
				     WHEN his.rc > 1                      THEN 'M'
                     WHEN his.ETHNIC_CODE = '02'          THEN 'A'
                     WHEN his.ETHNIC_CODE IN ('01', '06') THEN 'I'
                     WHEN his.ETHNIC_CODE = '03'          THEN 'B'
                     WHEN his.ETHNIC_CODE = '05'          THEN 'W'
                     ELSE 'W'
				 END
			WHEN per.RESOLVED_ETHNICITY_RACE = '__TWO'       THEN 'M'
			WHEN per.RESOLVED_ETHNICITY_RACE = '02'          THEN 'A'
			WHEN per.RESOLVED_ETHNICITY_RACE IN ('01', '06') THEN 'I'
			WHEN per.RESOLVED_ETHNICITY_RACE = '03'          THEN 'B'
			WHEN per.RESOLVED_ETHNICITY_RACE = '05'          THEN 'W'
			ELSE 'W'
	    END AS [Race]
      , per.HISPANIC_INDICATOR                    AS [Hispanic_Latino]
      , CASE
	      WHEN EXISTS (SELECT ell.STUDENT_GU FROM rev.EPC_STU_PGM_ELL  ell 
					   WHERE  ell.STUDENT_GU = stu.STUDENT_GU 
					          and (ell.EXIT_DATE is null or ell.EXIT_DATE > GETDATE())
						      and ell.PROGRAM_CODE is not null	 
			           )    
		  THEN 'Y' 
		  ELSE 'N'
	    END                                       AS [Ell_Status]
      , CASE
	      WHEN EXISTS (SELECT top 1 stu.student_gu 
		               FROM rev.EPC_STU_PGM_FRM_HIS frm 
		               WHERE frm.STUDENT_GU = stu.STUDENT_GU 
					   and (frm.EXIT_DATE is null or frm.EXIT_DATE > GETDATE())
			    )   
          THEN 'Y' 
		  ELSE 'N'
	    END                                      AS [Frl_Status]
      , CASE
	      WHEN EXISTS (SELECT top 1 stu.student_gu 
		               FROM rev.EP_STUDENT_IEP iep
		               WHERE iep.STUDENT_GU = stu.STUDENT_GU
					         and iep.IEP_STATUS = 'CU' 
                             and iep.IEP_VALID = 'Y'
			    )
          THEN 'Y' 
		  ELSE 'N'
	    END                                      AS [Iep_Status]


	,adr.STREET_NAME							 AS [Student_street]
	,adr.CITY									 AS [Student_city]
	,adr.[STATE]								 AS [Student_state]
      , adr.ZIP_5                                AS [Student_Zip]
	, per.EMAIL                                  AS [Student_email]
	, par.Relation                               AS [Contact_relationship]
	, 'family'									 AS [Contact_type]
      , par.ParentName                           AS [Contact_name]
     
      , par.Phone                                AS [Contact_Phone]
     , par.EMAIL                                 AS [Contact_email]
      , ''                                       AS [Username]
      , ''                                       AS [password]
FROM  rev.EPC_STU                    stu
      JOIN rev.EPC_STU_SCH_YR        ssy ON ssy.STUDENT_GU           = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
											AND EXCLUDE_ADA_ADM IS NULL
      JOIN rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                            and oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
	  JOIN rev.EPC_SCH               sch ON sch.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	  JOIN rev.REV_PERSON            per ON per.PERSON_GU            = stu.STUDENT_GU
	  LEFT JOIN rev.REV_ADDRESS      adr ON adr.ADDRESS_GU           = COALESCE(per.MAIL_ADDRESS_GU, per.HOME_ADDRESS_GU)
	  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
	  LEFT JOIN Parents              par ON par.STUDENT_GU           = stu.STUDENT_GU and par.rn = 1
	  LEFT JOIN HispanicRace         his ON his.PERSON_GU            = stu.STUDENT_GU and his.rn = 1
where cast(ssy.grade as int) <= 230