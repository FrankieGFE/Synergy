USE [StudentTransfers]
GO
/****** Object:  StoredProcedure [dbo].[siblings_sis]    Script Date: 10/19/2015 1:59:23 PM ******/
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
--ALTER procedure [dbo].[siblings_sis] 
--(@StudentID as varchar(9))
/* This procedure returns the siblings given a student id.
   It returns the current school (not next year's school) since we can't resolve where 5th and 8th graders will go next year,
   so current school year is used.  Sibling request for 5th and 8th graders is not valid.


*/
--as
--begin
select 	ROW_NUMBER () over (order by siblings.sis_number) as row_num
		, *
from (
	select distinct 
		 sch.school_code
		, org.organization_name as current_school
		, stu.sis_number
		, per.first_name
		, per.middle_name
		, per.last_name
		, grade.VALUE_DESCRIPTION as current_grade
		, grade.alt_code_sif as next_grade
		, ssy.exclude_ada_adm
		, ssy.enter_date
		
	from [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT parent
	join [SYNERGYDBDC].ST_Production.rev.EPC_STU			   stu on stu.student_gu = parent.student_gu
	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
											and oyr.YEAR_GU = (select YEAR_GU from [SYNERGYDBDC].ST_Production.rev.SIF_22_Common_CurrentYearGU)
	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH			   sch	ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION      org						 ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
	JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON			   per  on per.person_gu = stu.student_gu
	LEFT JOIN [LookupTable]('K12','Grade') grade ON grade.VALUE_CODE = ssy.GRADE
	JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT        spar ON spar.STUDENT_GU = stu.STUDENT_GU
		 
/*	left join [SYNERGYDBDC].[ST_Production].[rev].[EPC_GRID] grid on stu.grid_code = grid.grid_code
	*/	
	where parent.parent_gu in
		(select parent.parent_gu 
		from  [SYNERGYDBDC].ST_Production.rev.EPC_STU stu
		join [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT parent
				on stu.student_gu = parent.student_gu
		where stu.sis_number = '970109608' 
		)
	  and stu.sis_number <> '970109608'
	  and ssy.enter_date is not null    -- Found records with two primary enrollments but only one has an enter date
										-- Should we check the leave date?
	  and ssy.exclude_ada_adm is null   -- If two enrollments, take the current one
	  --Find Reason_for_Attendance - if it's "Transfer Approved" then use this school for next year's school (unless 5th or 8th grade)
	  and SPAR.CONTACT_ALLOWED = 'Y'
) as siblings
--end

