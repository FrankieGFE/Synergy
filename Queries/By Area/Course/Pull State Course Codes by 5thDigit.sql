
/*
*	Created By:  Debbie Ann Chavez
*	Date:  7/2/2014
*
*	Pull State Course Codes that do not contain an 8 in the 5th digit.  8 = Bilingual.  For Active courses only.
*
*/

USE ST_Functional
GO

SELECT
	SUBSTRING(STATE_COURSE_CODE,5,1) AS [5THDIGIT]
	,STATE_COURSE_CODE
	,COURSE_ID
	,COURSE_TITLE
FROM
	rev.EPC_CRS
WHERE
	SUBSTRING(STATE_COURSE_CODE,5,1) != 8
	AND INACTIVE = 'N'
ORDER BY [5THDIGIT]