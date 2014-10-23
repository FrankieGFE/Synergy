IF OBJECT_ID('dbo.CleanName') IS NOT NULL DROP FUNCTION dbo.CleanName
GO
--function to cleanup name string
Create Function dbo.CleanName(@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin
    Declare @CleanValues as varchar(50)
    Set @CleanValues = '%[^a-z ]%'
    While PatIndex(@CleanValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@CleanValues, @Temp), 1, '')
    Return @Temp
End
go