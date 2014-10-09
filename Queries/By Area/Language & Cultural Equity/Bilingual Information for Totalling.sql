/* $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 * Information needed on Bilingual Students for Totalling Purposes
 * **NOTE** This is used in a report
 */
DECLARE @asOfDate DATE = GETDATE()
DECLARE @School VARCHAR(64) = '%'
SELECT
	School
	,COUNT(*)
FROM
(
SELECT
	Organization.ORGANIZATION_NAME AS School
/*
	,GradeLevel.VALUE_DESCRIPTION AS Grade
	,GradeLevel.LIST_ORDER AS GradeSort
	,BEPProgramCode.VALUE_DESCRIPTION AS Model
	,BEP.PROGRAM_INTENSITY AS [Hours]
	,CASE
		WHEN ELL.STUDENT_GU IS NOT NULL THEN 'ELL'
		WHEN Eval.IS_ELL IS NOT NULL AND Eval.IS_ELL != 1 THEN 'FEP'
		WHEN PHLOTE.STUDENT_GU IS NOT NULL THEN 'PHLOTE'
		ELSE 'None'

	END AS [Status]
*/
FROM
	APS.LCEBilingualAsOf(@asOfDate) AS BEP
	INNER JOIN
	APS.PrimaryEnrollmentsAsOf(@asOfDate) AS Enroll
	ON
	Enroll.STUDENT_GU = BEP.STUDENT_GU
	
	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	OrgYear.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	--FEP/ELL/PHLOTE
	LEFT JOIN
	APS.PHLOTEAsOf(@asOfDate) AS PHLOTE
	ON
	BEP.STUDENT_GU = PHLOTE.STUDENT_GU

	LEFT JOIN
	APS.ELLAsOf(@asOfDate) AS ELL
	ON
	BEP.STUDENT_GU = ELL.STUDENT_GU
/*
	LEFT JOIN
	APS.LCELatestEvaluationAsOf(@asOfDate) AS Eval
	ON
	BEP.STUDENT_GU = Eval.STUDENT_GU


	LEFT JOIN
	APS.LookupTable('k12','Grade') AS GradeLevel 
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('K12.ProgramInfo', 'Bep_Program_Code') AS BEPProgramCode
	ON
	BEP.PROGRAM_CODE = BEPProgramCode.VALUE_CODE
*/
WHERE
	OrgYear.ORGANIZATION_GU LIKE @School
) AS FOO
GROUP BY
	School
ORDER BY
	School