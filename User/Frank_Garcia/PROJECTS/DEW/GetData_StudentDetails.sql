--<APS - SchoolNet student data>
SELECT distinct
         stu.SIS_NUMBER                            AS ID_NBR
       , per.LAST_NAME                             AS StudentLastName
       , per.FIRST_NAME                            AS StudentFirstName
       , per.MIDDLE_NAME                           AS StudentMiddleName
       , CONVERT(VARCHAR(10), per.BIRTH_DATE, 120) AS BRTH_DT
       , per.GENDER								   AS [gender_code]
	   , stu.STATE_STUDENT_NUMBER				   AS STATE_ID
	   , ''										   AS PRIOR_ID
	   , CASE
			WHEN [ETHNIC_CODES].RACE_1 = 'WHITE'
			THEN '1'
			WHEN [ETHNIC_CODES].RACE_1 = 'African-American'
			THEN '2'
			WHEN [ETHNIC_CODES].RACE_1 = 'Native American'
			THEN '4'
			WHEN [ETHNIC_CODES].RACE_1 = 'Asian'
			THEN '5'
			WHEN ETHNIC_CODES.RACE_1 = 'Pacific Islander'
			THEN '6'
			ELSE '0'
		END AS [Race1]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_2 = 'WHITE'
			THEN '1'
			WHEN [ETHNIC_CODES].RACE_2 = 'African-American'
			THEN '2'
			WHEN [ETHNIC_CODES].RACE_2 = 'Native American'
			THEN '4'
			WHEN [ETHNIC_CODES].RACE_2 = 'Asian'
			THEN '5'
			WHEN ETHNIC_CODES.RACE_2 = 'Pacific Islander'
			THEN '6'
			ELSE '0'
		END AS [Race2]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_3 = 'WHITE'
			THEN '1'
			WHEN [ETHNIC_CODES].RACE_3 = 'African-American'
			THEN '2'
			WHEN [ETHNIC_CODES].RACE_3 = 'Native American'
			THEN '4'
			WHEN [ETHNIC_CODES].RACE_3 = 'Asian'
			THEN '5'
			WHEN ETHNIC_CODES.RACE_3 = 'Pacific Islander'
			THEN '6'
			ELSE '0'
		END AS [Race3]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_4 = 'WHITE'
			THEN '1'
			WHEN [ETHNIC_CODES].RACE_4 = 'African-American'
			THEN '2'
			WHEN [ETHNIC_CODES].RACE_4 = 'Native American'
			THEN '4'
			WHEN [ETHNIC_CODES].RACE_4 = 'Asian'
			THEN '5'
			WHEN ETHNIC_CODES.RACE_4 = 'Pacific Islander'
			THEN '6'
			ELSE '0'
		END AS [Race4]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_5 = 'WHITE'
			THEN '1'
			WHEN [ETHNIC_CODES].RACE_5 = 'African-American'
			THEN '2'
			WHEN [ETHNIC_CODES].RACE_5 = 'Native American'
			THEN '4'
			WHEN [ETHNIC_CODES].RACE_5 = 'Asian'
			THEN '5'
			WHEN ETHNIC_CODES.RACE_5 = 'Pacific Islander'
			THEN '6'
			ELSE '0'
		END AS [Race5]
		, '' AS Race6
       , CASE
             WHEN per.HISPANIC_INDICATOR = 'Y' THEN 'Y'
			 ELSE 'N'
	     END                                       AS [ethnicity_code]
	   , CASE WHEN stu.HOME_LESS IS NULL THEN ''
			ELSE stu.HOME_LESS
	   END		    							   AS HOMELESS
	   , stu.EXPECTED_GRADUATION_YEAR			   AS GSTD_YR
	   , CASE
			WHEN [ETHNIC_CODES].RACE_1 = 'WHITE'
			THEN 'White-Caucasian'
			WHEN [ETHNIC_CODES].RACE_1 = 'African-American'
			THEN 'Black-AfricanAm'
			WHEN [ETHNIC_CODES].RACE_1 = 'Native American'
			THEN 'Am Indian'
			WHEN [ETHNIC_CODES].RACE_1 = 'Asian'
			THEN 'Asian'
			WHEN ETHNIC_CODES.RACE_1 = 'Pacific Islander'
			THEN 'PacificIslander'
		END AS [Race1Descr]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_2 = 'WHITE'
			THEN 'White-Caucasian'
			WHEN [ETHNIC_CODES].RACE_2 = 'African-American'
			THEN 'Black-AfricanAm'
			WHEN [ETHNIC_CODES].RACE_2 = 'Native American'
			THEN 'Am Indian'
			WHEN [ETHNIC_CODES].RACE_2 = 'Asian'
			THEN 'Asian'
			WHEN ETHNIC_CODES.RACE_2 = 'Pacific Islander'
			THEN 'PacificIslander'
		END AS [Race2Descr]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_3 = 'WHITE'
			THEN 'White-Caucasian'
			WHEN [ETHNIC_CODES].RACE_3 = 'African-American'
			THEN 'Black-AfricanAm'
			WHEN [ETHNIC_CODES].RACE_3 = 'Native American'
			THEN 'Am Indian'
			WHEN [ETHNIC_CODES].RACE_3 = 'Asian'
			THEN 'Asian'
			WHEN ETHNIC_CODES.RACE_3 = 'Pacific Islander'
			THEN 'PacificIslander'
		END AS [Race3Descr]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_4 = 'WHITE'
			THEN 'White-Caucasian'
			WHEN [ETHNIC_CODES].RACE_4 = 'African-American'
			THEN 'Black-AfricanAm'
			WHEN [ETHNIC_CODES].RACE_4 = 'Native American'
			THEN 'Am Indian'
			WHEN [ETHNIC_CODES].RACE_4 = 'Asian'
			THEN 'Asian'
			WHEN ETHNIC_CODES.RACE_4 = 'Pacific Islander'
			THEN 'PacificIslander'
		END AS [Race4Descr]
	   , CASE
			WHEN [ETHNIC_CODES].RACE_5 = 'WHITE'
			THEN 'White-Caucasian'
			WHEN [ETHNIC_CODES].RACE_5 = 'African-American'
			THEN 'Black-AfricanAm'
			WHEN [ETHNIC_CODES].RACE_5 = 'Native American'
			THEN 'Am Indian'
			WHEN [ETHNIC_CODES].RACE_5 = 'Asian'
			THEN 'Asian'
			WHEN ETHNIC_CODES.RACE_5 = 'Pacific Islander'
			THEN 'PacificIslander'
		END AS [Race5Descr]
	   , ''									       AS [Race6Descr]
	   , ''										   AS 'FAM_NBR'
	   , CASE WHEN spar.LIVES_WITH = 'Y' THEN 'X'
			ELSE ''
		END			     						   AS LIVE_WITH
	   , CASE WHEN spar.HAS_CUSTODY = 'Y' THEN 'X'
			ELSE ''
		END			     						   AS PRIM_FAM
	   , LEFT (per.PRIMARY_PHONE,3)				   AS HH_AREA_CD
	   , RIGHT (per.PRIMARY_PHONE,7)			   AS HM_PHNE
	   , pper.FIRST_NAME + ' ' + pper.LAST_NAME	   AS ADDR_TO
       , adr.ADDRESS                               AS ADDR_LNE_1
       , adr.ADDRESS2                              AS ADDR_LNE_2
       , adr.CITY                                  AS CITY
       , adr.STATE                                 AS STATE
       , adr.ZIP_5
	     +  COALESCE(adr.zip_4, '0000')			   AS [zip]
	   , ''										   AS DWL_NBR
	   , PPER.FIRST_NAME						   AS HHLastName
	   , pper.LAST_NAME							   AS HHLastName
	   , pper.MIDDLE_NAME						   AS HHMiddleName
	   , pper.GENDER							   AS HHGender
	   , pper.EMAIL								   AS HHEMail
	   ,'X'										   AS HHPhone1DayFlag
	   , pper.PRIMARY_PHONE_TYPE				   AS HHPhone1Type
	   , LEFT(pper.PRIMARY_PHONE,3)				   AS HHPhone1AreaCode
	   , RIGHT(pper.PRIMARY_PHONE,7)			   AS HHPhone1Number
	   , pper.PRIMARY_PHONE_EXTN				   AS HHPhone1Ext
	   , ''										   AS HHPhone2DayFlag
	   , ''										   AS HHPhone2Type
	   , ''										   AS HHPhone2AreaCode
	   , ''										   AS HHPhone2Number
	   , ''										   AS HHPhone1TypeDescr
	   , ''								           AS HHPhone2TypeDescr

 
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
	   LEFT JOIN rev.REV_ADDRESS      adr  ON adr.ADDRESS_GU = COALESCE(per.MAIL_ADDRESS_GU, per.home_address_gu)
	   LEFT JOIN
			(
			SELECT
				[ETHNIC_PIVOT].[PERSON_GU]
				,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[1]) AS [RACE_1]
				,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[2]) AS [RACE_2]
				,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[3]) AS [RACE_3]
				,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[4]) AS [RACE_4]
				,(SELECT [VALUE_DESCRIPTION] FROM APS.LookupTable ('Revelation', 'ETHNICITY') WHERE [VALUE_CODE] = [ETHNIC_PIVOT].[5]) AS [RACE_5]
			FROM
				(
				SELECT
					[SECONDARY_ETHNIC_CODES].[PERSON_GU]
					,[SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]
					,ROW_NUMBER() OVER(PARTITION by [SECONDARY_ETHNIC_CODES].[PERSON_GU] order by [SECONDARY_ETHNIC_CODES].[ETHNIC_CODE]) [RN]
				FROM
					rev.REV_PERSON_SECONDRY_ETH_LST AS [SECONDARY_ETHNIC_CODES]
				) [PVT]
				PIVOT (MIN(ETHNIC_CODE) FOR [RN] IN ([1],[2],[3],[4],[5])) AS [ETHNIC_PIVOT]
			) AS [ETHNIC_CODES]
			ON
			[STU].[STUDENT_GU] = [ETHNIC_CODES].[PERSON_GU]
		LEFT JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU
										  --AND spar.ORDERBY = '1'
		LEFT JOIN rev.REV_PERSON     pper ON pper.PERSON_GU  = spar.PARENT_GU
		                                  

ORDER BY ID_NBR