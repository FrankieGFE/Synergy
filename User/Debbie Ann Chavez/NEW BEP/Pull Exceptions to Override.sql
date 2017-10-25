
SELECT BEP.* FROM 

(
SELECT DISTINCT STUDENT_GU
FROM 
	dbo.BEPModelsAndHours
WHERE
QUALIFIED = 'Y'

) AS T1

INNER JOIN 
(
SELECT DISTINCT STUDENT_GU
FROM 
	dbo.BEPModelsAndHours
WHERE
QUALIFIED = 'N'

) AS T2

ON
T1.STUDENT_GU = T2.STUDENT_GU

INNER JOIN 
dbo.BEPModelsAndHours AS BEP
ON
T1.STUDENT_GU = BEP.STUDENT_GU

ORDER BY SIS_NUMBER