

DECLARE @DEPARTMENT VARCHAR(10) = 'Eng', @SUBJECTAREA1 VARCHAR(10) --= 'Sci',@SUBJECTAREA2 VARCHAR(10) = 'Sci'
DECLARE @SCHOOL VARCHAR(128) = '%' --'C1B4D18A-F1A8-47AB-A588-8CC8AF9B1AE6'

SELECT DISTINCT
	--[DISTRICT_COURSE].[COURSE_GU]
	--[DISTRICT_COURSE].[COURSE_ID]
	--,[SECTION_SCHOOL_YEAR].[SECTION_ID]
	--[DISTRICT_COURSE].[COURSE_TITLE]
	[DISTRICT_COURSE].[DEPARTMENT] AS [COURSE_DEPARTMENT]
	--,[DISTRICT_COURSE].[SUBJECT_AREA_1]
	--,[DISTRICT_COURSE].[SUBJECT_AREA_2]
	--,[DISTRICT_COURSE].[SUBJECT_AREA_3]
	--,[DISTRICT_COURSE].[SUBJECT_AREA_4]
	--,[DISTRICT_COURSE].[SUBJECT_AREA_5]
	--,[DISTRICT_COURSE].[STATE_COURSE_CODE]
	
	--,[SECTION_SCHOOL_YEAR].[SECTION_GU]
	--,[COURSE_SCHOOL_YEAR].[SCHOOL_YEAR_COURSE_GU]
	--,[STAFF].[STAFF_GU]
	
	,[Organization].[ORGANIZATION_NAME] AS [School Name]
	,[PERSON].[LAST_NAME]
	,[PERSON].[FIRST_NAME]
	,[PERSON].[EMAIL]
	--,[PERSON].[JOB_TITLE]
	--,[PERSON].[PRIMARY_PHONE]
	--,SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [BADGE_NUM]
	--,[STAFF].[STATE_ID]
	--,CASE WHEN [ALL_STAFF_SCH_YR].[PRIMARY_STAFF] = 1 THEN 'Y' ELSE 'N' END AS [PRIMARY_STAFF]
	--,[STAFF_SCHOOL_YEAR].*
FROM
	rev.[EPC_CRS] AS [DISTRICT_COURSE]
	
	INNER JOIN
    rev.[EPC_SCH_YR_CRS] AS [COURSE_SCHOOL_YEAR]
    ON
    [DISTRICT_COURSE].[COURSE_GU] = [COURSE_SCHOOL_YEAR].[COURSE_GU]
    
    INNER JOIN
    rev.[EPC_SCH_YR_SECT] AS [SECTION_SCHOOL_YEAR]
    ON
    [SECTION_SCHOOL_YEAR].[SCHOOL_YEAR_COURSE_GU] = [COURSE_SCHOOL_YEAR].[SCHOOL_YEAR_COURSE_GU]
    
    --INNER JOIN
    --rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
    --ON
    --[SECTION_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
    
    -- Get both primary and secodary staff
    INNER JOIN
    (
    SELECT
		[STAFF_SCHOOL_YEAR_GU]
		,[STAFF_GU]
		,[ORGANIZATION_YEAR_GU]
		,1 AS [PRIMARY_STAFF]
	FROM
		rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
		
	UNION ALL
		
	SELECT
		[STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		,[STAFF_SCHOOL_YEAR].[STAFF_GU]
		,[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU]
		,0 AS [PRIMARY_STAFF]
	FROM
		rev.[EPC_SCH_YR_SECT_STF] AS [SECONDARY_STAFF]
		
		INNER JOIN
		rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
		ON
		[SECONDARY_STAFF].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
    ) AS [ALL_STAFF_SCH_YR]
    ON
   [SECTION_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
    
    INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[ALL_STAFF_SCH_YR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
    
    INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	LEFT JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
    
    INNER JOIN
    rev.[EPC_STAFF] AS [STAFF]
    ON
    [ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]
    
    INNER JOIN
    rev.[REV_PERSON] AS [PERSON]
    ON
    [STAFF].[STAFF_GU] = [PERSON].[PERSON_GU]
	
WHERE
	[DISTRICT_COURSE].[INACTIVE] = 'N'
	AND [RevYear].[YEAR_GU] = '26f066a3-abfc-4edb-b397-43412edabc8b'
	--AND [RevYear].[EXTENSION] = 'R'
	AND [DISTRICT_COURSE].[DEPARTMENT] = COALESCE(@DEPARTMENT,[DISTRICT_COURSE].[DEPARTMENT])
	AND (
		[DISTRICT_COURSE].[SUBJECT_AREA_1] = COALESCE(@SUBJECTAREA1,[DISTRICT_COURSE].[SUBJECT_AREA_1])
		OR
		[DISTRICT_COURSE].[SUBJECT_AREA_2] = @SUBJECTAREA1
		OR
		[DISTRICT_COURSE].[SUBJECT_AREA_3] = @SUBJECTAREA1
		OR
		[DISTRICT_COURSE].[SUBJECT_AREA_4] = @SUBJECTAREA1
		OR
		[DISTRICT_COURSE].[SUBJECT_AREA_5] = @SUBJECTAREA1
		--OR
		--[DISTRICT_COURSE].[SUBJECT_AREA_1] = @SUBJECTAREA2
		--OR
		--[DISTRICT_COURSE].[SUBJECT_AREA_2] = @SUBJECTAREA2
		--OR
		--[DISTRICT_COURSE].[SUBJECT_AREA_3] = @SUBJECTAREA2
		--OR
		--[DISTRICT_COURSE].[SUBJECT_AREA_4] = @SUBJECTAREA2
		--OR
		--[DISTRICT_COURSE].[SUBJECT_AREA_5] = @SUBJECTAREA2
		)
	AND [OrgYear].[ORGANIZATION_GU] LIKE @SCHOOL
	--AND [STAFF].[STATE_ID] = '32614'
	
	AND [PERSON].[LAST_NAME] != 'Not Found'
	
ORDER BY
	[Organization].[ORGANIZATION_NAME]
	,[PERSON].[LAST_NAME]
	
	

/*	
	INNER JOIN
    rev.EPC_SCH_YR_SECT AS SEC
    ON
    TAGS.SECTION_GU = SEC.SECTION_GU
    
    INNER JOIN
    rev.EPC_SCH_YR_CRS AS CRSYR
    ON
    SEC.SCHOOL_YEAR_COURSE_GU = CRSYR.SCHOOL_YEAR_COURSE_GU
    
    INNER JOIN
    rev.EPC_CRS AS CRS
    ON
    CRSYR.COURSE_GU = CRS.COURSE_GU

    INNER JOIN
    rev.EPC_SCH_YR_SECT AS SECYR
    ON
    SECYR.ORGANIZATION_YEAR_GU = CRSYR.ORGANIZATION_YEAR_GU
    AND 
    SECYR.SECTION_GU = SEC.SECTION_GU

    INNER JOIN
    rev.EPC_STAFF_SCH_YR AS STAFFYR
    ON
    STAFFYR.STAFF_SCHOOL_YEAR_GU = SECYR.STAFF_SCHOOL_YEAR_GU
    
    INNER JOIN
    rev.EPC_STAFF AS STAFF
    ON
    STAFFYR.STAFF_GU = STAFF.STAFF_GU

*/
