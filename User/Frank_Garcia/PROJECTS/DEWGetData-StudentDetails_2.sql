    SELECT    
			  Enrollments.ID_NBR,
			  Enrollments.BEG_ENR_DT,           --- Get enrollment data from ST010... --->
              Enrollments.DROP_IND,
              Enrollments.END_ENR_DT,
              Enrollments.END_STAT,
              Enrollments.GRDE,
              Enrollments.MNT_DT,
              Enrollments.MNT_INIT,
              Enrollments.NONADA_SCH,
              Enrollments.SCH_NBR,
              Enrollments.SCH_YR,

              Schools.SCH_NME_27,               -- ...and school names from SY010... --->

              EndStatusDescriptions.STAT_DESCR  --- ...and end enrollment status code description lookup from ST080... --->


    FROM      PR.DBTSIS.ST010_V
    AS        Enrollments


    LEFT OUTER JOIN   PR.DBTSIS.SY010_V        --- Join to Schools table (SY010) to get school name. --->
    AS                Schools
    ON                ((Enrollments.SCH_NBR = Schools.SCH_NBR) AND      --- join on school number and... --->
                       (Enrollments.DST_NBR = Schools.DST_NBR))         --- ...district number --->

    LEFT OUTER JOIN   PR.DBTSIS.ST080_V    --- Join to End Enrollment code lookup table (ST010) to get END-STAT descriptions --->
    AS                EndStatusDescriptions
    ON                ((Enrollments.END_STAT = EndStatusDescriptions.END_STAT) AND    --- join on end enrollment status value and... --->
                       (Enrollments.SCH_YR = EndStatusDescriptions.SCH_YR) AND        --- ...school year and... --->
                       (Enrollments.DST_NBR = EndStatusDescriptions.DST_NBR))         --- ...district number --->


    WHERE     (Enrollments.DST_NBR = 1) --AND                                          --- Get records for district 1... --->
               --(Enrollments.ID_NBR = <CFQUERYPARAM  VALUE="#Session.CurrentStudentID#"  --- ...and the current student --->
               --                                           CFSQLTYPE="CF_SQL_DECIMAL"
               --                                           MAXLENGTH="9">)
             


    ORDER BY  Enrollments.SCH_YR DESC,
              Enrollments.BEG_ENR_DT DESC,
              Enrollments.END_ENR_DT ASC    --- end date sorted ASCENDING so active enrollment comes first in reverse school year order --->
