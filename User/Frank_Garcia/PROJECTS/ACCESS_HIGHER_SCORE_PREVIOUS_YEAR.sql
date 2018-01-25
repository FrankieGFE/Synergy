USE [SchoolNet]
GO
SELECT
	*
FROM
(
SELECT 
      ROW_NUMBER () OVER (PARTITION BY ONE.[State Student ID],ONE.[Comprehension Proficiency Level],ONE.[Date of Testing] ORDER BY ONE.[Date of Testing]) AS RN,
	  ONE.[School Name]
      ,ONE.[School Number]
      ,ONE.[Student Last Name]
      ,ONE.[Student First Name]
      ,ONE.[Student Middle Initial]
      ,ONE.[Birth Date]
      ,ONE.[Gender]
      ,ONE.[State Student ID]
      ,ONE.[District Student ID]
      ,ONE.[Grade]
      ,ONE.[Composite (Overall) Scale Score]
      ,ONE.[Composite (Overall) Proficiency Level] AS 'Overall PL - 2014-2015'
	  ,CCR.[Composite (Overall) Proficiency Level] AS 'Overall PL - Previous Years'
      ,ONE.[Date of Testing] AS 'Test Date 2014-2015'
	  ,CCR.[Date of Testing] AS 'Test Date Previous Years'
      ,ONE.[SCH_YR]
	  ,CCR.SCH_YR AS 'Previous SCH YR'
  FROM [dbo].[CCR_ACCESS] AS ONE
  LEFT JOIN CCR_ACCESS AS CCR
  ON ONE.[District Student ID] = CCR.[District Student ID]
  WHERE ONE.SCH_YR = '2014-2015'
  AND CCR.SCH_YR != '2014-2015'
  AND CCR.[Composite (Overall) Proficiency Level] >= '5'
) AS T1
WHERE RN = 1
ORDER BY [Student Last Name], [Student First Name]
GO


