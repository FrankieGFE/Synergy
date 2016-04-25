DECLARE @SchYr int, @NextSchYr int, @NextSchYrDisplay int
DECLARE @DistrictCode varchar(3)
SET @SchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 1
SET @NextSchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 1
select count(*) + 2 as c1
from
(
select stu.SIS_NUMBER
FROM rev.EPC_STU               stu   
JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU = stu.STUDENT_GU 
JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                        AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per   ON per.PERSON_GU = stu.STUDENT_GU
JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssyr.GRADE
LEFT JOIN rev.SIF_22_Common_GetLookupValues('Revelation', 'ETHNICITY') eth ON eth.VALUE_CODE = per.RESOLVED_ETHNICITY_RACE
where stu.STATE_STUDENT_NUMBER is null
union all
select stu.sis_number
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
) cn