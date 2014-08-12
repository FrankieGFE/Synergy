/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/11/2014 $
 *
 * Request By: Andy
 * InitialRequestDate: 7/17/2014
 * 
 * This script will get a count of students currently enrolled in each School.
 * One Record Per School
 */
 
 DECLARE @STARS80DAY TABLE
	(
		[SCHOOL_NUMBER]			VARCHAR(3)
		,[ENROLLMENT_COUNTS]	VARCHAR(10)
	)
		
INSERT INTO @STARS80DAY
VALUES		
(35,	10)
,(48,	55)
,(203,	617)
,(204, 158)
,(206,	606)
,(207,	258)
,(210,	651)
,(213,	368)
,(214,	427)
,(215,	453)
,(216,	381)
,(217,	544)
,(219,	504)
,(221,	445)
,(222,	579)
,(225,	544)
,(227,	222)
,(228,	418)
,(229,	332)
,(230,	528)
,(231,	489)
,(234,	897)
,(236,	606)
,(237,	289)
,(240,	369)
,(241,	417)
,(243,	295)
,(244,	413)
,(249,	299)
,(250,	904)
,(252,	597)
,(255,	516)
,(258,	473)
,(260,	747)
,(261,	319)
,(262,	649)
,(264,	731)
,(265,	808)
,(267,	370)
,(268,	629)
,(270,	499)
,(273,	588)
,(275,	1095)
,(276,	451)
,(279,	351)
,(280,	864)
,(282,	223)
,(285,	701)
,(288,	704)
,(291,	292)
,(295,	521)
,(297,	275)
,(300,	358)
,(303,	236)
,(305,	345)
,(307,	395)
,(309,	401)
,(310,	407)
,(312,	523)
,(315,	474)
,(317,	664)
,(321,	355)
,(324,	371)
,(327,	690)
,(328,	597)
,(329,	438)
,(330,	312)
,(332,	441)
,(333,	549)
,(336,	344)
,(339,	774)
,(345,	268)
,(348,	451)
,(350,	535)
,(351,	440)
,(356,	791)
,(357,	395)
,(360,	585)
,(363,	399)
,(364,	387)
,(365,	564)
,(370,	575)
,(373,	294)
,(376,	539)
,(379,	454)
,(385,	434)
,(388,	432)
,(389,	757)
,(392,	870)
,(393,	587)
,(395,	800)
,(405,	685)
,(407,	653)
,(410,	330)
,(413,	617)
,(415,	896)
,(416,	388)
,(418,	676)
,(420,	576)
,(425,	853)
,(427,	486)
,(430,	1030)
,(435,	705)
,(440,	540)
,(445,	1235)
,(448,	414)
,(450,	634)
,(452,	334)
,(455,	511)
,(457,	500)
,(460,	547)
,(465,	487)
,(470,	508)
,(475,	1395)
,(480,	894)
,(485,	872)
,(490,	977)
,(492,	1006)
,(514,	1185)
,(515,	1830)
,(516,	307)
,(517,	32)
,(520,	1508)
,(525,	1848)
,(530,	1729)
,(540,	1523)
,(549,	155)
,(550,	1851)
,(560,	1242)
,(570,	1460)
,(575,	2180)
,(576,	2336)
,(580,	1845)
,(590,	1668)
,(591,	72)
,(593,	201)
,(596,	158)
,(597,	127)
,(611,	17)
,(840,	25)
,(900,	245)
,(901,	6)
,(973,	14)
,(983,	47)

SELECT
	[SYNERGY_COUNTS].[SCHOOL_CODE] AS [School Code]
	,[SYNERGY_COUNTS].[School] AS [School Name]
	,[SYNERGY_COUNTS].[ENROLL_COUNT] AS [Daily Synergy Count]
	,[STARS80DAY].[ENROLLMENT_COUNTS] AS [STARS 80 Day Count 12/15/2013]
FROM	
	(
	SELECT
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [School]
		--,[Grades].[ALT_CODE_1] AS [Grade]
		,COUNT ([EnrollmentsAsOf].[ENROLLMENT_GU]) AS [ENROLL_COUNT]
	FROM
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [EnrollmentsAsOf]
		
		INNER JOIN 
		rev.EPC_STU_ENROLL AS [EnrollmentDetails] -- Contains Grade and Start Date
		ON 
		[EnrollmentsAsOf].[ENROLLMENT_GU] = [EnrollmentDetails].[ENROLLMENT_GU]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear] -- Contains Grade and Start Date 	
		ON
		[EnrollmentDetails].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]		
	
	GROUP BY
		[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME]
		--,[Grades].[ALT_CODE_1]
	) AS [SYNERGY_COUNTS]
	
	LEFT OUTER JOIN
	@STARS80DAY AS [STARS80DAY]
	ON 
	[SYNERGY_COUNTS].[SCHOOL_CODE] = [STARS80DAY].[SCHOOL_NUMBER]
		
--ORDER BY
--	[School].[SCHOOL_CODE]