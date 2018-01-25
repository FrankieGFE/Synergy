USE [StudentTransfersDev]
GO
SELECT DISTINCT
       STUD.student_code AS [APS_ID]
      --,[Student_First_Name]
      --,[Student_Last_Name]
      --,[Student_DOB]
      --,[Student_Gender]
      ,CASE WHEN [Current_School] = '' THEN sch.school_code ELSE CURRENT_SCHOOL END AS 'CURRENT_SCHOOL'
	  --,sch.school_code
			, case 
			when grade.alt_code_sif in ('P1','P2','PK','K','01','02','03','04','05') then 
				(select SCHOOL_CODE from [SYNERGYDBDC].ST_Production.rev.EPC_SCH
				where ORGANIZATION_GU = grid.elem_school_gu)
			when grade.alt_code_sif in ('06','07','08') then 
				(select SCHOOL_CODE from [SYNERGYDBDC].ST_Production.rev.EPC_SCH
				where ORGANIZATION_GU = grid.jr_high_school_gu)
			when grade.alt_code_sif in ('09','10','11','12','T1','T2','T3','T4','C1','C2','C3','C4') then 
				(select SCHOOL_CODE from [SYNERGYDBDC].ST_Production.rev.EPC_SCH 
				where ORGANIZATION_GU = grid.sr_high_school_gu)
			end as next_school
      ,[School_Accepted]
      ,[SPED_LOI]
      ,[SPED_Primary_Disability]
      ,[grade_entering]
      ,T1.[Status]
      ,T1.[School_Year]
FROM
(
SELECT 
      [APS_Student_ID_Number] AS APS_ID
	  ,[Student_First_Name] AS STUDENT_FIRST_NAME
      ,[Student_Last_Name] AS STUDENT_LAST_NAME
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Currently_Enrolled_School] AS CURRENT_SCHOOL
      ,[SPED_LOI]
      ,[SPED_Primary_Disability]
      ,[Grade_Entering]
	  ,Status
      ,[School_Accepted]
      ,[School_Year]
  FROM [dbo].[Non_APS_Xfer_Request]
  WHERE School_Accepted IN ('590','425')
  AND (SPED_Primary_Disability = 'GI' OR SPED_LOI LIKE '%GIFT%')
  --ORDER BY SPED_LOI DESC

UNION

SELECT 
      [APS_ID]
      ,[Student_First_Name]
      ,[Student_Last_Name]
      ,[Student_DOB]
      ,[Student_Gender]
      ,[Current_School]
      ,[SPED_LOI]
      ,[SPED_Primary_Disability]
      ,[grade_entering]
      ,[Status]
      ,[School_Accepted]
      ,[School_Year]
  FROM [dbo].[APS_Xfer_Request]
  WHERE School_Accepted IN ('590','425')
  AND SPED_Primary_Disability = 'GI'

) T1

LEFT JOIN
Assessments.DBO.ALLSTUDENTS AS STUD
ON T1.STUDENT_LAST_NAME = STUD.last_name
AND T1.STUDENT_FIRST_NAME = STUD.first_name
AND T1.Student_DOB = STUD.DOB

		    LEFT JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU               stu  ON stud.student_code = STU.SIS_NUMBER
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
										--and oyr.YEAR_GU = @year_guid
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.EPC_STU_PARENT        spar ON spar.STUDENT_GU = stu.STUDENT_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            pper ON pper.PERSON_GU  = spar.PARENT_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_ADDRESS           hadr ON hadr.ADDRESS_GU = pper.HOME_ADDRESS_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_USER_NON_SYS sys  ON sys.PERSON_GU = pper.PERSON_GU
			LEFT JOIN [LookupTable]('K12','Grade') grade ON grade.VALUE_CODE = ssy.GRADE
		 
			--LEFT JOIN [SYNERGYDBDC].ST_Production.rev.EPC_NM_STU_SPED_RPT rpt ON rpt.STUDENT_GU = stu.STUDENT_GU 
			--LEFT JOIN LookupTable ('K12.SpecialEd.IEP', 'LEVEL_INTEGRATION') AS LI ON LI.VALUE_CODE = rpt.LEVEL_INTEGRATION 
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.EPC_SCH               sch	 ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
			LEFT JOIN [SYNERGYDBDC].ST_Production.rev.REV_ORGANIZATION      org	 ON sch.ORGANIZATION_GU = org.ORGANIZATION_GU
			left join [SYNERGYDBDC].[ST_Production].[rev].[EPC_GRID] grid on stu.grid_code = grid.grid_code
			left join [SYNERGYDBDC].[ST_Production].[rev].UD_SPED_SERVICE_LEVEL sped ON SPED.STUDENT_GU = STU.STUDENT_GU

			WHERE YR.SCHOOL_YEAR = '2015'

			order by APS_ID


GO


