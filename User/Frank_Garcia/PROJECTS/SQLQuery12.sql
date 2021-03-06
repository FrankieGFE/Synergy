USE [StudentTransfers]
GO
/****** Object:  StoredProcedure [dbo].[schools_attended]    Script Date: 10/19/2015 1:40:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
--ALTER procedure [dbo].[schools_attended] (@student_id varchar(9)) as
--begin
	select  distinct
		 sch.school_code
		, org.organization_name as current_school
		, stu.sis_number
		--, per.first_name
		--, per.middle_name
		--, per.last_name
		--, grade.VALUE_DESCRIPTION as grade_attended
		--, ssy.exclude_ada_adm
		--, ssy.enter_date
		, CASE
	        WHEN sopt.SCHOOL_TYPE = '1' THEN 'ES'
			WHEN sopt.SCHOOL_TYPE = '2' THEN 'MS'
			WHEN sopt.SCHOOL_TYPE = '3' THEN 'HS'
			ELSE 'OT'
			end as school_type
	from [SYNERGYDBDC].ST_Production.rev.EPC_STU			   stu 

	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU

	JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
											--and oyr.YEAR_GU = (select YEAR_GU from [SYNERGYDBDC].ST_Production.rev.SIF_22_Common_CurrentYearGU)
	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH			   sch	ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU

	JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION      org						 ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU


	JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON			   per  on per.person_gu = stu.student_gu
	LEFT JOIN [LookupTable]('K12','Grade') grade ON grade.VALUE_CODE = ssy.GRADE
	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH_YR_OPT        sopt ON sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
	
	where

	   stu.sis_number = '970053485'
	   and ssy.enter_date is not null    -- Found records with two primary enrollments but only one has an enter date
										-- Should we check the leave date?
	 -- and ssy.exclude_ada_adm is null   -- If two enrollments, take the current one
	  --Find Reason_for_Attendance - if it's "Transfer Approved" then use this school for next year's school (unless 5th or 8th grade)

	  and sopt.SCHOOL_TYPE =
	  (
	select max(sopt.SCHOOL_TYPE)

	from [SYNERGYDBDC].ST_Production.rev.EPC_STU			   stu 

	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH_YR_OPT        sopt ON sopt.ORGANIZATION_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
	
	where

	   stu.sis_number = '970053485'
	)
--end



