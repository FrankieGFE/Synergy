

UPDATE
TRASH_sped_transfer_status
SET [School 3 Availability] = 'NO'
FROM
(
SELECT
	   [Transfer ID]
      ,[Row]
      ,[APS ID]
      ,[DOB]
      ,[Gender]
      ,[Current School]
      ,GRADE_ENTERING
      ,[SPED LOI]
      ,[School Requested 1]
	  ,SPA1
	  ,SC1
      ,[School 1 Availability]
      ,[School Requested 2]
	  ,SPA2
	  ,SC2
      ,[School 2 Availability]
      ,[School Requested 3]
	  ,SPA3
	  ,SC3
      ,[School 3 Availability]
FROM (
SELECT
	   [Transfer ID]
      ,[Row]
      ,[APS ID]
      ,[DOB]
      ,[Gender]
      ,[Current School]
      ,GRADE_ENTERING
      ,[SPED LOI]
      ,[School Requested 1]
	  ,SA1.spaces_available AS SPA1
	  ,SC1
      ,[School 1 Availability]
      ,[School Requested 2]
	  ,SA2.spaces_available AS SPA2
	  ,SC2
      ,[School 2 Availability]
      ,[School Requested 3]
	  ,SA3.spaces_available AS SPA3
	  ,SC3
      ,[School 3 Availability]
FROM
(
SELECT
	   [Transfer ID]
      ,[Row]
      ,[APS ID]
      ,[DOB]
      ,[Gender]
      ,[Current School]
      ,GRADE_ENTERING
      ,[SPED LOI]
      ,[School Requested 1]
	  ,SCH1.school_code AS SC1
      ,[School 1 Availability]
      ,[School Requested 2]
	  ,SCH2.school_code AS SC2
      ,[School 2 Availability]
      ,[School Requested 3]
	  ,SCH3.school_code AS SC3
      ,[School 3 Availability]
FROM
(
SELECT 
	   [Transfer ID]
      ,[Row]
      ,[APS ID]
      ,[DOB]
      ,[Gender]
      ,[Current School]
      ,CASE WHEN [Grade Entering] != 'K' THEN RIGHT('00' + [Grade Entering],2) ELSE [Grade Entering] END AS GRADE_ENTERING
      ,[SPED LOI]
      ,[School Requested 1]
      ,[School 1 Availability]
      ,[School Requested 2]
      ,[School 2 Availability]
      ,[School Requested 3]
      ,[School 3 Availability]
  FROM [StudentTransfersProd].[dbo].[TRASH_sped_transfer_status]
) AS T1
LEFT JOIN
Schools AS SCH1
ON SCH1.school_name = [School Requested 1]

LEFT JOIN
SCHOOLS AS SCH2
ON SCH2.SCHOOL_NAME = [School Requested 2]

LEFT JOIN
SCHOOLS AS SCH3
ON SCH3.school_name = [School Requested 3]

)AS T2
  LEFT JOIN
  School_Availability AS SA1
  ON GRADE_ENTERING = SA1.grade
  AND SC1 = SA1.school_code

  LEFT JOIN School_Availability AS SA2
  ON GRADE_ENTERING = SA2.grade
  AND SC2 = SA2.school_code

  LEFT JOIN School_Availability AS SA3
  ON GRADE_ENTERING = SA3.grade
  AND SC3 = SA3.school_code

  --OR SA.school_code = SC2
  --OR SA.school_code = SC3
) AS TTT
WHERE TTT.SPA3 = 0
) TRT
WHERE TRASH_sped_transfer_status.[Transfer ID] = TRT.[Transfer ID]

