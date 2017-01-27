--/*
-- * Revision 1
-- * Last Changed By:    JoAnn Smith
-- * Last Changed Date:  1/26/17
-- ******************************************************
-- Hanover will examine the impact of Nspire on students’ attendance.
--	1.	Attendance information for all Highland students between 2011-12 to Present school year
--	Total Membership days
--	Total absences
--	Total Present
--	School year identified
--	2.	Tardiness information if available
 
-- ******************************************************
-- 1-26-2017 Initial query
--note this takes ~8 1/2 minutes to run
--/*


EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
		T1.*
		,BS.STATE_STUDENT_NUMBER as STATE_ID
		--,ESO.SCHOOL_TYPE
		,PRIM.SCHOOL_YEAR AS SY
		,'FALL' as Semester
		,PRIM.GRADE AS GRDE
		,PRIM.SCHOOL_CODE as SCH_NBR
		,PRIM.SCHOOL_NAME as SCH_NME
		,CASE WHEN ESO.SCHOOL_TYPE = '2'
			THEN (SELECT GPA.[MS Cum Flat] FROM APS.CUMGPA AS GPA WHERE GPA.SIS_NUMBER = BS.SIS_NUMBER) 
		END AS MS_FLAT_GPA
		,CASE WHEN ESO.SCHOOL_TYPE = '3'
			THEN (SELECT GPA.[HS Cum Flat] FROM APS.CUMGPA GPA WHERE GPA.SIS_NUMBER = BS.SIS_NUMBER)
		END as HS_FLAT_GPA
		,CASE WHEN ESO.SCHOOL_TYPE = '3'
			THEN (SELECT GPA.[HS Cum Weighted] FROM APS.CUMGPA GPA WHERE GPA.SIS_NUMBER = BS.SIS_NUMBER) 
		END AS HS_WEIGHTED_GPA       
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from LutheranFamilysERVICESRequest.csv'
                ) AS [T1]

LEFT JOIN
		APS.BasicStudentWithMoreInfo AS BS
		ON T1.APS_ID = BS.SIS_NUMBER

LEFT JOIN 
       APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS PRIM
       ON BS.STUDENT_GU = PRIM.STUDENT_GU 

LEFT JOIN
		APS.CumGPA GPA
		ON bs.SIS_NUMBER = gpa.SIS_NUMBER

Left join
		REV.EPC_SCH_YR_OPT ESO
		ON ESO.ORGANIZATION_YEAR_GU = PRIM.ORGANIZATION_YEAR_GU
ORDER BY
	T1.[Student Last Name], T1.[Student First Name]

       
REVERT
GO


