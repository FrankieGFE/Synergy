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
 * SPED LEVEL OF INTEGRATION code_program
 * 
	
****/

SELECT  
       DISTINCT LI.VALUE_DESCRIPTION                  AS [program_code]
	   , LI.VALUE_DESCRIPTION   					  AS [program_name]
	   , 'SP_LI'									  AS [program_type_code]
	   , 'N'										  AS [gifted_program]
	   , 'Y'										  AS [special_ed_program]
	   , 'N'									      AS [lep_program]
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   LEFT JOIN rev.EPC_NM_STU_SPED_RPT rpt ON rpt.STUDENT_GU = stu.STUDENT_GU
	   LEFT JOIN APS.LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LI
	   ON LI.VALUE_CODE = rpt.LEVEL_INTEGRATION


WHERE  ssy.ENTER_DATE is not null
	   AND LI.VALUE_CODE IS NOT NULL

	   



 
