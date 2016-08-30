DECLARE @AsOfDate AS DATETIME = '2014-12-15'
	   
	  SELECT 
		SY
		,[ENGLISH PROFICIENCY]
	  ,COUNT(*)
	  FROM ( 
	   SELECT 
		'2015' AS SY

		,CASE
			WHEN FEP.STUDENT_GU IS NOT NULL THEN 'FEP'
			WHEN [ENGLISH PROFICIENCY] IN (2,3) THEN 'FEPM'
			WHEN [ENGLISH PROFICIENCY] = 4 THEN 'FEPE'
			WHEN [ENGLISH PROFICIENCY] = 1 THEN 'ELL'
			ELSE '' 
		END AS [ENGLISH PROFICIENCY]


	    FROM 
	  
	  (
	   SELECT 
				[SY]
				, [LOCATION CODE]
				,[LAST NAME LONG]
				,[FIRST NAME LONG]
				,[HISPANIC INDICATOR]
				,[ETHNIC CODE SHORT]
				,[GENDER CODE]
				,[Field11]
				,[ENGLISH PROFICIENCY]
				,[Field13]
	           ,SIS_NUMBER
			   ,STATE_STUDENT_NUMBER
		  ,STUDENT_GU
		  --SELECT * 
		  FROM
				--Uses the 80th Day Stars File
				[RDAVM.APS.EDU.ACTD].[db_STARS_History].[dbo].[STUD_SNAPSHOT] AS STARS
				INNER JOIN 
				REV.EPC_STU AS STU
				ON STARS.[STUDENT ID] = STU.STATE_STUDENT_NUMBER
				           
		  WHERE
				[Period] = @AsOfDate
				--[Period] =  '2014-12-15'
				AND [DISTRICT CODE] = '001'

) AS ALS

LEFT JOIN 
APS.PHLOTEAsOf(@AsOfDate) AS PHL
ON
ALS.STUDENT_GU = PHL.STUDENT_GU

LEFT JOIN 
(SELECT * FROM 
rev.EPC_STU_PGM_ELL_HIS
WHERE
EXIT_DATE BETWEEN  '2014-06-01' AND '2014-08-14'
) AS FEP
ON
ALS.STUDENT_GU = FEP.STUDENT_GU

---------GET SCHOOL NAME FOR GOOD STARS LOCATIONS------------------------------------
LEFT JOIN 
rev.EPC_SCH AS SCH
ON
ALS.[LOCATION CODE] = SCH.SCHOOL_CODE

LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU
-------------------------------------------------------------------------------------

--GET SYNERGY LOCATION AND NAME WHERE STARS LOCATIONS ARE ROLLED UP, STATE LOCATIONS
LEFT JOIN 
APS.PrimaryEnrollmentDetailsAsOf('2014-12-15') AS ENR
ON
ALS.STUDENT_GU = ENR.STUDENT_GU
----------------------------------------------------------------------------------------

) AS T1
GROUP BY
SY
,[ENGLISH PROFICIENCY]