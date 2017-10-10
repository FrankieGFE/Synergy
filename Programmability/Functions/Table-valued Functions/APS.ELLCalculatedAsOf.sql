USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[ELLCalculatedAsOf]    Script Date: 10/10/2017 4:20:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/**

 */
ALTER FUNCTION [APS].[ELLCalculatedAsOf](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT
	Enroll.*
	/*
	Enroll.STUDENT_GU
	,Enroll.ORGANIZATION_YEAR_GU
	,Enroll.STUDENT_SCHOOL_YEAR_GU
	,Enroll.ENROLLMENT_GU
	,Enroll.GRADE
	,Enroll.ENTER_DATE
	,Enroll.LEAVE_DATE
	*/
	,Assessment.ADMIN_DATE
	,Assessment.PERFORMANCE_LEVEL
	,Assessment.TEST_GU
	,Assessment.GRADE AS GradeELLEntered
	,Assessment.TEST_NAME
FROM
	-- Enrollments
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll

	/* As per Lynne (8/28/2014) => Once PHLOTE, always PHLOTE
	-- PHLOTE Students
	INNER JOIN
	APS.PHLOTEAsOf(GETDATE()) AS PHLOTE
	ON
	Enroll.STUDENT_GU = PHLOTE.STUDENT_GU
	*/
	-- Latest Assessment
	INNER JOIN
	APS.LCELatestEvaluationAsOf(@AsOfDate) AS Assessment
	ON
	Enroll.STUDENT_GU = Assessment.STUDENT_GU


--SKIP STUDENTS THAT ARE "ADMINISTRATIVELY EXITED" - CHANGED PHLOTE STATUS
--	LEFT JOIN 
--	(SELECT STUDENT_GU FROM 
--	REV.EPC_STU_PGM_ELL AS PGM
--	WHERE
--	EXIT_REASON = 'EY-') 
--	AS ADMINEXITED

--ON 
--ADMINEXITED.STUDENT_GU = Enroll.STUDENT_GU

WHERE
	-- Only those where performance level qualifies them for ELL
	Assessment.IS_ELL IN (1, -1)
	--AND ADMINEXITED.STUDENT_GU IS NULL


GO


