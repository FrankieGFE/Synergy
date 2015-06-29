
SELECT 
	[Student Number]
	,[School Number]
	,LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1)
	,[Class Key]
	,CASE WHEN LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1) = 'C' THEN 'Cibola'
		  WHEN LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1) = 'W' AND [Class Key] LIKE 'INTERMED%' THEN 'Wilson'
		  WHEN LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1) = 'W' AND [Class Key] LIKE 'ADVANCED ESL%' THEN 'Wilson'
		  WHEN LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1) = 'W' THEN 'West Mesa'
		  WHEN LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1) = 'S' THEN 'Sandia'
		  WHEN LEFT(substring([Class Key],charindex('-',[Class Key])+1 ,250),1) = 'E' THEN 'Ecademy'
	ELSE '' END AS SCHOOL
			
FROM 
SchoolMessenger.StudentSchedule
WHERE
[School Number] = '533'
--AND [Class Key] LIKE '%20903%'

ORDER BY SCHOOL, [Class Key]