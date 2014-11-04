/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[TeachersByDepartmentAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.TeachersByDepartmentAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.TeachersByDepartmentAsOf
 * List of Staff Assigned to classes with kids in them, and the pivoted departments they teach
 * Note that this uses a pivot, and so it can be a bit slow.
 *
 * #param DATE @AsOfDate date to look for schedules and assignments
 * 
 * #return TABLE Staff gu and pivoted list of applicable departments
 */
ALTER FUNCTION APS.TeachersByDepartmentAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN
SELECT
	*
FROM
	(
	SELECT
		Sections.STAFF_GU
		,Schedules.DEPARTMENT	
	FROM
		APS.ScheduleAsOf(@asOfDate) AS Schedules
		INNER JOIN
		APS.SectionsAndAllStaffAssignedAsOf(@asOfDate) AS Sections
		ON
		Schedules.SECTION_GU = Sections.SECTION_GU
	WHERE
		-- Some of these departments are either legacy, or irrelevant in terms of tracking
		Schedules.DEPARTMENT NOT IN ('Noc','Advis','Off','Sch','Comm','Ele')
	GROUP BY
		Sections.STAFF_GU
		,Schedules.DEPARTMENT
	) AS GroupedTeachers
PIVOT
(
    MAX(Department)
FOR
	Department
    IN (
	[PE]
	,[P/FA]
	,[Eng]
	,[Hea]
	,[Sci]
	,[Math]
	,[Soc]
	,[Sped]
	,[Elem]
	    )
) AS PivotedResults