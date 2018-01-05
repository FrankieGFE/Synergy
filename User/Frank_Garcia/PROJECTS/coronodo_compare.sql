select
	syn.student_code
	,aims.[APS ID] aims_id
	,pe.SIS_NUMBER pe_id
	,syn.FIRST_NAME sy_id
	,syn.LAST_NAME
	,syn.GRADE
from
	coronodo_synergy as syn
	left join
	coronodo as aims
	on syn.student_code = aims.[APS ID]
	left join
	coronodo_primaryenrollment as pe
	on syn.student_code = pe.SIS_NUMBER

order by SIS_NUMBER