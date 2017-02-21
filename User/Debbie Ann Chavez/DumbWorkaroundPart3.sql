

--CREATE TABLE PART3LASTUNE
--(

-- SIS_NUMBER VARCHAR (9),
-- SCHOOL_CODE VARCHAR (4),
-- EXCLUDE_ADA_ADM VARCHAR (3),
--HALF_DAY DECIMAL (5,2),
--FULL_DAY DECIMAL (5,2),
-- TOTAL DECIMAL (5,2)
-- )


DECLARE @startDate DATE = '20161202'
DECLARE @endDate DATE = '20170208'

INSERT INTO dbo.PART3LASTUNE

SELECT

	SIS_NUMBER
	,SCHOOL_CODE
	,EXCLUDE_ADA_ADM
    ,[Period].[Half Days Unexcused]*0.5 as [Half-Day Unexcused]
    ,[Period].[Full Days Unexcused] AS [Full-Day Unexcused]
	,([Period].[Half Days Unexcused]*0.5)+[Period].[Full Days Unexcused] AS [Total Unexcused]

FROM (

SELECT
	[Truants].[SIS_NUMBER]
	,[Truants].[SCHOOL_CODE]
	,[Truants].EXCLUDE_ADA_ADM
	,SUM([Truants].[Half Days Unexcused]) AS [Half Days Unexcused]
	,SUM([Truants].[Full Days Unexcused]) AS [Full Days Unexcused]
	,SUM([Truants].[Total Unexcused]) AS [Total Unexcused]
FROM
(
SELECT 
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
	,Truant.EXCLUDE_ADA_ADM
    ,ISNULL(SUM(CASE
	   WHEN [Truant].ABSENCE_COUNT >= 2 THEN
		  CASE WHEN [Truant].[Truant Percentage]<=50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Half Days Unexcused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].ABSENCE_COUNT >= 2 THEN
		       CASE WHEN ([Truant].[Truant Percentage]>50.00 AND [Truant].[Truant Percentage]>0) THEN 1.00
		       ELSE 0.00
		  END
	   ELSE
		  0
     END),0.00) AS [Full Days Unexcused]
    ,ISNULL(SUM(CASE
	   WHEN [Truant].ABSENCE_COUNT >= 2 THEN
			  CASE WHEN ([Truant].[Truant Percentage]<=50.00 AND [Truant].[Truant Percentage]>0) THEN 0.50
				  WHEN [Truant].[Truant Percentage]>50.00 THEN 1.00
		       ELSE 0
		  END
	   ELSE
		  0
     END),0.00) AS [Total Unexcused]
FROM
(
SELECT
    [Truant1].*
    ,[SchedCount].[Total Classes]
    ,([Truant1].ABSENCE_COUNT/[SchedCount].[Total Classes])*100 AS [Truant Percentage]
FROM
dbo.PART1LASTUNE AS [Truant1]

LEFT JOIN
(
SELECT
    [STUDENT_GU]
    ,[SIS_NUMBER]
	,SCHOOL_CODE
    ,[CAL_DATE]
    ,[ROTATION]
    ,CAST(SUM(CLASS_COUNT) AS DECIMAL(5,2)) AS [Total Classes]
FROM
	dbo.PART2LASTEXC AS [SchedCount]

GROUP BY
    [STUDENT_GU]
    ,[SIS_NUMBER]
	,SCHOOL_CODE
    ,[CAL_DATE]
    ,[ROTATION]
) AS [SchedCount]
ON
[Truant1].[STUDENT_GU]=[SchedCount].[STUDENT_GU]
AND [Truant1].SCHOOL_CODE = SchedCount.SCHOOL_CODE
AND [Truant1].[ABS_DATE]=[SchedCount].[CAL_DATE]
--AND [Truant1].[ROTATION]=[SchedCount].[ROTATION]
AND [Truant1].ABSENCE_COUNT>=2
) AS [Truant]

WHERE
--	[Truant].[ABS_DATE]<=@endDate
--	AND [Truant].[ABS_DATE]>=@startDate
TRUANT.ABS_DATE = '20160218'
GROUP BY
    [Truant].[SIS_NUMBER]
    ,[Truant].[SCHOOL_CODE]
	,TRUANT.EXCLUDE_ADA_ADM
) AS [Truants]

GROUP BY
	[Truants].[SIS_NUMBER]
	,[Truants].[SCHOOL_CODE]
	,Truants.EXCLUDE_ADA_ADM

) AS Period