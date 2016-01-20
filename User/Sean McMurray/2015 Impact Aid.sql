

DECLARE @AsOfDate DATETIME = GETDATE()


------------------------------------------------------------------------------
-- DEFINE MAIN SELECT

SELECT 
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[BIRTH_DATE] AS [DOB]
	,GRADE
	,SCHOOL_NAME
	,[PARENT_NAMES].[Parents]

	,rev.UD_PARENT_LOG.DATE AS [Impact Date]
	,rev.UD_PARENT_LOG.DATE_RESENT_ERROR AS [Resent Error]
	,rev.UD_PARENT_LOG.DATE_RETURNED_ERROR AS [Returned Error]
	,rev.UD_PARENT_LOG.DATE_SURVEY_RETURNED AS [Survey Returned]
	,rev.UD_PARENT_LOG.HOW_FIRST_PARENT_QUALIFIED AS [First Qualified]
	,rev.UD_PARENT_LOG.HOW_SECOND_PARENT_QUALIFIED AS [Second Qualified]
	,rev.UD_PARENT_LOG.QUALIFIED AS [Qualified]
	,rev.UD_PARENT_LOG.REFUSED_TO_SIGN AS [Refused]
	,rev.UD_PARENT_LOG.SECOND_PARENT_QUALIFIED AS [Second Qualified]


FROM
	----------------------------------------------------------
	-- Enrollment Details
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS PRIM
	
	--------------------------------------------------------------------
	-- Student Details
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	PRIM.[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	-- Get student info
	INNER JOIN
	rev.EPC_STU AS [EPC_STU]
	ON
	[STUDENT].[STUDENT_GU] = [EPC_STU].[STUDENT_GU]
	
	-- Get student personal details
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
	-- Get concatenated list of parent names
	INNER JOIN
	(
	SELECT 
			stu.STUDENT_GU
		  , pper.FIRST_NAME + ' ' +  pper.LAST_NAME AS [Parents]
		  , spar.PARENT_GU
		FROM rev.EPC_STU stu
		JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.CONTACT_ALLOWED = 'Y'
		JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
		INNER JOIN
	rev.EPC_PARENT AS [PARENT]
	ON
	spar.[PARENT_GU] = [PARENT].[PARENT_GU]
	) AS [PARENT_NAMES]
	ON
	[STUDENT].[STUDENT_GU] = [PARENT_NAMES].[STUDENT_GU] 
	
	INNER JOIN
	rev.UD_PARENT_LOG ON [PARENT_NAMES].PARENT_GU = rev.UD_PARENT_LOG.PARENT_GU
	
WHERE
rev.UD_PARENT_LOG.DATE IS NOT NULL