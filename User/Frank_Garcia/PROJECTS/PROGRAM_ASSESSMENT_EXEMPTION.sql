USE SchoolNetDW
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 9/9/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * Assessment Exemptions (AssEX)
 * Read tabel program_assessment_exemptions populated by data Sonya collects
	
****/

	SELECT
		  AssEx.APS_ID AS student_code
		  ,LEFT (SCH_YR,4) AS school_year
		  ,[School Loc] AS school_code
		  ,''AE-'' + AssEx.Assessment AS program_code /*** Assessment Exemption ***/
		  , CONVERT(date, convert(varchar(10), ssy.ENTER_DATE), 112) as date_enrolled
		  , CONVERT(date, convert(varchar(10), ssy.ENTER_DATE), 112) as date_withdrawn
		  , null AS date_iep
		  , null AS date_iep_end
FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
       JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
	   JOIN AIMS.dbo.Program_Assessment_Exemptions AS AssEx
										   ON AssEx.APS_ID = stu.SIS_NUMBER

WHERE AssEx.SCH_YR = '2014-2015'

	     

