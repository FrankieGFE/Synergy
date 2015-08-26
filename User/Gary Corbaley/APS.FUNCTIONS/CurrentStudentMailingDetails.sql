/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/26/2015 $
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 08/26/2015
 * 
 * This script will pull mailing info for currently enrolled students.
 * One Record Per Student
 */

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[CurrentStudentMailingDetails]'))
	EXEC ('CREATE VIEW APS.CurrentStudentMailingDetails AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.CurrentStudentMailingDetails AS

SELECT
	-- Basic Student Demographics	
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[MIDDLE_NAME]	
	,[STUDENT].[MAIL_ADDRESS] AS [MAIL_ADDRESS]
	,[STUDENT].[MAIL_ADDRESS_2] AS [MAIL_ADDRESS_2]
	,[STUDENT].[MAIL_CITY] AS [MAIL_CITY]
	,[STUDENT].[MAIL_STATE] AS [MAIL_STATE]
	,[STUDENT].[MAIL_ZIP] AS [MAIL_ZIP]
    
    -- Prefered Home Contact Language
    ,CASE WHEN [Contact_Language].[VALUE_DESCRIPTION] IS NULL THEN [STUDENT].[HOME_LANGUAGE] ELSE [Contact_Language].[VALUE_DESCRIPTION] END AS [HOME_LANGAUGE]
    
    ,[ENROLLMENT].[GRADE]
    ,[ENROLLMENT].[SCHOOL_NAME]    
    
    ,[STU_PARENT].[FIRST_NAME] AS [PARENT_FIRST_NAME]
    ,[STU_PARENT].[LAST_NAME] AS [PARENT_LAST_NAME]
    
    ----------------------------------------------------
    -- LIST OF GU'S
    ,[STUDENT].[STUDENT_GU]
    
        
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT JOIN
    rev.EPC_STU_PGM_ELL AS [ELL_PGM]
    ON
    [STUDENT].[STUDENT_GU] = [ELL_PGM].[STUDENT_GU]
		
	-- Get Home Contact Language
	LEFT JOIN
	APS.LookupTable ('K12', 'Language') AS [Contact_Language]	
	ON
	[ELL_PGM].[LANGUAGE_TO_HOME] = [Contact_Language].[VALUE_CODE]	
	
	-- Get Primary Parents First and Last Names.
	LEFT OUTER JOIN
	(
		SELECT 
			stu.STUDENT_GU
		  , COALESCE(spar.ORDERBY, (ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.ORDERBY))) rn
		  , pper.FIRST_NAME 
		  , pper.LAST_NAME
		FROM rev.EPC_STU stu
		JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.LIVES_WITH = 'Y'
		JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
	) AS [STU_PARENT]
	ON
	[STUDENT].[STUDENT_GU] = [STU_PARENT].[STUDENT_GU]
	AND [STU_PARENT].[rn] = 1