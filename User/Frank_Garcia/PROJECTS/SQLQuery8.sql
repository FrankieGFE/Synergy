USE [db_KDPR]
GO
/****** Object:  StoredProcedure [dbo].[usp_Get_KDPR_Results]    Script Date: 09/25/2012 09:09:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Get_KDPR_Results]
	@studentIDNumber bigint,
	@assessmentWindow varchar(15),
	@assessmentLanguage varchar(10)

AS

GOTO Get_Student_Results

	Get_Student_Results:
			
			BEGIN

				SELECT     Results.*
				FROM       Results
				WHERE     (fld_ID_NBR = @studentIDNumber) AND (fld_AssessmentWindow = @assessmentWindow) AND (fld_Language = @assessmentLanguage)
				
				Return 1;
			
			END
		

		

			











