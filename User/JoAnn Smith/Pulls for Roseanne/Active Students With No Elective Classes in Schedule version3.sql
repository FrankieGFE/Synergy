/************************************************************************
* $Revison: 1
* $Last Changed By:   JoAnn Smith
* $Last Changed Date: 1/9/2017
**************************************************************************
Pull students who have no elective classes in their schedules,
Grades 6 and above
**************************************************************************/

SELECT * FROM (
       SELECT 
                    ORGANIZATION_NAME
                    ,SIS_NUMBER
                    ,LAST_NAME
                    ,FIRST_NAME
                    ,GRADE
                    ,MAX(ELECTIVES) AS FILTER
       FROM (

   select
                SAO.SIS_NUMBER
                           , bsc.FIRST_NAME
                           , bsc.LAST_NAME
                           , sao.ORGANIZATION_NAME
                           --, count(sao.department) as ELECTIVE_COUNT
              ,LU.VALUE_DESCRIPTION as GRADE
                      , LST.COURSE_LEVEL
                      ,SAO.COURSE_ID
                      ,SAO.COURSE_TITLE
                      ,CASE WHEN LST.COURSE_LEVEL = 'E' THEN 'ELE' ELSE '' END AS ELECTIVES
       from
              aps.scheduleasof(getdate()) SAO
       inner join 
               aps.BasicStudent BSC on SAO.SIS_NUMBER = bsc.SIS_NUMBER
             LEFT JOIN 
                    rev.EPC_CRS_LEVEL_LST AS LST ON LST.COURSE_GU = SAO.COURSE_GU 
             LEFT JOIN 
                    APS.LookupTable ('K12', 'GRADE') AS LU
             ON
             SAO.ENROLLMENT_GRADE_LEVEL = LU.VALUE_CODE

       where
              ENROLLMENT_GRADE_LEVEL in ('160', '170', '180','190', '200', '210', '220') 
                    
              and sao.COURSE_ENTER_DATE >= '2017-01-04'
       ) AS T1

          GROUP BY

          ORGANIZATION_NAME
                    ,SIS_NUMBER
                    ,LAST_NAME
                    ,FIRST_NAME
                    ,GRADE

) AS T2
WHERE
FILTER = ''
ORDER BY ORGANIZATION_NAME, LAST_NAME








