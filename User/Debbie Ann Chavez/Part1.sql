
--LAST DAY 2013-2014
DECLARE @asOfDate DECIMAL (8,0) = 20140522

    SELECT
	   PERIOD.ID_NBR
	   ,PERIOD.SCH_NBR
	   ,CAL.CAL_DT
	   ,CAL.CYCLE_DAY
	   ,COUNT(PERIOD.CAL_DT) AS  [Count For Day]
    FROM
	   DBTSIS.AT030_V AS PERIOD
	   
	   INNER JOIN 
	   DBTSIS.AT015_V AS CODES
	   ON
	   PERIOD.DST_NBR = CODES.DST_NBR
	   AND PERIOD.SCH_NBR = CODES.SCH_NBR
	   AND PERIOD.REAS_CD = CODES.REAS_CD
	   
	   INNER JOIN 
	   DBTSIS.CA005_V AS CAL
	   ON
	   CAL.DST_NBR = PERIOD.DST_NBR
	   AND CAL.SCH_YR = PERIOD.SCH_YR
	   AND CAL.SCH_NBR = PERIOD.SCH_NBR
	   AND CAL.CAL_DT = PERIOD.CAL_DT

    WHERE
	   PERIOD.DST_NBR = 1
	   AND PERIOD.SCH_YR = 2014
	   AND PERIOD.ATT_STAT = 'A'
	   AND (CODES.EXCSD_ABS IN ('E', 'U') --AND CODES.REAS_CD != 'AC'
	   )
	   AND PERIOD.CAL_DT<= @asOfDate
	   AND ID_NBR = 102785458

    GROUP BY
	   PERIOD.ID_NBR
	   ,PERIOD.SCH_NBR
	   ,CAL.CAL_DT
	   ,CAL.CYCLE_DAY