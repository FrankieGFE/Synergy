---RUN IN TEST FIRST


select * into rev.aaa_egb_gbresult_bu_201609062
from rev.EGB_GBRESULT

select * into rev.aaa_egb_gbperiod_bu_201609062
from rev.EGB_GBPERIODS

select * into rev.aaa_egb_gradebook_bu_201609062
from rev.EGB_GRADEBOOK

SELECT gb.ID GRADEBOOKID
INTO   #temp_assignments
FROM   rev.egb_gradebook gb
       JOIN rev.EGB_CLASS cl
         ON cl.ID = gb.CLASSID
       JOIN rev.EPC_SCH_YR_SECT sec
         ON sec.SECTION_GU = cl.CLASSGUID
       JOIN rev.EPC_SCH_YR_CRS cs
         ON cs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_CRS crs
         ON crs.COURSE_GU = cs.COURSE_GU
WHERE  crs.COURSE_ID IN ( '07532' )
       AND gb.parentid IN (SELECT gb.id
                           FROM   rev.egb_gradebook gb
                                  JOIN rev.egb_class c
                                    ON c.id = gb.classid
                           WHERE  gb.MEASURE IN ( 'G8 U1 Pre', 'G8 U1 Post', 'G8 U1 PT', 'G8 U2 Pre',
                                                  'G8 U2 Post', 'G8 U2 PT', 'G8 U3 Pre', 'G8 U3 Post',
                                                  'G8 U3 PT', 'G8 U4 Pre', 'G8 U4 Post', 'G8 U4 PT',
                                                  'G8 U5 Pre', 'G8 U5 Post', 'G8 U5 PT' )
                                  AND c.classtypeid = 4) 


DELETE FROM rev.EGB_GBRESULT
WHERE  GRADEBOOKID IN (SELECT GRADEBOOKID FROM #temp_assignments) 

DELETE from rev.EGB_GBPERIODS
where GRADEBOOKID in (SELECT GRADEBOOKID FROM #temp_assignments) 

DELETE from rev.EGB_GRADEBOOK
where ID in (SELECT GRADEBOOKID FROM #temp_assignments) 


DROP TABLE #temp_assignments
