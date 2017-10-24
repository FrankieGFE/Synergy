
SELECT 
	[SIS Number], [State Student Number], [School Code], [State School Code], Exclude_ADA_ADM
	, CAST([Absence Date] AS DATE) AS [Absence Date], [Unexcused Half Day], [Unexcused Full Day], [Excused Religious Half Day], [Excused Religious Full Day]

 FROM 
[APS].[STARSAttendanceDetailsAsOf]('20171011')
--WHERE [School Code] = '496'