BEGIN TRAN

--UPDATE
--	CCR_ACCESS_TRASH
--SET
--	CCR_ACCESS_TRASH.[Listening PL] = AC.[Listening Proficiency Level]
--	,CCR_ACCESS_TRASH.[Speaking PL] = AC.[Speaking Proficiency Level]
--	,CCR_ACCESS_TRASH.[Reding PL] = AC.[Reading Proficiency Level]
--	,CCR_ACCESS_TRASH.[Writing PL] = AC.[Writing Proficiency Level]
--	,CCR_ACCESS_TRASH.[Composite Overal PL] = AC.[Comprehension Proficiency Level]	

SELECT
	AT.[Listening PL]
	,AT.[Speaking PL]
	,AT.[Reding PL]
	,AT.[Writing PL]
	,AT.[Composite Overal PL]
	,AT.[ELL Level]
	,AT.GRDE
	,AT.ID_NBR
	,AT.[Most Recent Test]
	,AT.Name
	,AT.RequestingLoc
	,AT.RequestingSchName
	,AT.SCH_NME_27
	,AT.SCH_NME_27
	,AT.TestDate
FROM
	CCR_ACCESS_TRASH AS AT
LEFT JOIN
	CCR_ACCESS AS AC
	ON
	AT.ID_NBR = AC.[District Student ID]

ROLLBACK