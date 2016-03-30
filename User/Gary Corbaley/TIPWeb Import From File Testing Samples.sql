




		
		

	
EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRAN

DECLARE @FeeCodes TABLE ([FEE_CODE_GU] UNIQUEIDENTIFIER, [FEE_CODE] VARCHAR(256), [FEE_DESCRIPTION] VARCHAR(256), [START_DATE] DATETIME, [END_DATE] DATETIME )

INSERT INTO
	@FeeCodes

	SELECT
		[FEE_CODE_GU]
		,[FEE_CODE]
		,[FEE_DESCRIPTION]
		,[CalendarOptions].[START_DATE]
		,[CalendarOptions].[END_DATE]
	FROM
		[rev].[EPC_SCH_YR_FEE]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[EPC_SCH_YR_FEE].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		rev.EPC_SCH_ATT_CAL_OPT AS [CalendarOptions]
		ON
		[OrgYear].[ORGANIZATION_YEAR_GU] = [CalendarOptions].[ORG_YEAR_GU]
		
	WHERE
		LEFT([FEE_CODE],3) IN ('525','540','550','560','576','580')
		
-----------------------------------------------------------------------------------	

--INSERT INTO
--	[rev].[EPC_STU_FEE] 

--	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
--	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])	

SELECT
	[STUDENT_FEE_GU]
	,CASE WHEN [STUDENT_SCHOOL_YEAR_GU2] IS NULL THEN [STUDENT_SCHOOL_YEAR_GU1] ELSE [STUDENT_SCHOOL_YEAR_GU2] END AS [STUDENT_SCHOOL_YEAR_GU]
	--,[STUDENT_SCHOOL_YEAR_GU1]
	--,[STUDENT_SCHOOL_YEAR_GU2]
	,[STUDENT_GU]
	,[TRANSACTION_DATE]
	--,[CampusID]
	,(SELECT [FEE_DESCRIPTION] FROM @FeeCodes AS FC WHERE [FC].[FEE_CODE_GU] = [LOST1].[FEE_CODE_GU]) AS [DESCRIPTION]
	,[FEE_CATEGORY]
	,[FEE_CODE_GU]
	,[CREDIT_AMOUNT]
	,[NOTE]
	,[REFUND_NEEDED]
	,[FEE_STATUS]
	,[ADD_DATE_TIME_STAMP]
FROM
	(
SELECT
		NEWID() AS [STUDENT_FEE_GU]
		,[ssy].[STUDENT_SCHOOL_YEAR_GU] AS [STUDENT_SCHOOL_YEAR_GU1]
		--,[stu].[STUDENT_GU] AS [STUDENT_GU]
		--,[Lost].[StudentID]
		,(SELECT TOP 1
				[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU]
			FROM
				APS.StudentEnrollmentDetails AS [ENROLLMENTS]	
				--INNER JOIN
				--APS.YearDates AS [YEARDATES]
				--ON
				--[ENROLLMENTS].[YEAR_GU] = [YEARDATES].[YEAR_GU]
				INNER JOIN
				rev.EPC_SCH_ATT_CAL_OPT AS [CalendarOptions]
				ON
				[ENROLLMENTS].[ORGANIZATION_YEAR_GU] = CalendarOptions.[ORG_YEAR_GU]
			WHERE
				[ENROLLMENTS].[STUDENT_GU]=[stu].[STUDENT_GU]
				AND
				[ENROLLMENTS].[SCHOOL_CODE]=[Lost].[CampusID]
				AND
				(
				[Lost].[ModifiedDate] BETWEEN [ENROLLMENTS].[ENTER_DATE] AND COALESCE([ENROLLMENTS].[LEAVE_DATE], CalendarOptions.[END_DATE])
				OR
				[Lost].[ModifiedDate] > COALESCE([ENROLLMENTS].[LEAVE_DATE], CalendarOptions.[END_DATE])
				)
			ORDER BY
				COALESCE([ENROLLMENTS].[LEAVE_DATE], CalendarOptions.[END_DATE]) DESC
			) AS [STUDENT_SCHOOL_YEAR_GU2]
		,[stu].[STUDENT_GU] AS [STUDENT_GU]
		--,GETDATE() AS [TRANSACTION_DATE]
		,[Lost].[CampusID]
		,[Lost].[ModifiedDate] AS [TRANSACTION_DATE]
		,'Lost Textbook' AS [DESCRIPTION]
		,'ACT' AS [FEE_CATEGORY]
		--,CASE --these might be different in live.
		--	WHEN [Lost].[CampusID]='540' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='540551' AND [Lost].[ModifiedDate] BETWEEN [START_DATE] AND [END_DATE] )
		--	WHEN [Lost].[CampusID]='550' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='550501' AND [Lost].[ModifiedDate] BETWEEN [START_DATE] AND [END_DATE] )
		--	WHEN [Lost].[CampusID]='560' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='560203' AND [Lost].[ModifiedDate] BETWEEN [START_DATE] AND [END_DATE] )
		--	WHEN [Lost].[CampusID]='576' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='576204' AND [Lost].[ModifiedDate] BETWEEN [START_DATE] AND [END_DATE] )
		--	WHEN [Lost].[CampusID]='580' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='580110' AND [Lost].[ModifiedDate] BETWEEN [START_DATE] AND [END_DATE] )
		-- END AS [FEE_CODE_GU]
		 ,(SELECT TOP 1
				[FEE_CODE_GU]
			FROM
				@FeeCodes AS [FEECODES]
				
			WHERE
				LEFT([FEE_CODE],3)=[Lost].[CampusID]
				AND
				(
				[Lost].[ModifiedDate] BETWEEN [FEECODES].[START_DATE] AND [FEECODES].[END_DATE]
				OR
				[Lost].[ModifiedDate] > [FEECODES].[END_DATE]
				)
				AND [FEE_CODE] =
				(
				CASE 
					WHEN [Lost].[CampusID] = '525' THEN '525401'
					WHEN [Lost].[CampusID] = '540' THEN '540551'
					WHEN [Lost].[CampusID] = '550' THEN '550501'
					WHEN [Lost].[CampusID] = '560' THEN '560203'
					WHEN [Lost].[CampusID] = '576' THEN '576204'
					WHEN [Lost].[CampusID] = '580' THEN '580110'
				END
				)
			ORDER BY
				[FEECODES].[END_DATE] DESC
			) AS [FEE_CODE_GU]
		,[Lost].[Price] AS [CREDIT_AMOUNT]
		,CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title] + ' LST' AS [NOTE] 
		,'N' AS [REFUND_NEEDED]
		,0 AS [FEE_STATUS]
		,GETDATE() AS [ADD_DATE_TIME_STAMP]
	FROM
		OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSLostBooks.csv'
		) AS [Lost]

		INNER JOIN
		[rev].[EPC_STU] as [stu]
		ON
		[Lost].[StudentID]=[stu].[SIS_NUMBER]

		INNER JOIN
		--APS.StudentEnrollmentDetails AS [ssy]
		--ON
		--[stu].[STUDENT_GU] = [ssy].[STUDENT_GU]
		--AND [Lost].[ModifiedDate] BETWEEN [ssy].[ENTER_DATE] AND [ssy].LEAVE_DATE
		(
			SELECT
				*
				,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS [RN]
			FROM
				[rev].[EPC_STU_SCH_YR]
			WHERE
				[EXCLUDE_ADA_ADM] IS NULL
		) AS [ssy]
		ON
			[stu].[STUDENT_GU]=[ssy].[STUDENT_GU]
			AND [ssy].[RN]=1

		LEFT JOIN
		[rev].[EPC_STU_FEE] AS [fee]
		ON
		CAST([fee].[NOTE] AS VARCHAR(4000))=CAST([Lost].[ISBN] AS VARCHAR(255))+' '+CAST([Lost].[Accession] AS VARCHAR(255))+' '+[Lost].[Title] + ' LST'

WHERE
	[Lost].[CampusID] IN ('525','540','550','560','576','580')
	AND [fee].[STUDENT_FEE_GU] IS NULL
	--AND [stu].[SIS_NUMBER] = '102702214'
	AND [Lost].[ModifiedDate] IS NOT NULL
	
) AS [LOST1]
	
--INSERT INTO
--	[rev].[EPC_STU_FEE] 

--	([STUDENT_FEE_GU],[STUDENT_SCHOOL_YEAR_GU],[STUDENT_GU],[TRANSACTION_DATE],[DESCRIPTION],[FEE_CATEGORY],[FEE_CODE_GU],[CREDIT_AMOUNT]
--	,[NOTE],[REFUND_NEEDED],[FEE_STATUS],[ADD_DATE_TIME_STAMP])

SELECT
	[STUDENT_FEE_GU]
	,CASE WHEN [STUDENT_SCHOOL_YEAR_GU2] IS NULL THEN [STUDENT_SCHOOL_YEAR_GU1] ELSE [STUDENT_SCHOOL_YEAR_GU2] END AS [STUDENT_SCHOOL_YEAR_GU]
	,[STUDENT_GU]
	,[TRANSACTION_DATE]
	,(SELECT [FEE_DESCRIPTION] FROM @FeeCodes AS FC WHERE [FC].[FEE_CODE_GU] = [DAMAGED1].[FEE_CODE_GU]) AS [DESCRIPTION]
	,[FEE_CATEGORY]
	,[FEE_CODE_GU]
	,[CREDIT_AMOUNT]
	,[NOTE]
	,[REFUND_NEEDED]
	,[FEE_STATUS]
	,[ADD_DATE_TIME_STAMP]
FROM
	(
	SELECT
		NEWID() AS [STUDENT_FEE_GU]
		,[ssy].[STUDENT_SCHOOL_YEAR_GU] AS [STUDENT_SCHOOL_YEAR_GU1]
		,(SELECT TOP 1
				[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU]
			FROM
				APS.StudentEnrollmentDetails AS [ENROLLMENTS]	
				INNER JOIN
				APS.YearDates AS [YEARDATES]
				ON
				[ENROLLMENTS].[YEAR_GU] = [YEARDATES].[YEAR_GU]
			WHERE
				[ENROLLMENTS].[STUDENT_GU]=[stu].[STUDENT_GU]
				AND
				[ENROLLMENTS].[SCHOOL_CODE]=[Damaged].[CampusID]
				AND
				(
				[Damaged].[ModifiedDate] BETWEEN [YEARDATES].[START_DATE] AND [YEARDATES].[END_DATE]
				OR
				[Damaged].[ModifiedDate] > [YEARDATES].[END_DATE]
				)
			ORDER BY
				[YEARDATES].[END_DATE] DESC
			) AS [STUDENT_SCHOOL_YEAR_GU2]
		,[stu].[STUDENT_GU] AS [STUDENT_GU]
		--,[Damaged].[StudentID]
		--,[Damaged].[CampusID]
		,[Damaged].[ModifiedDate] AS [TRANSACTION_DATE]
		,'Damaged Textbook' AS [DESCRIPTION]
		,'ACT' AS [FEE_CATEGORY]
		--,CASE --these might be different in live.
		--	WHEN [Damaged].[CampusID]='540' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='540552')
		--	WHEN [Damaged].[CampusID]='550' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='550502')
		--	WHEN [Damaged].[CampusID]='560' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='560204')
		--	WHEN [Damaged].[CampusID]='576' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='576203')
		--	WHEN [Damaged].[CampusID]='580' THEN (SELECT [FEE_CODE_GU] FROM @FeeCodes WHERE [FEE_CODE]='580107')
		-- END AS [FEE_CODE_GU]
		,(SELECT TOP 1
				[FEE_CODE_GU]
			FROM
				@FeeCodes AS [FEECODES]
				
			WHERE
				LEFT([FEE_CODE],3)=[Damaged].[CampusID]
				AND
				(
				[Damaged].[ModifiedDate] BETWEEN [FEECODES].[START_DATE] AND [FEECODES].[END_DATE]
				OR
				[Damaged].[ModifiedDate] > [FEECODES].[END_DATE]
				)
				AND [FEE_CODE] =
				(
				CASE 
					WHEN [Damaged].[CampusID] = '525' THEN '525402'
					WHEN [Damaged].[CampusID] = '540' THEN '540552'
					WHEN [Damaged].[CampusID] = '550' THEN '550502'
					WHEN [Damaged].[CampusID] = '560' THEN '560204'
					WHEN [Damaged].[CampusID] = '576' THEN '576203'
					WHEN [Damaged].[CampusID] = '580' THEN '580107'
				END
				)
			ORDER BY
				[FEECODES].[END_DATE] DESC
			) AS [FEE_CODE_GU]
		,[Damaged].[ChargeAmount] AS [CREDIT_AMOUNT]
		,CAST([Damaged].[ISBN] AS VARCHAR(255))+' '+CAST([Damaged].[Accession] AS VARCHAR(255))+' '+[Damaged].[Title] + ' DMG' AS [NOTE]
		,'N' AS [REFUND_NEEDED]
		,0 AS [FEE_STATUS]
		,GETDATE() AS [ADD_DATE_TIME_STAMP]
	FROM
		OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSDamagedBooks.csv'
		) AS [Damaged]

		INNER JOIN
		[rev].[EPC_STU] as [stu]
		ON
		[Damaged].[StudentID]=[stu].[SIS_NUMBER]

		INNER JOIN
		(
			SELECT 
				*
				,ROW_NUMBER() OVER (PARTITION BY [STUDENT_GU] ORDER BY [ENTER_DATE] DESC) AS [RN]
			FROM
				[rev].[EPC_STU_SCH_YR] AS [ssy]

			WHERE
				[EXCLUDE_ADA_ADM] IS NULL
		) AS [ssy]
		ON
			[stu].[STUDENT_GU]=[ssy].[STUDENT_GU]
			AND [ssy].[RN]=1

		LEFT JOIN
		[rev].[EPC_STU_FEE] AS [fee]
		ON
		CAST([fee].[NOTE] AS VARCHAR(4000))=CAST([Damaged].[ISBN] AS VARCHAR(255))+' '+CAST([Damaged].[Accession] AS VARCHAR(255))+' '+[Damaged].[Title] + ' DMG'

WHERE
	[Damaged].[CampusID] IN ('525','540','550','560','576','580')
	AND [fee].[STUDENT_FEE_GU] IS NULL
	AND [Damaged].[ModifiedDate] IS NOT NULL	
	--AND [stu].[SIS_NUMBER] = '102702214'
	
) AS [DAMAGED1]
	
ROLLBACK
--COMMIT
		
REVERT
GO