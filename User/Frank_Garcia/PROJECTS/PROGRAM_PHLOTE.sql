USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/5/2014 $s
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * ELL
 * 
	
****/

SELECT 
	STU.SIS_NUMBER AS student_code
	,YR.SCHOOL_YEAR  AS school_year
	,sch.SCHOOL_CODE AS school_code
    ,'ELL' AS  program_code
	,CONVERT(VARCHAR(10), ELL.ENTER_DATE, 120) AS date_enrolled
	,'' AS date_withdrawn
	,'' AS date_iep
	,'' as date_iep_end
FROM
	/*** Using PHLOTE As Of Function to get current PHLOTE students  ***/
	APS.ELLAsOf (GETDATE()) AS ELL
	/***   ***/

	LEFT JOIN /*** This gets student ID  ***/
	rev.EPC_STU AS STU
	ON ELL.STUDENT_GU = STU.STUDENT_GU
	LEFT JOIN 
	rev.REV_ORGANIZATION_YEAR AS OYR  
	ON OYR.ORGANIZATION_YEAR_GU = ELL.ORGANIZATION_YEAR_GU
	LEFT JOIN  /*** This gets school number  ***/
	rev.EPC_SCH AS SCH  
	ON SCH.ORGANIZATION_GU = OYR.ORGANIZATION_GU
	LEFT JOIN /*** This gets school year. ***/
	rev.REV_YEAR AS YR
	ON OYR.YEAR_GU = YR.YEAR_GU



 
