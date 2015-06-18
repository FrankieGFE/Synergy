



SELECT --top 100
	[ENROLLMENTS].[SCHOOL_CODE]			AS [Sch #]
	--,[ENROLLMENTS].[SCHOOL_NAME]		
	,[Schedule].[COURSE_TITLE]			AS [Course Name]
	,[Schedule].[COURSE_ID]				AS [Course #]
	,[Schedule].[SECTION_ID]			AS [Section]
	,[Schedule].[PRIMARY_STAFF]			AS [Employee Num]
	,[Schedule].[PERIOD_BEGIN]			AS [Period]
	,[STUDENT].[SIS_NUMBER]				AS [Student ID]
	,[Schedule].[SUBJECT_AREA_1]		AS [Dept]
	, CASE WHEN NOT EXISTS           
			 (SELECT symd.MEET_DAY_CODE 
		   FROM rev.EPC_SCH_YR_SECT_MET_DY sysmd
		   JOIN rev.EPC_SCH_YR_MET_DY      symd ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
		   WHERE sysmd.SECTION_GU = [Schedule].[SECTION_GU]
		  )
	THEN 'M,T,W,R,F'   
	ELSE               
			 STUFF((SELECT [*]=', '+(LEFT(symd.MEET_DAY_CODE,1))  
					FROM rev.EPC_SCH_YR_SECT sec    
					JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
					JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
					WHERE sec.SECTION_GU  = [Schedule].[SECTION_GU]    
					ORDER BY symd.ORDERBY    
					FOR XML PATH('')
				   ),1,2,'')    
	END                                 AS [Cycle Days]
	,CONVERT(VARCHAR(10),[TERMDATES].[TermBegin],101)		AS [Class Start Day]
	,CONVERT(VARCHAR(10),[TERMDATES].[TermEnd],101)				AS [Class End Date]
  
  --,[Schedule].[ORGANIZATION_YEAR_GU]
  --,[Schedule].*
  --,[TERMINFO].*
  --,[Section].*
  
  --,[Schedule].[TERM_CODE]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]	

	INNER JOIN
	APS.StudentScheduleDetails AS [Schedule]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [Schedule].[STUDENT_GU]
	AND [ENROLLMENTS].[YEAR_GU] = [Schedule].[YEAR_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.TermDatesAsOF(GETDATE()) AS [TERMDATES]
	ON
	[Schedule].[ORGANIZATION_YEAR_GU] = [TERMDATES].[OrgYearGu]
	AND [Schedule].[TERM_CODE] = [TERMDATES].[TermCode]
	
WHERE
	[ENROLLMENTS].[YEAR_GU] IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)