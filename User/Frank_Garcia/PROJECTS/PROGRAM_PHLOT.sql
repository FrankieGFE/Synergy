USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/18/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * PHLOT (PHLOT-Y)
 * 
	
****/

SELECT  
         stu.SIS_NUMBER                            AS [student_code]
       , yr.SCHOOL_YEAR                            AS [school_year]
       , sch.SCHOOL_CODE                           AS [school_code]
       , 'PHLOT-Y'					               AS [program_code]
       , CONVERT(VARCHAR(10), PHLOT.DATE_ASSIGNED, 120) AS [date_enrolled]
       , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 120) AS [date_withdrawn]
	   , ''									   AS [date_iep]
	   , ''									   AS [date_iep_end]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN
		   (SELECT
			*
			FROM
			(
			SELECT
				STUDENT_GU
				,Q1_LANGUAGE_SPOKEN_MOST
				,Q2_CHILD_FIRST_LANGUAGE
				,Q3_LANGUAGES_SPOKEN
				,Q4_OTHER_LANG_UNDERSTOOD
				,Q5_OTHER_LANG_COMMUNICATED
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY DATE_ASSIGNED DESC) AS RN
				,DATE_ASSIGNED
			FROM
				rev.UD_HLS_HISTORY AS HLSHistory
			WHERE
				DATE_ASSIGNED <= (GETDATE())
			) AS RowedHLS
		WHERE
			RN = 1
			AND Q1_LANGUAGE_SPOKEN_MOST + Q2_CHILD_FIRST_LANGUAGE + Q3_LANGUAGES_SPOKEN + Q4_OTHER_LANG_UNDERSTOOD + Q5_OTHER_LANG_COMMUNICATED != '0000000000'
			) AS PHLOT
			ON PHLOT.STUDENT_GU = stu.STUDENT_GU
WHERE  ssy.ENTER_DATE is not null
	   



 
