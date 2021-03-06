/*
	Created by Debbie Ann Chavez
	Date 2016-04-12
*/

/**/
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[EnvironmentsInfo]'))
	EXEC ('CREATE VIEW APS.EnvironmentsInfo AS SELECT 0 AS DUMMY')
GO

ALTER VIEW [APS].EnvironmentsInfo AS


--LIVE
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
rev.UD_VER AS UD
INNER JOIN 
rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--assess
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Assess.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Assess.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL
--experiment
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Experiment.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Experiment.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--functional
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Functional.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Functional.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--instructional
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Instructional.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Instructional.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--release
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Release.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Release.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--release02
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Release_02.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Release_02.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--SPED
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_SPED.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_SPED.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--STARS
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_STARS.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_STARS.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

UNION ALL

--Training
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Train_90.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Train_90.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

/*
UNION ALL

--Implement
SELECT VER.VERSION, CAST(UD.REFRESH_DATE AS DATE) AS REFRESH_DATE, UD.URL, UD.NOTES FROM 
[SYNSECONDDB.APS.EDU.ACTD].ST_Implement.rev.UD_VER AS UD
INNER JOIN 
[SYNSECONDDB.APS.EDU.ACTD].ST_Implement.rev.REV_VER AS VER
ON
UD.VER_GU = VER.VER_GU

*/