/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	*
FROM
(
SELECT	 [id_nbr]
      ,[Last_Name]
      ,[First_name]
      ,[School]
      ,[Current SY2014 Grade]
      ,[Reading_SBA]
      ,[Math_SBA]
      ,[Combo_MR_SBA]
      ,[Science_SBA]
      ,[Writing_EOC]
      ,[History_EOC]
      ,[Reading_EOC]
      ,[Biology_EOC]
      ,[Chemistry_EOC]
      ,[Pass/Fail_Reading]
      ,[Pass/Fail_Math]
      ,[Pass/Fail_R/M]
      ,[Pass/Fail_Science]
      ,[Pass/Fail_Writing]
      ,[Pass/Fail_History]
      ,[Pass/Fail_Reading_EOC]
      ,[Pass/Fail_Chemistry]
      ,[Pass/Fail_Biology]
      ,[Passed All Required Tests]
      ,[Take_SBA]
      ,[Take_EOC]
      ,[SCI_FD]
      ,[Math (English)]
      ,[Math (Spanish)]
      ,[Reading (English)]
      ,[Reading (Spanish)]
      ,[Science (English)]
      ,[Science (Spanish)]
      ,[Social Studies (English)]
      ,[Grand Total]
      ,[Science (English)] + [Science (Spanish)]  AS science_total 
  FROM [SchoolNetDevelopment].[dbo].[Exit_Exam_Status_Winter_2013_2014]
  ) AS T1
WHERE Writing_EOC > 1 and Writing_EOC < 10 AND [Pass/Fail_Writing] = 'fail'