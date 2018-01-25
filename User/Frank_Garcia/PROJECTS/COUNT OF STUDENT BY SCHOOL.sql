SELECT
	SCH_NBR
	,COUNT(ID_NBR) [Enrollment Last Day]
FROM
	APS.EnrollmentMemberDaysAsOf ('20130516') AS MEMDAYS	
INNER JOIN 
	APS.PrimaryEnrollmentsAsOf ('20130516') AS CPE
ON 
	MEMDAYS.[Enrollment_Id] = CPE._Id
WHERE
	CPE.DST_NBR = 1	
group by 
	CPE.SCH_NBR
