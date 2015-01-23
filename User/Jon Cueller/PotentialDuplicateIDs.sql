
DECLARE @NewStudentDayInterval INT = 10

SELECT
	*
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER (PARTITION BY UniqueRow ORDER BY NEW_SIS_NUMBER DESC) AS RN -- RN is so we show one record A-B, and not B-A which is the same comparison
		
		--the ranking
		,([First Name] + [LAST NAME] + [Last Name Exact] + Hispanic + MiddleName + EthnicCode + Bday + Gender + CloseIDs + NoStateID + 2) AS Rating -- (scale of 0-14)

		--ranking percentage
		,([First Name] + [LAST NAME] + [Last Name Exact] + Hispanic + MiddleName + EthnicCode + Bday + Gender + CloseIDs + NoStateID + 2)/14 AS PercentRating -- (scale of 0-14)
	FROM
		(
		SELECT
			DIFFERENCE(AllStudents.FIRST_NAME, NewStudents.FIRST_NAME)/2.0 AS [First Name]					-- 0 - 2
			,DIFFERENCE(AllStudents.LAST_NAME, NewStudents.LAST_NAME)/4.0  AS [Last Name]						-- 0 - 1
			,CASE WHEN AllStudents.LAST_NAME = NewStudents.LAST_NAME THEN 1 ELSE 0 END AS [Last Name Exact]	-- 0 - 1
			,CASE WHEN AllStudents.HISPANIC_INDICATOR = NewStudents.HISPANIC_INDICATOR THEN 0.5 ELSE 0 END AS Hispanic			-- 0 - 0.5
			,CASE WHEN AllStudents.MIDDLE_NAME = NewStudents.MIDDLE_NAME THEN 0.5 ELSE 0 END AS MiddleName			-- 0 - 0.5
			,CASE WHEN AllStudents.RESOLVED_ETHNICITY_RACE = NewStudents.RESOLVED_ETHNICITY_RACE THEN 1.0 ELSE 0 END AS EthnicCode		-- 0 - 1
			,CASE WHEN ABS(DATEDIFF(DAY,AllStudents.BIRTH_DATE,NewStudents.BIRTH_DATE)) <= 2  THEN 3 - ABS(DATEDIFF(DAY,AllStudents.BIRTH_DATE,NewStudents.BIRTH_DATE)) ELSE 0 END AS Bday	-- 0 - 3
			,CASE WHEN AllStudents.GENDER = NewStudents.GENDER THEN 3.0 ELSE 0 END as Gender				-- 0 - 3
			,CASE WHEN ABS(CAST(NewStudents.SIS_NUMBER AS BIGINT) - CAST(AllStudents.SIS_NUMBER AS BIGINT)) <= 30 THEN -2 ELSE 0 END AS CloseIDs	-- -2, 0  Multiple Siblings (Twins will usually have ids close to each other)
			,CASE WHEN AllStudents.STATE_STUDENT_NUMBER = '' OR NewStudents.STATE_STUDENT_NUMBER = '' THEN 1 ELSE 0 END AS NoStateID -- 0,1
	
			,CASE WHEN NewStudents.STUDENT_GU > AllStudents.STUDENT_GU 
				THEN CAST(NewStudents.STUDENT_GU AS VARCHAR(128))+ '-' + CAST(AllStudents.STUDENT_GU AS VARCHAR(128))
				ELSE CAST(AllStudents.STUDENT_GU AS VARCHAR(128))+ '-' + CAST(NewStudents.STUDENT_GU AS VARCHAR(128))
			END AS UniqueRow

			,NewStudents.SIS_NUMBER AS NEW_SIS_NUMBER
			,NewStudents.STATE_STUDENT_NUMBER AS NEW_STATE_STUDENT_NUMBER
			,NewStudents.FIRST_NAME AS NEW_FIRST_NAME
			,NewStudents.LAST_NAME AS NEW_LAST_NAME
			,NewStudents.MIDDLE_NAME AS NEW_MIDDLE_NAME
			,NewStudents.GENDER AS NEW_GENDER
			,NewStudents.BIRTH_DATE AS NEW_BIRTH_DATE
			,NewStudents.RESOLVED_ETHNICITY_RACE AS NEW_RESOLVED_ETHNICITY_RACE
			,NewStudents.HISPANIC_INDICATOR AS NEW_HISPANIC_INDICATOR

			,BADGE_NUM
			,StaffName

			,AllStudents.SIS_NUMBER AS OTHER_SIS_NUMBER
			,AllStudents.STATE_STUDENT_NUMBER AS OTHER_STATE_STUDENT_NUMBER
			,AllStudents.FIRST_NAME AS OTHER_FIRST_NAME
			,AllStudents.LAST_NAME AS OTHER_LAST_NAME
			,AllStudents.MIDDLE_NAME AS OTHER_MIDDLE_NAME
			,AllStudents.GENDER AS OTHER_GENDER
			,AllStudents.BIRTH_DATE AS OTHER_BIRTH_DATE
			,AllStudents.RESOLVED_ETHNICITY_RACE AS OTHER_RESOLVED_ETHNICITY_RACE
			,AllStudents.HISPANIC_INDICATOR AS OTHER_HISPANIC_INDICATOR
		FROM
			(
			SELECT
				Student.STUDENT_GU
				,Student.SIS_NUMBER
				,Student.STATE_STUDENT_NUMBER
				,Person.BIRTH_DATE
				,Person.FIRST_NAME
				,Person.LAST_NAME
				,Person.MIDDLE_NAME
				,Person.GENDER
				,Person.HISPANIC_INDICATOR
				,PERSON.RESOLVED_ETHNICITY_RACE

				,Staff.BADGE_NUM
				,PersonAdded.LAST_NAME + ', ' + PersonAdded.FIRST_NAME AS StaffName
			FROM
				rev.EPC_STU AS Student
				INNER JOIN
				rev.REV_PERSON AS Person
				ON
				Student.STUDENT_GU = Person.PERSON_GU

				INNER JOIN
				rev.REV_PERSON AS PersonAdded
				ON
				Student.ADD_ID_STAMP = PersonAdded.PERSON_GU

				INNER JOIN
				rev.EPC_STAFF AS Staff
				ON
				Student.ADD_ID_STAMP = Staff.STAFF_GU

			WHERE
				Student.ADD_DATE_TIME_STAMP >= DATEADD(DAY,(-1 * @NewStudentDayInterval),GETDATE())
				AND (USER_CODE_7 != 'R' OR USER_CODE_7 IS NULL)
			) AS NewStudents

			INNER JOIN

			(
			SELECT
				Student.STUDENT_GU
				,Student.SIS_NUMBER
				,Student.STATE_STUDENT_NUMBER
				,Person.BIRTH_DATE
				,Person.FIRST_NAME
				,Person.LAST_NAME
				,Person.MIDDLE_NAME
				,Person.GENDER
				,Person.HISPANIC_INDICATOR
				,PERSON.RESOLVED_ETHNICITY_RACE
			FROM
				rev.EPC_STU AS Student
				INNER JOIN
				rev.REV_PERSON AS Person
				ON
				Student.STUDENT_GU = Person.PERSON_GU
			)AS AllStudents
			ON
			NewStudents.STUDENT_GU != AllStudents.STUDENT_GU
			AND
			(
				NewStudents.BIRTH_DATE = AllStudents.BIRTH_DATE
				OR NewStudents.FIRST_NAME = AllStudents.FIRST_NAME
				OR NewStudents.LAST_NAME = AllStudents.LAST_NAME
			)
		) AS CombinedResults
	) AS RowNumbered
WHERE
	RowNumbered.RN = 1
	AND Rating >= 12 -- This is our threshold