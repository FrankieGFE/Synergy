USE [ST_Production]
GO

/****** Object:  View [APS].[CleverAdmins]    Script Date: 8/21/2017 1:50:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/**********************************************************

Pull All Active Staff (non-teachers) for Clever and Canvas

**********************************************************/

/*
	Created by Debbie Ann Chavez 
	Date 8/7/2017
*/


CREATE VIEW [APS].[CleverAdmins] AS


SELECT 

	School_id
	,Staff_id
	,Admin_email
	,First_name
	,Last_name
	,Admin_title
	,Username
	,[Password]

FROM(

SELECT 
	EMP.School_id
	,EMP.Staff_id
	,EMAIL_ADDRESS AS Admin_email
	,FIRST_NAME AS First_name
	, LAST_NAME AS Last_name
	,[DESCRIPTION] AS Admin_title
	,'' AS Username
	,'' AS [Password]

	--ONLY PULL TECHNOLOGY FOLKS AT 068 -- I DO NOT HAVE 011 HERE UNLESS REQUESTED --
	,CASE WHEN School_id IN ('068', '053') THEN 'Y' 
		  WHEN LOGIN_NAME IS NOT NULL THEN 'Y'
		ELSE 'N' END AS PULLADMINS
	,LOGIN_NAME	  
			
FROM
--PULL ALL NON TEACHERS FROM LAWSON
 (
	SELECT 
		LOCATION AS School_id
		,'e' + RIGHT('000000'+ CONVERT (VARCHAR (6), CAST(EMP.EMPLOYEE AS VARCHAR)), 6) AS Staff_id
		,EMAIL_ADDRESS
		,FIRST_NAME, LAST_NAME
		,[DESCRIPTION]
	 FROM 
	[180-SMAXODS-01.APS.EDU.ACTD].LAWSON.APS.ActiveEmployeeMostRecentAssignment AS EMP
 
	 INNER JOIN 
	 (SELECT DISTINCT POSITION, [DESCRIPTION] FROM [180-SMAXODS-01.APS.EDU.ACTD].LAWSON.dbo.PAPOSITION WHERE END_DATE IS NULL) AS PAP
	  ON
	  EMP.POSITION = PAP.POSITION
	WHERE 
	SCHEDULE NOT LIKE 'A SCH%' ) AS EMP

--ONLY PULL IN ADMINS THAT ARE ALREADY USERS IN SYNERGY WITH THE EXCEPTION OF 068/TECHNOLOGY, INCLUDE THEM 
LEFT JOIN 
REV.REV_USER AS USR
ON
USR.LOGIN_NAME = EMP.Staff_id

) AS T1

WHERE 
	T1.PULLADMINS = 'Y'


--ORDER BY School_id

GO


