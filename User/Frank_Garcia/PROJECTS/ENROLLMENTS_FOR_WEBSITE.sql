SELECT
	'2014' AS SCH_YR
	,SCH_NBR
	,GRDE
	,COUNT (ID_NBR) AS TOTAL
FROM
   (
    SELECT    ROW_NUMBER () OVER (PARTITION BY ID_NBR ORDER BY ID_NBR) AS RN
			  ,ID_NBR
              ,SCH_NBR
              ,GRDE

    FROM      PR.DBTSIS.ST010_V

    WHERE     DST_NBR = 1 
			  AND
              NONADA_SCH != 'X'
              AND
              SCH_YR = 2014
              AND
              END_ENR_DT != 20130000 
              AND
              BEG_ENR_DT <=  20130828      
              AND
              (END_ENR_DT = 0  OR END_ENR_DT >= 20130828)
	)AS ALLSTUDENTS              
WHERE RN = 1  
GROUP BY SCH_NBR, GRDE   
ORDER BY SCH_NBR     

