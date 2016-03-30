

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
	--[STRING]
	[CampusID]
	,[StudentID]
	,[ISBN]
	,[Title]
	,[Accession]
	,[ChargeAmount]
	,[ModifiedDate]
	,SUBSTRING([STRING],[LAST_COMMA]+1,LEN([STRING])) AS [Notes]
	--,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
FROM
	(
	SELECT
		[STRING]
		,[CampusID]
		,[StudentID]
		,[ISBN]
		,[Title]
		,[Accession]
		,[ChargeAmount]
		,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [ModifiedDate]
		,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
	FROM
		(
		SELECT
			[STRING]
			,[CampusID]
			,[StudentID]
			,[ISBN]
			,[Title]
			,[Accession]
			,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [ChargeAmount]
			,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
		FROM
			(
			SELECT
				[STRING]
				,[CampusID]
				,[StudentID]
				,[ISBN]
				,[Title]
				,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [Accession]
				,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
			FROM
				(
				SELECT
					[STRING]
					,[CampusID]
					,[StudentID]
					,[ISBN]
					,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [Title]
					,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
				FROM
					(
					SELECT
						[STRING]
						,[CampusID]
						,[StudentID]
						,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [ISBN]
						,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
					FROM
						(
						SELECT
							[STRING]
							,[CampusID]
							,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [StudentID]
							,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
						FROM
							(
							SELECT
								[Damaged].[CampusID,StudentID,ISBN,Title,Accession,ChargeAmount,ModifiedDat] AS [STRING]
								,SUBSTRING([Damaged].[CampusID,StudentID,ISBN,Title,Accession,ChargeAmount,ModifiedDat],0,CHARINDEX(',',[Damaged].[CampusID,StudentID,ISBN,Title,Accession,ChargeAmount,ModifiedDat])) AS [CampusID]
								,CHARINDEX(',',[Damaged].[CampusID,StudentID,ISBN,Title,Accession,ChargeAmount,ModifiedDat]) AS [LAST_COMMA]
								
							FROM
								OPENROWSET (
									'Microsoft.ACE.OLEDB.12.0', 
									'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
									'SELECT * from APS_DamagedBooks.csv'
									) AS [Damaged]
							) AS [SUB1]
						) AS [SUB2]
					) AS [SUB3]
				) AS [SUB4]
			) AS [SUB5]
		) AS [SUB6]
	) AS [SUB7]
	
SELECT
	--[STRING]
	[CampusID]
	,[StudentID]
	,[ISBN]
	,[Title]
	,[Accession]
	,[Status]
	,[Price]
	,[ModifiedDat]
	,SUBSTRING([STRING],[LAST_COMMA]+1,LEN([STRING])) AS [Notes]
	--,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
FROM
	(	
	SELECT
		[STRING]
		,[CampusID]
		,[StudentID]
		,[ISBN]
		,[Title]
		,[Accession]
		,[Status]
		,[Price]
		--,SUBSTRING([STRING],[LAST_COMMA]+1,LEN([STRING])) AS [Notes]
		,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [ModifiedDat]
		,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
		,LEN([STRING]) AS [LENGTH]
	FROM
		(
		SELECT
			[STRING]
			,[CampusID]
			,[StudentID]
			,[ISBN]
			,[Title]
			,[Accession]
			,[Status]
			,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [Price]
			,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
		FROM
			(
			SELECT
				[STRING]
				,[CampusID]
				,[StudentID]
				,[ISBN]
				,[Title]
				,[Accession]
				,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [Status]
				,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
			FROM
				(
				SELECT
					[STRING]
					,[CampusID]
					,[StudentID]
					,[ISBN]
					,[Title]
					,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [Accession]
					,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
				FROM
					(
					SELECT
						[STRING]
						,[CampusID]
						,[StudentID]
						,[ISBN]
						,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [Title]
						,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
					FROM
						(
						SELECT
							[STRING]
							,[CampusID]
							,[StudentID]
							,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [ISBN]
							,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
						FROM
							(
							SELECT
								[STRING]
								,[CampusID]
								,SUBSTRING([STRING],[LAST_COMMA]+1,CHARINDEX(',',[STRING],[LAST_COMMA]+1)-[LAST_COMMA]-1) AS [StudentID]
								,CHARINDEX(',',[STRING],[LAST_COMMA]+1) AS [LAST_COMMA]
							FROM
								(
								SELECT
									--*
									[Lost].[CampusID,StudentID,ISBN,Title,Accession,Status,Price,ModifiedDat] AS [STRING]
									,SUBSTRING([Lost].[CampusID,StudentID,ISBN,Title,Accession,Status,Price,ModifiedDat],0,CHARINDEX(',',[Lost].[CampusID,StudentID,ISBN,Title,Accession,Status,Price,ModifiedDat])) AS [CampusID]
									,CHARINDEX(',',[Lost].[CampusID,StudentID,ISBN,Title,Accession,Status,Price,ModifiedDat]) AS [LAST_COMMA]
									
								FROM
									OPENROWSET (
										'Microsoft.ACE.OLEDB.12.0', 
										'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
										'SELECT * from APS_LostBooks.csv'
										) AS [Lost]
								) AS [SUB1]
							) AS [SUB2]
						) AS [SUB3]
					) AS [SUB4]
				) AS [SUB5]
			) AS [SUB6]
		) AS [SUB7]
	) AS [SUB8]
	
REVERT
GO