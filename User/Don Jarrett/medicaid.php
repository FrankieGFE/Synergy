<?php
	//mental health should be in social work as well.
	//970068353,970085341,143559 - different dates should be one. needs later begin date.
	
	//$output=fopen(rawurlencode("smb://syntempssis.aps.edu.actd/Files/Export/Medicaid/APS_StudentData_".date("Ymd",time())."_Test.csv"),"w");
	$state=smbclient_state_new();
	smbclient_state_init($state,null,"APS\sis-service","SISadmin@2011");

	if (!$state)
		exit();
	
	$filename="smb://172.17.0.202/Files/Export/Medicaid/APS_StudentData_".date("Ymd",time()).".csv";

	$output=smbclient_open($state,$filename,"w");
	
	if (!$output)
		exit();
	
	$sql=mssql_connect('synergydbdc.aps.edu.actd','APSExport','RhLW6y6KBqAT58Y7NFVf',true);
	mssql_select_db('ST_Production',$sql);
	
	if (!$sql)
		exit();
	
	$query="SELECT
		  [IEP].[IEP_GU]
		  ,'01' AS [District CD]
		  ,RIGHT('0000'+[School].[SCHOOL_CODE], 4)  AS [School CD]
		  ,[Org].[ORGANIZATION_NAME] AS [School Name]
		  ,RIGHT('000000000'+[Student].[SIS_NUMBER],9) AS [Student ID]
		  ,NULL AS [Medicaid ID]
		  ,[Person].[LAST_NAME] AS [Last Name]
		  ,[Person].[FIRST_NAME] AS [First Name]
		  ,[Person].[MIDDLE_NAME] AS [Middle Name]
		  ,CONVERT(VARCHAR(10),[Person].[BIRTH_DATE],101) AS [DOB (MM/DD/YYYY)]
		  ,'' AS [SSN]
		  ,[Person].[GENDER] AS [Gender CD]
		  ,[Address].[ADDRESS] AS [Student Address1]
		  ,[Address].[ADDRESS2] AS [Student Address2]
		  ,[Address].[CITY] AS [City]
		  ,[Address].[STATE] AS [State]
		  ,CASE WHEN [Address].[ZIP_5]='NoZip' THEN '' ELSE COALESCE([Address].[ZIP_5],'87110') END AS [Zip Code]
          ,'' AS [Primary Diagnosis CD]
		  ,'' AS [Secondary Diagnosis CD]
		  ,'' AS [Tertiary Diagnosis CD]
		  ,'' AS [Fourth Diagnosis CD]
		  ,[IEPS].[START_DATE] AS [IEP Start Date]
		  ,[IEPS].[END_DATE] AS [IEP End Date]
		  ,[IEPS].[START_DATE] AS [PCP Prescription Start Date]
		  ,[IEPS].[END_DATE] AS [PCP Prescription End Date]
		   ,'' AS [PCP Prescription Exempt(E)/In Process(P)]
		   ,'' AS [PCP Last Name]
		   ,'' AS [PCP First Name]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Audiology on IEP?]
		  ,'' AS [Case Management on IEP?]
		  ,/*CASE WHEN [IEPS].[START_DATE]<'20151001' THEN*/ CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' /*END*/ END AS [Mental Health-Counseling on IEP?]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Nursing Services on IEP?]
		  ,'' AS [Nutritional Services on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Occupational Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Physical Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Speech Therapy on IEP?]
		  ,CASE WHEN [AIEP].[SERV_TRANSPORT_YN]='Y' AND [AIEP].[SERV_TRANSPORT_ADULT_YN]='Y' THEN 'Y' ELSE '' END AS [Special Transportation on IEP?]
		   ,'' AS [BH-Mental Health Counselor/Therapist?]
		   ,'' AS [BH-Psychologist on IEP?]
		   ,'' AS [BH-School Psychologist on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [BH-Social Worker on IEP?]
		  ,CASE 
			 WHEN [Sped].[MEDICAID_CONSENT]='010' THEN 'Y'
			 WHEN [Sped].[MEDICAID_CONSENT]='020' THEN 'N'
			 WHEN [Sped].[MEDICAID_CONSENT]='030' THEN ''
			 WHEN [Sped].[MEDICAID_CONSENT] IS NULL THEN ''
		   END AS [Parent Consent]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [AD Hours]
		  ,/*CASE WHEN [IEPS].[START_DATE]<'20151001' THEN*/ CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' /*END*/ END AS [MHC Hours]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [NURS Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [OT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [PT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [SP Hours]
		   ,'' AS [BH-C Hours]
		   ,'' AS [BH-PS Hours]
		   ,'' AS [BH-SPS Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [BH-SW Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [AD Frequency]
		  ,/*CASE WHEN [IEPS].[START_DATE]<'20151001' THEN*/ CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' /*END*/ END AS [MHC Frequency]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [NURS Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [OT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [PT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [SP Frequency]
		   ,'' AS [BH-C Frequency]
		   ,'' AS [BH-PS Frequency]
		   ,'' AS [BH-SPS Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [BH-SW Frequency]
		  ,CASE 
			 WHEN (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') IS NULL THEN '' 
			 WHEN LEN((SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H'))<10 THEN '505'+(SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H')
			 ELSE (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') 
		   END AS [Phone Nbr]
		  ,'' AS [Inactive?]
		  ,'' AS [Override Ind]
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
		  --AND [Student].[SIS_NUMBER] IN (143559,970068353,100013655,190430)
		  --AND [Student].[SIS_NUMBER] IN (970068353,970085341,143559)
		  
	   UNION

	   SELECT
		  [IEP].[IEP_GU]
		  ,'01' AS [District CD]
		  ,RIGHT('0000'+[School].[SCHOOL_CODE], 4)  AS [School CD]
		  ,[Org].[ORGANIZATION_NAME] AS [School Name]
		  ,RIGHT('000000000'+[Student].[SIS_NUMBER],9) AS [Student ID]
		  ,NULL AS [Medicaid ID]
		  ,[Person].[LAST_NAME] AS [Last Name]
		  ,[Person].[FIRST_NAME] AS [First Name]
		  ,[Person].[MIDDLE_NAME] AS [Middle Name]
		  ,CONVERT(VARCHAR(10),[Person].[BIRTH_DATE],101) AS [DOB (MM/DD/YYYY)]
		  ,'' AS [SSN]
		  ,[Person].[GENDER] AS [Gender CD]
		  ,[Address].[ADDRESS] AS [Student Address1]
		  ,[Address].[ADDRESS2] AS [Student Address2]
		  ,[Address].[CITY] AS [City]
		  ,[Address].[STATE] AS [State]
		  ,CASE WHEN [Address].[ZIP_5]='NoZip' THEN '' ELSE COALESCE([Address].[ZIP_5],'87110') END AS [Zip Code]
          ,'' AS [Primary Diagnosis CD]
		  ,'' AS [Secondary Diagnosis CD]
		  ,'' AS [Tertiary Diagnosis CD]
		  ,'' AS [Fourth Diagnosis CD]
		  ,[IEPS].[START_DATE] AS [IEP Start Date]
		  ,[IEPS].[END_DATE] AS [IEP End Date]
		  ,[IEPS].[START_DATE] AS [PCP Prescription Start Date]
		  ,[IEPS].[END_DATE] AS [PCP Prescription End Date]
		   ,'' AS [PCP Prescription Exempt(E)/In Process(P)]
		   ,'' AS [PCP Last Name]
		   ,'' AS [PCP First Name]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Audiology on IEP?]
		  ,'' AS [Case Management on IEP?]
		  ,/*CASE WHEN [IEPS].[START_DATE]<'20151001' THEN*/ CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' /*END*/ END AS [Mental Health-Counseling on IEP?]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Nursing Services on IEP?]
		  ,'' AS [Nutritional Services on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Occupational Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Physical Therapy on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [Speech Therapy on IEP?]
		  ,CASE WHEN [AIEP].[SERV_TRANSPORT_YN]='Y' AND [AIEP].[SERV_TRANSPORT_ADULT_YN]='Y' THEN 'Y' ELSE '' END AS [Special Transportation on IEP?]
		   ,'' AS [BH-Mental Health Counselor/Therapist?]
		   ,'' AS [BH-Psychologist on IEP?]
		   ,'' AS [BH-School Psychologist on IEP?]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' AND [IEPS].[NUM_MINUTES] IS NOT NULL THEN 'Y' ELSE '' END AS [BH-Social Worker on IEP?]
		  ,CASE 
			 WHEN [Sped].[MEDICAID_CONSENT]='010' THEN 'Y'
			 WHEN [Sped].[MEDICAID_CONSENT]='020' THEN 'N'
			 WHEN [Sped].[MEDICAID_CONSENT]='030' THEN ''
			 WHEN [Sped].[MEDICAID_CONSENT] IS NULL THEN ''
		   END AS [Parent Consent]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [AD Hours]
		  ,/*CASE WHEN [IEPS].[START_DATE]<'20151001' THEN*/ CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' /*END*/ END AS [MHC Hours]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [NURS Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [OT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [PT Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [SP Hours]
		   ,'' AS [BH-C Hours]
		   ,'' AS [BH-PS Hours]
		   ,'' AS [BH-SPS Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN COALESCE(CAST(CAST(([IEPS].[NUM_MINUTES]/60) AS NUMERIC(6,2)) AS VARCHAR(10)),'') ELSE '' END AS [BH-SW Hours]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='AU' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [AD Frequency]
		  ,/*CASE WHEN [IEPS].[START_DATE]<'20151001' THEN */CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' /*END*/ END AS [MHC Frequency]
		  ,CASE WHEN [SSRV].[SERVICE_TYPE]='080' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [NURS Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='OT' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [OT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='PT' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [PT Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE] IN ('SS','SO') THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [SP Frequency]
		   ,'' AS [BH-C Frequency]
		   ,'' AS [BH-PS Frequency]
		   ,'' AS [BH-SPS Frequency]
		  ,CASE WHEN [SSRV].[STATE_REPORTING_CODE]='SW' THEN LEFT([Freq].[VALUE_DESCRIPTION],1) ELSE '' END AS [BH-SW Frequency]
		  ,CASE 
			 WHEN (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') IS NULL THEN '' 
			 WHEN LEN((SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H'))<10 THEN '505'+(SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H')
			 ELSE (SELECT TOP 1 [P].[PHONE] FROM [rev].[REV_PERSON_PHONE] AS [P] WHERE [Student].[STUDENT_GU]=[P].[PERSON_GU] AND [P].[PHONE_TYPE]='H') 
		   END AS [Phone Nbr]
		  ,'' AS [Inactive?]
		  ,'' AS [Override Ind]
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
		  AND ([LRE].[SEC_SRV_SHOW]='N' OR [LRE].[SEC_SRV_SHOW] IS NULL)
		  --AND [Student].[SIS_NUMBER] IN (143559,970068353,100013655,190430)
		  --AND [Student].[SIS_NUMBER] IN (970068353,970085341,143559)";

	$rows=mssql_query($query,$sql);
	$records=array();
	$toWrite=array();
	
	$lines="";
	// Dump all field names in result
	for ($i = 1; $i < mssql_num_fields($rows); ++$i) {
		if ($i==mssql_num_fields($rows)-2) {
			smbclient_write($state,$output,'"'.mssql_field_name($rows,$i).'"'."\r\n");
			break;
		}
		else
			smbclient_write($state,$output,'"' . mssql_field_name($rows, $i).'",');
	}
	//use earlier end date
	//use later begin date
	//100013655, 190430
	$seed="";
	while ($row=mssql_fetch_array($rows,MSSQL_BOTH)) {
		//rows 16-19 are the date/time
		$seed=mssql_guid_string($row["IEP_GU"]).$row["IEP End Date"];
		
		if (!isset($records[$seed])) {
			$records[$seed]=array();
			$records[$seed][0]=array();
			$records[$seed][0]=$row;
			$toWrite[$seed]="N";
			
			$oldIepStart=strtotime($records[$seed][0][21],time());
			$oldIepEnd=strtotime($records[$seed][0][22],time());
			$oldPcpStart=strtotime($records[$seed][0][23],time());
			$oldPcpEnd=strtotime($records[$seed][0][24],time());

			$records[$seed][0][21]=date("Y-m-d 00:00:00",$oldIepStart);
			$records[$seed][0][22]=date("Y-m-d 00:00:00",$oldIepEnd);
			$records[$seed][0][23]=date("Y-m-d 00:00:00",$oldPcpStart);
			$records[$seed][0][24]=date("Y-m-d 00:00:00",$oldPcpEnd);
			
			if (strlen($records[$seed][0][16])!==5)
				$records[$seed][0][16]='';

			if ($records[$seed][0][28]==="Y") {
				$toWrite[$seed]="Y";
			}
			if ($records[$seed][0][30]==="Y") {
				$toWrite[$seed]="Y";
			}
			if ($records[$seed][0][31]==="Y") {
				$toWrite[$seed]="Y";
			}
			if ($records[$seed][0][33]==="Y") {
				$toWrite[$seed]="Y";
			}
			if ($records[$seed][0][34]==="Y") {
				$toWrite[$seed]="Y";
			}
			if ($records[$seed][0][35]==="Y") {
				$toWrite[$seed]="Y";
			}
			if ($records[$seed][0][40]==="Y") {
				$toWrite[$seed]="Y";
			}
		}
		else {
			$oldIepStart=strtotime($records[$seed][0][21],time());
			$oldIepEnd=strtotime($records[$seed][0][22],time());
			$oldPcpStart=strtotime($records[$seed][0][23],time());
			$oldPcpEnd=strtotime($records[$seed][0][24],time());
			
			$iepStart=strtotime($row[21],time());
			$iepEnd=strtotime($row[22],time());
			$pcpStart=strtotime($row[23],time());
			$pcpEnd=strtotime($row[24],time());
			
			if ($iepStart>$oldIepStart) {
				$records[$seed][0][21]=date("Y-m-d 00:00:00",$iepStart);
				$records[$seed][0][23]=date("Y-m-d 00:00:00",$pcpStart);
			}
			else {
				$records[$seed][0][21]=date("Y-m-d 00:00:00",$oldIepStart);
				$records[$seed][0][23]=date("Y-m-d 00:00:00",$oldPcpStart);
			}
			
			if ($iepEnd<$oldIepEnd) {
				$records[$seed][0][22]=date("Y-m-d 00:00:00",$iepEnd);
				$records[$seed][0][24]=date("Y-m-d 00:00:00",$pcpEnd);
			}
			else {
				$records[$seed][0][22]=date("Y-m-d 00:00:00",$oldIepEnd);
				$records[$seed][0][24]=date("Y-m-d 00:00:00",$oldPcpEnd);
			}
			
			//audiology on iep
			if ($row[28]==="Y") {
				$records[$seed][0][28]=$row[28];
				$records[$seed][0][42]=$row[42];
				$records[$seed][0][52]=substr($row[52],0,1);
				$toWrite[$seed]="Y";
			}
			//mental health counseling on iep
			if ($row[30]==="Y") {
				$records[$seed][0][30]=$row[30];
				$records[$seed][0][43]=$row[43]; 
				$records[$seed][0][53]=substr($row[53],0,1);
				$toWrite[$seed]="Y";
			}			
			//nursing services on iep
			if ($row[31]==="Y") {
				$records[$seed][0][31]=$row[31];
				$records[$seed][0][44]=$row[44];
				$records[$seed][0][54]=substr($row[54],0,1);
				$toWrite[$seed]="Y";
			}
			//occupational therapy on iep
			if ($row[33]==="Y") {
				$records[$seed][0][33]=$row[33];
				$records[$seed][0][45]=$row[45];
				$records[$seed][0][55]=substr($row[55],0,1);
				$toWrite[$seed]="Y";
			}
			//physical therapy on iep
			if ($row[34]==="Y") {
				$records[$seed][0][34]=$row[34];
				$records[$seed][0][46]=$row[46];
				$records[$seed][0][56]=substr($row[56],0,1);
				$toWrite[$seed]="Y";
			}
			//speech therapy on iep
			if ($row[35]==="Y") {
				$records[$seed][0][35]=$row[35];
				$records[$seed][0][47]=$row[47];
				$records[$seed][0][57]=substr($row[57],0,1);
				$toWrite[$seed]="Y";
			}
			//bh-social worker on iep
			if ($row[40]==="Y") {
				$records[$seed][0][40]=$row[40];
				$records[$seed][0][51]=$row[51];
				$records[$seed][0][61]=substr($row[61],0,1);
				$toWrite[$seed]="Y";
			}
		}
	}
	foreach ($records as $Key => $Value) {
		if ($toWrite[$Key]==="Y") {
			foreach ($records[$Key][0] as $Key2 => $Value2) {
				if ($Key2!=0) {
					if ($Key2==64) {
						$lines.='"'.trim($Value2).'"'."\r\n";
						break;
					}
					else
						$lines.='"'.trim($Value2).'",';
				}
			}
		}
	}
	//fputs($output,$lines);
	smbclient_write($state,$output,$lines);
	mssql_close($sql);
	//fclose($output);
	smbclient_close($state,$output);
	smbclient_state_free($state);
	
?>
