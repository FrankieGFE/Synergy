/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 06/19/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 06/19/2015
 * 
 * Description: Pull most recent student enrollments, to be used for preprinting the Emergency Contact registration cards.
 * One Record Per Student
 *
 * Tables Referenced:
 */

-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[EmergencyCardInfo]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].EmergencyCardInfo AS SELECT 0')
GO

CREATE PROCEDURE [APS].EmergencyCardInfo

AS
BEGIN

--------------------------------------------------------------
-- GET YEAR GU DEPENDING ON THE CURRENT MONTH
declare @SchRunYearGU uniqueidentifier
declare @SchRunGrade int = 0
IF MONTH(GETDATE()) < 6 -- IN SPRING GET CURRENT YEAR GU THEN ADD 1 TO STUDENT GRADES
BEGIN
	SET @SchRunYearGU = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
	SET @SchRunGrade = 10 -- GRADE + 1
END
IF MONTH(GETDATE()) BETWEEN 6 AND 8 -- IN SUMMER GET NEXT YEAR GU THEN ADD 0 TO STUDENT GRADES
BEGIN
	--SELECT '08/30/' + CONVERT(VARCHAR(4),YEAR(GETDATE()))
	SET @SchRunYearGU = (SELECT YEAR_GU FROM APS.YearDates WHERE CONVERT(DATE,'08/30/' + CONVERT(VARCHAR(4),YEAR(GETDATE()))) BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
	SET @SchRunGrade = 0 -- GRADE + 0
END
IF MONTH(GETDATE()) > 8 -- IN THE FALL GET CURRENT YEAR GU AND ADD 0 TO STUDENT GRADES
BEGIN
	--SELECT '08/30/' + CONVERT(VARCHAR(4),YEAR(GETDATE()))
	SET @SchRunYearGU = (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
	SET @SchRunGrade = 0 -- GRADE + 0
END
--------------------------------------------------------------


SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[FIRST_NAME]	
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[GENDER]
	,[ENROLLMENTS].[ENTER_DATE]
	,[STUDENT].[BIRTH_DATE]
	,[STUDENT].[HOME_ADDRESS]
	,[STUDENT].[HOME_CITY]
	,[STUDENT].[HOME_STATE]
	,[STUDENT].[HOME_ZIP]
	,[STUDENT].[PRIMARY_PHONE]
	,[STUDENT].[HOME_LANGUAGE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	
FROM
	APS.StudentEnrollmentDetails AS [ENROLLMENTS]
	
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENTS].[YEAR_GU] = @SchRunYearGU
	

END
GO