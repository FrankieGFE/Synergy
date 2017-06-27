USE [ST_Production]
GO



ALTER PROC [APS].[ActiveDirectoryStudents]

AS
BEGIN



DECLARE  @vDistrict_Number VARCHAR(20)
DECLARE  @vSchYr VARCHAR(300)
DECLARE  @vRunDate smalldatetime
SET @vRunDate = GETDATE() - 1 

SET @vDistrict_Number = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')


IF MONTH(GETDATE()) BETWEEN 6 AND 8 
BEGIN
	SET @vSchYr = (SELECT YEAR_GU FROM APS.YearDates WHERE EXTENSION = 'R' AND CONVERT(DATE,'08/30/' + CONVERT(VARCHAR(4),YEAR(GETDATE()))) BETWEEN YearDates.START_DATE AND YearDates.END_DATE )
END


IF MONTH(GETDATE()) < 6
BEGIN
	SET @vSchYr = (SELECT YEAR_GU FROM APS.YearDates WHERE EXTENSION = 'R' AND GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
END

IF MONTH(GETDATE()) >8
BEGIN
	SET @vSchYr = (SELECT YEAR_GU FROM APS.YearDates WHERE EXTENSION = 'R' AND GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
END


SELECT 
	DistrictNumber
	,SchoolYear = (SELECT SCHOOL_YEAR + 1 FROM REV.SIF_22_Common_CurrentYear)
	,StudentIDNumber
	,MAX(CASE WHEN RN = 1 THEN SORSchoolNumber ELSE '' END) AS [SORSchoolNumber]
	,MAX(CASE WHEN RN = 1 THEN SchoolName ELSE '' END) AS [SchoolName]	

	--for one record per student we have to keep the highest grade level and the earliest enter date --
	,MAX(Grade) AS Grade
	,MIN(EnterDate) AS EnterDate
	
	,AddDelStatus
	,LastName
	,FirstName
	,StudentMiddleName
	,MAX(CASE WHEN RN = 1 THEN SchoolOfRecord ELSE '' END) AS [SchoolOfRecord]

	,MAX(CASE WHEN RN = 2 THEN SORSchoolNumber ELSE '' END) AS [ALTLOC2]
	,MAX(CASE WHEN RN = 3 THEN SORSchoolNumber ELSE '' END) AS [ALTLOC3]
	,MAX(CASE WHEN RN = 4 THEN SORSchoolNumber ELSE '' END) AS [ALTLOC4]
	,MAX(CASE WHEN RN = 5 THEN SORSchoolNumber ELSE '' END) AS [ALTLOC5]
	,BIRTH_DATE
FROM 
(


SELECT 
	ALL_ENROLLMENTS.*
	,ROW_NUMBER() OVER (PARTITION BY [StudentIDNumber] ORDER BY NEW_EXTENSION) AS RN

FROM 

(
/************************************************************************************************************************

--FIRST PULL PRIMARY ENROLLMENTS

************************************************************************************************************************/

SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
,CASE WHEN EXTENSION = 'R' THEN 1 ELSE 0 END AS NEW_EXTENSION
,EXCLUDE_ADA_ADM


 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'P'                                      AS [SchoolOfRecord]
 	/*
	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5
	*/
	,CAST(per.BIRTH_DATE AS DATE) AS BIRTH_DATE
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null -- primary only
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = @vSchYr
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
JOIN REV.REV_YEAR YRS ON SSY.YEAR_GU = YRS.YEAR_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 



UNION ALL

/************************************************************************************************************************

--SECOND - PULL FOR THE SAME SCHOOL YEAR NON-ADA'S

************************************************************************************************************************/

SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
,CASE WHEN EXTENSION = 'R' THEN 2 ELSE 0 END AS EXTENSION
,EXCLUDE_ADA_ADM

 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'S'                                      AS [SchoolOfRecord]
 	/*
	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5
	*/
	,CAST(per.BIRTH_DATE AS DATE) AS BIRTH_DATE
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is not null -- concurrent enrollments
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = @vSchYr
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
JOIN REV.REV_YEAR YRS ON SSY.YEAR_GU = YRS.YEAR_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

/************************************************************************************************************************

--THIRD - PULL JUMP START ENROLLMENTS

************************************************************************************************************************/


UNION ALL


SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
,CASE WHEN EXTENSION = 'N' THEN 3 ELSE 0 END AS EXTENSION
,EXCLUDE_ADA_ADM

 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'P'                                      AS [SchoolOfRecord]
 	/*
	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5
	*/
	,CAST(per.BIRTH_DATE AS DATE) AS BIRTH_DATE
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null -- primary enrollments
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=(SELECT SCHOOL_YEAR + 1 FROM REV.SIF_22_Common_CurrentYear) AND [EXTENSION] ='N')
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
JOIN REV.REV_YEAR YRS ON SSY.YEAR_GU = YRS.YEAR_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 
WHERE
	MONTH(GETDATE()) BETWEEN 6 AND 8 



/************************************************************************************************************************

--FOURTH - PULL SUMMER ENROLLMENTS

************************************************************************************************************************/

UNION ALL

SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
,CASE WHEN EXTENSION = 'S' THEN 4 ELSE 0 END AS EXTENSION
,EXCLUDE_ADA_ADM

 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'S'                                      AS [SchoolOfRecord]
 	/*
	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5
	*/
	,CAST(per.BIRTH_DATE AS DATE) AS BIRTH_DATE
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null -- primary enrollments
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM [rev].[REV_YEAR] WHERE [SCHOOL_YEAR]=(SELECT * FROM REV.SIF_22_Common_CurrentYear) AND [EXTENSION] ='S')
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
JOIN REV.REV_YEAR YRS ON SSY.YEAR_GU = YRS.YEAR_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

WHERE
	MONTH(GETDATE()) BETWEEN 6 AND 8 

) AS ALL_ENROLLMENTS

--DEBUG
--where
--StudentIDNumber = 100013465

) AS CREATEONEROW

GROUP BY 
	DistrictNumber
	,SchoolYear
	,StudentIDNumber

	,AddDelStatus
	,LastName
	,FirstName
	,StudentMiddleName
		
	,BIRTH_DATE





END --END STORED PROCEDURE



GO


