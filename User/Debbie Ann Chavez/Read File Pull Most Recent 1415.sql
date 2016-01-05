

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
--DISTINCT Student_ID


CAREER.*

     ,T1.[STATE_STUDENT_NUMBER]
         ,T1.[SIS_NUMBER]
      ,T1.[LAST_NAME]
      ,T1.[FIRST_NAME]
      ,T1.[MIDDLE_NAME]
         ,T1.[SCHOOL_CODE]
         ,T1.[SCHOOL_NAME]
         ,T1.GRADE
		
		--,T1.LEAVE_CODE
		--,T1.LEAVE_DESCRIPTION
		--,T1.LEAVE_DATE
		  
		  , PARENTSTUFF.PrimaryPhone

		, PARENTSTUFF.LIVES_WITH
		 ,PARENTSTUFF.PARENT_NAME
         , PARENTSTUFF.HomePhone AS PARENT_HOME_PHONE
         , PARENTSTUFF.CellPhone AS PARENT_CELL_PHONE
         , PARENTSTUFF.OtherPhone AS PARENT_OTHER_PHONE
         , PARENTSTUFF.EMAIL


--, STU.STUDENT_GU 

FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from No_Show_15_16.csv'
                ) AS [CAREER]

LEFT JOIN 
rev.EPC_STU AS STU

ON
[CAREER].[Student_ID] = STU.STATE_STUDENT_NUMBER

LEFT JOIN
(SELECT 
       *
FROM
       (
       SELECT
       row_number() over (partition by sis_number order by EXCLUDE_ADA_ADM, enter_date desc ) as RowNum 
		,STUDENT.STUDENT_GU
      ,STUDENT.[STATE_STUDENT_NUMBER]
         ,STUDENT.[SIS_NUMBER]
      ,STUDENT.[LAST_NAME]
      ,STUDENT.[FIRST_NAME]
      ,STUDENT.[MIDDLE_NAME]
         ,ENROLL.[SCHOOL_CODE]
         ,ENROLL.[SCHOOL_NAME]
         ,ENROLL.GRADE
		,ENROLL.LEAVE_CODE
		,ENROLL.LEAVE_DESCRIPTION
		,ENROLL.LEAVE_DATE
		
FROM
       (
       SELECT *
       FROM

       [APS].[BasicStudentWithMoreInfo]
       ) AS STUDENT
       
       JOIN
       (
       SELECT *
       FROM
             [APS].[StudentEnrollmentDetails]
       ) AS ENROLL
       ON
       STUDENT.[STUDENT_GU]=ENROLL.[STUDENT_GU]
             
       WHERE ([SCHOOL_YEAR] = 2014 AND [EXTENSION] = 'R')
      
       ) AS T1
WHERE RowNum = 1
) AS T1

ON
T1.STUDENT_GU = STU.STUDENT_GU



LEFT JOIN
	(
SELECT   
           stu.STUDENT_GU
         , stupar.ORDERBY CALL_ORDER
		 , STUPAR.LIVES_WITH
		 ,PAR.LAST_NAME + ', ' + PAR.FIRST_NAME AS PARENT_NAME
         , phone.H HomePhone
         , phone.C CellPhone
         , phone.O OtherPhone
         , par.EMAIL
         , ParPriPhone.Y PrimaryPhone

      FROM rev.EPC_STU_PARENT  stupar
           JOIN rev.REV_PERSON par ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
           JOIN rev.EPC_STU stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C],  [O])) phone ON phone.PERSON_GU = par.PERSON_GU
           LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PRIMARY_PHONE FROM rev.REV_PERSON_PHONE phn) ParPhn
                      PIVOT (min(phone) FOR PRIMARY_PHONE in ([Y])) ParPriPhone ON ParPriPhone.PERSON_GU = par.PERSON_GU


	) AS PARENTSTUFF
	ON
	[STU].[STUDENT_GU] = PARENTSTUFF.[STUDENT_GU] 


WHERE
	LEAVE_DATE IS NULL AND T1.STATE_STUDENT_NUMBER IS NOT NULL

      REVERT
GO