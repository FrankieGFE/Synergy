USE Assessments
GO



/***MATH***/
drop table SBA_Math
SELECT *
into SBA_Math
FROM
(
select 
row_number() over (partition by student_code order by CAST(scaled_score AS INT) desc) as high, *
		from SBA
where SBA.test_section_name = 'MATH' AND SBA.scaled_score NOT LIKE '99%' AND SBA.test_level_name IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 


) as t
where high = 1

/***READING***/
drop table SBA_Reading
SELECT *
into SBA_Reading
FROM
(
select 
row_number() over (partition by student_code order by CAST(scaled_score AS INT) desc) as high, *
		from SBA 
where SBA.test_section_name IN ('READING','READING(S)') AND scaled_score NOT LIKE '99%' AND SBA.test_level_name IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 
) as t
where high = 1


/***SOCIAL STUDIES***/
drop table SBA_Social_Studies
SELECT *
into SBA_Social_Studies
FROM
(
select 
row_number() over (partition by student_code order by CAST(scaled_score AS INT) desc) as high, *
		from SBA 
where SBA.test_section_name = 'SOCIAL STUDIES' AND scaled_score NOT LIKE '99%' AND SBA.test_level_name IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 

) as t
where high = 1

/***SCIENCE***/
drop table SBA_Science
SELECT *
into SBA_Science
FROM
(
select 
row_number() over (partition by student_code order by CAST(scaled_score AS INT) desc) as high, *
		from SBA 
where SBA.test_section_name = 'SCIENCE' AND scaled_score NOT LIKE '99%' AND SBA.test_level_name IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 

) as t
where high = 1

/***WRITING***/
drop table SBA_Writing
SELECT *
into SBA_Writing
FROM
(
select 
row_number() over (partition by student_code order by CAST(scaled_score AS INT) desc) as high, *
		from SBA 
where SBA.test_section_name = 'WRITING' AND scaled_score NOT LIKE '99%' AND SBA.test_level_name IN ( '09', '10', '11', '12','C1', 'C2', 'C3', 'C4', 'T1', 'T2', 'T3', 'T4','H0','H1','H2','H3','H4','H5','H6','H7','H8','H9') 

) as t
where high = 1

DROP TABLE TMP 

SELECT DISTINCT ID_NBR 
INTO   TMP 
FROM   ST010

ALTER TABLE TMP 
  ADD LAST_NAME Varchar(50) 

ALTER TABLE TMP 
  ADD FIRST_NAME Varchar(50) 

ALTER TABLE TMP 
  ADD M_NAME Varchar(50) 

ALTER TABLE TMP 
  ADD SCHOOL Varchar(4) 

ALTER TABLE TMP 
  ADD [CURRENT SY2014 GRADE] Varchar(2) 

ALTER TABLE TMP 
  ADD [READING] Numeric(5) 
  
  
ALTER TABLE TMP 
  ADD [MATH] Numeric(5) 

ALTER TABLE TMP 
  ADD [TOTAL SCORE READING/MATH] Numeric(5) 

ALTER TABLE TMP 
  ADD [WRITING] Numeric(5) 

ALTER TABLE TMP 
  ADD [SOCIAL STUDIES] Numeric(5) 

ALTER TABLE TMP 
  ADD [SCIENCE] Numeric(5) 

ALTER TABLE TMP 
  ADD [TEST_SUB] Varchar(16) 

ALTER TABLE TMP 
  ADD [PARCC_ALG_II] VARCHAR(10) 

ALTER TABLE TMP 
  ADD [PARCC_GEOM] VARCHAR(10)

ALTER TABLE TMP 
  ADD [PARCC_ELA_11_READ] VARCHAR(10)

ALTER TABLE TMP 
  ADD [PARCC_ELA_11_WRIT] VARCHAR(10)




UPDATE TMP 
SET    TMP.READING = SBA_READING.scaled_score
FROM   SBA_READING 
WHERE  TMP.ID_NBR = SBA_READING.student_code
AND SBA_Reading.scaled_score > '1'


UPDATE TMP 
SET    TMP.MATH = SBA_MATH.scaled_score
FROM   SBA_MATH 
WHERE  TMP.ID_NBR = SBA_MATH.student_code
AND SBA_Math.scaled_score > '1'

UPDATE TMP 
SET    TMP.[SOCIAL STUDIES] = SBA_SOCIAL_STUDIES.scaled_score
FROM   SBA_SOCIAL_STUDIES 
WHERE  TMP.ID_NBR = SBA_SOCIAL_STUDIES.student_code
AND SBA_Social_Studies.scaled_score > '1'

UPDATE TMP 
SET    TMP.[SCIENCE] = SBA_SCIENCE.scaled_score
FROM   SBA_SCIENCE 
WHERE  TMP.ID_NBR = SBA_SCIENCE.student_code
AND SBA_Science.scaled_score > '1'

UPDATE TMP 
SET    TMP.[Writing] = SBA_Writing.scaled_score
FROM   SBA_Writing
WHERE  TMP.ID_NBR = SBA_Writing.student_code
AND SBA_Writing.scaled_score > '1'

UPDATE TMP 
SET    TMP.LAST_NAME = ST010.last_name
FROM   ST010 AS ST010 
WHERE  TMP.ID_NBR = ST010.ID_NBR

UPDATE TMP 
SET    FIRST_NAME = ST010.first_name
FROM   ST010 AS ST010 
WHERE  TMP.ID_NBR = ST010.ID_NBR
UPDATE TMP 
SET    [CURRENT SY2014 GRADE] = ST010.GRDE
FROM   ST010 AS ST010 
WHERE  TMP.ID_NBR = ST010.ID_NBR

UPDATE TMP 
SET    SCHOOL = ST010.SCH_NBR
FROM   ST010 AS ST010 
WHERE  TMP.ID_NBR = ST010.ID_NBR

--UPDATE TMP 
--SET    M_NAME = M_NME 
--FROM   [SMAXDBPROD].[PR].[DBTSIS].[CE020_V] AS CE020 
--WHERE  TMP.ID_NBR = CE020.ID_NBR 

UPDATE TMP 
SET    [TOTAL SCORE READING/MATH] = [READING] + [MATH] 
--WHERE  ([READING] >= 1129)
--       AND ([MATH] >= 1127)

ALTER TABLE TMP 
  ADD [PASS/FAIL_RM] Varchar(5) 

UPDATE TMP 
SET    [PASS/FAIL_RM] = ( CASE
							WHEN [READING] IS NULL OR [MATH] IS NULL THEN ''
							ELSE
								CASE 
								WHEN ( ( [READING] ) + ( [MATH] ) >= 2273 
									   AND ( [MATH] ) >= 1127 
									   AND ( [READING] ) >= 1129 ) THEN 'PASS' 
								ELSE ( 'FAIL' ) 
							  END
							END ) 

--UPDATE TMP 
--SET    [PASS/FAIL_RM] = '' 
--WHERE  ([MATH] < 1127)
--        OR ([READING] < 1129)
        
        
        

ALTER TABLE TMP 
  ADD [PASS/FAIL_READING] Varchar(5) 

UPDATE [TMP] 
SET    [PASS/FAIL_READING] = ( CASE 
                                 WHEN ( ( [READING] ) >= 1137 ) THEN 'PASS' 
                                 ELSE ( 'FAIL' ) 
                               END ) 

UPDATE [TMP] 
SET    [PASS/FAIL_READING] = '' 
WHERE  [READING]IS NULL 




ALTER TABLE TMP 
  ADD [PASS/FAIL_MATH] Varchar(5) 

UPDATE [TMP] 
SET    [PASS/FAIL_MATH] = ( CASE 
                              WHEN ( ( [MATH] ) >= 1137 ) THEN 'PASS' 
                              ELSE ( 'FAIL' ) 
                            END ) 

UPDATE [TMP] 
SET    [PASS/FAIL_MATH] = '' 
WHERE  [MATH]IS NULL 



ALTER TABLE TMP 
  ADD [PASS/FAIL_SCIENCE] Varchar(5) 

UPDATE [TMP] 
SET    [PASS/FAIL_SCIENCE] = ( CASE 
                                 WHEN ( ( [SCIENCE] ) >= 1138 ) THEN 'PASS' 
                                 ELSE ( 'FAIL' ) 
                               END ) 

UPDATE [TMP] 
SET    [PASS/FAIL_SCIENCE] = '' 
WHERE  [SCIENCE]IS NULL 

UPDATE TMP 
SET    TMP.[PARCC_ALG_II] = (CASE WHEN Preliminary_2015_PARCC.PL IN ('3','4','5') THEN 'PASS'
						       ELSE 'FAIL'
							   END)
FROM   Preliminary_2015_PARCC 
WHERE  TMP.ID_NBR = Preliminary_2015_PARCC.StudentID
AND Preliminary_2015_PARCC.Subtest = 'Algebra 2'

UPDATE TMP 
SET    TMP.PARCC_GEOM = (CASE WHEN Preliminary_2015_PARCC.PL IN ('3','4','5') THEN 'PASS'
						       ELSE 'FAIL'
							   END)
FROM   Preliminary_2015_PARCC 
WHERE  TMP.ID_NBR = Preliminary_2015_PARCC.StudentID
AND Preliminary_2015_PARCC.Subtest = 'Geometry'

UPDATE TMP 
SET    TMP.PARCC_ELA_11_READ = (CASE WHEN Preliminary_2015_PARCC.ReadingPF = '1' THEN 'PASS'
						       ELSE 'FAIL'
							   END)
FROM   Preliminary_2015_PARCC 
WHERE  TMP.ID_NBR = Preliminary_2015_PARCC.StudentID
AND Preliminary_2015_PARCC.Subtest = 'English Language Arts 11th Grade'

UPDATE TMP 
SET    TMP.PARCC_ELA_11_WRIT = (CASE WHEN Preliminary_2015_PARCC.WritingPF = '1' THEN 'PASS'
						       ELSE 'FAIL'
							   END)
FROM   Preliminary_2015_PARCC 
WHERE  TMP.ID_NBR = Preliminary_2015_PARCC.StudentID
AND Preliminary_2015_PARCC.Subtest = 'English Language Arts 11th Grade'


