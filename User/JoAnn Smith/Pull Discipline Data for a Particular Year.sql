
EXECUTE AS LOGIN='QueryFileUser'
GO

;with StudentCTE
as
(
SELECT 
		t1.[Student APS ID]

		FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from edlead2015.csv'
                ) AS [T1]
)
--select * from StudentCTE

, DisciplineCTE
as
(
  
       SELECT 
              [ENROLLMENTS].[SCHOOL_YEAR]
              --,[ENROLLMENTS].[SCHOOL_CODE]
              --,[ENROLLMENTS].[SCHOOL_NAME]
			  ,[student].STATE_STUDENT_NUMBER
              ,[STUDENT].[SIS_NUMBER]
              --,[STUDENT].[FIRST_NAME]
              --,[STUDENT].[LAST_NAME]
              --,[ENROLLMENTS].[GRADE]
              --,[STUDENT].[GENDER]
              --,STUDENT.BIRTH_DATE
              --,[STUDENT].[ELL_STATUS]
              --,[STUDENT].[SPED_STATUS]
              ,[INCIDENT].[INCIDENT_ID]
              ,[INCIDENT].[INCIDENT_DATE] 
              --,[Disposition].[DISPOSITION_DATE]
              --,[Disposition].[DISPOSITION_ID]
              --,[Discipline].[DAYS]
              --,[Disposition_Code].[DISP_CODE]
              --,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
              --,[Disposition].[REASSIGNMENT_DAYS]
              --,[Disposition].[DISPOSITION_START_DATE]
              --,[Disposition].[DISPOSITION_END_DATE]
              
              
              --,[Violation].[VIOLATION_ID]
              ,[Violation_Code].[DISC_CODE]
              ,[Violation_Code].[DESCRIPTION] AS [VIOLATION_DESCRIPTION]
              --,[Violation].[SEVERITY_LEVEL]
              --,[Violation_Code].[SEVERITY_LEVEL]
              
       
       --, REFERRED_BY_LNAME
       --, REFERRED_BY_FNAME
       --, REFERRER_TYPE
       --, Violation.ADDITIONAL_TEXT
       --,INCIDENT.[DESCRIPTION]
       --,PRIVATE_DESCRIPTION
              --,[Violation].*
              --,[INCIDENT].*
              --,[Violation_Code].*
              
              --[Violation_Code].[DISC_CODE]
              --,[Violation_Code].[DESCRIPTION]
			  ,DISCIPLINE.INCIDENT_ROLE,
			  case
				WHEN Discipline.Incident_Role = 1
					then 'Offender'
				when Discipline.Incident_Role = 2
					then 'Victim'
				when Discipline.Incident_Role = 3
					then 'Bystander or witness'
			  end 
			 as [Offender/Victim]

              
       FROM
              (
              SELECT
                     *
                     ,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS RN
              FROM
                     APS.StudentEnrollmentDetails
                     
              WHERE
                     SCHOOL_YEAR = 2015
                     AND EXTENSION = 'R'
                     --AND EXCLUDE_ADA_ADM IS NULL
              ) AS [ENROLLMENTS]
              
              INNER JOIN
              APS.BasicStudentWithMoreInfo AS [STUDENT]
              ON
              [ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
              
              INNER JOIN
              [rev].[EPC_STU_INC_DISCIPLINE] AS [Discipline]
              ON
              [ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [Discipline].[STUDENT_SCHOOL_YEAR_GU]
           
              INNER JOIN
              rev.EPC_SCH_INCIDENT AS [INCIDENT]
              ON
              [Discipline].[SCH_INCIDENT_GU] = [INCIDENT].[SCH_INCIDENT_GU]
           
              INNER JOIN
              [rev].[EPC_STU_INC_DISPOSITION] AS [Disposition]
              ON
              [Discipline].[STU_INC_DISCIPLINE_GU] = [Disposition].[STU_INC_DISCIPLINE_GU]
           
              INNER JOIN
              [rev].[EPC_CODE_DISP] AS [Disposition_Code]
              ON
              [Disposition].[CODE_DISP_GU] = [Disposition_Code].[CODE_DISP_GU]
           
              LEFT OUTER JOIN
              [rev].[EPC_STU_INC_VIOLATION] AS [Violation]
              ON
              [Discipline].[SCH_INCIDENT_GU] = [Violation].[SCH_INCIDENT_GU]
           
              LEFT OUTER JOIN
              [rev].[EPC_CODE_DISC] AS [Violation_Code]
              ON
              [Violation].[CODE_DISC_GU] = [Violation_Code].[CODE_DISC_GU]
			  --where STUDENT.SIS_NUMBER = 104215819
              
       --WHERE
       --     [Disposition_Code].[DISP_CODE] IN ()
       --       [Violation_Code].[DESCRIPTION] LIKE '%BULLY%'
       --       [Violation_Code].[DISC_CODE] IN ('12', '1EXTO', '1HRDS', '2BLG')
       --       [ENROLLMENTS].SCHOOL_CODE 


       --       ORDER BY INCIDENT_ID
)

--select * from DisciplineCTE
select
	 S.[Student APS ID],
	 d.SCHOOL_YEAR as [School Year],
	 d.STATE_STUDENT_NUMBER as [State Student ID],
	 d. INCIDENT_ID as [Event Identifier],
	 d.INCIDENT_DATE as [Infraction Date],
	 d.DISC_CODE as [Infraction Code],
	 d.VIOLATION_DESCRIPTION as [Infraction Code Description],
	 D.INCIDENT_ROLE,
	 d.[Offender/Victim],
	 d.INCIDENT_DATE
from
	StudentCTE S
left outer join
	DisciplineCTE D
on
	S.[Student APS ID] = D.SIS_NUMBER
where
	d.[Offender/Victim] = 'Offender'



--	d.INCIDENT_DATE is not null
--order by
--	s.[student APS ID]



