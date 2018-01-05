/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 10/25/2012 $
*  This is part of a query use on the RDA site for student enrollments
 */
SELECT
  "PR" ."DBTSIS" ."ST010" ."DST_NBR",
  "PR" ."DBTSIS" ."ST010" ."END_ENR_DT",
  "PR" ."DBTSIS" ."ST010" ."FULL_NME",
  "PR" ."DBTSIS" ."ST010" ."GRDE",
  "PR" ."DBTSIS" ."ST010" ."ID_NBR",
  "PR" ."DBTSIS" ."ST010" ."SCH_NBR",
  "PR" ."DBTSIS" ."ST010" ."TITLE_1",
  "PR" ."DBTSIS" ."ST010" ."RES_CNTY",
  "PR" ."DBTSIS" ."ST010" ."SCH_YR" 
FROM
  "PR" ."DBTSIS" ."ST010" WITH (NOLOCK)
WHERE
  (("PR" ."DBTSIS" ."ST010" ."END_ENR_DT" = 0 OR "PR" ."DBTSIS" ."ST010" ."END_ENR_DT" >= 
    (SELECT
      (MAX (DBTOAS."OS010" ."LST_LI_DTE"))
    FROM
      DBTOAS."OS010" WITH (NOLOCK)
    WHERE
      (DBTOAS."OS010" ."DST_NBR" = 1)))AND "PR" ."DBTSIS" ."ST010" ."DST_NBR" = 1 AND "PR" ."DBTSIS" ."ST010" ."SCH_YR" = 
    (SELECT
      DBTSIS."SY075" ."SCH_YR" 
    FROM
      DBTSIS."SY075" WITH (NOLOCK)
    WHERE
      (DBTSIS."SY075" ."DST_NBR" = 1))AND "PR" ."DBTSIS" ."ST010" ."BEG_ENR_DT" <= (CONVERT (VARCHAR (8), GETDATE (), 112))AND "PR" ."DBTSIS" ."ST010" ."NONADA_SCH" <> 'X')
ORDER BY
  5 ASC ,
  2 DESC 