SELECT 
    DISTINCT 
    SCH.ORGANIZATION_NAME
    ,SCH.COURSE_TITLE
    ,SCH.COURSE_ID 
	,SCH.SECTION_ID
    ,YR.SCHOOL_YEAR
    ,PER.LAST_NAME + ', ' + PER.FIRST_NAME AS TEACHER_NAME
    ,PER.EMAIL      
    FROM 
    APS.ScheduleDetailsAsOf (GETDATE()) AS SCH

	LEFT JOIN
	REV.EPC_CRS_LEVEL_LST CLL
	ON
	SCH.COURSE_GU = CLL.COURSE_GU

    LEFT JOIN
    REV.REV_YEAR AS YR
    ON YR.YEAR_GU = SCH.YEAR_GU

    LEFT JOIN
    REV.REV_PERSON AS PER
    ON SCH.STAFF_GU = PER.PERSON_GU

    LEFT JOIN 
    REV.EPC_STAFF AS ST
    ON PER.PERSON_GU = ST.STAFF_GU
    WHERE 1 = 1
    AND SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
    AND EXTENSION = 'R'
    AND PRIMARY_STAFF = 1
    AND SCH.ENROLLMENT_ENTER_DATE IS NOT NULL
    AND CLL.COURSE_LEVEL = 'A'




