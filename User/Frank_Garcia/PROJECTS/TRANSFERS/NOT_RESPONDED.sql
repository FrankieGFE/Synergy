USE [StudentTransfersProd]
GO

SELECT 
	  --[sequence_num]
   --   ,[xfer_id]
   [APS_ID]
      --,[Student_First_Name]
      --,[Student_Last_Name]
      --,[Student_DOB]
      --,[Student_Gender]
      --,[Synergy_Parent_GU]
      --,[Current_School]
      --,[SPED_LOI]
      --,[SPED_Primary_Disability]
      --,[Reason_For_Request]
      --,[F_School_Flag]
      --,[School_1_Requested]
      --,[School_1_SPED_Availability]
      --,[School_1_Program]
      --,[School_2_Requested]
      --,[School_2_SPED_Availability]
      --,[School_2_Program]
      --,[School_3_Requested]
      --,[School_3_SPED_Availability]
      --,[School_3_Program]
      --,[SPED_comments]
      --,[grade_entering]
      --,[Status]
      --,[Sibling_First_Name]
      --,[Sibling_Last_Name]
      --,[Sibling_APS_ID]
      --,[Sibling_School]
      --,[Rank]
      --,[School_Accepted]
      --,[Program_Accepted]
      --,[Email]
      --,[Email_Status]
      --,[Tumble_Number]
      --,[Last_Tumble_Processed]
      --,[Comments]
      --,[Record_Inserted_Date]
      --,[School_Year]
  FROM [dbo].[APS_Xfer_Request]
  WHERE School_Year = '2017-2018'
  AND Status = 'ACCEPTED'
  AND Email_Status = '2017-05-16'

GO


