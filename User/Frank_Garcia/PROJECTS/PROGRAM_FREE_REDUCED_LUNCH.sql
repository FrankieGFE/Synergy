USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/5/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * Free and Reduced Lunch (FRL)
 * 
	
****/

SELECT 
	STU.SIS_NUMBER AS student_code
	,YR.SCHOOL_YEAR - 1 AS school_year
	,sch.SCHOOL_CODE AS school_code
    , CASE
	        WHEN FRL.FRM_CODE = '2' THEN 'Free'
			WHEN FRL.FRM_CODE = 'F'  THEN 'Free'
	        WHEN FRL.FRM_CODE = 'R' THEN 'Reduced'
	   END  AS  program_code
	,CONVERT(VARCHAR(10), PE.ENTER_DATE, 120) AS date_enrolled
	,'' AS date_withdrawn
	,'' AS date_iep
	,'' as date_iep_end
FROM
	/*** Using Primary Enrollment As Of Function to get currently enrolled students for program ***/
	APS.PrimaryEnrollmentsAsOf (GETDATE()) AS PE
	/***   ***/
	LEFT JOIN
		   (SELECT   FR.STUDENT_GU
	                , FR.FRM_CODE
	        FROM   rev.EPC_STU_PGM_FRM_HIS AS  FR
	        WHERE  FR.EXIT_DATE is null
	        ) AS FRL
	ON FRL.STUDENT_GU = PE.STUDENT_GU
	LEFT JOIN /*** This gets student ID  ***/
	rev.EPC_STU AS STU
	ON PE.STUDENT_GU = STU.STUDENT_GU
	LEFT JOIN 
	rev.REV_ORGANIZATION_YEAR AS OYR  
	ON OYR.ORGANIZATION_YEAR_GU = PE.ORGANIZATION_YEAR_GU
	LEFT JOIN  /*** This gets school number  ***/
	rev.EPC_SCH AS SCH  
	ON SCH.ORGANIZATION_GU = OYR.ORGANIZATION_GU
	LEFT JOIN /*** This gets school year. Subtract 1 for AIMS school year  ***/
	rev.REV_YEAR AS YR
	ON OYR.YEAR_GU = YR.YEAR_GU

WHERE FRL.FRM_CODE IN ('2','F','R')

 
