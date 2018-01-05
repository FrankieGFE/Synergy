BEGIN TRAN

update ia

set
	ia.school_code = STARS.[location code]
	,ia.dob = STARS.[BIRTHDATE]
	,IA.student_code = STARS.[ALTERNATE STUDENT ID]
	


from
	[180-smaxods-01].schoolnet.dbo.Interim_Assessment as ia
inner join
[046-WS02].db_STARS_History.dbo.student as stars
on
ia.last_name = stars.[LAST NAME LONG]
AND ia.first_name = STARS.[FIRST NAME LONG]

where
	BAD_ID is not null
	AND STARS.PERIOD = '2013-12-15'
	--AND LEFT (IA.student_code, 3) = LEFT (STARS.[ALTERNATE STUDENT ID], 3)
	

--select * from [180-smaxods-01].schoolnet.dbo.interim_Assessment

