

/**
Thu 10/27/2016 2:40 PM
Please pull the data being requested in the attached E-file template for only the MS’s below in Eleanor’s email
and use the associated NAEP ID in her grid below to populate column B ‘NAEP ID’.  The other attached file EFile
Codebook has the expected values needed based on the Synergy data, please see me if you have any questions.
There are a handful of scripts in the repository with NAEP in the script name you can check out to see if they
can be used as a basis for this pull.  Thanks - Andy

-- =================================================================
**/
 

 SELECT
	[NAEP ID]
	,[School Name]
	,[State Unique Student ID]
	,[Student First Name]
	,CASE WHEN [Student Middle Name] IS NULL THEN '' ELSE [Student Middle Name] END AS [Student Middle Name]
	,[Student Last Name]
	--,Grade
	--,'' AS [Homeroom or Other Locator]
	,[Month of Birth]
	,[Year of Birth]
	--,Sex
	--,[Student with a Disability]
	--,[Hispanic of any race]
	--,White
	--,[Black or African American]
	--,Asian
	--,[American Indian or AK Native]
	--,[Native Hawaiian or Pac Islander]
	--,[English Language Learner]
	--,[School Lunch]
	--,'' AS [On-Break Indicator]
	--,[Student ZIP code]

FROM
(
SELECT
		  
		  stu.STATE_STUDENT_NUMBER                    AS [State Unique Student ID]
		  , per.LAST_NAME                             AS [Student Last Name]
		  , per.FIRST_NAME                            AS [Student First Name]
		  , per.MIDDLE_NAME							  AS [Student Middle Name]
		  , YEAR (per.BIRTH_DATE)                     AS [Year of Birth]
		  , MONTH (per.BIRTH_DATE)                    AS [Month of Birth]
		  , org.ORGANIZATION_NAME					  AS [School Name]
		  , CASE WHEN sch.SCHOOL_CODE = '407' THEN '3520091'
		         WHEN sch.SCHOOL_CODE = '450' THEN '3520131'
				 WHEN sch.SCHOOL_CODE = '492' THEN '3520141'
				 WHEN sch.SCHOOL_CODE = '460' THEN '3520081'
				 WHEN sch.SCHOOL_CODE = '465' THEN '3520071'
			end as [NAEP ID]
		         
		  --ELSE NAEP.[NAEP ID] END					  AS [NAEP ID]
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
  	  , per.GENDER                                AS [Sex]
      , CASE WHEN per.HISPANIC_INDICATOR = 'Y' THEN 'Y' ELSE 'N'
							                  END AS [Hispanic of any race]
      , CASE WHEN BS.RACE_1 = 'WHITE' THEN 'Y' 
	         WHEN BS.RACE_2 = 'WHITE' THEN 'Y'
			 WHEN BS.RACE_3 = 'WHITE' THEN 'Y'
			 WHEN BS.RACE_4 = 'WHITE' THEN 'Y'
			 WHEN BS.RACE_5 = 'WHITE' THEN 'Y'
	         ELSE 'N' 
	  END AS [White]
      , CASE WHEN BS.RACE_1 = 'AFRICAN-AMERICAN' THEN 'Y' 
		     WHEN BS.RACE_2 = 'AFRICAN-AMERICAN' THEN 'Y'
			 WHEN BS.RACE_3 = 'AFRICAN-AMERICAN' THEN 'Y'
			 WHEN BS.RACE_4 = 'AFRICAN-AMERICAN' THEN 'Y'
			 WHEN BS.RACE_5 = 'AFRICAN-AMERICAN' THEN 'Y'
			 ELSE 'N' 
	  END AS [Black or African American]
      , CASE WHEN BS.RACE_1 = 'ASIAN' THEN 'Y' 
			 WHEN BS.RACE_2 = 'ASIAN' THEN 'Y' 
			 WHEN BS.RACE_3 = 'ASIAN' THEN 'Y' 
			 WHEN BS.RACE_4 = 'ASIAN' THEN 'Y' 
			 WHEN BS.RACE_5 = 'ASIAN' THEN 'Y' 
	         ELSE 'N' 
	  END AS [Asian]
      , CASE WHEN BS.RACE_1 = 'NATIVE AMERICAN' THEN 'Y' 
			 WHEN BS.RACE_2 = 'NATIVE AMERICAN' THEN 'Y' 
			 WHEN BS.RACE_3 = 'NATIVE AMERICAN' THEN 'Y' 
			 WHEN BS.RACE_4 = 'NATIVE AMERICAN' THEN 'Y' 
			 WHEN BS.RACE_5 = 'NATIVE AMERICAN' THEN 'Y' 
		     ELSE 'N' 
	  END AS [American Indian or AK Native]
      , CASE WHEN BS.RACE_1 = 'PACIFIC ISLANDER' THEN 'Y' 
	         WHEN BS.RACE_2 = 'PACIFIC ISLANDER' THEN 'Y' 
			 WHEN BS.RACE_3 = 'PACIFIC ISLANDER' THEN 'Y' 
			 WHEN BS.RACE_4 = 'PACIFIC ISLANDER' THEN 'Y' 
			 WHEN BS.RACE_5 = 'PACIFIC ISLANDER' THEN 'Y' 
			 ELSE 'N' 
	  END AS [Native Hawaiian or Pac Islander]
	  , '' AS [RACE 2 OR MORE]
	  , CASE WHEN BS.LUNCH_STATUS = '2' THEN 'F' ELSE BS.LUNCH_STATUS END AS [School Lunch]
	  , CASE WHEN ELL.ELL_STUDENT_GU IS NOT NULL THEN 'Y'
	        WHEN ELL.LCEE_STUDENT_GU IS NOT NULL AND ELL.ELL_STUDENT_GU IS NULL THEN 'F'
			WHEN ELL.ELL_STUDENT_GU IS NULL AND ELL.LCEE_STUDENT_GU IS NULL THEN 'N'
	  END AS [English Language Learner]
	  , BS.SPED_STATUS AS [Student with a Disability]
	  , sch.SIS_SCHOOL_CODE
	  , BS.HOME_ZIP AS [Student ZIP code]

FROM  rev.EPC_STU                    stu
      JOIN rev.EPC_STU_SCH_YR        ssy ON ssy.STUDENT_GU           = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
											AND EXCLUDE_ADA_ADM IS NULL
      JOIN rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                            and oyr.YEAR_GU          = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
	  JOIN rev.REV_ORGANIZATION      org ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	  JOIN rev.EPC_SCH               sch ON sch.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
	  JOIN rev.REV_PERSON            per ON per.PERSON_GU            = stu.STUDENT_GU
	  LEFT JOIN rev.REV_ADDRESS      adr ON adr.ADDRESS_GU           = COALESCE(per.MAIL_ADDRESS_GU, per.HOME_ADDRESS_GU)
	  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
	  LEFT JOIN APS.BasicStudentWithMoreInfo BS ON BS.STUDENT_GU = STU.STUDENT_GU
	  LEFT JOIN
	  (
	  SELECT pri.STUDENT_GU AS PRI_STUDENT_GU
	  ,lcee.STUDENT_GU AS LCEE_STUDENT_GU
	  ,ell.STUDENT_GU AS ELL_STUDENT_GU
		FROM
			aps.PrimaryEnrollmentDetailsAsOf (getdate()) pri
			left join
			aps.LCEEverELLStudentAsOf (getdate()) lcee
			on lcee.STUDENT_GU = pri.STUDENT_GU
			left join
			aps.ELLAsOf (getdate()) ell
			on lcee.STUDENT_GU = ell.STUDENT_GU
	    ) ELL
		ON ELL.PRI_STUDENT_GU = STU.STUDENT_GU
   --   LEFT JOIN
	  -- AS NAEP
	  --ON NAEP.[School Name] + ' School' = org.ORGANIZATION_NAME
WHERE sch.SCHOOL_CODE IN ('407', '450', '492', '460', '465')
) AS PULL
WHERE 1 = 1
	AND GRADE IN ('8')
	--AND NAEPID IS NULL
order by 