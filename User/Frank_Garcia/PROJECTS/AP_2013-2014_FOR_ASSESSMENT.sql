SELECT
student_code
,school_year
,school_code
, test_date_code
,test_type_code
--,t2.test_type_name
--,apq.test_section_code
,APQ.test_section_name
--,APQ.parent_test_section_code
--,APQ.low_test_level_code
--,APQ.high_test_level_code
,[scaled_score]
,score_group_name
,test_level_name AS grade_level
--,version_code
--,score_group_code
--,score_group_lable
,last_name
,first_name
,DOB
,[ETHNIC CODE SHORT]
,[HISPANIC INDICATOR]
--,raw_score
--,[nce_score]
--,[percentile_score]
--,[score_1]
--,[score_2]
--,[score_3]
--,[score_4]
--,[score_5]
--,[score_6]
--,[score_7]
--,[score_8]
--,[score_9]
--,[score_10]
--,[score_11]
--,[score_12]
--,[score_13]
--,[score_14]
--,[score_15]
--,[score_16]
--,[score_17]
--,[score_18]
--,[score_19]
--,[score_20]
--,[score_21]
--,[score_raw_name]
--,[score_scaled_name]
--,[score_nce_name]
--,[score_percentile_name]
--,[score_1_name]
--,[score_2_name]
--,[score_3_name]
--,[score_4_name]
--,[score_5_name]
--,[score_6_name]
--,[score_7_name]
--,[score_8_name]
--,[score_9_name]
--,[score_10_name]
--,[score_11_name]
--,[score_12_name]
--,[score_13_name]
--,[score_14_name]
--,[score_15_name]
--,[score_16_name]
--,[score_17_name]
--,[score_18_name]
--,[score_19_name]
--,[score_20_name]
--,[score_21_name]

FROM
(

SELECT
ID_NBR AS student_code
,'2013' AS school_year
,SCHOOL AS school_code
,'2014-05-01' AS test_date_code
,'AP Exam' AS test_type_code
,'AP Exam' AS test_type_name
,GRADE AS test_level_name
,'' AS version_code
,CASE
	WHEN SCORE IN ('1','2') THEN 'FAIL' ELSE 'PASS'
END AS score_group_name
,CASE
	WHEN SCORE IN ('1','2') THEN 'F' ELSE 'P'
END AS score_group_code
,'Performance Level' AS score_group_lable
,LAST_NAME AS last_name
,FIRST_NAME AS first_name
,DOB AS DOB
,'' AS raw_score
,SCORE AS scaled_score
      ,'' AS [nce_score]
      ,'' AS [percentile_score]
      ,'' AS [score_1]
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
      ,'Scale Score' AS [score_scaled_name]
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
	  ,[ETHNIC CODE SHORT]
	  ,[HISPANIC INDICATOR]
	  ,SUBTEST


FROM
(
SELECT [FULL_NAME]
      ,[DOB]
	  --,SCORE
	  --,SUBTEST
      ,[ART HISTORY]
      ,[BIOLOGY]
      ,[CALCULUS AB]
      ,[CALCULUS BC]
      ,[CHEMISTRY]
      ,[CHINESE LANGUAGE AND CULTURE]
      ,[COMPUTER SCIENCE A]
      ,[ENGLISH LANGUAGE AND COMPOSITION]
      ,[ENGLISH LITERATURE AND COMPOSITION]
      ,[ENVIRONMENTAL SCIENCE]
      ,[EUROPEAN HISTORY]
      ,[FRENCH LANGUAGE]
      ,[GERMAN LANGUAGE]
      ,[GOVERNMENT AND POLITICS: COMPARATIVE]
      ,[GOVERNMENT AND POLITICS: UNITED STATES]
      ,[HUMAN GEOGRAPHY]
      ,[ITALIAN LANGUAGE AND CULTURE]
      ,[JAPANESE LANGUAGE AND CULTURE]
      ,[LATIN: VERGIL]
      ,[MACROECONOMICS]
      ,[MICROECONOMICS]
      ,[MUSIC THEORY]
      ,[PHYSICS B]
      ,[PHYSICS C: ELECTRICITY AND MAGNETISM]
      ,[PHYSICS C: MECHANICS]
      ,[PSYCHOLOGY]
      ,[SPANISH LANGUAGE]
      ,[SPANISH LITERATURE]
      ,[STATISTICS]
      ,[STUDIO ART: 2-D DESIGN]
      ,[STUDIO ART: 3-D DESIGN]
      ,[STUDIO ART: DRAWING]
      ,[US HISTORY]
      ,[WORLD HISTORY]
      ,[GRADE]
      ,[SCHOOL]
      ,[ID_NBR]
      ,[FIRST_NAME]
      ,[LAST_NAME]
      ,[MI]
      ,[SCH_YR]
      ,[STID]
	  ,STUD.[ETHNIC CODE SHORT]
	  ,STUD.[HISPANIC INDICATOR]
  FROM [180-SMAXODS-01].[SchoolNet].[dbo].[CCR_AP_RAW] AS APR
  LEFT JOIN
  [046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
  ON APR.ID_NBR = STUD.[ALTERNATE STUDENT ID]
  AND STUD.PERIOD = '2014-03-01'
  
  ) AS T1
  UNPIVOT (SCORE FOR SUBTEST IN 
	(
	   [ART HISTORY]
      ,[BIOLOGY]
      ,[CALCULUS AB]
      ,[CALCULUS BC]
      ,[CHEMISTRY]
      ,[CHINESE LANGUAGE AND CULTURE]
      ,[COMPUTER SCIENCE A]
      ,[ENGLISH LANGUAGE AND COMPOSITION]
      ,[ENGLISH LITERATURE AND COMPOSITION]
      ,[ENVIRONMENTAL SCIENCE]
      ,[EUROPEAN HISTORY]
      ,[FRENCH LANGUAGE]
      ,[GERMAN LANGUAGE]
      ,[GOVERNMENT AND POLITICS: COMPARATIVE]
      ,[GOVERNMENT AND POLITICS: UNITED STATES]
      ,[HUMAN GEOGRAPHY]
      ,[ITALIAN LANGUAGE AND CULTURE]
      ,[JAPANESE LANGUAGE AND CULTURE]
      ,[LATIN: VERGIL]
      ,[MACROECONOMICS]
      ,[MICROECONOMICS]
      ,[MUSIC THEORY]
      ,[PHYSICS B]
      ,[PHYSICS C: ELECTRICITY AND MAGNETISM]
      ,[PHYSICS C: MECHANICS]
      ,[PSYCHOLOGY]
      ,[SPANISH LANGUAGE]
      ,[SPANISH LITERATURE]
      ,[STATISTICS]
      ,[STUDIO ART: 2-D DESIGN]
      ,[STUDIO ART: 3-D DESIGN]
      ,[STUDIO ART: DRAWING]
      ,[US HISTORY]
      ,[WORLD HISTORY]

	)) AS UPVT
  where score is not null and score != ''
) AS T2
  LEFT JOIN
  [180-SMAXODS-01].SCHOOLNET.DBO.AP_Questions AS APQ
  ON T2.SUBTEST = APQ.test_section_name
  --where student_code = '102961919'
  where student_code > '1'
  order by [ETHNIC CODE SHORT]
