SELECT
	SCH_NBR
	,SUM(MemberDays)
FROM
	APS.EnrollmentMemberDaysAsOf ('20121211') AS MEMDAYS	
INNER JOIN 
	APS.PrimaryEnrollmentsAsOf ('20121211') AS CPE
ON 
	MEMDAYS.[Enrollment_Id] = CPE._Id
WHERE
	CPE.DST_NBR = 1	
GROUP BY
	CPE.SCH_NBR