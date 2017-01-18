
/****** Object:  UserDefinedFunction [APS].[PrimaryEnrollmentsAsOf]    Script Date: 04/18/2016 08:43:18 ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [APS].[NonPrimaryEnrollmentsAsOf](@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	



--DECLARE @AsOfDate DATE = GETDATE()
	SELECT
		[ENROLLMENTS].*
	FROM
		APS.StudentEnrollmentDetails AS [ENROLLMENTS]
		
		INNER JOIN
		APS.YearDates AS [YearDates]
		ON
		[ENROLLMENTS].[YEAR_GU] = [YearDates].[YEAR_GU]		

	WHERE
		[ENROLLMENTS].[EXCLUDE_ADA_ADM] IS NOT NULL
		AND @AsOfDate BETWEEN [YearDates].START_DATE AND [YearDates].END_DATE
		AND @AsOfDate BETWEEN [ENROLLMENTS].ENTER_DATE AND COALESCE([ENROLLMENTS].LEAVE_DATE, [YearDates].END_DATE)
		
GO


