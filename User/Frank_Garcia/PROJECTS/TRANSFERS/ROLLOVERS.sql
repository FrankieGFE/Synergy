USE [db_Transfers]
GO
SELECT
	*
FROM
(
SELECT [Request_Number]
      ,[Date_Approved]
      ,[WD_Approval_Loc_Parent]
      ,[WD_Approval_Date]
      ,[note]
      ,[Edited_By]
      ,[Random_Numb]
      ,[Stu_APS_ID]
      ,[Name_Last]
      ,[Name_First]
      ,[School_Year_Four]
      ,XFER.[School_Year]
      ,[First_Round_Tumbled]
      ,[Round]
      ,XFER.[DOB]
      ,[App_Loc]
	  ,STUD.school_code
      ,[APP_School]
      ,[APP__Priority]
      ,[None]
      ,[GradeCode]
	  ,STUD.grade_code
      ,[Priority_Level]
      ,[Wait_List_1]
      ,[WL_1_Priority]
      ,[Wait_List_2]
      ,[WL_2_Priority]
      ,[Wait_List_3]
      ,[WL_3_Priority]
      ,[SH_Date]
      ,[Date_Added_To_Table]
      ,[Sped_CC]
      ,[Sped_Elig]
      ,[Sped_Lev]
  FROM [dbo].[tbl__Outcomes_All] AS XFER
  LEFT JOIN
  Assessments.DBO.ALLSTUDENTS AS STUD
  ON XFER.Stu_APS_ID = STUD.student_code
) AS T1
WHERE
	1 = 1
	AND App_Loc > 1
	AND school_code != 'NULL'
	AND grade_code NOT IN ('05','08')
	AND App_Loc = school_code
  ORDER BY App_Loc
GO


