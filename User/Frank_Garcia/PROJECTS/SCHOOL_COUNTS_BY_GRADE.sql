
SELECT 
            --VALUE_DESCRIPTION AS GRADE
			ORG.ORGANIZATION_NAME AS NAME
            , COUNT(*) AS [COUNT]

FROM
APS.PrimaryEnrollmentsAsOf(GETDATE()) AS PE
INNER JOIN
rev.REV_ORGANIZATION_YEAR AS ORGYR
ON
PE.ORGANIZATION_YEAR_GU = ORGYR.ORGANIZATION_YEAR_GU
INNER JOIN
rev.REV_ORGANIZATION AS ORG
ON
ORGYR.ORGANIZATION_GU = ORG.ORGANIZATION_GU
INNER JOIN
APS.LookupTable('K12','Grade') AS LE
ON
PE.GRADE = LE.VALUE_CODE

--WHERE
--ORGANIZATION_NAME LIKE 'ALBUQUER%'

GROUP BY ORG.ORGANIZATION_NAME



 

