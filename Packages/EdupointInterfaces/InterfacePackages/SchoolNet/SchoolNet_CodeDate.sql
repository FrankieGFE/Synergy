--<APS - SchoolNet code_date data>

declare @vSchYr varchar(4)
      , @vFullSchYr varchar(9)
set @vSchYr     = cast((select school_year from rev.SIF_22_Common_CurrentYear) as varchar(4))
set @vFullSchYr = cast((select school_year from rev.SIF_22_Common_CurrentYear) as varchar(4)) + '-' +
                  cast((select school_year+1 from rev.SIF_22_Common_CurrentYear) as varchar(4))
SELECT  distinct
        syd.date_string AS [fulldate]
      , CASE
	      WHEN (scal.HOLIDAY is not null                                     -- date marked as holiday
		        or syd.IsWeekend = 1                                         -- weekend
				or syd.yr_date not between copt.START_DATE and copt.END_DATE -- any date ouside of school cal is marked as a holiday
				) 
          THEN '1'
		  ELSE '0'
	    END  AS [holiday]
      , @vSchYr          AS [school_year_code]
      , @vFullSchYr      AS [school_year_name]
      -- calendar_code Default 
      -- except for Mary Ann Binford, Cochiti, Duranes, Eugene Field, Mark Twain, Navajo, Onate, and Susie Rayos Marmon. 
      -- For these schools it should be A
      , CASE
	        WHEN sch.SCHOOL_CODE IN ('250', '237', '249', '261', '364', '327', '227', '280' ) THEN 'A'
			ELSE 'Default'
	    END  AS [calendar_code]
      -- calendar_name Traditional 
      -- except for Mary Ann Binford, Cochiti, Duranes, Eugene Field, Mark Twain, Navajo, Onate, and Susie Rayos Marmon. 
      -- For these schools it should be Alternative  
      , CASE
	        WHEN sch.SCHOOL_CODE IN ('250', '237', '249', '261', '364', '327', '227', '280' ) THEN 'Alternative'
			ELSE 'Traditional'
	    END AS [calendar_name]
FROM  rev.EPC_SCH                       sch
      JOIN rev.REV_ORGANIZATION_YEAR    oyr  ON oyr.ORGANIZATION_GU = sch.ORGANIZATION_GU
      JOIN rev.REV_YEAR                 yr   ON yr.YEAR_GU          = oyr.YEAR_GU
	                                            AND yr.EXTENSION    = 'R'
      JOIN ##TempYearDates              syd  ON syd.SchoolYear      = yr.SCHOOL_YEAR
	  LEFT JOIN rev.EPC_SCH_ATT_CAL     scal ON scal.SCHOOL_YEAR_GU = oyr.ORGANIZATION_YEAR_GU
	                                            and scal.HOLIDAY is not null
											    and scal.CAL_DATE   = syd.yr_date
      LEFT JOIN rev.EPC_SCH_ATT_CAL_OPT copt ON copt.ORG_YEAR_GU    = oyr.ORGANIZATION_YEAR_GU
WHERE sch.SCHOOL_CODE IN  ('590', '250' ) -- Albuquerque High School, Mary Ann Binford Elementary
ORDER BY fulldate, calendar_code
