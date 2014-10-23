--<APS - State ID File Submission - Student data>
DECLARE @SchYr int, @NextSchYr int, @NextSchYrDisplay int
DECLARE @DistrictCode varchar(3)
SET @SchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 1
SET @NextSchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 1
SET @NextSchYrDisplay = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 2
SET @DistrictCode = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')

SELECT
   'ID'                                       AS [RowID]
 , sch.SCHOOL_CODE                            AS [State School Number]
 , @DistrictCode                              AS [District Number1]
 , per.LAST_NAME                              AS [Student Last Name]
 , per.FIRST_NAME                             AS [Student First Name]
 , per.MIDDLE_NAME                            AS [Student Middle Name]
 , per.GENDER                                 AS [Gender]
 , CONVERT(VARCHAR(10), per.BIRTH_DATE, 101)  AS [Birthdate]
 , CASE
    WHEN grd.ALT_CODE_2 = 'PK' THEN 'KF'
	ELSE grd.ALT_CODE_2
   END                                        AS [Grade Level]
 --, stu.STATE_STUDENT_NUMBER                   AS [State ID Number]
 , stu.SIS_NUMBER                             AS [State ID Number]
 , ''                                         AS [Blank1]
 , CASE
    WHEN  eth.ALT_CODE_3 = 'W' THEN 'C'
    WHEN  eth.ALT_CODE_3 = 'B' THEN 'B'
    WHEN  eth.ALT_CODE_3 = 'AI' THEN 'I'
    WHEN  eth.ALT_CODE_3 = 'A' THEN 'A'
    WHEN  eth.ALT_CODE_3 = 'P' THEN 'A'
	ELSE  'C'
   END                                        AS [Student Ethnic Code]
 , ''                                         AS [Blank2]
 , @DistrictCode                              AS [District Number]
 , @SchYr                                     AS [School Year]
FROM rev.EPC_STU               stu   
JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU = stu.STUDENT_GU 
JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                        AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per   ON per.PERSON_GU = stu.STUDENT_GU
JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') eth ON eth.VALUE_CODE = per.RESOLVED_ETHNICITY_RACE
where stu.STATE_STUDENT_NUMBER is null
 --Include Next year Students
UNION
SELECT
   'ID'                                       AS [RowID]
 , sch.SCHOOL_CODE                            AS [State School Number]
 , @DistrictCode                              AS [District Number1]
 , per.LAST_NAME                              AS [Student Last Name]
 , per.FIRST_NAME                             AS [Student First Name]
 , per.MIDDLE_NAME                            AS [Student Middle Name]
 , per.GENDER                                 AS [Gender]
 , CONVERT(VARCHAR(10), per.BIRTH_DATE, 101)  AS [Birthdate]
 , CASE
    WHEN grd.ALT_CODE_2 = 'PK' THEN 'KF'
	ELSE grd.ALT_CODE_2
   END                                        AS [Grade Level]
 --, stu.STATE_STUDENT_NUMBER                   AS [State ID Number]
 , stu.SIS_NUMBER                             AS [State ID Number]
 , ''                                         AS [Blank1]
 , CASE
    WHEN  eth.ALT_CODE_3 = 'W' THEN 'C'
    WHEN  eth.ALT_CODE_3 = 'B' THEN 'B'
    WHEN  eth.ALT_CODE_3 = 'AI' THEN 'I'
    WHEN  eth.ALT_CODE_3 = 'A' THEN 'A'
    WHEN  eth.ALT_CODE_3 = 'P' THEN 'A'
	ELSE  'C'
   END                                        AS [Student Ethnic Code]
 , ''                                         AS [Blank2]
 , @DistrictCode                              AS [District Number]
 , @NextSchYrDisplay                          AS [School Year]
 
FROM rev.EPC_STU               stu   
JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU = stu.STUDENT_GU 
JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              yr    ON yr.YEAR_GU               = oyr.YEAR_GU      
                                        AND yr.SCHOOL_YEAR = @NextSchYr
JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per   ON per.PERSON_GU = stu.STUDENT_GU
JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') eth ON eth.VALUE_CODE = per.RESOLVED_ETHNICITY_RACE
where stu.STATE_STUDENT_NUMBER is null