/* Brian Rieb
 * 9/25/2014
 *
 * Original request by: Jude Garcia
 *
 * For students in a given file, Need their *earliest* enter date (and school code) for 2013-2014
 *
 */

-- Add the next to lines to simulate running as a non-ad account
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	Kids.ID_NBR AS [Student ID]
	,Enroll.SCHOOL_CODE
	,Enroll.ENTER_DATE
FROM 
	-- List of kids
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
		'SELECT * from META2014Ids.txt'
	    ) AS Kids
	LEFT HASH JOIN
	rev.EPC_STU AS Student
	ON
	Kids.ID_NBR = Student.SIS_NUMBER

	LEFT JOIN
	(
		SELECT 
			SSY.STUDENT_GU
			,School.SCHOOL_CODE
			,Enroll.ENTER_DATE
			,ROW_NUMBER() OVER (PARTITION BY SSY.STUDENT_GU ORDER BY Enroll.ENTER_DATE ASC) AS RN
		FROM
			rev.EPC_STU_SCH_YR AS SSY

			INNER JOIN
			rev.REV_ORGANIZATION_YEAR AS OrgYear
			ON
			SSY.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

			INNER JOIN
			rev.REV_YEAR AS SynYear
			ON
			OrgYear.YEAR_GU = SynYear.YEAR_GU
			AND SynYear.SCHOOL_YEAR = '2013'
			AND SynYear.EXTENSION = 'R'

			INNER JOIN
			rev.EPC_STU_ENROLL AS Enroll
			ON
			SSY.STUDENT_SCHOOL_YEAR_GU = Enroll.STUDENT_SCHOOL_YEAR_GU

			INNER JOIN
			rev.EPC_SCH AS School
			ON
			OrgYear.ORGANIZATION_GU = School.ORGANIZATION_GU
		) AS Enroll
		ON
		Student.STUDENT_GU = Enroll.STUDENT_GU
		AND Enroll.RN = 1
ORDER BY
	Kids.ID_NBR

-- Always conclude your statement with these last two lines so it reverts back
-- to your user
REVERT
GO
