

/******************************************************************************

CREATED BY DEBBIE ANN CHAVEZ
DATE 9/1/2016

--PULL ALL SCHEDULED JOBS FROM SERVERS:  SYNERGYDBDC, SYNTEMPSSIS, 180-SMAXODS-01

*******************************************************************************/

CREATE VIEW dbo.ScheduledJobsAllServers AS


SELECT * FROM dbo.scheduledjobs

UNION ALL

SELECT * FROM [SYNTEMPSSIS.APS.EDU.ACTD].[MASTER].dbo.ScheduledJobs

UNION ALL

SELECT * FROM [180-SMAXODS-01.APS.EDU.ACTD].[MASTER].dbo.ScheduledJobs
WHERE
[Category] = 'Lawson'