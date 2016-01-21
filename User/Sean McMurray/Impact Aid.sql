SELECT

    --DISTINCT
	   STATE_STUDENT_NUMBER AS [State ID]
       ,SIS_NUMBER AS [ID Number]
       ,LAST_NAME AS [Last Name]
       ,FIRST_NAME AS [First Name]
       ,MIDDLE_NAME AS [Middle Name]
	   ,SCHOOL_CODE AS [School Number]
	   ,SCHOOL_NAME AS [School Name]
	   ,GENDER
	   ,RESOLVED_ETHNICITY_RACE AS [Ethnicity]
	   ,PRIMARY_RACE_INDICATOR
       ,ADDRESS AS [Home Address]
       ,CITY AS [City]
       ,STATE AS [State]
       ,ZIP_5 AS [Zip Code]
       ,GRADE AS [Grade] 
	   ,UD_PARENT_LOG.DATE AS [TYPE]         

FROM
APS.PrimaryEnrollmentDetailsAsOf ('20151213')  AS PRIM --Change this date based on how many days to pull (This pulled for the 120th day)
INNER JOIN 
rev.REV_PERSON ON PRIM.STUDENT_GU = rev.REV_PERSON.PERSON_GU

INNER JOIN
rev.REV_ADDRESS ON rev.REV_PERSON.HOME_ADDRESS_GU = rev.REV_ADDRESS.ADDRESS_GU

INNER JOIN
rev.EPC_STU ON PRIM.STUDENT_GU = rev.EPC_STU.STUDENT_GU

INNER JOIN 
rev.EPC_STU_PARENT ON rev.EPC_STU.STUDENT_GU = rev.EPC_STU_PARENT.STUDENT_GU

LEFT JOIN
rev.UD_PARENT_LOG ON rev.EPC_STU_PARENT.PARENT_GU = rev.UD_PARENT_LOG.PARENT_GU 