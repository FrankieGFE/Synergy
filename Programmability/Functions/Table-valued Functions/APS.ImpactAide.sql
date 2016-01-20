/**
 * Created By:  Sean McMurray
 * Date:  1/20/2016
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ImpactAide]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ImpactAide() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ImpactAide
 * 
 * This pulls all Active Students that have Parent data in the Parent Log table.  
 *
 *
 */


ALTER FUNCTION APS.ImpactAide(@AsOfDate AS DATE)
RETURNS TABLE
AS
RETURN	

--DECLARE @AsOfDate DATETIME = GETDATE()


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

	,DATE AS [Impact Date]
	,DATE_RESENT_ERROR AS [Resent Error]
	,DATE_RETURNED_ERROR AS [Returned Error]
	,DATE_SURVEY_RETURNED AS [Survey Returned]
	,LU.VALUE_DESCRIPTION AS [How First Qualified]
	,HOW_SECOND_PARENT_QUALIFIED AS [How Second Qualified]
	,QUALIFIED AS [Qualified]
	,REFUSED_TO_SIGN AS [Refused]
	,SECOND_PARENT_QUALIFIED AS [Second Qualified]


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
	rev.UD_PARENT_LOG  AS LOGS ON [PARENT_NAMES].PARENT_GU = LOGS.PARENT_GU

	INNER JOIN
	APS.LookupTable('Revelation.UD.ParentGuardianInfo', 'Howfirstparentqualified') AS LU
	ON
	LOGS.HOW_FIRST_PARENT_QUALIFIED = LU.VALUE_CODE
	
WHERE
LOGS.DATE IS NOT NULL