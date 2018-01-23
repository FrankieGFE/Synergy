--One Roseter Courses.csv --

select
crs.COURSE_ID			AS [sourcedId]
, ''					AS [status]  --must be blank--
, ''					AS [dateLastModified]  --must be blacnk--
, 'FY'					AS [schoolYearSourcedId]
, crs.COURSE_TITLE		AS [title]
, crs.COURSE_ID			AS [courseCode]
, CASE WHEN crs.GRADE_RANGE_LOW = '090'THEN 'PK'
	   WHEN crs.GRADE_RANGE_LOW = '100'THEN 'KG'
	   WHEN crs.GRADE_RANGE_LOW = '110'THEN '01'
	   WHEN crs.GRADE_RANGE_LOW = '120'THEN '02'
	   WHEN crs.GRADE_RANGE_LOW = '130'THEN '03'
	   WHEN crs.GRADE_RANGE_LOW = '140'THEN '04'
	   WHEN crs.GRADE_RANGE_LOW = '150'THEN '05'
	   WHEN crs.GRADE_RANGE_LOW = '160'THEN '06'
	   WHEN crs.GRADE_RANGE_LOW = '170'THEN '07'
	   WHEN crs.GRADE_RANGE_LOW = '180'THEN '08'
	   WHEN crs.GRADE_RANGE_LOW = '190'THEN '09'
	   WHEN crs.GRADE_RANGE_LOW = '200'THEN '10'
	   WHEN crs.GRADE_RANGE_LOW = '210'THEN '11'
	   WHEN crs.GRADE_RANGE_LOW = '220'THEN '12'

ELSE ''
END + '-' +
 CASE WHEN crs.GRADE_RANGE_HIGH = '090'THEN 'PK'
	   WHEN crs.GRADE_RANGE_HIGH = '100'THEN 'KG'
	   WHEN crs.GRADE_RANGE_HIGH = '110'THEN '01'
	   WHEN crs.GRADE_RANGE_HIGH = '120'THEN '02'
	   WHEN crs.GRADE_RANGE_HIGH = '130'THEN '03'
	   WHEN crs.GRADE_RANGE_HIGH = '140'THEN '04'
	   WHEN crs.GRADE_RANGE_HIGH = '150'THEN '05'
	   WHEN crs.GRADE_RANGE_HIGH = '160'THEN '06'
	   WHEN crs.GRADE_RANGE_HIGH = '170'THEN '07'
	   WHEN crs.GRADE_RANGE_HIGH = '180'THEN '08'
	   WHEN crs.GRADE_RANGE_HIGH = '190'THEN '09'
	   WHEN crs.GRADE_RANGE_HIGH = '200'THEN '10'
	   WHEN crs.GRADE_RANGE_HIGH = '210'THEN '11'
	   WHEN crs.GRADE_RANGE_HIGH = '220'THEN '12'	
	  ELSE ''
	  END			
AS [grades]
, 'RCPS'			AS [orgSourcedId]
, ''				AS [subjects]
, ''				AS [subjectCodes]  --must be blank--

from rev.epc_crs crs

where crs.YEAR_END IS NULL
and crs.COURSE_TITLE not like '%Homeroom%'
and crs.COURSE_TITLE not like '%Lunch%'
and crs.COURSE_TITLE not like '%AIDE%'
and crs.COURSE_TITLE not like '%Work Release%'
and crs.COURSE_TITLE not like '%Study Hall%'
and crs.COURSE_TITLE not like '%Sr Release%'
and crs.COURSE_TITLE not like '%Out of Building%'
and crs.COURSE_TITLE not like '%BCAT%'