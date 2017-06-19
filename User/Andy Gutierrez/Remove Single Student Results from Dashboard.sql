--declare @StudentDistrictID varchar(50) = 970038158

-- Important that this value is the ID found in the EGB_TEST_SCHEDULED table.
declare @AssessmentScheduleID int = 637

-- Run this first SQL to verify you are targetting the right assessment and the right student.
/*
	SELECT stu.ID DirectAssignmentID, sr.ID ResponseID, sp.LastName, sp.FirstName, t.TESTNAME AssessmentName, sch.Name ScheduleName, sch.STARTDATE ScheduleStartDate, sch.ENDDATE ScheduleEndDate 
	FROM rev.egb_test_scheduled sch 
	JOIN rev.EGB_TEST t ON t.ID = sch.TESTID
	JOIN rev.EGB_TEST_STUDENTS stu ON stu.SCHEDULEDTESTID = sch.ID
	JOIN rev.EGB_PEOPLE sp ON sp.ID = stu.STUDENTID
	JOIN rev.EGB_TEST_STUDENTRESPONSES sr ON sr.SCHEDULEDTESTID = stu.SCHEDULEDTESTID AND sr.STUDENTID = stu.STUDENTID
	WHERE sch.ID = @AssessmentScheduleID
--  The AND statements below can be used for one student or multiple students by commenting out the declare 
--  @StudentDistrictID above or the AND statement below with the multiple IDs
--    AND sp.STUDENTID = '970024069'
     AND sp.STUDENTID IN ('970061614','980035834') 
*/
-- If you are confident everything looks good, uncomment the sql below and run it as well.  It will remove the results targetted from above.

	
	-- Removing the student's answer chocies to the scheduled assessment
	-- Must be run first
/*	BEGIN TRAN
	DELETE FROM rev.EGB_TEST_RESPONSEANSWER WHERE RESPONSEID IN
	(
		SELECT sr.ID 
		FROM rev.egb_test_scheduled sch 
		JOIN rev.EGB_TEST t ON t.ID = sch.TESTID
		JOIN rev.EGB_TEST_STUDENTS stu ON stu.SCHEDULEDTESTID = sch.ID
		JOIN rev.EGB_PEOPLE sp ON sp.ID = stu.STUDENTID
		JOIN rev.EGB_TEST_STUDENTRESPONSES sr ON sr.SCHEDULEDTESTID = stu.SCHEDULEDTESTID AND sr.STUDENTID = stu.STUDENTID
		WHERE sch.ID = @AssessmentScheduleID
		AND sp.STUDENTID IN ('970061614','980035834') 
	)
--ROLLBACK
COMMIT
*/
	-- Removing the student's responses to the scheduled assessment
	-- Must be run second
/*	BEGIN TRAN
	DELETE FROM rev.EGB_TEST_STUDENTRESPONSES WHERE ID IN
	(
		SELECT sr.ID 
		FROM rev.egb_test_scheduled sch 
		JOIN rev.EGB_TEST t ON t.ID = sch.TESTID
		JOIN rev.EGB_TEST_STUDENTS stu ON stu.SCHEDULEDTESTID = sch.ID
		JOIN rev.EGB_PEOPLE sp ON sp.ID = stu.STUDENTID
		JOIN rev.EGB_TEST_STUDENTRESPONSES sr ON sr.SCHEDULEDTESTID = stu.SCHEDULEDTESTID AND sr.STUDENTID = stu.STUDENTID
		WHERE sch.ID = @AssessmentScheduleID
		AND sp.STUDENTID IN ('970061614','980035834') 
	)
COMMIT
*/
	-- Removing the student's direct assignment to the scheduled assessment.
	-- Must be run last
	BEGIN TRAN
	DELETE FROM rev.EGB_TEST_STUDENTS WHERE ID IN
	(
		SELECT stu.ID 
		FROM rev.egb_test_scheduled sch 
		JOIN rev.EGB_TEST t ON t.ID = sch.TESTID
		JOIN rev.EGB_TEST_STUDENTS stu ON stu.SCHEDULEDTESTID = sch.ID
		JOIN rev.EGB_PEOPLE sp ON sp.ID = stu.STUDENTID
		WHERE sch.ID = @AssessmentScheduleID
		AND sp.STUDENTID IN ('970061614','980035834') 
	)

--ROLLBACK
COMMIT

