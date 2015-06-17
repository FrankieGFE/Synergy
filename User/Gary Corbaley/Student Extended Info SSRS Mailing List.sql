/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 05/19/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 10/09/2014
 * 
 *
 */



DECLARE @School VARCHAR = '%'
DECLARE @AsOfDate DATETIME = GETDATE()
DECLARE @Grade AS VARCHAR(2) = '05'
DECLARE @Buisness AS VARCHAR(1) = 'Y'
DECLARE @University AS VARCHAR(1) = 'N'
DECLARE @Military AS VARCHAR(1) = 'N'



SELECT
	[Student].[FIRST_NAME]
	,[Student].[LAST_NAME]
	,[Student].[MIDDLE_NAME]
	,[Student].[SIS_NUMBER]
	,[Student].[ELL_STATUS]
	,[Student].[SPED_STATUS]
	,[Student].[CONTACT_LANGUAGE]
	,[Enrollments].[GRADE] AS [GRADE_LEVEL]
    ,[Enrollments].[SCHOOL_NAME]
    ,[Enrollments].[SCHOOL_CODE]
    ,[Student].[PRIMARY_PHONE]
	,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS] ELSE [Student].[MAIL_ADDRESS] END AS [ADDRESS]
    ,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS_2] ELSE [Student].[MAIL_ADDRESS_2] END AS [ADDRESS_2]
    ,CASE WHEN [Student].[MAIL_CITY] IS NULL THEN [Student].[HOME_CITY] ELSE [Student].[MAIL_CITY] END AS [CITY]
    ,CASE WHEN [Student].[MAIL_STATE] IS NULL THEN [Student].[HOME_STATE] ELSE [Student].[MAIL_STATE] END AS [STATE]
    ,CASE WHEN [Student].[MAIL_ZIP] IS NULL THEN [Student].[HOME_ZIP] ELSE [Student].[MAIL_ZIP] END AS [ZIP]
	,[Student].[Parents]
FROM
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS [Enrollments]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [Student] 
	ON
	[Enrollments].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	LEFT JOIN
	rev.[UD_STU] AS [STUDENT_EXCEPTIONS]
	ON
	[Student].[STUDENT_GU] = [STUDENT_EXCEPTIONS].[STUDENT_GU]
	
	--LEFT JOIN
	--rev.[EPC_STU_PARENT] AS [STUDENT_PARENT]
	--ON
	--[STUDENT].[STUDENT_GU] = [STUDENT_PARENT].[STUDENT_GU]
	--AND [STUDENT_PARENT].[LIVES_WITH] = 'Y'
	
	-- Get concatenated list of parent names
	--LEFT JOIN
	--(
	--SELECT
	--   PNm.STUDENT_GU
	--, ROW_NUMBER() OVER(PARTITION BY PNm.STUDENT_GU order by PNm.STUDENT_GU) rno
	--, Parents = STUFF(  COALESCE(', ' + Pnm.[1], '')
	--				   + COALESCE(', ' + Pnm.[2], '') 
	--				   + COALESCE(', ' + Pnm.[3], '') 
	--				   + COALESCE(', ' + Pnm.[4], '') 
	--				   , 1, 1,'')
	--FROM
	--  (
	--	SELECT 
	--		stu.STUDENT_GU
	--	  , COALESCE(spar.ORDERBY, (ROW_NUMBER() OVER(PARTITION BY spar.STUDENT_GU order by spar.STUDENT_GU))) rn
	--	  , pper.FIRST_NAME + ' ' +  pper.LAST_NAME [pname]
	--	FROM rev.EPC_STU stu
	--	JOIN rev.EPC_STU_PARENT spar ON spar.STUDENT_GU = stu.STUDENT_GU AND spar.LIVES_WITH = 'Y'
	--	JOIN rev.REV_PERSON pper     ON pper.PERSON_GU  = spar.PARENT_GU
	--  ) 
	--  pn PIVOT (min(pname) for rn in ([1], [2], [3], [4])) PNm
	--) AS [PARENT_NAMES]
	--ON
	--[STUDENT].[STUDENT_GU] = [PARENT_NAMES].[STUDENT_GU] 
	--AND [PARENT_NAMES].[rno] = 1
	
WHERE
	--[Enrollments].[ORGANIZATION_GU] LIKE @School
	--AND [Enrollments].[GRADE] LIKE @Grade
	
	[Enrollments].[GRADE] IN ('08')
	--AND [Enrollments].[SCHOOL_CODE] IN ('452','407','427','485','440','435','420','418','455','448')
	AND [Enrollments].[SCHOOL_CODE] IN ('470','460','416','413','427')
	
	--[Enrollments].[GRADE] IN ('09')
	--AND [School].[SCHOOL_CODE] IN ('452','407','427','485','440','435','420','418','455','448')
	--AND [Enrollments].[SCHOOL_CODE] IN ('514')
	--AND [Organization].[ORGANIZATION_NAME] LIKE '%Sandia%'
	--AND [Student].[MAIL_ZIP] IN ('87123','87112','87111','87108','87106')
	
--	--- EXCEPTIONS
	AND ([STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] != @Buisness OR @Buisness = 'N')
	AND ([STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] != @University OR @University = 'N')
	AND ([STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] IS NULL OR [STUDENT_EXCEPTIONS].[EXCLUDE_MILITARY] != @Military OR @Military = 'N')
	
ORDER BY
	[Enrollments].[SCHOOL_NAME]
	,[Student].[LAST_NAME]