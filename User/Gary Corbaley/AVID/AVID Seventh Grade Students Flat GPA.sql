/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 06/04/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 01/20/2014
 * 
 * Initial Request: Please look it over and start framing SQL script to pull the data that is obvious to you, we can discuss the other data with Tom.
 *
 * Description: Start with getting all student's primary enrollments and student details, and then join in SPED and ELL stats
 * One Record Per Student
 *
 * Note: Script can take over a minute to run.
 *
 * Tables Referenced:
 */

DECLARE @ASOFDATE DATETIME = '05/01/2014'
DECLARE @SCHOOLYEAR INT = 2014


SELECT -- DISTINCT --TOP 972
	--[Enrollments].[DST_NBR]
	--,[Enrollments].[SCH_YR]
	--,[Enrollments].[SCH_NBR]
	--,[School].[SCH_NME]
	[Students].[ID_NBR]
	--,[Students].[STATE_ID]
	--,[Enrollments].[BEG_ENR_DT]
	--,[Enrollments].[END_ENR_DT]
	
	--,[Students].[FRST_NME]
	--,[Students].[LST_NME]
	--,[Enrollments].[SCH_YR]
	--,[Enrollments].[SCH_NBR]
	--,[School].[SCH_NME]
	--,[Enrollments].[GRDE]
	--,[Students].[GENDER]
	--,[Students].[Race]
	--,[Students].[FRPL]
	--,[SPED].[Primary Disability]
	
	--,[ADA_504].[ADA_504]
	
	,[GPA].[Cumulative Flat GPA]
	,[GPA].[Cumulative Weighted GPA]
	--,[BasicGPA].[FLAT GPA]
	--,[BasicGPA].[Weighted GPA]
	--,[BasicGPA].[Attempted Credits]
	--,[BasicGPA].[Earned Credits]
	--,[BasicGPA].[Honors Points]
	
	--,[Students].[ADDR_TO]
	--,[Students].[ADDR_LNE_1]
	--,[Students].[ADDR_LNE_2]
	--,[Students].[CITY]
	--,[Students].[STATE]
	--,[Students].[ZIP_CD]
	
	-- List the classes in order by Date Assigned
	--,ROW_NUMBER() OVER (PARTITION BY [Enrollments].[ID_NBR] ORDER BY [Schedules].[DATE_ASG] DESC) AS RN
	
FROM
	
	
	-- Get Student Details
	--INNER JOIN
	APS.BasicStudent AS [Students]	
	--ON
	--[Enrollments].[DST_NBR] = [Students].[DST_NBR]
	--AND [Enrollments].[ID_NBR] = [Students].[ID_NBR]
	
	-- Get Primary Enrollments
	LEFT JOIN
	(
	SELECT DISTINCT
		_Id,
		DST_NBR,
		SCH_YR,
		SCH_NBR,
		GRDE,
		ID_NBR,
		BEG_ENR_DT,
		END_ENR_DT
	FROM 
		(
		SELECT
			ST010._Id,
			ST010.DST_NBR,
			ST010.SCH_NBR,
			ST010.GRDE,
			ST010.ID_NBR,
			ST010.SCH_YR,
			ST010.BEG_ENR_DT,
			ST010.END_ENR_DT,
			ROW_NUMBER() OVER (PARTITION BY ST010.DST_NBR, ST010.ID_NBR ORDER BY ST010.BEG_ENR_DT DESC) AS RN
		FROM
			DBTSIS.ST010 WITH(NOLOCK) 
		WHERE
			  --SCH_YR <= @SCHOOLYEAR
			  GRDE = '08'
			  AND NONADA_SCH != 'X'
			  AND END_ENR_DT > BEG_ENR_DT

		) AS ST010CURR
	WHERE RN = 1
	) AS [Enrollments]
	--APS.PrimaryEnrollmentsAsOf('05/22/2014') AS [Enrollments]
	ON
	[Students].[DST_NBR] = [Enrollments].[DST_NBR]
	AND [Students].[ID_NBR] = [Enrollments].[ID_NBR]
	
	--LEFT JOIN
	---- Get Current SPED status
	--APS.SpedAsOf(@ASOFDATE) AS [SPED]
	
	--ON
	--[Students].[DST_NBR] = [SPED].[DST_NBR]
	--AND [Students].[ID_NBR] = [SPED].[ID_NBR]
	--AND [Students].[SCH_YR] = [SPED].[SCH_YR]
	
	-- Get ELL Stats
	--LEFT JOIN
	--APS.ELLStudentsAsOf(@ASOFDATE) AS [ELLSTAT]
	
	--ON
	--[Enrollments].[DST_NBR] = [ELLSTAT].[DST_NBR]
	--AND [Enrollments].[ID_NBR] = [ELLSTAT].[ID_NBR]
	--AND [Enrollments].[SCH_YR] = [ELLSTAT].[SCH_YR]
	--AND [Enrollments].[SCH_NBR] = [ELLSTAT].[SCH_NBR]
	
	--LEFT JOIN
	---- Get last ELL evaluation
	--APS.LCELatestEvaluationAsOf(@ASOFDATE) AS [LCELatest]
	
	--ON
	--[Students].[DST_NBR] = [LCELatest].[DST_NBR]
	--AND [Students].[ID_NBR] = [LCELatest].[ID_NBR]
	
	LEFT OUTER JOIN
	(
	SELECT
		DST_NBR
		,ID_NBR
		,CASE WHEN SUM([Attempted Credits]) != 0 THEN
			SUM([FLAT GPA]*[Attempted Credits])/SUM([Attempted Credits])+SUM([Honors Points]) 
		 ELSE 0
		 END AS [Cumulative Weighted GPA]
		 
		,CASE WHEN SUM([Attempted Credits]) != 0 THEN
			SUM([FLAT GPA]*[Attempted Credits])/SUM([Attempted Credits]) 
		 ELSE 0
		 END AS [Cumulative Flat GPA]
		 
	FROM
		APS.BasicGPA
	WHERE
		--ENR_GRDE IN ('06','07','08')
		ENR_GRDE IN ('08')
		--SCH_YR <= @SCHOOLYEAR
	GROUP BY
		DST_NBR
		,ID_NBR
	) AS [GPA]
	
	ON
	[Students].[DST_NBR]=[GPA].[DST_NBR]
	AND [Students].[ID_NBR]=[GPA].[ID_NBR]
	
	--LEFT OUTER HASH JOIN
	--APS.BasicGPA AS [BasicGPA]
	
	--ON
	--[Enrollments].[DST_NBR]=[BasicGPA].[DST_NBR]
	--AND [Enrollments].[ID_NBR]=[BasicGPA].[ID_NBR]
	
	--LEFT JOIN
	--APS.School AS [School]	
	--ON
	--[Enrollments].[SCH_NBR] = [School].[SCH_NBR]
	
	--INNER JOIN
	--[DBTSIS].[ST013_V] AS [ExclusionsDistrict]
	--ON
	--[Enrollments].[DST_NBR] = [ExclusionsDistrict].[DST_NBR]
	--AND [Enrollments].[ID_NBR] = [ExclusionsDistrict].[ID_NBR]
	
	--INNER JOIN
	--[DBTSIS].[HE010_V] AS [ADA_504]
	--ON
	--[Enrollments].[DST_NBR] = [ADA_504].[DST_NBR]
	--AND [Enrollments].[ID_NBR] = [ADA_504].[ID_NBR]
	
WHERE
	[Students].[DST_NBR] = 1
	-- Only get school year 2012
	--AND [Enrollments].[SCH_YR] = @SCHOOLYEAR
	-- Only get High School students
	--AND [Enrollments].[GRDE] IN ('08','09','10','12')
	--AND [ExclusionsDistrict].[DST_XCLTY] != 'M'
	--AND [ADA_504].[ADA_504] = 'X'
	
	--AND [Enrollments].[ID_NBR] IN ('104093067','100015338','100015619','100037035')
	
--GROUP BY
--	[SPED].[Primary Disability]
--	,[Enrollments].[GRDE]
		
--ORDER BY
	--[GPA].[Cumulative Weighted GPA] DESC
	--[SPED].[Primary Disability]
	
	AND [Students].[ID_NBR] IN
('100109016', 
'100109891', 
'100110196', 
'100110493', 
'100114065', 
'100114826', 
'102757176', 
'102758877', 
'102780368', 
'102835865', 
'102840501', 
'102840741', 
'102841129', 
'102841251', 
'102841269', 
'102841368', 
'102841459', 
'102841475', 
'102841483', 
'102841806', 
'102848330', 
'102867546', 
'102868122', 
'102868551', 
'102874195', 
'102884566', 
'102895620', 
'102913985', 
'102914116', 
'102914611', 
'102915097', 
'102939618', 
'102939766', 
'102939964', 
'102940152', 
'103450458', 
'103563094', 
'103847257', 
'103862751', 
'104130281', 
'104216858', 
'104229117', 
'104494810', 
'970008960', 
'970018632', 
'970023881', 
'970030634', 
'970035491', 
'970036844', 
'970050944', 
'100109651', 
'102800141', 
'100110436', 
'102758083', 
'970019590', 
'102834561', 
'100046911', 
'428951453', 
'970022519', 
'102841152', 
'100089895', 
'102772407', 
'102772423', 
'102895760', 
'102939675', 
'358514248', 
'970035933', 
'102939899', 
'104398128', 
'102914892', 
'102758836', 
'103392429', 
'970037558', 
'102759198', 
'103708145', 
'970046474', 
'100114214', 
'100109453', 
'102912029', 
'102948726', 
'102841319', 
'102914165', 
'102913514', 
'100088855', 
'102840667', 
'102867728', 
'100114420', 
'102786613', 
'103760799', 
'102895802', 
'970018406', 
'102939949', 
'103744389', 
'970051534', 
'102913555', 
'102841111', 
'102883733', 
'102949591', 
'102758349', 
'103608600', 
'102914157', 
'102936887', 
'970053247', 
'970001991', 
'970045595', 
'102983590', 
'102840584', 
'224487686', 
'104458153', 
'970036933', 
'970054062', 
'113851620', 
'102868023', 
'102915014', 
'102913886', 
'100108075', 
'102895182', 
'100037811', 
'102841178', 
'102913027', 
'970034434', 
'104562814', 
'970047735', 
'103411583', 
'102884616', 
'970054912', 
'102913761', 
'103452645', 
'102911732', 
'103563979', 
'104549100', 
'102324621', 
'102820537', 
'102967635', 
'100046184', 
'102912748', 
'102846987', 
'100114024', 
'102913522', 
'102758208', 
'100047067', 
'103469854', 
'104462254', 
'103384954', 
'102939923', 
'238916589', 
'970040160', 
'970046755', 
'100109958', 
'102949856', 
'100120443', 
'104530530', 
'970031418', 
'102895885', 
'100108190', 
'102758125', 
'102915253', 
'101577419', 
'102364866', 
'100045681', 
'970052905', 
'102840964', 
'102939980', 
'102913621', 
'100114396', 
'104297957', 
'102868890', 
'102758000', 
'369412473', 
'102840659', 
'102757846', 
'358149367', 
'102915550', 
'102719549', 
'102850138', 
'103560223', 
'100090216', 
'102564614', 
'102847142', 
'103613022', 
'103005401', 
'102758539', 
'102915113', 
'104537980', 
'102912888', 
'102868445', 
'100014752', 
'100084292', 
'102913175', 
'970053566', 
'342535655', 
'102829348', 
'102895083', 
'344678818', 
'970053567', 
'102841160', 
'970054748', 
'102840543', 
'102916137', 
'100089812', 
'102766805', 
'102845559', 
'102914231', 
'102763117', 
'970037234', 
'102709219', 
'970051414', 
'102914041', 
'102952454', 
'104108956', 
'104008834', 
'970037560', 
'102914991', 
'104206966', 
'104361530', 
'102868973', 
'676624240', 
'102868833', 
'100089655', 
'102792934', 
'102757200', 
'104466362', 
'102868056', 
'103414819', 
'102841137', 
'876446675', 
'102939808', 
'102557725', 
'102839289', 
'100113869', 
'102939782', 
'100089994', 
'970050417', 
'970039786', 
'102841640', 
'102867926', 
'103713558', 
'102891165', 
'103708608', 
'970036162', 
'100089556', 
'100089572', 
'102908779', 
'970036140', 
'102867587', 
'102940194', 
'102840535', 
'102908233', 
'211482369', 
'128595485', 
'100085711', 
'970051387', 
'103467205', 
'102868916', 
'102939915', 
'102841905', 
'102915675', 
'100119700', 
'970032852', 
'970036674', 
'102868106', 
'102840519', 
'100089671', 
'102913357', 
'102948049', 
'970035376', 
'102894201', 
'100109495', 
'102913845', 
'970036866', 
'102510765', 
'102915576', 
'104090758', 
'102804564')
	