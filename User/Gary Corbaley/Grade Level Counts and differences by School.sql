



SELECT
       SynergyNumbers.SCHOOL_CODE
       ,SynergyNumbers.GradeLevel
       ,SynergyNumbers.TheCount AS SynergyCount
       ,SchoolMaxNumbers.TheCount AS SchoolMaxCount
       ,SynergyNumbers.TheCount - SchoolMaxNumbers.TheCount AS Diff
FROM
       OPENQUERY([SYNERGYDBDC.APS.EDU.ACTD],'
       SELECT
              School.SCHOOL_CODE
              ,GradeLevel.VALUE_DESCRIPTION AS GradeLevel
              ,COUNT(*) AS TheCount
       FROM
              [ST_Production].APS.PrimaryEnrollmentsAsOf(''10/1/2013'') AS Enroll
              INNER JOIN
              [ST_Production].rev.REV_ORGANIZATION_YEAR AS OrgYear
              ON
              Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

              INNER JOIN 
              [ST_Production].REV.EPC_SCH AS School
              ON
              OrgYear.ORGANIZATION_GU = School.ORGANIZATION_GU

              LEFT JOIN
              [ST_Production].APS.LookupTable(''K12'',''Grade'') AS GradeLevel
              ON
              Enroll.GRADE = GradeLevel.VALUE_CODE
       GROUP BY
              School.SCHOOL_CODE
              ,GradeLevel.VALUE_DESCRIPTION
       ') AS SynergyNumbers

       LEFT HASH JOIN
       (
              SELECT
                     SCH_NBR
                     ,GRDE
                     ,COUNT(*) AS TheCount
              FROM
                     APS.PrimaryEnrollmentsAsOf('10/1/2013')
              WHERE
                     DST_NBR = 1
              GROUP BY
                     SCH_NBR
                     ,GRDE  
       ) AS SchoolMaxNumbers

       ON
       SynergyNumbers.SCHOOL_CODE = SchoolMaxNumbers.SCH_NBR COLLATE DATABASE_DEFAULT
       AND SynergyNumbers.GradeLevel = SchoolMaxNumbers.GRDE COLLATE DATABASE_DEFAULT
