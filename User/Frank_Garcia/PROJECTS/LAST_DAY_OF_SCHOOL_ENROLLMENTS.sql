BEGIN TRAN

		SELECT
			--ST010._Id,
			--ROW_NUMBER() OVER (PARTITION BY ST010.DST_NBR, ST010.ID_NBR ORDER BY ST010.BEG_ENR_DT DESC) AS RN,
			--ST010.DST_NBR,
			ST010.SCH_NBR,
			--ST010.GRDE,
			COUNT(ID_NBR) [Enrollment Last Day]
			--ST010.ID_NBR,
			--ST010.SCH_YR,
			--ST010.BEG_ENR_DT,
			--ST010.END_ENR_DT
		FROM
			DBTSIS.ST010 WITH(NOLOCK) 
		WHERE
			  -- Qualifications for Enrollment is that today's date needs to fall within beginning and end enrollment
			  -- dates AND the enrollment is marked primary (NONADA_SCH not X)
			  NONADA_SCH != 'X' 
			  --AND  ST010.BEG_ENR_DT <= (CONVERT (VARCHAR (8), @asOfDate, 112))
			  --AND (END_ENR_DT >= (CONVERT (VARCHAR (8), @asOfDate, 112)) OR END_ENR_DT = 0)
			  AND END_ENR_DT = '20130522'
			  AND DST_NBR = 1
		GROUP BY SCH_NBR
		ORDER BY SCH_NBR


ROLLBACK