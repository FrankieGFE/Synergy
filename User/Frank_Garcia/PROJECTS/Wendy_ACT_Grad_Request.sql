SELECT
*
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [student_code], [test_section_name] ORDER BY [scaled_score] DESC) AS RN
	  ,DR.[SCH_YR]
      ,DR.[ID_NBR]
      ,DR.[FRST_NME]
      ,DR.[LST_NME]
      ,DR.[M_NME]
	  ,ACT.test_section_name
	  ,ACT.scaled_score
  FROM [SchoolNet].[dbo].[ACT_data_request_for_Frank] AS DR
  LEFT JOIN
  [CCR_ACT_HISTORY] AS ACT
  ON DR.ID_NBR = ACT.student_code
  AND ACT.test_section_name IN ('READING', 'MATHEMATICS', 'COMPOSITE')
) AS T1
WHERE (RN = 1 OR RN > 10) --and SCH_YR = '2013' and scaled_score is not null
ORDER BY ID_NBR

