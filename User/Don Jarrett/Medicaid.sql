/*K12.SpecialEd.Student R0, K12.SpecialEd.IEP.IEPInfo R1, K12.School R8 (OrganizationGU,R0.OrganizationID,Outer), K12.SpecialEd.IEP.Service R3, K12.SpecialEd.SpecialEdService R7 (ServiceID,R3.ServiceCode,Outer), Revelation.FrequencyUnit R2 (FreqUnitID,R3.FrequencyUnit,Outer)
 COLS R0.FormattedName (2.5in), R0.SisNumber (1in), R8.OrganizationName (3in), R3.ServiceCode (1.5in), R3.StartDate, R3.EndDate, R3.Frequency, R3.FrequencyUnit, R7.StateReportingCode  If R1.IepStatus ='Current'
 Sort R0.FormattedName, R3.StartDate
*/

SELECT
    *
FROM
(
    SELECT
		[District CD]
	   ,[School CD]
	   ,[School Name]
	   ,[Student ID]
	   ,[Medicaid ID]
	   ,[Last Name]
	   ,[First Name]
	   ,[Middle Name]
	   ,[DOB (MM/DD/YYYY)]
	   ,'' AS [SSN]
	   ,[Gender CD]
	   ,[Student Address1]
	   ,[Student Address2]
	   ,[City]
	   ,[State]
	   ,[Zip Code]
	   ,'' AS [Primary Diagnosis CD]
	   ,'' AS [Secondary Diagnosis CD]
	   ,'' AS [Tertiary Diagnosis CD]
	   ,'' AS [Fourth Diagnosis CD]
	   ,MAX(CONVERT(VARCHAR(10),[IEP Start Date],101)) AS [IEP Start Date]
	   ,MIN(CONVERT(VARCHAR(10),[IEP End Date],101)) AS [IEP End Date]
	   ,MAX(CONVERT(VARCHAR(10),[PCP Prescription Start Date],101)) AS [PCP Prescription Start Date]
	   ,MIN(CONVERT(VARCHAR(10),[PCP Prescription End Date],101)) AS [PCP Prescription End Date]
	   ,'' AS [PCP Prescription Exempt(E)/In Process(P)]
	   ,'' AS [PCP Last Name]
	   ,'' AS [PCP First Name]
	   ,MAX([Audiology on IEP?]) AS [Audiology on IEP?]
	   ,'' AS [Case Management on IEP?]
	   ,MAX([Mental Health-Counseling on IEP?]) AS [Mental Health-Counseling on IEP?]
	   ,MAX([Nursing Services on IEP?]) AS [Nursing Services on IEP?]
	   ,'' AS [Nutritional Services on IEP?]
	   ,MAX([Occupational Therapy on IEP?]) AS [Occupational Therapy on IEP?]
	   ,MAX([Physical Therapy on IEP?]) AS [Physical Therapy on IEP?]
	   ,MAX([Speech Therapy on IEP?]) AS [Speech Therapy on IEP?]
	   ,MAX([Special Transportation on IEP?]) AS [Special Transportation on IEP?]
	   ,'' AS [BH-Mental Health Counselor/Therapist?]
	   ,'' AS [BH-Psychologist on IEP?]
	   ,'' AS [BH-School Psychologist on IEP?]
	   ,'' AS [BH-Social Worker on IEP?]
	   ,MAX([Parent Consent]) AS [Parent Consent]
	   ,MAX([AD Hours]) AS [AD Hours] 
	   ,MAX([MHC Hours]) AS [MHC Hours] 
	   ,MAX([NURS Hours]) AS [NURS Hours] 
	   ,MAX([OT Hours]) AS [OT Hours] 
	   ,MAX([PT Hours]) AS [PT Hours] 
	   ,MAX([SP Hours]) AS [SP Hours]
	   ,'' AS [BH-C Hours]
	   ,'' AS [BH-PS Hours]
	   ,'' AS [BH-SPS Hours]
	   ,'' AS [BH-SW Hours]
	   ,LEFT(MAX([AD Frequency]),1) AS [AD Frequency]
	   ,LEFT(MAX([MHC Frequency]),1) AS [MHC Frequency]
	   ,LEFT(MAX([NURS Frequency]),1) AS [NURS Frequency]
	   ,LEFT(MAX([OT Frequency]),1) AS [OT Frequency]
	   ,LEFT(MAX([PT Frequency]),1) AS [PT Frequency]
	   ,LEFT(MAX([SP Frequency]),1) AS [SP Frequency]
	   ,'' AS [BH-C Frequency]
	   ,'' AS [BH-PS Frequency]
	   ,'' AS [BH-SPS Frequency]
	   ,'' AS [BH-SW Frequency]
	   ,[Phone Nbr]
	   ,'' AS [Inactive?]
	   ,'' AS [Override Ind]
    FROM
    (
	   SELECT
		  '01' AS [District CD]
		  ,RIGHT('0000'+[School].[SCHOOL_CODE], 4)  AS [School CD]
		  ,[Org].[ORGANIZATION_NAME] AS [School Name]
		  ,RIGHT('000000000'+[Student].[SIS_NUMBER],9) AS [Student ID]
		  ,NULL AS [Medicaid ID]
		  ,[Person].[LAST_NAME] AS [Last Name]
		  ,[Person].[FIRST_NAME] AS [First Name]
		  ,[Person].[MIDDLE_NAME] AS [Middle Name]
		  ,CONVERT(VARCHAR(10),[Person].[BIRTH_DATE],101) AS [DOB (MM/DD/YYYY)]
		  ,[Person].[GENDER] AS [Gender CD]
		  ,[Address].[ADDRESS] AS [Student Address1]
		  ,[Address].[ADDRESS2] AS [Student Address2]
		  ,[Address].[CITY] AS [City]
		  ,[Address].[STATE] AS [State]
		  ,CASE WHEN [Address].[ZIP_5]='NoZip' THEN '' ELSE COALESCE([Address].[ZIP_5],'87110') END AS [Zip Code]
		  ,[IEPS].[START_DATE] AS [IEP Start Date]
		  ,[IEPS].[END_DATE] AS [IEP End Date]
		  ,[IEPS].[START_DATE] AS [PCP Prescription Start Date]
		  ,[IEPS].[END_DATE] AS [PCP Prescription End Date]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Audiology on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Mental Health-Counseling on IEP?]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Nursing Services on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Occupational Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Physical Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Speech Therapy on IEP?]
		  ,CASE WHEN [AIEP].[SERV_TRANSPORT_YN]='Y' AND [AIEP].[SERV_TRANSPORT_ADULT_YN]='Y' THEN 'Y' ELSE '' END AS [Special Transportation on IEP?]
		  ,CASE 
			 WHEN [Sped].[MEDICAID_CONSENT]='010' THEN 'Y'
			 WHEN [Sped].[MEDICAID_CONSENT]='020' THEN 'N'
			 WHEN [Sped].[MEDICAID_CONSENT]='030' THEN ''
			 WHEN [Sped].[MEDICAID_CONSENT] IS NULL THEN ''
		   END AS [Parent Consent]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [AD Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [MHC Hours]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [NURS Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [OT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [PT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [SP Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [AD Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [MHC Frequency]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [NURS Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [OT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [PT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') THEN [Freq].[VALUE_DESCRIPTION] ELSE '' END AS [SP Frequency]
		  ,CASE 
			 WHEN (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') IS NULL THEN '' 
			 WHEN LEN((SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H'))<10 THEN '505'+(SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H')
			 ELSE (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') 
		   END AS [Phone Nbr]
	   FROM
		  [rev].[EP_STUDENT_SPECIAL_ED] AS [Sped]

		  INNER JOIN
		  [rev].[EPC_STU] AS [Student]
		  ON
		  [Sped].[STUDENT_GU]=[Student].[STUDENT_GU]

		  INNER JOIN
		  [rev].[REV_PERSON] AS [Person]
		  ON
		  [Student].[STUDENT_GU]=[Person].[PERSON_GU]

		  INNER JOIN 
		  (
			 SELECT
				*
				,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ENTER_DATE DESC) AS [RN]
			 FROM
				[rev].[EPC_STU_SCH_YR]
			 WHERE
				[STATUS] IS NULL
				AND [EXCLUDE_ADA_ADM] IS NULL
				AND ([LEAVE_DATE] IS NULL
				OR [LEAVE_DATE]<=GETDATE())
		  ) AS [SSY]
		  ON
		  [Student].[STUDENT_GU]=[SSY].[STUDENT_GU]
		  AND [SSY].[RN]=1
    
		  INNER JOIN
		  [rev].[REV_ORGANIZATION_YEAR] AS [OrgYear]
		  ON
		  [SSY].[ORGANIZATION_YEAR_GU]=[OrgYear].[ORGANIZATION_YEAR_GU]

		  INNER JOIN
		  [rev].[REV_ORGANIZATION] AS [Org]
		  ON
		  [OrgYear].[ORGANIZATION_GU]=[Org].[ORGANIZATION_GU]

		  INNER JOIN
		  [rev].[EPC_SCH] AS [School]
		  ON
		  [Org].[ORGANIZATION_GU]=[School].[ORGANIZATION_GU]

		  INNER JOIN
		  [rev].[EP_STUDENT_IEP] AS [IEP]
		  ON
		  [Sped].[STUDENT_GU]=[IEP].[STUDENT_GU]

		  INNER JOIN
		  [rev].[EP_STU_IEP_SERVICE] AS [IEPS]
		  ON
		  [IEP].[IEP_GU]=[IEPS].[IEP_GU]
    
		  INNER JOIN
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [ISRV]
		  ON
		  [ieps].[SERVICE_GU]=[isrv].[SERVICE_GU]

		  LEFT JOIN
		  [APS].[LookupTable]('K12.SpecialEd.IEP','SERVICE_FREQUENCY') AS [Freq]
		  ON
		  [IEPS].[FREQUENCY_UNIT_DD]=[Freq].[VALUE_CODE]

		  LEFT JOIN
		  [rev].[REV_ADDRESS] AS [Address]
		  ON
		  [Person].[HOME_ADDRESS_GU]=[Address].[ADDRESS_GU]

		  LEFT JOIN
		  [rev].[EP_AZ_STUDENT_IEP] AS [AIEP]
		  ON
		  [IEP].[IEP_GU]=[AIEP].[IEP_GU]
		  AND [IEP].[NEXT_IEP_DATE]>=GETDATE()

		  INNER JOIN 
		  [rev].[EP_SPECIAL_ED_SERVICE] AS [SSRV]
		  ON
		  [IEPS].[SERVICE_GU]=[SSRV].[SERVICE_GU]

		  LEFT JOIN
		  [rev].[EP_AZ_IEP_LRE] AS [LRE]
		  ON
		  [IEP].[IEP_GU]=[LRE].[IEP_GU]

       WHERE
		  [IEP].[IEP_STATUS]='CU'
		  AND [IEP].[IEP_VALID]='Y'
		  AND [LRE].[SEC_SRV_SHOW]='Y'

    ) AS [IEP]

    GROUP BY
		[District CD]
	   ,[School CD]
	   ,[School Name]
	   ,[Student ID]
	   ,[Medicaid ID]
	   ,[Last Name]
	   ,[First Name]
	   ,[Middle Name]
	   ,[DOB (MM/DD/YYYY)]
	   ,[Gender CD]
	   ,[Student Address1]
	   ,[Student Address2]
	   ,[City]
	   ,[State]
	   ,[Zip Code]
	   ,[IEP Start Date]
	   --,[IEP End Date]
	   ,[PCP Prescription Start Date]
	   --,[PCP Prescription End Date]
	   ,[Phone Nbr]
) AS [IEP]

WHERE
    'Y' IN (
		  [Audiology on IEP?]
		  ,[Case Management on IEP?]
		  ,[Mental Health-Counseling on IEP?]
		  ,[Nursing Services on IEP?]
		  ,[Nutritional Services on IEP?]
		  ,[Occupational Therapy on IEP?]
		  ,[Physical Therapy on IEP?]
		  ,[Speech Therapy on IEP?])

	--AND [Student ID] IN (970085341,970068353,970096404,100123629)

ORDER BY
    [Student ID]