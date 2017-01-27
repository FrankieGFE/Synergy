/************************************************************************
* $Revison: 1
* $Last Changed By:   JoAnn Smith
* $Last Changed Date: 1/10/2017
**************************************************************************
Pull students who have no elective classes in their schedules along with
their full schedule for Grades 6 and above
**************************************************************************/
select org.ORGANIZATION_NAME, t3.* , sch.COURSE_ID, sch.COURSE_TITLE from(

SELECT * FROM (
       SELECT		
                    
					STUDENT_GU
                    ,SIS_NUMBER
                    ,LAST_NAME
                    ,FIRST_NAME
                    ,GRADE
                    ,MAX(ELECTIVES) AS FILTER
					,SPED_STATUS
					,ELL_STATUS
       FROM (

   select

                SAO.SIS_NUMBER,
				SAO.STUDENT_GU
                , bsc.FIRST_NAME
                , bsc.LAST_NAME
                ,LU.VALUE_DESCRIPTION as Grade
                , LST.COURSE_LEVEL
                ,SAO.COURSE_ID
                ,SAO.COURSE_TITLE
				,bsc.ELL_STATUS
				,bsc.SPED_STATUS
                ,CASE WHEN LST.COURSE_LEVEL = 'E' THEN 'ELE' ELSE '' END AS ELECTIVES
       from
              aps.scheduleasof(getdate()) SAO
		inner join
				aps.TermDatesAsOf(getdate()) TDA on TDA.OrgYearGU = SAO.ORGANIZATION_YEAR_GU
				and tda.TermCode = SAO.Term_code

       inner join 
               aps.BasicStudentWithMoreInfo BSC on SAO.SIS_NUMBER = bsc.SIS_NUMBER
             LEFT JOIN 
                    rev.EPC_CRS_LEVEL_LST AS LST ON LST.COURSE_GU = SAO.COURSE_GU 
             LEFT JOIN 
                    APS.LookupTable ('K12', 'GRADE') AS LU
			 
					
             ON
             SAO.ENROLLMENT_GRADE_LEVEL = LU.VALUE_CODE

       where
              ENROLLMENT_GRADE_LEVEL in ('160', '170', '180','190', '200', '210', '220') 
                    
              

       ) AS T1

          GROUP BY

                    SIS_NUMBER
					,student_GU
                    ,LAST_NAME
                    ,FIRST_NAME
                    ,Grade
					,SPED_STATUS
					,ELL_STATUS

) AS T2
WHERE
FILTER = ''
)
as T3

inner join
	aps.scheduleasof(getdate()) as sch on t3.sis_number = sch.sis_number
inner JOIN
	aps.TermDatesAsOf(getdate()) TDA ON TDA.OrgYearGU = sch.ORGANIZATION_YEAR_GU
	and tda.TermCode = sch.TERM_CODE

inner join
	rev.REV_ORGANIZATION org on sch.ORGANIZATION_GU = org.ORGANIZATION_GU

ORDER BY
	SIS_NUMBER, ORGANIZATION_NAME











