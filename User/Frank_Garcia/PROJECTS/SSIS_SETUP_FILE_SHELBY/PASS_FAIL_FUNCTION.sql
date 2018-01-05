USE [SchoolNet]
GO

/****** Object:  UserDefinedFunction [dbo].[passFail_fn]    Script Date: 4/12/2013 3:00:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[passFail_fn](@test varchar(50), @aps_subtest_name varchar(50), @score varchar(50))
returns varchar(50)
begin
	declare @resultValue varchar(50);
	declare @cutValue int;

	SELECT   @resultValue = 
      CASE 
	    WHEN cut_score = 'No Cut Score' then 'No Cut Score'
         WHEN cast(@score as int) >= cast(cut_score as int) THEN 'Pass'
         WHEN cast(@score as int) < cast(cut_score as int) THEN 'Fail'
      END
	FROM pass_fail
	WHERE lower(test_name) = lower(@test)
	  AND lower(aps_subtest_name) = lower(@aps_subtest_name);
	
	RETURN @resultValue;
end;



GO
