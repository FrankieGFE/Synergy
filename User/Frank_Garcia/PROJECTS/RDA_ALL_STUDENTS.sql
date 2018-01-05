SELECT distinct
         stu.SIS_NUMBER                            AS [fld_ID_NBR]
	   , stu.STATE_STUDENT_NUMBER				   AS [fld_STATE_ID]
	   , ''										   AS [fld_PRIOR_ID]
       , replace(per.FIRST_NAME,'''','')          AS [fld_FRST_NME]
       , replace(per.LAST_NAME,'''','')           AS [fld_LST_NME]
       , CASE 
			WHEN per.MIDDLE_NAME IS NULL THEN ''
			ELSE replace(per.MIDDLE_NAME,'"','''')
		END								           AS [fld_M_NME]
       , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) AS [fld_BRTH_DT]
       , per.GENDER								   AS [fld_GENDER]
	   , ''										   AS [fld_ETHN_CD]
	   , ''										   AS [fld_ETHN_VALUE]
	   , ''										   AS [fld_ETHN_CD2]
	   , ''										   AS [fld_ETHN2_VALUE]
	   , ''										   AS [fld_ETHN_CD3]
	   , ''										   AS [fld_ETHN3_VALUE]
	   , ''										   AS [fld_ETHN_CD4]
	   , ''										   AS [fld_ETHN4_VALUE]
	   , ''										   AS [fld_ETHN_CD5]
	   , ''										   AS [fld_ETHN5_VALUE]
       , CASE
             WHEN per.HISPANIC_INDICATOR = 'Y' THEN 'HL'
			 ELSE 'NHL'
	     END                                       AS [fld_HISPLAT]
	   , sch.SCHOOL_CODE						   AS [fld_SCH_NBR]
	   , grade.VALUE_DESCRIPTION                   AS [fld_GRDE]
	   , CASE WHEN FRL.FRM_CODE IS NULL THEN ''
		 ELSE FRL.FRM_CODE
		 END									   AS [fld_LNCH_FLG]
	   , CASE 
			WHEN ELL.PROGRAM_CODE IS NULL THEN ''
			ELSE 'Y'
		END										   AS [fld_ELL_STATUS]
	   , CASE 
			 WHEN CS.PRIMARY_DISABILITY_CODE IS NULL THEN ''
			 ELSE 'Y'
	    END										   AS [fld_SPED]
	   , CASE WHEN CS.PRIMARY_DISABILITY_CODE
			       IS NULL THEN ''
		 ELSE CS.PRIMARY_DISABILITY_CODE
		 END									   AS [fld_PRIM_DISAB]
	   , ''										   AS [fld_504]
	   , (GETDATE())						       AS [fld_DateCreate]

 
FROM   synergydbdc.st_production.rev.EPC_STU                    stu
       JOIN synergydbdc.st_production.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN synergydbdc.st_production.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from synergydbdc.st_production.rev.SIF_22_Common_CurrentYearGU)
       JOIN synergydbdc.st_production.rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN synergydbdc.st_production.rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN synergydbdc.st_production.rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   LEFT JOIN synergydbdc.st_production.rev.REV_ADDRESS      adr  ON adr.ADDRESS_GU = COALESCE(per.MAIL_ADDRESS_GU, per.home_address_gu)
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
	   LEFT JOIN
		   (SELECT  FR.STUDENT_GU
		   			, FR.FRM_CODE
			FROM   rev.EPC_STU_PGM_FRM_HIS AS  FR
			WHERE  FR.EXIT_DATE is null
			) AS FRL
	       ON FRL.STUDENT_GU = stu.STUDENT_GU
		   AND FRL.FRM_CODE IN ('2','F','R')
	 LEFT JOIN rev.EPC_STU_PGM_ELL_HIS AS ELL ON ELL.STUDENT_GU = stu.STUDENT_GU
	 LEFT JOIN
     (
     SELECT
                STUDENT_GU
                ,PRIMARY_DISABILITY_CODE
				,NEXT_IEP_DATE
     FROM
                REV.EP_STUDENT_SPECIAL_ED AS SPED
     WHERE
                NEXT_IEP_DATE IS NOT NULL
                AND (
                        EXIT_DATE IS NULL 
                        OR EXIT_DATE >= CONVERT(DATE, GETDATE())
                        )
     ) AS CS
     ON stu.STUDENT_GU = CS.STUDENT_GU
	 where stu.STATE_STUDENT_NUMBER is not null
	 AND SSY.LEAVE_DATE IS NULL
	 --AND per.LAST_NAME = 'GREEN'
	 --AND per.FIRST_NAME LIKE 'J%'
	 --AND STU.SIS_NUMBER = '970068290'
	 order by fld_STATE_ID