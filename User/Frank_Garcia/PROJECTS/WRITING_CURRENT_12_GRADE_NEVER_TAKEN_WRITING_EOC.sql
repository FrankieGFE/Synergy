

USE [SchoolNet]
GO
SELECT
	  student_code
      ,last_name
      ,first_name
	  ,grade_code
	  ,school_code
	  ,DOB
	  ,SCHOOL_YEAR
	  /* UNCOMMENT BELOW FOR ELA WRITING */
	  --,ELA3V1
	  --,ELA4V1
	  --,ELA3V2
	  --,SELA3V1
	  /* FOR SS */
	  ,ECONV1
	  ,NMHV1
	  ,NMH_V1
	  ,USGV1
	  ,USGV2
	  ,USHV1
	  ,USHV2
	  ,WHV2

FROM
(
SELECT 
	  --ROW_NUMBER () OVER (PARTITION BY [SIS_NUMBER] ORDER BY [SIS_NUMBER]) AS RN
	  student_code
      ,STUD.last_name
      ,STUD.first_name
	  ,STUD.school_code
	  ,STUD.DOB
	  ,STUD.grade_code
	  ,STUD.SCHOOL_YEAR
	  ,[Economics 9 12 V001] AS ECONV1
	  ,[New Mexico History 7 12 V001] AS NMHV1
	  ,[NM History 7 12 V001] AS NMH_V1
	  ,[US Government Comprehensive 9 12 V001] AS USGV1
	  ,[US Government Comprehensive 9 12 V002] AS USGV2
	  ,[US History 9 12 V001] USHV1
	  ,[US History 9 12 V002] AS USHV2
	  ,[World History And Geography 9 12 V001] AS WHV2
  FROM [SchoolNet].[dbo].[ALLSTUDENTS] AS STUD
  LEFT JOIN

(
SELECT
	*
FROM
(
SELECT	
[ID Number]
,EOC.Subtest
,EOC.Score1
FROM
EOC_ AS EOC
/*** FOR WRITING ***/
--WHERE EOC.assessment_id IN ('7033','7500','7994','8014','8127','8129','8016','8074')
/*** FOR SOCIAL STUDIES ***/
WHERE EOC.subtest in ('Economics 9 12 V001','New Mexico History 7 12 V001','NM History 7 12 V001','US Government Comprehensive 9 12 V001','US Government Comprehensive 9 12 V002','US History 9 12 V001','US History 9 12 V002','World History And Geography 9 12 V001')
  ) AS T1
pivot
(max([SCORE1]) FOR SUBTEST IN ([Economics 9 12 V001],[New Mexico History 7 12 V001],[NM History 7 12 V001],[US Government Comprehensive 9 12 V001],[US Government Comprehensive 9 12 V002],[US History 9 12 V001],[US History 9 12 V002],[World History And Geography 9 12 V001])) AS UP1
) AS EOC2

ON EOC2.[ID Number] = STUD.student_code

) AS EOC2
WHERE grade_code = '12'
AND (ECONV1 IS NULL AND NMHV1 IS NULL AND NMH_V1 IS NULL AND USGV1 IS NULL AND USGV2 IS NULL AND USHV1 IS NULL AND USHV2 IS NULL AND WHV2 IS NULL)
ORDER BY school_code






