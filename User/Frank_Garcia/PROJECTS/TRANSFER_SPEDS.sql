
SELECT
	XFER_ID
	,Student_First_Name
	,Student_Last_Name
	,APS_ID
	,Student_DOB
	,Student_Gender
	,CURRENT_SCHOOL
	,grade_entering
	,RESOLVED_LOI
	,RESOLVED_PRIM_DISAB
	,Reason_For_Request
	--,School_Requested_1
	--,School_1_SPED_Availability
	--,School_Requested_2
	--,School_2_SPED_Availability
	--,School_Requested_3
	--,School_3_SPED_Availability
	,Status
	,[SCHOOL ACCEPTED]
	,'' AS Availability
FROM
(
SELECT
      --ROW_NUMBER () OVER (PARTITION BY [Student_Last_Name], Student_First_Name, APS_ID ORDER BY Student_First_Name) AS RN
      DISTINCT XFER_ID
	  ,[Student_First_Name]
      ,[Student_Last_Name]
	  ,CASE WHEN APS_ID IS NULL THEN STUD.student_code
			ELSE APS_ID
	  END AS 'APS_ID'
      ,[Student_DOB]
      ,[Student_Gender]
      , SCHC.SCHOOL_NAME AS CURRENT_SCHOOL
      ,[grade_entering]
   --   ,[SPED_LOI]
	  --,SPED.LOI
	  ,CASE WHEN LOI IS NULL THEN SPED_LOI ELSE LOI
	  END AS 'RESOLVED_LOI'
	  --,SPED.program_code
	  ,CASE WHEN SPED.program_code IS NULL THEN SPED_LOI ELSE SPED.program_code
	  END AS RESOLVED_PRIM_DISAB
      ,[Reason_For_Request]
      ,SCH1.school_name AS School_Requested_1
	  ,'' AS [School_1_SPED_Availability]
      ,SCH2.school_name AS School_Requested_2
	  ,'' AS [School_2_SPED_Availability]
      ,SCH3.school_name AS School_Requested_3
	  ,'' AS [School_3_SPED_Availability]
      ,[Status]
	  ,School_Accepted
      --,[Email]
      --,[Comments]
      --,T2.[School_Year]
	  ,SCH_a.school_name AS 'SCHOOL ACCEPTED'
	  
FROM
(
SELECT
      --ROW_NUMBER () OVER (PARTITION BY [Student_Last_Name], Student_First_Name, APS_ID ORDER BY Student_First_Name) AS RN
	  distinct 
      XFER_ID
	  ,[Student_First_Name]
      ,[Student_Last_Name]
	  ,CASE
			WHEN [APS_ID] = '' THEN STUD.student_code
			ELSE APS_ID
	  END AS APS_ID
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Current_School]
      ,[grade_entering]
      ,[SPED_LOI]
      ,[Reason_For_Request]
      ,[School_Requested_1]
	  ,[School_1_SPED_Availability]
      ,[School_Requested_2]
	  ,[School_2_SPED_Availability]
      ,[School_Requested_3]
	  ,[School_3_SPED_Availability]
      ,[Status]
      ,[Email]
      ,[Comments]
      ,T1.[School_Year]
	  ,School_Accepted
FROM
(
SELECT 
      XFER_ID
	  ,[Student_First_Name]
      ,[Student_Last_Name]
	  ,[APS_ID]
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Current_School]
      ,[SPED_LOI]
      ,[Reason_For_Request]
      ,[School_Requested_1]
	  ,[School_1_SPED_Availability]
      ,[School_Requested_2]
	  ,[School_2_SPED_Availability]
      ,[School_Requested_3]
	  ,[School_3_SPED_Availability]
      ,[grade_entering]
      ,[Status]
      ,[Email]
      ,[Comments]
      ,[School_Year]
	  ,School_Accepted
  FROM [dbo].[APS_Xfer_Request]
  

  UNION

  SELECT 
      XFER_ID
	  ,[Student_First_Name]
      ,[Student_Last_Name]
      ,[APS_Student_ID_Number] AS 'APS_ID'
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Currently_Enrolled_School] AS 'Current_School'
      ,[SPED_LOI]
      ,[Reason_For_Request]
      ,[School_Requested_1]
	  ,[School_1_SPED_Availability]
      ,[School_Requested_2]
	  ,[School_2_SPED_Availability]
      ,[School_Requested_3]
	  ,[School_3_SPED_Availability]
      ,[Grade_Entering]
      ,[Status]
      ,[Parent_Gaurdian_1_Email] AS 'EMAIL'
      ,[Comments]
      ,[School_Year]
	  ,School_Accepted
  FROM [dbo].[Non_APS_Xfer_Request]
  ) AS T1

  LEFT JOIN
  Assessments.DBO.allstudents_ALL AS STUD
  ON T1.STUDENT_FIRST_NAME = STUD.first_name
  AND T1.Student_Last_Name = STUD.last_name
  AND T1.Student_DOB = STUD.DOB

  WHERE SPED_LOI != ''
  AND Status != 'DELETED'
  AND SPED_LOI NOT IN ('A','B','GIFTED')

) AS T2
LEFT JOIN
Schools AS SCH1
ON SCH1.school_code = T2.School_Requested_1

LEFT JOIN
Schools AS SCH2
ON SCH2.school_code = T2.School_Requested_2

LEFT JOIN
Schools AS SCH3
ON SCH3.school_code = T2.School_Requested_3

LEFT JOIN
Schools AS SCHC
ON SCHC.school_code = T2.Current_School

LEFT JOIN
Schools AS SCH_a
ON SCH_a.school_code = T2.School_Accepted

LEFT JOIN
allstudents_sped AS SPED
ON (T2.APS_ID = SPED.student_code
OR T2.APS_ID = SPED.state_id)

LEFT JOIN
Assessments.DBO.allstudents_ALL AS STUD
ON T2.Student_First_Name = STUD.first_name
AND T2.Student_Last_Name = STUD.last_name
AND T2.Student_DOB = STUD.DOB

) AS SPED_STAT
WHERE 1 = 1
AND RESOLVED_LOI NOT IN ('(A)','(B)')
AND RESOLVED_PRIM_DISAB != 'GI'
AND RESOLVED_PRIM_DISAB NOT LIKE '%GIFTED%'
AND Status = 'ACCEPTED'


ORDER BY RESOLVED_LOI
--ORDER BY [School_Requested_1], [School_Requested_2], [School_Requested_3]
