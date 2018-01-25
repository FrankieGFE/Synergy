--TRUNCATE TABLE [180-SMAXODS-01.APS.EDU.ACTD].SCHOOLNET.DBO.test_result_SEMESTER_GRADES

--INSERT INTO
--[180-SMAXODS-01.aps.edu.actd].SCHOOLNET.DBO.test_result_SEMESTER_GRADES

SELECT
	  DISTINCT
	  [student_code]
      ,[school_year]
      ,[school_code]
      ,[test_date_code]
      ,[test_type_code]
      ,[test_type_name]
      ,[test_section_code]
      ,[test_section_name]
      ,[parent_test_section_code]
      ,[low_test_level_code]
      ,[high_test_level_code]
      ,[test_level_name]
      ,[version_code]
      ,[score_group_name]
      ,[score_group_code]
      ,[score_group_label]
      ,[last_name]
      ,[first_name]
      ,[DOB]
      ,[raw_score]
      ,[scaled_score]
      ,[nce_score]
      ,[percentile_score]
      ,[score_1]
      ,[score_2]
      ,[score_3]
      ,[score_4]
      ,[score_5]
      ,[score_6]
      ,[score_7]
      ,[score_8]
      ,[score_9]
      ,[score_10]
      ,[score_11]
      ,[score_12]
      ,[score_13]
      ,[score_14]
      ,[score_15]
      ,[score_16]
      ,[score_17]
      ,[score_18]
      ,[score_19]
      ,[score_20]
      ,[score_21]
      ,[score_raw_name]
      ,[score_scaled_name]
      ,[score_nce_name]
      ,[score_percentile_name]
      ,[score_1_name]
      ,[score_2_name]
      ,[score_3_name]
      ,[score_4_name]
      ,[score_5_name]
      ,[score_6_name]
      ,[score_7_name]
      ,[score_8_name]
      ,[score_9_name]
      ,[score_10_name]
      ,[score_11_name]
      ,[score_12_name]
      ,[score_13_name]
      ,[score_14_name]
      ,[score_15_name]
      ,[score_16_name]
      ,[score_17_name]
      ,[score_18_name]
      ,[score_19_name]
      ,[score_20_name]
      ,[score_21_name]
FROM
(

SELECT
      ROW_NUMBER () OVER (PARTITION BY [STUDENT].[SIS_NUMBER], COURSE.DEPARTMENT ORDER BY grade.VALUE_DESCRIPTION desc, COURSE.DEPARTMENT) AS RN
	  ,[STUDENT].[SIS_NUMBER] AS student_code
	  ,[COURSE_HISTORY_DUPLICATES].[SCHOOL_YEAR] AS school_year  
	  ,SCH.SCHOOL_CODE AS school_code
	  ,'2015-01-01' AS test_date_code
	  ,'S1 GRADES' AS test_type_code
	  ,'S1 GRADES' AS test_type_name
	  ,CASE
		WHEN COURSE.DEPARTMENT = 'MATH' THEN 'MATH'
		WHEN DEPARTMENT = 'ENG' THEN 'ELA'
	  END AS test_section_code
	  ,CASE
		WHEN COURSE.DEPARTMENT = 'MATH' THEN 'MATH'
		WHEN DEPARTMENT = 'ENG' THEN 'ELA'
	  END AS test_section_name
	  ,'0' AS parent_test_section_code
	  ,'06' AS low_test_level_code
	  ,'12' AS high_test_level_code
	  ,grade.VALUE_DESCRIPTION AS [test_level_name]
	  ,'' AS version_code
	  ,[COURSE_HISTORY_DUPLICATES].[MARK] AS score_group_name
	  ,[COURSE_HISTORY_DUPLICATES].[MARK] AS score_group_code
	  ,'Semester 1 Grade' AS [score_group_label]
	  ,[STUDENT].[LAST_NAME] AS last_name 
      ,[STUDENT].[FIRST_NAME] AS first_name
	  ,'' AS DOB
	  ,'' AS raw_score
	  ,'' AS scaled_score
	  ,'' AS nce_score
	  ,'' AS percentile_score
	  ,'' AS score_1
      ,'' AS [score_2]
      ,'' AS [score_3]
      ,'' AS [score_4]
      ,'' AS [score_5]
      ,'' AS [score_6]
      ,'' AS [score_7]
      ,'' AS [score_8]
      ,'' AS [score_9]
      ,'' AS [score_10]
      ,'' AS [score_11]
      ,'' AS [score_12]
      ,'' AS [score_13]
      ,'' AS [score_14]
      ,'' AS [score_15]
      ,'' AS [score_16]
      ,'' AS [score_17]
      ,'' AS [score_18]
      ,'' AS [score_19]
      ,'' AS [score_20]
      ,'' AS [score_21]
      ,'' AS [score_raw_name]
      ,'' AS [score_scaled_name]
      ,'' AS [score_nce_name]
      ,'' AS [score_percentile_name]
      ,'' AS [score_1_name]
      ,'' AS [score_2_name]
      ,'' AS [score_3_name]
      ,'' AS [score_4_name]
      ,'' AS [score_5_name]
      ,'' AS [score_6_name]
      ,'' AS [score_7_name]
      ,'' AS [score_8_name]
      ,'' AS [score_9_name]
      ,'' AS [score_10_name]
      ,'' AS [score_11_name]
      ,'' AS [score_12_name]
      ,'' AS [score_13_name]
      ,'' AS [score_14_name]
      ,'' AS [score_15_name]
      ,'' AS [score_16_name]
      ,'' AS [score_17_name]
      ,'' AS [score_18_name]
      ,'' AS [score_19_name]
      ,'' AS [score_20_name]
      ,'' AS [score_21_name]

      --,CASE WHEN [Organization].[ORGANIZATION_NAME] IS NULL THEN [NON_DST_SCHOOL].[NAME] ELSE [Organization].[ORGANIZATION_NAME] END AS [SCHOOL_NAME]
      
      --,[COURSE_HISTORY_DUPLICATES].[COURSE_ID]
      --,[COURSE_HISTORY_DUPLICATES].[COURSE_TITLE]
      --,[COURSE].[DEPARTMENT]
      --,[COURSE_HISTORY_DUPLICATES].[TERM_CODE]
      --,[COURSE_HISTORY_DUPLICATES].[REPEAT_TAG_GU]
      --,[COURSE_HISTORY_DUPLICATES].[MARK]
      --,[COURSE_HISTORY_DUPLICATES].[COURSE_HISTORY_TYPE]
      
FROM
      rev.EPC_STU_CRS_HIS AS [COURSE_HISTORY_DUPLICATES]
      
      INNER JOIN
      rev.EPC_CRS AS [COURSE]
      ON
      [COURSE_HISTORY_DUPLICATES].[COURSE_GU] = [COURSE].[COURSE_GU]
      
      INNER JOIN
      APS.BasicStudent AS [STUDENT] 
      ON
      [COURSE_HISTORY_DUPLICATES].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
      
      LEFT OUTER JOIN 
      rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
      ON 
      [COURSE_HISTORY_DUPLICATES].[SCHOOL_IN_DISTRICT_GU] = [Organization].[ORGANIZATION_GU]

	  LEFT OUTER JOIN
	  rev.EPC_SCH AS SCH
	  ON
	  Organization.ORGANIZATION_GU = SCH.ORGANIZATION_GU
      
      LEFT OUTER JOIN
      rev.EPC_SCH_NON_DST AS [NON_DST_SCHOOL]
      ON
      [COURSE_HISTORY_DUPLICATES].[SCHOOL_NON_DISTRICT_GU] = [NON_DST_SCHOOL].[SCHOOL_NON_DISTRICT_GU]

	  JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = STUDENT.STUDENT_GU
	  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
	  LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.Enrollment', 'Leave_CODE') lcd ON lcd.VALUE_CODE = ssy.LEAVE_CODE
      
WHERE
      [SCHOOL_YEAR] = '2014'
--    [STUDENT].[SIS_NUMBER] = '970112082'
	  AND [DEPARTMENT] IN ('ENG','MATH')
 ) AS T1   
 WHERE RN = 1  
 --and student_code = '100010222'
ORDER BY
      student_code
      --,[COURSE_HISTORY_DUPLICATES].[TERM_CODE]
