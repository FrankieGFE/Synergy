
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT 
	COHORT.*
	
	,MOSTRECENT.school_name
	,MOSTRECENT.date_enrolled
	,MOSTRECENT.date_withdrawn
	,MOSTRECENT.LEAVE_CODE
	,NO_SHOW_STUDENT
	,MOSTRECENT.SIS_NUMBER
	,NON_DISTRICT_SCHOOL
	,RELEASE_DATE
	,DELIVERY_TYPE
	,RELEASE_PURPOSE
	
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
            
            STU.sis_number
			,STATE_STUDENT_NUMBER
			--,SSY.EXCLUDE_ADA_ADM
			--,YEARS.SCHOOL_YEAR
         --   , sch.SCHOOL_CODE
            , org.organization_name as school_name

    , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 120) AS [date_enrolled]
    , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
	,CASE WHEN NO_SHOW_STUDENT = 'Y' THEN SUMMER_WITHDRAWL_CODE + '-'+  NOSHOWCODE.VALUE_DESCRIPTION ELSE CODE.VALUE_DESCRIPTION END AS LEAVE_CODE
    ,SSY.NO_SHOW_STUDENT
	,ROW_NUMBER() OVER (PARTITION BY STU.sis_number ORDER BY school_year desc, exclude_ada_adm asc, no_show_student asc, ssy.ENTER_DATE DESC) AS RN

	,NON_DISTRICT_SCHOOL
	,RELEASE_DATE
	,DELIVERY_TYPE
	,RELEASE_PURPOSE


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
					WITHDRAWALVERIFICATION.SIS_NUMBER = STU.SIS_NUMBER

) as T1

WHERE
	RN = 1 
	) AS MOSTRECENT

	ON

	COHORT.StudentID = MOSTRECENT.STATE_STUDENT_NUMBER

	--WHERE school_name IS NOT NULL


	ORDER BY school_name

      REVERT
GO




