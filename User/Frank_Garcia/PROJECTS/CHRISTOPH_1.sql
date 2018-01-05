

select
	count ([district student id]) as counts
	,grade
	,proficiency
	--,[School Number]
	from
	(
select 
	[District Student ID]
	,case when Grade = '0' then 'K' else grade
	end as grade
	,case when cast ([Composite (Overall) Proficiency Level] as varchar) >= '5' then 'proficient'
	      when cast([Composite (Overall) Proficiency Level] as varchar) < '5' then 'non proficient'
	end as proficiency
	,[School Number]
from ACCESS_2016_2017
where ([Composite (Overall) Proficiency Level] != '' and [Composite (Overall) Proficiency Level] != 'na')

) tt
group by grade, proficiency

order by  grade, proficiency