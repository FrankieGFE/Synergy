EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT *
	,CASE WHEN T4.SIS_NUMBER IS NULL THEN 'Synergy NO PREV RECORD BEFORE NO SHOW'  ELSE 'Synergy' END AS SYSTEM
 FROM 

(
SELECT 
	COHORT.*
	,SIS_NUMBER

 FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from COHORT.csv'
                ) AS COHORT

INNER JOIN 
(
SELECT * FROM

(
select 
            
            sis_number
			,STATE_STUDENT_NUMBER
			--,SSY.EXCLUDE_ADA_ADM
			--,YEARS.SCHOOL_YEAR
         --   , sch.SCHOOL_CODE
            , org.organization_name as school_name
			,SUMMER_WITHDRAWL_CODE
    , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
    , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
	,CASE WHEN NO_SHOW_STUDENT = 'Y' THEN SUMMER_WITHDRAWL_CODE + '-'+  NOSHOWCODE.VALUE_DESCRIPTION ELSE CODE.VALUE_DESCRIPTION END AS LEAVE_CODE
    ,SSY.NO_SHOW_STUDENT
	,ROW_NUMBER() OVER (PARTITION BY sis_number ORDER BY school_year desc, exclude_ada_adm asc, no_show_student asc, ssy.ENTER_DATE DESC) AS RN

FROM   rev.EPC_STU    AS stu 
       INNER JOIN 
	   rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU  
       INNER JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU  
       INNER JOIN rev.rev_organization org    ON org.organization_gu = oyr.organization_gu
       INNER join rev.EPC_SCH sch         ON sch.organization_gu = oyr.organization_gu
		INNER JOIN
			  rev.REV_YEAR AS YEARS
			  ON
			  YEARS.YEAR_GU = OYR.YEAR_GU
			  LEFT JOIN
			  APS.LookupTable ('K12', 'LEAVE_CODE') AS CODE
			  ON
			  CODE.VALUE_CODE = SSY.LEAVE_CODE
			   LEFT JOIN
			  APS.LookupTable ('K12.Enrollment', 'WITHDRAWAL_REASON_CODE') AS NOSHOWCODE
			  ON
			  NOSHOWCODE.ALT_CODE_1 = SSY.SUMMER_WITHDRAWL_CODE
) as T1

WHERE
	RN = 1 
	) AS MOSTRECENT

	ON

	COHORT.StudentID = MOSTRECENT.STATE_STUDENT_NUMBER

	WHERE NO_SHOW_STUDENT = 'Y' AND SUMMER_WITHDRAWL_CODE =  '52'
	) AS GIVEMENOSHOWS

	LEFT JOIN 


	(SELECT 
			SIS_NUMBER
			,school_name
			,date_enrolled
			,date_withdrawn
			,LEAVE_CODE
			,NO_SHOW_STUDENT
	
	 FROM (
SELECT * FROM

(
select 
            
            sis_number
			,STATE_STUDENT_NUMBER
			--,SSY.EXCLUDE_ADA_ADM
			--,YEARS.SCHOOL_YEAR
         --   , sch.SCHOOL_CODE
            , org.organization_name as school_name

    , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
    , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
	,CASE WHEN NO_SHOW_STUDENT = 'Y' THEN SUMMER_WITHDRAWL_CODE + '-'+  NOSHOWCODE.VALUE_DESCRIPTION ELSE CODE.VALUE_DESCRIPTION END AS LEAVE_CODE
    ,SSY.NO_SHOW_STUDENT
	,ROW_NUMBER() OVER (PARTITION BY sis_number ORDER BY school_year desc, exclude_ada_adm asc, no_show_student asc, ssy.ENTER_DATE DESC) AS RN

FROM   rev.EPC_STU    AS stu 
       INNER JOIN 
	   rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU  
       INNER JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU  
       INNER JOIN rev.rev_organization org    ON org.organization_gu = oyr.organization_gu
       INNER join rev.EPC_SCH sch         ON sch.organization_gu = oyr.organization_gu
		INNER JOIN
			  rev.REV_YEAR AS YEARS
			  ON
			  YEARS.YEAR_GU = OYR.YEAR_GU
			  LEFT JOIN
			  APS.LookupTable ('K12', 'LEAVE_CODE') AS CODE
			  ON
			  CODE.VALUE_CODE = SSY.LEAVE_CODE
			   LEFT JOIN
			  APS.LookupTable ('K12.Enrollment', 'WITHDRAWAL_REASON_CODE') AS NOSHOWCODE
			  ON
			  NOSHOWCODE.ALT_CODE_1 = SSY.SUMMER_WITHDRAWL_CODE
WHERE
	NO_SHOW_STUDENT = 'N'

) as T1

WHERE
	RN = 1
	) AS SECONDRECENT
	) AS T4
		
	ON
	GIVEMENOSHOWS.SIS_NUMBER = T4.SIS_NUMBER

 LEFT JOIN
			 (
				SELECT 
					SIS_NUMBER
					,NOND.NAME AS NON_DISTRICT_SCHOOL
					 ,RELEASE_DATE
					 ,CRSHIST.VALUE_DESCRIPTION AS DELIVERY_TYPE
					 ,RELEASE.VALUE_DESCRIPTION AS RELEASE_PURPOSE

				FROM
					rev.EPC_STU_REQUEST_TRACKING AS REQ
					INNER JOIN
					rev.EPC_SCH_NON_DST AS NOND
					ON
					REQ.SCHOOL_NON_DISTRICT_GU = NOND.SCHOOL_NON_DISTRICT_GU
	
					INNER JOIN
					APS.LookupTable ('K12.CourseHistoryInfo', 'DELIVERY_TYPE') AS CRSHIST
					ON
					CRSHIST.VALUE_CODE = REQ.DELIVERY_TYPE

					INNER JOIN
					APS.LookupTable ('K12.CourseHistoryInfo', 'RELEASE_PURPOSE') AS RELEASE
					ON
					RELEASE.VALUE_CODE = REQ.RELEASE_PURPOSE

					INNER JOIN
					rev.EPC_STU AS STU
					ON
					STU.STUDENT_GU = REQ.STUDENT_GU

					WHERE
					RELEASE_PURPOSE = 5
					) AS WITHDRAWALVERIFICATION
	ON
	GIVEMENOSHOWS.SIS_NUMBER = WITHDRAWALVERIFICATION.SIS_NUMBER

				
	ORDER BY school_name

      REVERT
GO
