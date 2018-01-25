USE Assessments
GO
SELECT
	T1.Last
	,STU.last_name
	,T1.IDNum
	,T1.First
	,STU.first_name
	,STU.student_code
FROM
(
SELECT 
      ROW_NUMBER () OVER (PARTITION BY [IDNum] ORDER BY [IDNum]) AS RN
	  ,[First]
      ,[Last]
      ,[DistNum]
      ,[IDNum]
      ,[TestID]
      ,[Subtest]
      ,[SchoolYear]
      ,[Test Date]
      ,[School]
      ,[Grade]
      ,LTRIM(RTRIM([Score1])) AS SCORE1
      ,[Score2]
      ,[SCH_YR]
  FROM [dbo].[WAPT]
  WHERE SCH_YR = '2015-2016'

) AS T1
  LEFT JOIN
  ALLSTUDENTS AS STU
  ON T1.IDNum = STU.student_code
WHERE RN > 0
AND LEFT(T1.LAST,3) != LEFT(STU.LAST_NAME,3)
AND LEFT(T1.First,3) != LEFT(STU.first_name,3)

--and idnum = '104059316'
--AND  IDNum NOT IN ('980009632','')

ORDER BY T1.Last

GO


