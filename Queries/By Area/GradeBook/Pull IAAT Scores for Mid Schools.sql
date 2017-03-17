
SELECT SCHOOLNAME ,SIS_NUMBER, LASTNAME, FIRSTNAME, [IAAT Comments],[IAAT Placement Recommendations], [IAAT Attitude and Independence],[IAAT Work Ethic]   FROM 
(
select SCHOOLNAME, stu.LASTNAME, stu.FIRSTNAME, STU2.SIS_NUMBER, MEASURE, GBR.SCORE

from rev.EGB_GRADEBOOK gb  --assignments
join rev.EGB_GBRESULT gbr on gbr.GRADEBOOKID = gb.ID  --student results
join rev.EGB_PEOPLE stu on stu.id = gbr.studentid
join rev.EGB_CLASS c on c.id = gb.CLASSID
join rev.EGB_SCHOOL s on s.id = c.SCHOOLID
join rev.EGB_GBSCORETYPES sct on sct.id = gb.SCORETYPEID
join rev.EGB_MEASURETYPE mt on mt.id = gb.MEASURETYPEID
join rev.EPC_STU AS STU2 ON STU2.STUDENT_GU = STU.GENESISID

where 
SCHOOLNAME LIKE '%Middle%'
AND MEASURE LIKE 'IAAT%'
--AND GBR.DATEADDED > '2016-02-01'
--AND LASTNAME = 'Aguero'
--AND FIRSTNAME = 'Ismael'
)
AS PIVOTME

PIVOT
(
MAX([SCORE])
FOR MEASURE IN ([IAAT Comments], [IAAT Placement Recommendations], [IAAT Attitude and Independence],[IAAT Work Ethic])
) AS PVT


--order by SCHOOLNAME, classname



