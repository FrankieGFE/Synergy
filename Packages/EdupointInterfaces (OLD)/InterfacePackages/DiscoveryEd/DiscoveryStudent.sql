--<APS Discovery Ed>
declare @DefaultSitePassCode varchar(20), @DefaultSiteName varchar(40)
set @DefaultSitePassCode = (select PassCode from ##TempDiscoverySites where SchNumber = 'ZZZ')
set @DefaultSiteName     = (select SiteName from ##TempDiscoverySites where SchNumber = 'ZZZ')
; with ParEmail AS
(
SELECT   
  stu.STUDENT_GU
, par.EMAIL
, ROW_NUMBER() over(partition by stu.student_gu order by stu.student_gu) rn
FROM rev.EPC_STU_PARENT  stupar
JOIN rev.REV_PERSON par ON par.PERSON_GU = stupar.PARENT_GU and stupar.CONTACT_ALLOWED = 'Y'
JOIN rev.EPC_STU stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
where par.EMAIL is not null
)
SELECT

  COALESCE(Dsites.Passcode,@DefaultSitePassCode)   AS [Site Passcode]
, 'NM_ALBUQUERQUE SCHOOL DISTRICT'                 AS [Account Name]
, COALESCE(Dsites.Sitename, @DefaultSiteName)      AS [Site Name]
, dbo.CleanName(per.FIRST_NAME)                     AS [First Name]
, dbo.CleanName(per.MIDDLE_NAME)                     AS [Middle Initial]
, dbo.CleanName(per.LAST_NAME)                      AS [Last Name]
, stu.SIS_NUMBER + + '@aps.discoveryeducation.com' AS [UserName]
, 'student'                                        AS [Password]
, stu.SIS_NUMBER                                   AS [Student ID]
, grade.VALUE_DESCRIPTION                          AS [Student Grade]
, ''                                               AS [Parent Email] -- optional left blank due to extraneous comas in email
, 'N'                                              AS [Archive Flag]

FROM rev.EPC_STU stu
JOIN rev.EPC_STU_SCH_YR ssyr        ON ssyr.STUDENT_GU = stu.STUDENT_GU
                                       AND ssyr.STATUS IS NULL
                                       AND ssyr.LEAVE_DATE IS NULL
									   AND ssyr.EXCLUDE_ADA_ADM is NULL
									   and ssyr.ENTER_DATE <= getdate() 
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssyr.ORGANIZATION_YEAR_GU
                                       AND oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.EPC_SCH sch                ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON  per            ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN ParEmail pem              ON pem.STUDENT_GU = stu.STUDENT_GU and pem.rn = 1
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssyr.GRADE
LEFT JOIN ##TempDiscoverySites Dsites ON Dsites.SchNumber = sch.SCHOOL_CODE
WHERE grade.VALUE_DESCRIPTION IN ('K','01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')

IF OBJECT_ID('tempdb..##TempDiscoverySites') IS NOT NULL DROP TABLE ##TempDiscoverySites