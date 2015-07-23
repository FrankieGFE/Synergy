



EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	SynSISNUMBER
	,Grade
	,School
	,AppSch
	, SCH.ORGANIZATION_NAME
	, SCH.SIS_NUMBER
	, SCH.COURSE_ID
	, SCH.COURSE_TITLE
	, SCH.CREDIT
	, SCH.DEPARTMENT
	, SCH.SUBJECT_AREA_1
	, SCH.COURSE_ENTER_DATE
	, SCH.SECTION_ID
	, SCH.ROOM_SIMPLE
	, SCH.TERM_CODE
	, SCH.PERIOD_BEGIN
	, SCH.PERIOD_END
	, SCH.ENROLLMENT_ENTER_DATE
	,SCH.ENROLLMENT_LEAVE_DATE
	,SCH.ENROLLMENT_GRADE_LEVEL

 FROM 
       OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from TEST.csv'
                ) AS [Approvals]

	INNER JOIN 
		rev.EPC_STU AS STU
		ON 
		[Approvals].SynSISNUMBER = STU.SIS_NUMBER
	LEFT JOIN 
		APS.ScheduleAsOf('2015-08-13') AS SCH
		ON
		SCH.STUDENT_GU = STU.STUDENT_GU

WHERE [AppSch] > '400'

REVERT
GO
