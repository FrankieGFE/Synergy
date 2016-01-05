

/**
 * Created By:  Debbie Ann Chavez
 * Date:  1/5/2016
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[NYRLookup]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.NYRLookup() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.NYRLookup
 * 
 * This function looks up the GUID error that NYR kicks out.  Note - this only pulls the errors that are Student related.  
 * If no results are returned the GUID may belong to a different table, SSY GU, Enroll GU, OrgYr GU, etc.  
 *
 *
 */


ALTER FUNCTION APS.NYRLookup(@STUDENTGU VARCHAR(132))
RETURNS TABLE
AS
RETURN	

SELECT STUDENT_GU, SIS_NUMBER FROM 
rev.EPC_STU AS STU
WHERE
STUDENT_GU = @STUDENTGU


	