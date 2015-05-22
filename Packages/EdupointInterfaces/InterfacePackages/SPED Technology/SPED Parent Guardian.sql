SELECT DISTINCT 
                         rev.EPC_STU.SIS_NUMBER AS [Student ID]
						 , rev.EPC_STU_PARENT.RELATION_TYPE
						 , rev.REV_PERSON.LAST_NAME AS [Last Name]
						 , rev.REV_PERSON.FIRST_NAME AS [First Name]
						 , rev.REV_PERSON.MIDDLE_NAME AS [Middle Name]
						 , rev.REV_ADDRESS.ADDRESS AS [Street Address 1]
						 , rev.REV_ADDRESS.ADDRESS2 AS [Street Address 2]
						 , rev.REV_ADDRESS.CITY AS City, rev.REV_ADDRESS.STATE AS State
						 , rev.REV_ADDRESS.ZIP_5 AS Zipcode
						 , rev.REV_PERSON.PRIMARY_PHONE AS [Phone 1]
						 , rev.REV_PERSON.EMAIL AS [Email]
						 ,'2014R' AS [School Year]
                         , CONVERT (VARCHAR(10), rev.REV_PERSON.CHANGE_DATE_TIME_STAMP, 101) AS [Record Last Updated]
                         , rev.REV_PERSON.CHANGE_ID_STAMP AS [Last Updated By]
FROM            rev.EPC_STU 
				INNER JOIN
                         rev.REV_PERSON ON rev.EPC_STU.STUDENT_GU = rev.REV_PERSON.PERSON_GU 
						 AND 
						 rev.EPC_STU.STUDENT_GU = rev.REV_PERSON.PERSON_GU 
						 AND 
                         rev.EPC_STU.STUDENT_GU = rev.REV_PERSON.PERSON_GU 
						 INNER JOIN
                         rev.EPC_STU_SCH_YR ON rev.EPC_STU.STUDENT_GU = rev.EPC_STU_SCH_YR.STUDENT_GU 
						 AND 
                         rev.EPC_STU.STUDENT_GU = rev.EPC_STU_SCH_YR.STUDENT_GU 
						 INNER JOIN
                         rev.EPC_STU_PARENT ON rev.EPC_STU.STUDENT_GU = rev.EPC_STU_PARENT.STUDENT_GU 
						 AND 
                         rev.EPC_STU.STUDENT_GU = rev.EPC_STU_PARENT.STUDENT_GU 
						 AND 
						 rev.EPC_STU.STUDENT_GU = rev.EPC_STU_PARENT.STUDENT_GU 
						 INNER JOIN
                         rev.REV_ADDRESS ON rev.REV_PERSON.HOME_ADDRESS_GU = rev.REV_ADDRESS.ADDRESS_GU 
WHERE        (rev.EPC_STU_SCH_YR.STATUS IS NULL)
ORDER BY [Student ID]