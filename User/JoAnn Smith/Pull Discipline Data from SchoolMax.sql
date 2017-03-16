/*
*$LastChangedBy: JoAnn Smith
*$LastchangedDate: 3-10-2017
*Initial Request:  3-10-2017
*Pull 2013 Discipline With corresponding EV030 for each Participant Number.
*Offender (EV020.PART_TYPE = O, OFFENDER) ONLY
*
*/
USE PR
GO
--select * from DBTSIS.EV010_V
--select * from DBTSIS.EV020_V
--select * from DBTSIS.EV030_V
--select * from DBTSIS.CE020_V

;with StudentCTE
as
(
SELECT 
		[Student APS ID]

		FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\180-SMAXODS-01\SQLWorkingFiles;',
		'SELECT * from edlead2013.csv'
                ) 
)
--select * from StudentCTE
,DisciplineCTE
as
(

SELECT
	EV2.ID_NBR,
	EV1.SCH_YR,
	CE.STATE_ID,
	EV2.EV_SEQ_NBR [Incident Nbr],
	EV1.DATE_8,
	EV1.EVENT_CD,
	EV2.PART_TYPE

	--EV2.SCH_NBR,
	--SY.SCH_NME_27,
	--EV2.EV_SEQ_NBR,
	--EV2.PART_SEQ,
	--EV2.PART_TYPE,
	--EV2.OTH_FACT,
	--EV2.PART_STAT,
	--EV2.ID_NBR,
	--CE.FRST_NME,
	--CE.M_NME,
	--CE.LST_NME,
	--EV3.RESP_CD,
	--EV3.EMP_NBR,
	--EV3.DIS_BY
	
FROM
	DBTSIS.EV010_V AS EV1
	INNER JOIN
	DBTSIS.EV020_V AS EV2
	ON
	EV1.SCH_NBR = EV2.SCH_NBR
	AND EV1.SCH_YR = EV2.SCH_YR
	AND EV1.EV_SEQ_NBR = EV2.EV_SEQ_NBR
	
	INNER JOIN
	DBTSIS.EV030_V AS EV3
	ON
	EV1.SCH_NBR = EV3.SCH_NBR
	AND EV1.SCH_YR = EV3.SCH_YR
	AND EV1.EV_SEQ_NBR = EV3.EV_SEQ_NBR
	AND EV2.PART_SEQ = EV3.PART_SEQ
	
	INNER JOIN
	DBTSIS.CE020_V AS CE
	ON
	EV2.DST_NBR = CE.DST_NBR
	AND EV2.ID_NBR = CE.ID_NBR
	
	INNER JOIN
	DBTSIS.SY010 AS SY
	ON
	EV1.SCH_NBR = SY.SCH_NBR
	AND EV1.DST_NBR = SY.DST_NBR
		
WHERE
	EV1.DST_NBR = 1
	AND EV1.SCH_YR = 2014
	--AND EV1.EVENT_CD = '2BUL*'
	AND EV2.PART_TYPE = 'O'
)

--ADDED CODES TABLE TO PULL IN DESCRIPTION OF INFRACTION CODE 3/14/17 DAC 
select DISTINCT 
	S.[Student APS ID],
	D.SCH_YR as [School Year],
	D.STATE_ID as [State Student ID],
	D.[Incident Nbr] as [Event Identifier],
	D.DATE_8 as [Infraction Date],
	D.EVENT_CD as [Infraction Code],
	CODES.EVENT_DESC AS [Description],
	
	CASE 
		WHEN D.PART_TYPE = 'O'
		   THEN 'Offender'
	END  AS [Offender/Victim]
from
	StudentCTE S
left outer join
	DisciplineCTE D
on S.[Student APS ID] = D.ID_NBR
INNER JOIN 
(SELECT DISTINCT 
      [EVENT_CD]
      ,[EVENT_DESC]

  FROM [PR].[DBTSIS].[EV060_V]
 WHERE DST_NBR = 1) AS CODES
ON
D.EVENT_CD = CODES.EVENT_CD


	


	