
/*************************************************************************************************

Created By Debbie Ann Chavez
Date 3/17/2017

Pull Algebra Placement for Mid Schools from GradeBook 

**************************************************************************************************/


IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[GradebookAlgebraPlacement]'))
	EXEC ('CREATE VIEW APS.GradebookAlgebraPlacement AS SELECT 0 AS DUMMY')
GO

ALTER VIEW [APS].[GradebookAlgebraPlacement] AS


SELECT SCHOOLNAME ,SIS_NUMBER, LASTNAME, FIRSTNAME, [Algebra Placement Comments],[Algebra Placement Recommendations], [Algebra Placement Attitude and Independence],[Algebra Placement Work Ethic]   FROM 
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
AND MEASURE LIKE '%ALGEBRA PLACEMENT%'
AND MEASURETYPE = 'Recommendations'
--AND GBR.DATEADDED >= @ASOFDATE
----@ASOFDATE

)
AS PIVOTME

PIVOT
(
MAX([SCORE])
FOR MEASURE IN ([Algebra Placement Comments], [Algebra Placement Recommendations], [Algebra Placement Attitude and Independence],[Algebra Placement Work Ethic])
) AS PVT


--order by SCHOOLNAME



