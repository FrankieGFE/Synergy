-- create a temp table to hold dates of the academic year
IF OBJECT_ID('tempdb..##TempYearDates') IS NOT NULL DROP TABLE ##TempYearDates
CREATE TABLE ##TempYearDates (
    yr_date smalldatetime primary key
  , date_string varchar(10)
  , DayofWeekName varchar(10)
  , IsWeekend bit
  , SchoolYear varchar(4)
)
CREATE INDEX SY ON ##TempYearDates (SchoolYear)
-- Declare and set variables for loop
Declare
  @StartDate smalldatetime
, @EndDate smalldatetime
, @Date smalldatetime
, @SchYr varchar(4)
, @SchYrPlusOne varchar(4)
set @SchYr = cast((select school_year from rev.SIF_22_Common_CurrentYear) as varchar(4)) 
set @SchYrPlusOne = cast((select school_year+1 from rev.SIF_22_Common_CurrentYear) as varchar(4)) 
Set @StartDate = '07/01/'+ @SchYr
Set @EndDate = '06/30/'+ @SchYrPlusOne
Set @Date = @StartDate
-- Loop through dates
WHILE @Date <=@EndDate
BEGIN
    -- Check for weekend
    DECLARE @IsWeekend BIT
    IF (DATEPART(dw, @Date) = 1 OR DATEPART(dw, @Date) = 7)
    BEGIN
        SELECT @IsWeekend = 1
    END
    ELSE
    BEGIN
        SELECT @IsWeekend = 0
    END
 
    -- Insert record in temp table
	    INSERT Into ##TempYearDates
    (
       yr_date
     , date_string
     , DayofWeekName
     , IsWeekend
	 , SchoolYear
    )
    Values
    (
        @Date
	  , CONVERT(varchar(10), @Date, 120)
	  , DATENAME(dw, @Date)
	  , @IsWeekend
	  , @SchYr
    )
    -- Goto next day
    Set @Date = @Date + 1
END
