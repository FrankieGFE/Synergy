
SELECT
*
FROM [UNISYSComplete].[SISDB].[cocrs2] AS COCRS
WHERE
COCRS.cocrs_room_id = 'J13R'
ORDER BY cocrs_scl_yr, cocrs_room_id

SELECT
*
FROM [UNISYSComplete].[SISDB].[coRSR2] AS CPRSR2
WHERE
CPRSR2.corsr_room_id = 'J13R'
ORDER BY corsr_scl_yr, corsr_room_id


