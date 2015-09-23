/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 09/23/2015 $
 *
 * Request By: Gary Corbaley
 * InitialRequestDate: 09/23/2015
 * 
 * This script will pull the most recent enrollment detail for a given school year
 * One Record Per Student
 */

--DECLARE @YEAR_GU UNIQUEIDENTIFIER = 'BCFE2270-A461-4260-BA2B-0087CB8EC26A'

CREATE FUNCTION APS.LatestPrimaryEnrollmentInYear(@YEAR_GU UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN	
	SELECT
		*
	FROM
		(
		SELECT
			*
			,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, YEAR_GU ORDER BY ENTER_DATE DESC) AS RN
		FROM
			APS.StudentEnrollmentDetails AS [ENROLLMENTS]
			
		WHERE
			[ENROLLMENTS].[YEAR_GU] = @YEAR_GU 
			AND [ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NULL
			AND [ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NULL
		) AS [LATEST_ENROLLMENT]
	WHERE
		[RN] = 1
