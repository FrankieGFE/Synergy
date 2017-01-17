USE ST_Production
GO




/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 12/02/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * DUAL CREDIT (DUAL)
 * 
	
****/
SELECT  
        [school_code] AS LOCATION_CODE
	   , SCHOOL_NAME
	   , LAST_NAME AS LAST_NAME
	   , FIRST_NAME AS FIRST_NAME
       , [student_code] AS SIS_NUMBER
	   , GRADE
	   , RESOLVED_RACE
	   , HISPANIC_INDICATOR
	   , SPED_STATUS
	   , ELL_STATUS
	   , LUNCH_STATUS
	   , GENDER
       , [school_year] AS SCHOOL_YEAR
	   , COURSE_TITLE
	   , COURSE_ID
	   --, SOR
	   , DEPARTMENT
	   , LEAVE_DATE
FROM
(
SELECT  row_number() over(partition by stu.SIS_NUMBER order by crs.course_id desc) rn
       , stu.SIS_NUMBER                           AS [student_code]
       , PED.SCHOOL_YEAR                           AS [school_year]
	   , PED.SCHOOL_CODE as school_CODE
	   , PED.SCHOOL_NAME
	   , PED.GRADE
       , CONVERT(VARCHAR(10),cls.ENTER_DATE,120)  AS [date_enrolled]
       , CONVERT(VARCHAR(10),cls.LEAVE_DATE,120)  AS [date_withdrawn]
	   , CONVERT(VARCHAR(10), NULL, 120)		  AS [date_iep]
	   , CONVERT(VARCHAR(10), NULL, 120)		  AS [date_iep_end]
	   ,PED.ENTER_DATE
	   ,PED.LEAVE_DATE
	   , crs.COURSE_TITLE
	   , crs.COURSE_ID
	   , crs.DEPARTMENT
	   , per.last_name
	   , per.first_name
	   , mor.HISPANIC_INDICATOR
	   , mor.ELL_STATUS
	   , mor.SPED_STATUS
	   , mor.LUNCH_STATUS
	   , mor.GENDER
	   , mor.RESOLVED_RACE
FROM   APS.PrimaryEnrollmentDetailsAsOf (GETDATE()) AS PED
		JOIN
		rev.EPC_STU                             stu
		ON STU.STUDENT_GU = PED.STUDENT_GU
       --JOIN rev.EPC_STU_SCH_YR                 ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
       --JOIN rev.REV_ORGANIZATION_YEAR          oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
       --                                                and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       --JOIN rev.REV_YEAR                       yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
	   --JOIN rev.EPC_SCH                        sch  ON sch.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS                  cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = PED.STUDENT_SCHOOL_YEAR_GU
	   JOIN rev.EPC_SCH_YR_SECT                sect ON sect.SECTION_GU                   = cls.SECTION_GU
	   JOIN rev.EPC_SCH_YR_CRS                 ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.EPC_CRS                        crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
	   JOIN REV.REV_PERSON                     per  ON per.PERSON_GU = stu.STUDENT_GU
	   JOIN APS.BasicStudentWithMoreInfo       mor  ON mor.STUDENT_GU = STU.STUDENT_GU

			 --  LEFT JOIN
		--	(
		--	SELECT	
		--		sch.SCHOOL_CODE AS SOR
		--		,stu.STUDENT_GU
		--	FROM   rev.EPC_STU                    stu
		--	   JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
		--	   join rev.EPC_STU_YR AS SOR		   ON SOR.STU_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU  
		--	   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
		--											  and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
		--	   JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU          = oyr.YEAR_GU
		--	   JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		--	   JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
		--	WHERE  ssy.ENTER_DATE is not null
		--	) AS SOR
		--ON stu.STUDENT_GU = SOR.STUDENT_GU

				
WHERE 1 = 1
AND COURSE_ID IN
	(
		'610401',
		'610402',
		'610411',
		'610412',
		'610421',
		'610422',
		'610431',
		'610432',
		'700301',
		'700302',
		'70030de1',
		'70030de2',
		'70031de1',
		'70031de2',
		'700401',
		'700402',
		'705111',
		'705112',
		'70511de1',
		'70511de2',
		'705121',
		'705122',
		'705131',
		'705132',
		'705141',
		'705142',
		'705201',
		'705202',
		'705301',
		'705302',
		'705321',
		'705322',
		'705341',
		'705342',
		'70538de1',
		'70538de2',
		'70901',
		'70901de',
		'70902',
		'70902de',
		'70903de',
		'70906',
		'7090y',
		'709b1',
		'709b2',
		'710101',
		'710102',
		'710121',
		'710122',
		'710141',
		'710142',
		'710161',
		'710162',
		'710301',
		'710302',
		'710311',
		'710312',
		'710361',
		'710362',
		'710421',
		'710422',
		'71042de1',
		'71042de2',
		'710441',
		'710442',
		'715101',
		'715102',
		'71520de',
		'715301',
		'715302',
		'715321',
		'715322',
		'715341',
		'715342',
		'715361',
		'715362',
		'715501',
		'715502',
		'715511',
		'715512',
		'715601',
		'715602',
		'715611',
		'715612',
		'715701',
		'715702',
		'71570de1',
		'71570de2',
		'715721',
		'715722',
		'715741',
		'715742',
		'715761',
		'715762',
		'715771',
		'715772',
		'715781',
		'715782',
		'71578de1',
		'71578de2',
		'715791',
		'715792',
		'715811',
		'715812',
		'715821',
		'715822',
		'715831',
		'715832',
		'715841',
		'715842',
		'720531',
		'720532',
		'720601',
		'720602',
		'720701',
		'720702',
		'72070de1',
		'72070de2',
		'720711',
		'720712',
		'720721',
		'720722',
		'7211i1',
		'7211i2',
		'7212i1',
		'7212i2',
		'7213i1',
		'7213i2',
		'7214i1',
		'7214i2',
		'725321',
		'725322',
		'72532de1',
		'72532de2',
		'725331',
		'725332',
		'725341',
		'725342',
		'725351',
		'725352',
		'725361',
		'725362',
		'7253i1',
		'7253i2',
		'7254i1',
		'7254i2',
		'7255i1',
		'7255i2',
		'7256i1',
		'7256i2',
		'72600',
		'72602',
		'72603',
		'72603de',
		'72604de',
		'72605de',
		'72700',
		'72901',
		'72903',
		'72904',
		'7290y',
		'73004',
		'73005',
		'73006',
		'73007',
		'73008',
		'73009',
		'730371',
		'730372',
		'7303a1',
		'7303a2',
		'7303b1',
		'7303b2',
		'7303c1',
		'7303c2',
		'7303f1',
		'7303f2',
		'7303g1',
		'7303g2',
		'7303h1',
		'7303h2',
		'7303j1',
		'7303j2',
		'7303p1',
		'7303p2',
		'7303q1',
		'7303q2',
		'7303r1',
		'7303r2',
		'730411',
		'730412',
		'730431',
		'730432',
		'7304a1',
		'7304a2',
		'7304b1',
		'7304b2',
		'7304c1',
		'7304c2',
		'7304e1',
		'7304e2',
		'7304f1',
		'7304f2',
		'7304g1',
		'7304g2',
		'7304h1',
		'7304h2',
		'7304k1',
		'7304k2',
		'7304l1',
		'7304l2',
		'7304m1',
		'7304m2',
		'7304n1',
		'7304n2',
		'73504',
		'73505',
		'73506',
		'735211',
		'735212',
		'735221',
		'735222',
		'735231',
		'735232',
		'735241',
		'735242',
		'735441',
		'735442',
		'735451',
		'735452',
		'7354a1',
		'7354a2',
		'7354b1',
		'7354b2',
		'7354c1',
		'7354c2',
		'7354g1',
		'7354g2',
		'7354h1',
		'7354h2',
		'7354j1',
		'7354j2',
		'735a1',
		'735a2',
		'735a3',
		'74004',
		'74005',
		'74006',
		'740481',
		'740482',
		'740491',
		'740492',
		'7404a1',
		'7404a2',
		'7404b1',
		'7404b2',
		'7404c1',
		'7404c2',
		'740501',
		'740502',
		'740511',
		'740512',
		'7405a1',
		'7405a2',
		'7405b1',
		'7405b2',
		'7405c1',
		'7405c2',
		'7405d1',
		'7405d2',
		'7405e1',
		'7405e2',
		'7405h1',
		'7405h2',
		'7405j1',
		'7405j2',
		'7405k1',
		'7405k2',
		'7405l1',
		'7405l2',
		'74904',
		'74905',
		'75000',
		'75001',
		'75002',
		'75003',
		'75004',
		'750151',
		'750152',
		'750161',
		'750162',
		'750171',
		'750172',
		'750181',
		'750182',
		'750191',
		'750192',
		'750201',
		'750202',
		'750251',
		'750252',
		'750261',
		'750262',
		'750271',
		'750272',
		'750301',
		'750302',
		'755541',
		'755542',
		'755551',
		'755552',
		'755561',
		'755562',
		'755571',
		'755572',
		'755581',
		'755582',
		'755591',
		'755592',
		'755601',
		'755602',
		'755611',
		'755612',
		'755621',
		'755622',
		'75562de1',
		'755631',
		'755632',
		'755641',
		'755642',
		'755651',
		'755652'
	)

) AS DC
WHERE 1 = 1
AND date_withdrawn IS NULL
--AND student_code = '100047463'
--and COURSE_ID = '7304e1'
--and COURSE_TITLE = 'SYMP BAND I'
ORDER BY COURSE_ID