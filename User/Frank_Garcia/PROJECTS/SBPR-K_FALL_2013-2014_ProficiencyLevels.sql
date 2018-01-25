BEGIN TRAN

USE
db_KDPR
GO

SELECT
	MATH_.ID_NBR
	,MATH_.MATH_SCORE
	--,LANG_.LANG
	--,MATH_.LANG
	,MATH_PL =
		CASE
		WHEN MATH_.MATH_SCORE < 5 THEN 'N/A'
		WHEN MATH_.MATH_SCORE BETWEEN 5 AND 10 THEN 'Beginning Steps'
		WHEN MATH_.MATH_SCORE BETWEEN 11 AND 16 THEN 'Nearing Proficient'
		WHEN MATH_.MATH_SCORE BETWEEN 17 AND 21 THEN 'Proficient'
		WHEN MATH_.MATH_SCORE BETWEEN 22 AND 28 THEN 'Advanced'
		END
	,LANG_.ELA_SCORE
	,ELA_PL =
		CASE
		WHEN LANG_.ELA_SCORE < 5 THEN 'Unavailable'
		WHEN LANG_.ELA_SCORE BETWEEN 5 AND 13 THEN 'Beginning Steps'
		WHEN LANG_.ELA_SCORE BETWEEN 14 AND 21 THEN 'Nearing Proficient'
		WHEN LANG_.ELA_SCORE BETWEEN 22 AND 27 THEN 'Proficient'
		WHEN LANG_.ELA_SCORE BETWEEN 28 AND 36 THEN 'Advanced'
		END

FROM
			(	
			SELECT
			ID_NBR
			,SUM (CAST(MATH AS INT)) AS 'MATH_SCORE'
			,LANG
			FROM	
				(	
				SELECT [fld_ID_NBR] AS ID_NBR
					  ,[fld_Language] AS LANG
					  ,CASE [fld_Q22]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q22
						END
						AS Q22
					  ,CASE [fld_Q23]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q23
						END
						AS Q23
					  ,CASE 
						[fld_Q24]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q24
						END
						AS Q24
					  ,CASE [fld_Q25]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q25
						END
						AS Q25
					  ,CASE	[fld_Q26]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q26
						END
						AS Q26
					  ,CASE [fld_Q27]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q27
						END
						AS Q27
					  ,CASE	[fld_Q28]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q28
						END
						AS Q28
					  ,CASE	[fld_Q29]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q29
						END
						AS Q29
					  ,CASE	[fld_Q30]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q30
						END
						AS Q30
					  ,CASE [fld_Q31]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q31
						END
						AS Q31
					  ,CASE	[fld_Q33]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q33
						END
						AS Q33
					  ,CASE	[fld_Q34]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q34
						END
						AS Q34
				FROM [db_KDPR].[dbo].[Results]
				WHERE
					fld_AssessmentWindow = 'Fall'
			  ) AS QM
					UNPIVOT
					(MATH FOR QM IN (Q22, Q23, Q24, Q25, Q30,Q31, Q33)) AS U3
					--(MATH FOR QM IN (Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30,Q31,Q33, Q34)) AS U3
			--WHERE ID_NBR = '970078096'
		
			GROUP BY
				ID_NBR, LANG
			)AS MATH_	
			
			INNER JOIN
			(
			SELECT
			ID_NBR
			,LANG
			,SUM (CAST(ELA AS INT)) AS 'ELA_SCORE'
			FROM	
				(	
				SELECT [fld_ID_NBR] AS ID_NBR
					  ,[fld_Language] AS LANG
					  ,CASE [fld_Q2]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q2
						END
						AS Q2
					  ,CASE [fld_Q3]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q3
						END
						AS Q3
					  ,CASE	[fld_Q4]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q4
						END
						AS Q4
					  ,CASE	[fld_Q5]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q5
						END
						AS Q5
					  ,CASE	[fld_Q6]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q6
						END
						AS Q6
					  ,CASE	[fld_Q7]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q7
						END
						AS Q7
					  ,CASE	[fld_Q8]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q8
						END
						AS Q8
					  ,CASE	[fld_Q9]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q9
						END
						AS Q9
					  ,CASE	[fld_Q10]
							WHEN 'NA' THEN '0'
							WHEN '' THEN '0'
							ELSE fld_Q10
						END
						AS Q10
					 -- ,CASE [fld_Q12]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q12
						--END
						--AS Q12
					 -- ,CASE	[fld_Q13]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q13
						--END
						--AS Q13
					 -- ,CASE	[fld_Q14]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q14
						--END
						--AS Q14
					 -- ,CASE	[fld_Q15]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q15
						--END
						--AS Q15
					 -- ,CASE	[fld_Q16]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q16
						--END
						--AS Q16
					 -- ,CASE	[fld_Q18]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q18
						--END
						--AS Q18
					 -- ,CASE	[fld_Q19]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q19
						--END
						--AS Q19
					 -- ,CASE	[fld_Q20]
						--	WHEN 'NA' THEN '0'
						--	WHEN '' THEN '0'
						--	ELSE fld_Q20
						--END
						--AS Q20
				FROM [db_KDPR].[dbo].[Results]
				WHERE
					fld_AssessmentWindow = 'Fall'
				) AS QE
					UNPIVOT
					(ELA FOR QE IN (Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10)) AS U4
					--(ELA FOR QE IN (Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q12, Q13, Q14,Q15,Q16,Q18,Q19,Q20)) AS U4
				GROUP BY
					ID_NBR, LANG
				)AS LANG_
				ON MATH_.ID_NBR = LANG_.ID_NBR	
				   AND MATH_.LANG = LANG_.LANG				
			


ROLLBACK