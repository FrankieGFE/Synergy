USE [SchoolNet]
GO
SELECT
	DST_NBR
	,ID_NBR
	,TEST_ID
	,TEST_SUB
	,SCH_YR
	,TEST_DT
	,SCH_NBR
	,GRDE
	,CASE
		WHEN PL = '1' THEN 'BS'
		WHEN PL = '2' THEN 'NP'
		WHEN PL = '3' THEN 'PRO'
		WHEN PL = '4' THEN 'ADV'
	END AS SCORE1
	,'11' +SS AS SCORE2
	,SCORE3

FROM
(
SELECT
	   [LATEST_DISTRICT_CODE] AS DST_NBR
      ,CAST(APS_ID AS INT) AS ID_NBR
	  ,'SBA' AS TEST_ID
	  ,CASE
			WHEN test_section_name = 'SS_MATH_FALL_2014' THEN 'MATE'
			WHEN test_section_name = 'SS_SCIENCE_FALL_2014' THEN 'SCIE'
			WHEN test_section_name = 'SS_READ_FALL_2014' THEN 'REAE'
	  END AS TEST_SUB
	  ,'2015' AS SCH_YR
	  ,'2014-10-01' AS TEST_DT
      ,[LATEST_SCHOOL_CODE] AS SCH_NBR
	  ,'' AS GRDE
	  ,'H3' AS SCORE3
	  ,CASE
			WHEN test_section_name = 'SS_MATH_FALL_2014' THEN PL_MATH_FALL_2014
			WHEN test_section_name = 'SS_READ_FALL_2014' THEN PL_READ_FALL_2014
			WHEN test_section_name = 'SS_SCIENCE_FALL_2014' THEN PL_SCIENCE_FALL_2014
	  END AS PL
	  ,CASE
			WHEN scaled_score = '0' THEN '00'
			WHEN scaled_score = '1' THEN '01'
			WHEN scaled_score = '2' THEN '02'
			WHEN scaled_score = '3' THEN '03'
			WHEN scaled_score = '4' THEN '04'
			WHEN scaled_score = '5' THEN '05'
			WHEN scaled_score = '6' THEN '06'
			WHEN scaled_score = '7' THEN '07'
			WHEN scaled_score = '8' THEN '08'
			WHEN scaled_score = '9' THEN '09'
			ELSE scaled_score
	  END AS SS
	  ,test_section_name
      --,[SS_READ_SPRING_2012]
      --,[SS_READ_FALL_2012]
      --,[SS_READ_SPRING_2013]
      --,[SS_READ_FALL_2013]
      ,[SS_READ_SPRING_2014]
      --,[SS_READ_FALL_2014]
      --,[PL_READ_SPRING_2012]
      --,[PL_READ_FALL_2012]
      --,[PL_READ_SPRING_2013]
      --,[PL_READ_FALL_2013]
      ,[PL_READ_SPRING_2014]
      ,[PL_READ_FALL_2014]
      --,[SS_MATH_SPRING_2012]
      --,[SS_MATH_FALL_2012]
      --,[SS_MATH_SPRING_2013]
      --,[SS_MATH_FALL_2013]
      --,[SS_MATH_SPRING_2014]
      --,[SS_MATH_FALL_2014]
      --,[PL_MATH_SPRING_2012]
      --,[PL_MATH_FALL_2012]
      --,[PL_MATH_SPRING_2013]
      --,[PL_MATH_FALL_2013]
      --,[PL_MATH_SPRING_2014]
      ,[PL_MATH_FALL_2014]
      --,[SS_SCIENCE_SPRING_2012]
      --,[SS_SCIENCE_SPRING_2013]
      --,[SS_SCIENCE_FALL_2013]
      --,[SS_SCIENCE_SPRING_2014]
      --,[SS_SCIENCE_FALL_2014]
      --,[PL_SCIENCE_SPRING_2012]
      --,[PL_SCIENCE_SPRING_2013]
      --,[PL_SCIENCE_FALL_2013]
      --,[PL_SCIENCE_SPRING_2014]
      ,[PL_SCIENCE_FALL_2014]
      --,[READ_SPRING_2012]
      --,[MATH_SPRING_2012]
      --,[SCIENCE_SPRING_2012]
      --,[READ_FALL_2012]
      --,[MATH_FALL_2012]
      --,[SCIENCE_SPRING_2012_2]
      --,[READ_SPRING_2013]
      --,[MATH_SPRING_2013]
      --,[SCIENCE_SPRING_2013]
      --,[READ_FALL_2013]
      --,[MATH_FALL_2013]
      --,[SCIENCE_FALL_2013]
      --,[READ_SPRING_2014]
      --,[MATH_SPRING_2014]
      --,[SCIENCE_SPRING_2014]
      --,[READ_FALL_2014]
      --,[MATH_FALL_2014]
      --,[SCIENCE_FALL_2014]
      --,[READSS_MAX]
      --,[MATHSS_MAX]
      --,[SCIENCESS_MAX]
      --,[READPL_MAX]
      --,[MATHPL_MAX]
      --,[SCIENCEPL_MAX]
      --,[BOOKLETNUMBER]
      --,[BEST_COMPOSITE_SUM]
      --,[BEST_READ_SCORE]
      --,[BEST_MATH_SCORE]
      --,[BEST_SCIENCE_SCORE]
      --,[BEST_COMPOSITE_SCORE]
      ,[APS_ID]
  FROM [dbo].[HSGA_Pass_Fail_Report_2012-2013-2014 No Charters]
  UNPIVOT (scaled_score FOR test_section_name IN (SS_READ_FALL_2014,SS_MATH_FALL_2014,SS_SCIENCE_FALL_2014)) AS Unpvt

) AS T1
WHERE PL != ''
AND SS != '110'
AND ID_NBR IS NOT NULL

ORDER BY SCORE2
GO


