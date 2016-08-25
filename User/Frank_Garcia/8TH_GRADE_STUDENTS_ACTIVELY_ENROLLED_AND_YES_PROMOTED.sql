/*
Frank – need youR help please getting the data for Item 1. In the attached request.  
It looks like you could use the Year End Status in Synergy back to 2010-2011.  
They want counts from 2010-2011 thru 2014-2015 (5 years).

Count of all 8th graders by school in each year who ended the year actively enrolled.
Count of all 8th graders by school in each year who ended the year actively enrolled *and* Year End Status=Promoted.

17 AUGUST 2016

*/



SELECT 
	SCHOOL_CODE
	,COUNT(SIS_NUMBER) PROMOTED
FROM
	APS.StudentEnrollmentDetails
WHERE 1 = 1
	AND SCHOOL_YEAR = '2011'
	AND GRADE = '08'
	AND LEAVE_CODE IS NULL
	AND EXTENSION = 'R'
	AND SUMMER_WITHDRAWL_CODE IS NULL
	AND YEAR_END_STATUS = 'P' --- COMMENT OUT FOR ACTIVELY ENROLLED ONLY
	and SCHOOL_CODE in ('452')
GROUP BY
	SCHOOL_CODE
ORDER BY SCHOOL_CODE

SELECT 
	SCHOOL_CODE
	,COUNT(SIS_NUMBER) ENROLLED
FROM
	APS.StudentEnrollmentDetails
WHERE 1 = 1
	AND SCHOOL_YEAR = '2011'
	AND GRADE = '08'
	AND LEAVE_CODE IS NULL
	AND EXTENSION = 'R'
	AND SUMMER_WITHDRAWL_CODE IS NULL
	--AND YEAR_END_STATUS = 'P' --- COMMENT OUT FOR ACTIVELY ENROLLED ONLY
	and SCHOOL_CODE in ('452')
GROUP BY
	SCHOOL_CODE
ORDER BY SCHOOL_CODE
