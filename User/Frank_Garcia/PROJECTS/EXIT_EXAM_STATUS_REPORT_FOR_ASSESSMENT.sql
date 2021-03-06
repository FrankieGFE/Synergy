BEGIN TRAN
USE SchoolNet
GO

SELECT
	SBA.[ID_NBR]
	,SBA.last_name
	,SBA.first_name
	,SBA.[CURRENT SY2014 GRADE] AS 'Grade'
	,SBA.School
	,CASE WHEN SBA.READING IS NULL OR SBA.READING = 'NULL' THEN '' ELSE SBA.READING END AS READING
	,SBA.[PASS FAIL_READING]
	,CASE WHEN SBA.MATH IS NULL OR SBA.MATH = 'NULL' THEN '' ELSE SBA.MATH END AS MATH
	,CASE WHEN SBA.[PASS FAIL_MATH] IS NULL OR SBA.[PASS FAIL_MATH] = 'NULL' THEN '' ELSE [PASS FAIL_MATH] END AS [PASS FAIL_MATH]
	,CASE WHEN SBA.[TOTAL SCORE READING MATH] IS NULL OR SBA.[TOTAL SCORE READING MATH] = 'NULL' THEN '' ELSE SBA.[TOTAL SCORE READING MATH] END AS [TOTAL SCORE READING MATH]
	,SBA.[PASS FAIL_RM]
	,CASE WHEN SBA.SCIENCE IS NULL OR SBA.SCIENCE = 'NULL' THEN '' ELSE SBA.SCIENCE END AS SCIENCE
	,CASE WHEN SBA.[PASS FAIL_SCIENCE] IS NULL OR SBA.[PASS FAIL_SCIENCE] = 'NULL' THEN '' ELSE SBA.[PASS FAIL_SCIENCE] END AS [PASS FAIL_SCIENCE]
	,CASE WHEN T2.[Biology 9 12 V002] IS NULL OR T2.[Biology 9 12 V002] = 'NULL' THEN '' ELSE T2.[Biology 9 12 V002] END AS [Biology 9 12 V002]
	,CASE
		WHEN T2.[Biology 9 12 V002] = 'NULL' OR T2.[Biology 9 12 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Biology 9 12 V002] < 22 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[Biology 9 12 V003] IS NULL OR T2.[Biology 9 12 V003] = 'NULL' THEN '' ELSE T2.[Biology 9 12 V003] END AS [Biology 9 12 V003]
	,CASE
		WHEN T2.[Biology 9 12 V003] = 'NULL' OR T2.[Biology 9 12 V003] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Biology 9 12 V003] < 27 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[Chemistry 9 12 V002] IS NULL OR T2.[Chemistry 9 12 V002] = 'NULL' THEN '' ELSE T2.[Chemistry 9 12 V002] END AS [Chemistry 9 12 V002]
	,CASE
		WHEN T2.[Chemistry 9 12 V002] = 'NULL' OR T2.[Chemistry 9 12 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Chemistry 9 12 V002] < 13 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[Chemistry 9 12 V003] IS NULL OR T2.[Chemistry 9 12 V003] = 'NULL' THEN '' ELSE T2.[Chemistry 9 12 V003] END AS [Chemistry 9 12 V003]
	,CASE
		WHEN T2.[Chemistry 9 12 V003] = 'NULL' OR T2.[Chemistry 9 12 V003] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Chemistry 9 12 V003] < 24 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[Economics 9 12 V001] IS NULL THEN '' ELSE T2.[Economics 9 12 V001] END AS [Economics 9 12 V001]
	,CASE
		WHEN T2.[Economics 9 12 V001] = 'NULL' OR T2.[Economics 9 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Economics 9 12 V001] < 23 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[English Language Arts III Reading 11 11 V001] IS NULL THEN '' ELSE T2.[English Language Arts III Reading 11 11 V001] END AS [English Language Arts III Reading 11 11 V001]
	,CASE
		WHEN T2.[English Language Arts III Reading 11 11 V001] = 'NULL' OR T2.[English Language Arts III Reading 11 11 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[English Language Arts III Reading 11 11 V001] < 25 THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS 'P/F'
	,CASE WHEN T2.[English Language Arts III Reading 11 11 V002] IS NULL THEN '' ELSE T2.[English Language Arts III Reading 11 11 V002] END AS [English Language Arts III Reading 11 11 V002]
	,CASE
		WHEN T2.[English Language Arts III Reading 11 11 V002] = 'NULL' OR T2.[English Language Arts III Reading 11 11 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[English Language Arts III Reading 11 11 V002] < 14 THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS 'P/F'
	,CASE WHEN T2.[English Language Arts III Writing 11 11 V001] IS NULL THEN '' ELSE T2.[English Language Arts III Writing 11 11 V001] END AS [English Language Arts III Writing 11 11 V001]
	,CASE
		WHEN T2.[English Language Arts III Writing 11 11 V001] = 'NULL' OR T2.[English Language Arts III Writing 11 11 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[English Language Arts III Writing 11 11 V001] < 15 THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS 'P/F'
	,CASE WHEN T2.[English Language Arts III Writing 11 11 V002] IS NULL THEN '' ELSE T2.[English Language Arts III Writing 11 11 V002] END AS [English Language Arts III Writing 11 11 V002]
	,CASE
		WHEN T2.[English Language Arts III Writing 11 11 V002] = 'NULL' OR T2.[English Language Arts III Writing 11 11 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[English Language Arts III Writing 11 11 V002] < 24 THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS 'P/F'
	,CASE WHEN T2.[English Language Arts IV Reading 12 12 V001] IS NULL THEN '' ELSE T2.[English Language Arts IV Reading 12 12 V001] END AS [English Language Arts IV Reading 12 12 V001]
	,CASE
		WHEN T2.[English Language Arts IV Reading 12 12 V001] = 'NULL' OR T2.[English Language Arts IV Reading 12 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[English Language Arts IV Reading 12 12 V001] < 15 THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS 'P/F'
	,CASE WHEN T2.[English Language Arts IV Writing 12 12 V001] IS NULL THEN '' ELSE T2.[English Language Arts IV Writing 12 12 V001] END AS [English Language Arts IV Writing 12 12 V001]
	,CASE
		WHEN T2.[English Language Arts IV Writing 12 12 V001] = 'NULL' OR T2.[English Language Arts IV Writing 12 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[English Language Arts IV Writing 12 12 V001] < 26 THEN 'FAIL'
		ELSE 'PASS'
		END
	END AS 'P/F'
	,CASE WHEN T2.[Spanish Language Arts III Reading 11 11 V001] IS NULL THEN '' ELSE T2.[Spanish Language Arts III Reading 11 11 V001] END AS [Spanish Language Arts III Reading 11 11 V001]
	,CASE
		WHEN T2.[Spanish Language Arts III Reading 11 11 V001] = 'NULL' OR T2.[Spanish Language Arts III Reading 11 11 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Spanish Language Arts III Reading 11 11 V001] < 14 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[Spanish Language Arts III Writing 11 11 V001] IS NULL THEN '' ELSE T2.[Spanish Language Arts III Writing 11 11 V001] END AS [Spanish Language Arts III Writing 11 11 V001]
	,CASE
		WHEN T2.[Spanish Language Arts III Writing 11 11 V001] = 'NULL' OR T2.[Spanish Language Arts III Writing 11 11 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Spanish Language Arts III Writing 11 11 V001] < 15 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[NM History 7 12 V001] IS NULL THEN '' ELSE T2.[NM History 7 12 V001] END AS [NM History 7 12 V001]
	,CASE
		WHEN T2.[NM History 7 12 V001] = 'NULL' OR T2.[NM History 7 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[NM History 7 12 V001] < 18 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[New Mexico History 7 12 V001] IS NULL THEN '' ELSE T2.[New Mexico History 7 12 V001] END AS [New Mexico History 7 12 V001]
	,CASE
		WHEN T2.[New Mexico History 7 12 V001] = 'NULL' OR T2.[New Mexico History 7 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[New Mexico History 7 12 V001] < 18 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[US Government Comprehensive 9 12 V001] IS NULL THEN '' ELSE T2.[US Government Comprehensive 9 12 V001] END AS [US Government Comprehensive 9 12 V001]
	,CASE
		WHEN T2.[US Government Comprehensive 9 12 V001] = 'NULL' OR T2.[US Government Comprehensive 9 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[US Government Comprehensive 9 12 V001] < 24 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[US Government Comprehensive 9 12 V002] IS NULL THEN '' ELSE T2.[US Government Comprehensive 9 12 V002] END AS [US Government Comprehensive 9 12 V002]
	,CASE
		WHEN T2.[US Government Comprehensive 9 12 V002] = 'NULL' OR T2.[US Government Comprehensive 9 12 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[US Government Comprehensive 9 12 V002] < 24 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[US History 9 12 V001] IS NULL THEN '' ELSE T2.[US History 9 12 V001] END AS [US History 9 12 V001]
	,CASE
		WHEN T2.[US History 9 12 V001] = 'NULL' OR T2.[US History 9 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[US History 9 12 V001] < 26 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[US History 9 12 V002] IS NULL THEN '' ELSE T2.[US History 9 12 V002] END AS [US History 9 12 V002]
	,CASE
		WHEN T2.[US History 9 12 V002] = 'NULL' OR T2.[US History 9 12 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[US History 9 12 V002] < 31 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[World History And Geography 9 12 V001] IS NULL THEN '' ELSE T2.[World History And Geography 9 12 V001] END AS [World History And Geography 9 12 V001]
	,CASE
		WHEN T2.[World History And Geography 9 12 V001] = 'NULL' OR T2.[World History And Geography 9 12 V001] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[World History And Geography 9 12 V001] < 25 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
	,CASE WHEN T2.[Algebra II 10 12 V002] IS NULL THEN '' ELSE T2.[Algebra II 10 12 V002] END AS [Algebra II 10 12 V002]
	,CASE
		WHEN T2.[Algebra II 10 12 V002] = 'NULL' OR T2.[Algebra II 10 12 V002] IS NULL THEN ''
		ELSE
		CASE WHEN T2.[Algebra II 10 12 V002] < 14 THEN 'FAIL'
		ELSE 'PASS'
		END 
	END AS 'P/F'
FROM
(
SELECT
	rn,[ID NUMBER]
	,[Biology 9 12 V002]
	,[Biology 9 12 V003]
	,[Chemistry 9 12 V002]
	,[Chemistry 9 12 V003]
	,[Economics 9 12 V001]
	,[English Language Arts III Reading 11 11 V001]
	,[English Language Arts III Reading 11 11 V002]
	,[English Language Arts III Writing 11 11 V001]
	,[English Language Arts III Writing 11 11 V002]
	,[English Language Arts IV Reading 12 12 V001]
	,[English Language Arts IV Writing 12 12 V001]
	,[Spanish Language Arts III Reading 11 11 V001]
	,[Spanish Language Arts III Writing 11 11 V001]
	,[NM History 7 12 V001]
	,[New Mexico History 7 12 V001]
	,[US Government Comprehensive 9 12 V001]
	,[US Government Comprehensive 9 12 V002]
	,[US History 9 12 V001]
	,[US History 9 12 V002]
	,[World History And Geography 9 12 V001]
	,[Algebra II 10 12 V002]
	,last_name
	,first_name
	,School
	,Grade
	--,Subtest
	--,Score1 AS 'RAW SCORE'
	--,Score2 AS 'PASS/FAIL'
FROM
(
SELECT 
	  ROW_NUMBER () OVER (PARTITION BY [ID Number], [Subtest] ORDER BY [Score1] DESC) AS RN
      ,[ID Number]
      ,[Subtest]
      ,[Score1]
	  ,last_name
	  ,first_name
	  ,SCHOOL
	  ,GRADE
  FROM [SchoolNet].[dbo].[EOC_]
  WHERE Subtest IN ('Biology 9 12 V002','Biology 9 12 V003','Chemistry 9 12 V002','Chemistry 9 12 V003','Economics 9 12 V001','English Language Arts III Reading 11 11 V001','English Language Arts III Reading 11 11 V002','English Language Arts III Writing 11 11 V001','English Language Arts III Writing 11 11 V002','English Language Arts IV Reading 12 12 V001','English Language Arts IV Writing 12 12 V001','New Mexico History 7 12 V001','NM History 7 12 V001','Spanish Language Arts III Reading 11 11 V001','Spanish Language Arts III Writing 11 11 V001','US Government Comprehensive 9 12 V001','US Government Comprehensive 9 12 V002','US History 9 12 V001','US History 9 12 V002','World History And Geography 9 12 V001','Algebra II 10 12 V002')
) AS T1
pivot
(max([score1]) FOR subtest IN ([Biology 9 12 V002],[Biology 9 12 V003],[Chemistry 9 12 V002],[Chemistry 9 12 V003],[Economics 9 12 V001],[English Language Arts III Reading 11 11 V001],[English Language Arts III Reading 11 11 V002],[English Language Arts III Writing 11 11 V001],[English Language Arts III Writing 11 11 V002],[English Language Arts IV Reading 12 12 V001],[English Language Arts IV Writing 12 12 V001],[New Mexico History 7 12 V001],[NM History 7 12 V001],[Spanish Language Arts III Reading 11 11 V001],[Spanish Language Arts III Writing 11 11 V001],[US Government Comprehensive 9 12 V001],[US Government Comprehensive 9 12 V002],[US History 9 12 V001],[US History 9 12 V002],[World History And Geography 9 12 V001],[Algebra II 10 12 V002])) AS UP1

WHERE RN = 1

) AS T2
RIGHT JOIN
[EOC_AIMS_SBA_AND_EOC] AS SBA
ON
	T2.[ID Number] = SBA.ID_NBR
--WHERE READING IS NOT NULL
--WHERE [ID Number] = '104525936'
--where sba.school = '540' and sba.[CURRENT SY2014 GRADE] in ('12')
--order by sba.last_name
--OR (SBA.LAST_NAME = 'ABEYTA' AND SBA.FIRST_NAME = 'SAMUEL')
--WHERE SBA.School = '575' AND SBA.[CURRENT SY2014 GRADE] = '12'
--ORDER BY Grade

ROLLBACK