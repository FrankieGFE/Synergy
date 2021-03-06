USE [StudentTransfersDev]
GO
/****** Object:  StoredProcedure [dbo].[Get_Xfer_Record_For_Update]    Script Date: 1/4/2018 2:10:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[Get_Xfer_Record_For_Update]
--	@Xfer_ID varchar(10)
--AS
--Return the Xfer request record repeated for each different comment
declare @aps_id varchar(10) = '970108780'
declare @school_year varchar(9) = '2018-2019'
declare @xfer_id varchar (9) = 'A18086'

	select 
		xfer.School_Year,
		xfer.APS_ID,
		xfer.Student_First_Name,
		xfer.Student_Last_Name,
		xfer.Student_DOB,
		xfer.current_school,
		xfer.xfer_id,
		xfer.SPED_LOI,
		xfer.Reason_For_Request,
		xfer.School_1_Requested,
		xfer.School_1_Program,
		xfer.School_2_Requested,
		xfer.School_2_Program,
		xfer.School_3_Requested,
		xfer.School_3_Program,
		xfer.grade_entering,
		xfer.Email,
		xfer.School_Accepted,
		xfer.Program_Accepted,
		xfer.f_school_flag,
		xfer.Status,
		xfer.Record_Inserted_Date
	from aps_xfer_request xfer
	where xfer.xfer_id = @Xfer_ID

	select @aps_id = aps_id, @school_year = School_Year
	from APS_Xfer_Request xfer
	where xfer.xfer_id = @Xfer_ID

	select id, Student_APS_ID, Sibling_First_Name, Sibling_Last_Name, Sibling_APS_ID, Sibling_School, School_Year, Grade_Entering, Record_Inserted_Date
	from Siblings
	where Student_APS_ID = @aps_id
	  and School_Year = @school_year

select comments from APS_Xfer_Request where xfer_id = @Xfer_ID
union
select a.value as Comments
 from audit a
	where xfer_id = @Xfer_ID
	  and action = 'User Update'
	  and value like 'Comments:%'


--RETURN 0