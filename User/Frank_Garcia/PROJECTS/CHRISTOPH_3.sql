


SELECT
	COUNT([District Student ID]) AS NUMBER
	,GRADE
	,PL
FROM
(
select 
	[District Student ID]
	,case when Grade = '0' then 'K' else grade
	end as grade
	,case when cast ([Composite (Overall) Proficiency Level] as varchar) >= '5' then 'proficient'
	      when cast([Composite (Overall) Proficiency Level] as varchar) < '5' then 'non proficient'
	end as proficiency
	,CASE WHEN [Composite (Overall) Proficiency Level] BETWEEN '1' AND '1.9' THEN 1
	      WHEN [Composite (Overall) Proficiency Level] BETWEEN '2' AND '2.9' THEN 2
		  WHEN [Composite (Overall) Proficiency Level] BETWEEN '3' AND '3.9' THEN 3
		  WHEN [Composite (Overall) Proficiency Level] BETWEEN '4' AND '4.9' THEN 4
		  WHEN [Composite (Overall) Proficiency Level] BETWEEN '5' AND '5.9' THEN 5
		  WHEN [Composite (Overall) Proficiency Level] BETWEEN '6' AND '6.9' THEN 6
	END AS PL
	,[Composite (Overall) Proficiency Level]

	,[School Number]
from ACCESS_2016_2017
where ([Composite (Overall) Proficiency Level] != '' and [Composite (Overall) Proficiency Level] != 'na')
) T1
GROUP BY
	grade, PL
order by grade, PL
