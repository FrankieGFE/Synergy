/**
 * $Revision: 221 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-09 17:00:25 -0600 (Thu, 09 Oct 2014) $
 *
 * For students enrolled and scheduled as of a certian date, grab their math and ela schedule courses (or homeroom - Period 1 if they are 3-5)
 * for 3-8th graders.  Then grab their SBA and DRA scores and then make an atempt at giving a stratified sample based on the square root
 * of the total number of students in the class who have scores.
 *
 * NOTE: Since this is grabbing semi-random sample sets, it's extremely possible that results will vary every time you run it.
 */
-- Add the next to lines to simulate running as a non-ad account
EXECUTE AS LOGIN='QueryFileUser'
GO

DECLARE @AsOfDate DATE = GETDATE()
DECLARE @Scores TABLE (VALUE VARCHAR(64), ValueRank INT)

-- This is just a cross-walk table fo ranking scores
INSERT INTO @Scores VALUES 
('Advanced',1)
,('Proficient',2)
,('Nearing Proficiency',3)
,('Beginning Step',4)
,('ADV',1)
,('PRO',2)
,('NP',3)
,('BS',4)

-- We set this up as a with because we need to pull from it twice, once for the data, and once for section
-- totals 
;WITH TheSet AS
(
SELECT
	Student.SIS_NUMBER
	,StudentPerson.LAST_NAME AS StudentLastName
	,StudentPerson.FIRST_NAME AS StudentFirstName
	,COALESCE(StudentPerson.MIDDLE_NAME,'') AS StudentMiddleName
	,GradeLevel.VALUE_DESCRIPTION As GradeLevel
	,Organization.ORGANIZATION_NAME
	,Schedule.SECTION_GU
	,Schedule.COURSE_TITLE
	,Schedule.COURSE_ID
	,Schedule.SECTION_ID
	,Schedule.DEPARTMENT
	,Staff.BADGE_NUM
	,StaffPerson.LAST_NAME AS StaffLastName
	,StaffPerson.FIRST_NAME AS StaffFirstName
	,COALESCE(StaffPerson.MIDDLE_NAME,'') AS StaffMiddleName

	,Scores.SBA_MATH
	,Scores.SBA_READING
	,Scores.DRA2

	,MathScoreRanking.ValueRank AS MathValueRank
	,ReadingScoreRanking.ValueRank AS ReadingValueRank
	,DRARanking.ValueRank AS DRAValueRank
FROM
	APS.PrimaryEnrollmentsAsOf(@AsOfDate) AS Enroll
	INNER JOIN
	APS.ScheduleAsOf(@AsOfDate) AS Schedule
	ON
	Enroll.STUDENT_GU = Schedule.STUDENT_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Enroll.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.rev_person as StudentPerson
	ON
	Enroll.STUDENT_GU = StudentPerson.PERSON_GU

	INNER JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	rev.EPC_STAFF AS Staff
	ON
	Schedule.STAFF_GU = Staff.STAFF_GU

	INNER JOIN
	rev.REV_PERSON AS StaffPerson
	ON
	Schedule.STAFF_GU = StaffPerson.PERSON_GU
	
	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	Schedule.ORGANIZATION_GU = Organization.ORGANIZATION_GU	

	-- SBA scores for last year were not loaded. DRA2 are never loaded
	INNER HASH JOIN 
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
		'SELECT DISTINCT SIS_NUMBER, SBA_MATH, SBA_READING, DRA2 from DorothysStratificationWithSBAAndDRA.csv'
	    ) AS Scores
	ON
	Scores.SIS_NUMBER= Student.SIS_NUMBER

	LEFT JOIN
	@Scores AS MathScoreRanking
	ON
	Scores.SBA_MATH = MathScoreRanking.VALUE

	LEFT JOIN
	@Scores AS ReadingScoreRanking
	ON
	Scores.SBA_READING = ReadingScoreRanking.VALUE

	LEFT JOIN
	@Scores AS DRARanking
	ON
	Scores.DRA2 = DRARanking.VALUE
WHERE
	-- 3-8 graders
	Enroll.GRADE BETWEEN 130 AND 180

	--eihter math/english for 6-8 or homeroom 3-5
	AND
	(
		(
		Enroll.GRADE BETWEEN 130 AND 150
		AND Schedule.PERIOD_BEGIN = 1
		)
	OR
		(
		Enroll.GRADE > 150
		AND Schedule.DEPARTMENT IN ('MATH','ENG')
		)
	)
	--Only ppl who have scores
	AND
	(
		COALESCE(Scores.SBA_MATH, Scores.SBA_READING, Scores.DRA2) IS NOT NULL 
		AND 
		COALESCE(Scores.SBA_MATH, Scores.SBA_READING, Scores.DRA2) != 'NULL'
	)
) 


-- Here is the main select.  We actually run this 3 times (changin out parameters)
-- once for math/homerooms minus 3rd graders.  once for reading/english/homeroom minus 3rd graders
-- and once for 3rd graders.  Results will be assembled in a spreadsheet.
SELECT
	ORGANIZATION_NAME
	,COURSE_ID
	,COURSE_TITLE
	,SECTION_ID
	,BADGE_NUM
	,StaffLastName
	,StaffFirstName
	,StaffMiddleName
	,SIS_NUMBER AS StudentID
	,GradeLevel
	,StudentLastName
	,StudentFirstName
	,StudentMiddleName
	,SBA_MATH
	,SBA_READING
	,DRA2
FROM
	(
	SELECT
		TheSet.*
		,Counts.TheCount
		,Counts.SqrtCount
		,ROW_NUMBER() OVER (PARTITION BY TheSet.SECTION_GU ORDER BY DRAValueRank) AS DRANumber -- This Changes for SBA math,reading,or DRA
	FROM
		(
		-- This sbuselect simply pulls class counts and quare root oof class counts
		SELECT
			SECTION_GU
			,FLOOR(SQRT(COUNT(*))) AS SqrtCount
			,COUNT(*) AS TheCount
		FROM
			TheSet
		GROUP BY
			SECTION_GU
		)AS Counts
		INNER JOIN
		TheSet
		ON
		Counts.SECTION_GU = TheSet.SECTION_GU
	) AS WholeCount
WHERE
	-- these parameters change depending on which set you are running
	(
	DRANumber = 1 
	OR DRANumber = TheCount
	OR DRANumber BETWEEN (TheCount)/2 - (SqrtCount - 2)/2 AND (TheCount)/2 + (SqrtCount - 2)/2
	)
	--AND DEPARTMENT IN ('Eng', 'ELEM')
	AND GradeLevel = '03'
ORDER BY
	ORGANIZATION_NAME
	,COURSE_ID
	,SECTION_ID
	,DRANumber -- < also changes

-- Always conclude your statement with these last two lines so it reverts back
-- to your user
REVERT
GO
