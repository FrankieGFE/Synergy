  SELECT COUNT(*)
		  FROM
				--Uses the 80th Day Stars File
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS
				INNER JOIN 
				REV.EPC_STU AS STU
				ON STARS.[STUDENT ID] = STU.STATE_STUDENT_NUMBER
				           
		  WHERE
				--[Period] = @AsOfDate
				[Period] =  '2014-12-15'
				AND [DISTRICT CODE] = '001'
				--AND [STUDENT ID] = 102494507
				