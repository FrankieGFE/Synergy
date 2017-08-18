

/**********************************************************

Pull All Active Staff (non-teachers) for Clever and Canvas

**********************************************************/


SELECT * FROM 
APS.ActiveEmployeesAllAssignments AS EMP

WHERE
SCHEDULE NOT LIKE 'A SCH%'

ORDER BY EMPLOYEE