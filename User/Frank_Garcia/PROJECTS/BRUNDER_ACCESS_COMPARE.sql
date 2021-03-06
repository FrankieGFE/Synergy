USE SchoolNet
SELECT 
      ACCESS_2013.[District Student ID] AS APS_ID
	  ,ACCESS_2013.[School Number] AS '2013-2014 SCHOOL'
      ,ACCESS_2013.[Grade] AS '2013-2014 GRADE'
      ,ACCESS_2013.[Composite (Overall) Scale Score] AS '2013-2014 Composite (Overall) Scale Score'
      ,ACCESS_2013.[Composite (Overall) Proficiency Level] AS '2013-2014 Composite (Overall) Proficiency Level'
	  ,ACCESS_2014.[School Number] AS '2014-2015 SCHOOL'
      ,CASE
		WHEN ACCESS_2014.[Grade] = '00' THEN 'K' ELSE ACCESS_2014.[Grade] 
	  END AS '2014-2015 GRADE'
      ,ACCESS_2014.[Composite (Overall) Scale Score] AS '2014-2015 Composite (Overall) Scale Score'
      ,ACCESS_2014.[Composite (Overall) Proficiency Level] AS '2014-2015 Composite (Overall) Proficiency Level'  
	  ,ACCESS_2013.Tier
	  ,ACCESS_2014.Tier
	  ,CASE
		WHEN ACCESS_2013.[Composite (Overall) Proficiency Level] > ACCESS_2014.[Composite (Overall) Proficiency Level] THEN 'X' ELSE ''
	 END AS GROWTH
 
  FROM [dbo].[CCR_ACCESS] AS ACCESS_2013
  JOIN
  [dbo].[CCR_ACCESS] AS ACCESS_2014
  ON
  ACCESS_2013.[District Student ID] = ACCESS_2014.[District Student ID]

  WHERE ACCESS_2013.SCH_YR = '2013-2014'
  AND ACCESS_2014.SCH_YR = '2014-2015'
  AND ACCESS_2013.[District Student ID] != ''
  AND ACCESS_2014.[District Student ID] != ''

  ORDER BY ACCESS_2013.[District Student ID]