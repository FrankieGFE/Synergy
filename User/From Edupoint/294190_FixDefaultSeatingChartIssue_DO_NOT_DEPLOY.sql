-- Script to update any classes that have seating charts defined but the default chart is not in the list
UPDATE 
	class 
SET 
	class.DEFAULT_SEAT_CHART_GU = chart.TXP_CLS_CHT_GU
FROM
	EPC_TXP_CLS class
	JOIN EPC_TXP_CLS_CHT chart ON class.TXP_CLS_GU = chart.TXP_CLS_GU
WHERE 
	NOT EXISTS(SELECT * FROM EPC_TXP_CLS_CHT cht WHERE cht.TXP_CLS_CHT_GU = class.DEFAULT_SEAT_CHART_GU
		and cht.TXP_CLS_GU = chart.TXP_CLS_GU)
