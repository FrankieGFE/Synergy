
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	T1.*
	
	,BilingualModel_2011_2012_40D, BEPHours_2011_2012_40D 
	,BilingualModel_2011_2012_80D, BEPHours_2011_2012_80D
	,BilingualModel_2011_2012_120D, BEPHours_2011_2012_120D
	,BilingualModel_2011_2012_LastDay, BEPHours_2011_2012_LastDay

	,BilingualModel_2012_2013_40D, BEPHours_2012_2013_40D 
	,BilingualModel_2012_2013_80D, BEPHours_2012_2013_80D
	,BilingualModel_2012_2013_120D, BEPHours_2012_2013_120D
	,BilingualModel_2012_2013_LastDay, BEPHours_2012_2013_LastDay

	,BilingualModel_2013_2014_40D, BEPHours_2013_2014_40D 
	,BilingualModel_2013_2014_80D, BEPHours_2013_2014_80D
	,BilingualModel_2013_2014_120D, BEPHours_2013_2014_120D
	,BilingualModel_2013_2014_LastDay, BEPHours_2013_2014_LastDay

	

	,DAY40.StudentID, DAY40.BEPProgramDescription AS BEPProgram_40D_2014_2015, DAY40.BEPHours AS BEPHours_40D_2014_2015 ,

	 DAY80.BEPProgramDescription AS BEPProgram_80D_2014_2015, DAY80.BEPHours AS BEPHours_80D_2014_2015  ,

	 DAY120.BEPProgramDescription AS BEPProgram_120D_2014_2015, DAY120.BEPHours AS BEPHours_120D_2014_2015 ,

	 LastDay.BEPProgramDescription AS BEPProgram_LastDay_2014_2015, LastDay.BEPHours AS BEPHours_LastDay_2014_2015

	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from Unduplicated2.csv'
                ) AS [T1]

LEFT JOIN
rev.EPC_STU AS STU
ON
T1.[StudentID] = STU.STATE_STUDENT_NUMBER

----------------------------------------------------------------------------------------
LEFT JOIN 
(SELECT DISTINCT StudentID, BEPProgramDescription, BEPHours FROM
APS.BilingualModelAndHoursDetailsAsOf('20141008')) AS DAY40
ON
STU.SIS_NUMBER = DAY40.StudentID

LEFT JOIN 
(SELECT DISTINCT StudentID, BEPProgramDescription, BEPHours FROM
APS.BilingualModelAndHoursDetailsAsOf('20141201')) AS DAY80
ON
STU.SIS_NUMBER = DAY80.StudentID

LEFT JOIN 
(SELECT DISTINCT StudentID, BEPProgramDescription, BEPHours FROM
APS.BilingualModelAndHoursDetailsAsOf('20150211')) AS DAY120
ON
STU.SIS_NUMBER = DAY120.StudentID

LEFT JOIN 
(SELECT DISTINCT StudentID, BEPProgramDescription, BEPHours FROM
APS.BilingualModelAndHoursDetailsAsOf('20150522')) AS LASTDAY
ON
STU.SIS_NUMBER = LASTDAY.StudentID
---------------------------------------------------------------------------------------------
--2011-2012
LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2011_2012_40D, TotalHours AS BEPHours_2011_2012_40D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2012_40D) AS BEP201240D
ON
STU.SIS_NUMBER = BEP201240D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2011_2012_80D, TotalHours AS BEPHours_2011_2012_80D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2012_80D) AS BEP201280D
ON
STU.SIS_NUMBER = BEP201280D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2011_2012_120D, TotalHours AS BEPHours_2011_2012_120D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2012_120D) AS BEP2012120D
ON
STU.SIS_NUMBER = BEP2012120D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2011_2012_LastDay, TotalHours AS BEPHours_2011_2012_LastDay  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2012_LastDay) AS BEP2012LastDay
ON
STU.SIS_NUMBER = BEP2012LastDay.ID_NBR collate database_default
------------------------------------------------------------------------------------------------------------------------------------

--2012-2013
LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2012_2013_40D, TotalHours AS BEPHours_2012_2013_40D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2013_40D) AS BEP201340D
ON
STU.SIS_NUMBER = BEP201340D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2012_2013_80D, TotalHours AS BEPHours_2012_2013_80D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2013_80D) AS BEP201380D
ON
STU.SIS_NUMBER = BEP201380D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2012_2013_120D, TotalHours AS BEPHours_2012_2013_120D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2013_120D) AS BEP2013120D
ON
STU.SIS_NUMBER = BEP2013120D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2012_2013_LastDay, TotalHours AS BEPHours_2012_2013_LastDay  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2013_LastDay) AS BEP2013LastDay
ON
STU.SIS_NUMBER = BEP2013LastDay.ID_NBR collate database_default

----------------------------------------------------------------------------------------------------------------------------------

--2013-2014
LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2013_2014_40D, TotalHours AS BEPHours_2013_2014_40D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2014_40D) AS BEP201440D
ON
STU.SIS_NUMBER = BEP201440D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2013_2014_80D, TotalHours AS BEPHours_2013_2014_80D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2014_80D) AS BEP201480D
ON
STU.SIS_NUMBER = BEP201480D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2013_2014_120D, TotalHours AS BEPHours_2013_2014_120D  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2014_120D) AS BEP2014120D
ON
STU.SIS_NUMBER = BEP2014120D.ID_NBR collate database_default

LEFT JOIN 
(SELECT DISTINCT ID_NBR, [Bilingual Model] AS BilingualModel_2013_2014_LastDay, TotalHours AS BEPHours_2013_2014_LastDay  FROM 
[180-SMAXODS-01.APS.EDU.ACTD].[PR].dbo.BilingualModelHours_2014_LastDay) AS BEP2014LastDay
ON
STU.SIS_NUMBER = BEP2014LastDay.ID_NBR collate database_default


REVERT
GO