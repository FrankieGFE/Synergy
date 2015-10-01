
SELECT
	[SCHOOL_CODE]
	,[SCHOOL_NAME]
	,[MIN_Grades].[VALUE_DESCRIPTION] AS [MIN_GRADE]
	,[MAX_Grades].[VALUE_DESCRIPTION] AS [MAX_GRADE]
	,[TOTAL ENROLLMENTS]
	,[Spanish]
	,[Vietnamese]
FROM
	(
	SELECT
		[SCHOOL_CODE]
		,[SCHOOL_NAME]
		,MIN([LIST_ORDER]) AS [MIN_GRADE]
		,MAX([LIST_ORDER]) AS [MAX_GRADE]
		,COUNT([SIS_NUMBER]) AS [TOTAL ENROLLMENTS]
		,SUM(CASE WHEN [HOME_LANGUAGE] = 'Spanish' THEN 1 ELSE 0 END) AS [Spanish]
		,SUM(CASE WHEN [HOME_LANGUAGE] = 'Vietnamese' THEN 1 ELSE 0 END) AS [Vietnamese]
	FROM
		(
		SELECT DISTINCT
			[ENROLLMENT].[SCHOOL_CODE]
			,[ENROLLMENT].[SCHOOL_NAME]
			,[ENROLLMENT].[GRADE]
			,[ENROLLMENT].[LIST_ORDER]
			,[STUDENT].[SIS_NUMBER]
			,CASE WHEN [STUDENT].[HOME_LANGUAGE] IS NULL THEN [STUDENT].[CONTACT_LANGUAGE] ELSE [STUDENT].[HOME_LANGUAGE] END AS [HOME_LANGUAGE]
			
		FROM
			APS.PrimaryEnrollmentDetailsAsOf('09/09/2015') AS [ENROLLMENT]
			
			INNER JOIN
			APS.BasicStudentWithMoreInfo AS [STUDENT]
			ON
			[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
			
		WHERE
			[ENROLLMENT].[SCHOOL_CODE] IN
		('321',
		'204', 
		'206', 
		'207', 
		'210', 
		'213', 
		'214', 
		'215', 
		'329', 
		'216', 
		'225', 
		'228', 
		'229', 
		'339', 
		'234', 
		'236', 
		'237', 
		'240', 
		'241', 
		'243', 
		'244', 
		'249', 
		'252', 
		'219', 
		'262', 
		'255', 
		'258', 
		'261', 
		'230', 
		'267', 
		'270', 
		'395', 
		'273', 
		'276', 
		'279', 
		'231', 
		'282', 
		'285', 
		'288', 
		'373', 
		'291', 
		'297', 
		'336', 
		'300', 
		'303', 
		'260', 
		'365', 
		'364', 
		'250', 
		'305', 
		'307', 
		'309', 
		'310', 
		'315', 
		'324', 
		'327', 
		'227', 
		'275', 
		'333', 
		'330', 
		'392', 
		'356', 
		'357', 
		'280', 
		'363', 
		'370', 
		'376', 
		'379', 
		'385', 
		'388', 
		'496', 
		'407', 
		'450', 
		'410', 
		'413', 
		'415', 
		'416', 
		'418', 
		'420', 
		'490', 
		'425', 
		'445', 
		'405', 
		'427', 
		'435', 
		'440', 
		'448', 
		'455', 
		'457', 
		'475', 
		'460', 
		'840', 
		'465', 
		'470', 
		'590', 
		'035', 
		'576', 
		'514', 
		'520', 
		'530', 
		'549', 
		'540', 
		'597', 
		'560', 
		'570')
		
		) AS [STUDENTS]
		
	GROUP BY
		[SCHOOL_CODE]
		,[SCHOOL_NAME]
	) AS [SCHOOLS]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [MIN_Grades]
	ON
	[SCHOOLS].[MIN_GRADE] = [MIN_Grades].[LIST_ORDER]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [MAX_Grades]
	ON
	[SCHOOLS].[MAX_GRADE] = [MAX_Grades].[LIST_ORDER]