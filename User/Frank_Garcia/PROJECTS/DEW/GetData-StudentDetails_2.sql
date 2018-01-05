SELECT distinct   
         stu.SIS_NUMBER                            AS ID_NBR
       , CONVERT(VARCHAR(10), ssy.ENTER_DATE, 112) AS BEG_ENR_DT
	   , ''										   AS DROP_IND
	   , CONVERT(VARCHAR(10), ssy.LEAVE_DATE, 112) AS END_ENR_DT
	   , LEFT (lcd.VALUE_DESCRIPTION,2)			   AS END_STAT
	   , grade.VALUE_DESCRIPTION                   AS GRDE
	   , ''										   AS MNT_DT
	   , ''										   AS MNT_INIT
	   , CASE WHEN ssy.EXCLUDE_ADA_ADM = '1'
			  OR ssy.EXCLUDE_ADA_ADM = '2'
			  THEN 'X'
			  ELSE ''
	   END										   AS NONADA_SCH
       , sch.SCHOOL_CODE                           AS SCH_NBR
       , yr.SCHOOL_YEAR                            AS SCH_YR
       , org.ORGANIZATION_NAME					   AS SCH_NME_27
       , lcd.VALUE_DESCRIPTION					   AS STAT_DESCR
	   , GRAD.VALUE_CODE
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   ----join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              --and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN APS.LookupTable('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
	   LEFT JOIN APS.LookupTable('K12', 'Leave_CODE') lcd ON lcd.VALUE_CODE = ssy.LEAVE_CODE
	   LEFT JOIN APS.LookupTable('K12', 'GRADUATION') GRAD ON GRAD.VALUE_CODE = '1'

WHERE  ssy.ENTER_DATE is not null 
--AND ssy.EXCLUDE_ADA_ADM is null

ORDER BY 
	--SCH_YR DESC
	--,BEG_ENR_DT DESC
	--,END_ENR_DT ASC
	--,ID_NBR
	END_STAT DESC



