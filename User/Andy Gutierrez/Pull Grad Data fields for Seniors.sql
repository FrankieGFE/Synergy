
SELECT
    ORG.ORGANIZATION_NAME AS SCHOOL
	,[Student].[SIS_NUMBER]
	,[Grades].[VALUE_DESCRIPTION] AS GRADE
	,LAST_NAME
	,FIRST_NAME
	,MIDDLE_NAME
    ,Diplomas.VALUE_DESCRIPTION AS DIPLOMA_TYPE
    
    ,[Student].[GRADUATION_DATE]
    ,GradStatus.VALUE_DESCRIPTION AS GRAD_STATUS
    ,[Student].[GRADUATION_SEMESTER]
    ,PostSecondary.VALUE_DESCRIPTION AS POST_SECONDARY
FROM
    [rev].[EPC_STU] AS [Student]

    INNER JOIN
    [APS].[PrimaryEnrollmentsAsOf](GETDATE()) AS [Enroll]
	--[APS].[PrimaryEnrollmentsAsOf]('05/22/2015') AS [Enroll]
    ON
    [Student].[STUDENT_GU]=[Enroll].[STUDENT_GU]

    INNER JOIN
    [APS].[LookupTable]('K12','GRADE') AS [Grades]
    ON
    [Enroll].[GRADE]=[Grades].[VALUE_CODE]

	INNER JOIN 
	rev.REV_PERSON AS PERSON
	ON
	Enroll.STUDENT_GU = PERSON.PERSON_GU

	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS ORGYR
	ON
	ENROLL.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU

	INNER JOIN 
	rev.REV_ORGANIZATION AS ORG
	ON
	ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU

	LEFT JOIN
    [APS].[LookupTable]('K12','DIPLOMA_TYPE') AS [Diplomas]
    ON
    [Student].DIPLOMA_TYPE=[Diplomas].[VALUE_CODE]

	LEFT JOIN
    [APS].[LookupTable]('K12','GRADUATION_STATUS') AS [GradStatus]
    ON
    [Student].GRADUATION_STATUS=[GradStatus].[VALUE_CODE]

	LEFT JOIN
    [APS].[LookupTable]('K12.Demographics','POST_SECONDARY') AS [PostSecondary]
    ON
    [Student].POST_SECONDARY=PostSecondary.[VALUE_CODE]

WHERE
	--[Student].[GRADUATION_DATE] IS NOT NULL
    --[Grades].[VALUE_DESCRIPTION]='12'
    [Student].[EXPECTED_GRADUATION_YEAR]=2017
	AND ORGANIZATION_NAME NOT IN ('Career Enrichment Center', 'Homebound', 'Private School', 'Title One School') 
	--AND STUDENT.CHANGE_ID_STAMP =  '27CDCD0E-BF93-4071-94B2-5DB792BB735F'
	ORDER BY 
	SCHOOL,
	GRADUATION_STATUS DESC, POST_SECONDARY DESC