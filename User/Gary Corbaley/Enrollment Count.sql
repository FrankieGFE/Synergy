/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 07/22/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 7/17/2014
 * 
 * This script will get the count of students enrolled in the 2014 school year from the Synergy system.
 */

SELECT	
		School.SCHOOL_CODE
		,Organization.ORGANIZATION_NAME
		,COUNT (*)AS ENROLL_COUNT
	FROM
		[011-SYNERGYDB].ST_Production.rev.EPC_STU_SCH_YR AS StudentSchoolYear
		INNER JOIN 
		[011-SYNERGYDB].ST_Production.rev.EPC_STU AS Student
		ON 
		Student.STUDENT_GU = StudentSchoolYear.STUDENT_GU
		INNER JOIN 
		[011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION_YEAR AS OrgYear 
		ON 
		OrgYear.ORGANIZATION_YEAR_GU = StudentSchoolYear.ORGANIZATION_YEAR_GU
		INNER JOIN 
		[011-SYNERGYDB].ST_Production.rev.REV_ORGANIZATION AS Organization 
		ON 
		Organization.ORGANIZATION_GU=OrgYear.ORGANIZATION_GU
		INNER JOIN 
		[011-SYNERGYDB].ST_Production.rev.EPC_SCH AS School 
		ON 
		School.ORGANIZATION_GU =OrgYear.ORGANIZATION_GU
		INNER JOIN 
		[011-SYNERGYDB].ST_Production.rev.REV_YEAR AS RevYear 
		ON 
		RevYear.YEAR_GU = OrgYear.YEAR_GU 
		AND RevYear.SCHOOL_YEAR = 2014
		
		INNER JOIN 
		[011-SYNERGYDB].ST_Production.rev.EPC_STU_ENROLL AS Enroll
		ON 
		Enroll.STUDENT_SCHOOL_YEAR_GU = StudentSchoolYear.STUDENT_SCHOOL_YEAR_GU
		
		INNER JOIN
        (
        SELECT
              Val.[ALT_CODE_1]
              ,Val.VALUE_CODE
        FROM
              [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_DEF] AS [Def]
              INNER JOIN
              [011-SYNERGYDB].ST_Production.[rev].[REV_BOD_LOOKUP_VALUES] AS [Val]
              ON
              [Def].[LOOKUP_DEF_GU]=[Val].[LOOKUP_DEF_GU]
              AND [Def].[LOOKUP_NAMESPACE]='K12'
              AND [Def].[LOOKUP_DEF_CODE]='Grade'
        ) AS [Grades]
        ON
        Enroll.[GRADE]=[Grades].[VALUE_CODE]
		
	WHERE
		(RevYear.SCHOOL_YEAR = 2014 )--AND RevYear.EXTENSION = 'S')
		AND SCHOOL_CODE != '592'

GROUP BY 
	School.SCHOOL_CODE
	,Organization.ORGANIZATION_NAME
	
ORDER BY School.SCHOOL_CODE