/*
	Created by Debbie Ann Chavez (ORIGINAL CODE FROM MLM/EDUPOINT)
	Date 7/18/2016
*/


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[CleverEnrollments]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].CleverEnrollmentsAS SELECT 0')
GO

ALTER PROC [APS].[CleverEnrollments]

AS
BEGIN

declare @RunDate smalldatetime
set @RunDate =  (select  case
                          when   
                             (select min(cal.start_date) 
                              from rev.EPC_SCH_ATT_CAL_OPT   cal
                              join rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_YEAR_GU = cal.ORG_YEAR_GU
                                                                    and oyr.YEAR_GU          = (select year_gu from rev.SIF_22_Common_CurrentYearGU)
                             ) > convert(smalldatetime, convert(varchar(8), getdate(),112))
                          then   
                             (select min(cal.start_date) 
                              from rev.EPC_SCH_ATT_CAL_OPT   cal
                              join rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_YEAR_GU = cal.ORG_YEAR_GU
                                                                    and oyr.YEAR_GU          = (select year_gu from rev.SIF_22_Common_CurrentYearGU)
                             )
                          else
                            (convert(varchar(8), getdate(),112))
                          end
                )


SELECT
        sch.SCHOOL_CODE                      AS [School_id]
      , sch.SCHOOL_CODE+'_'+sect.SECTION_ID  AS [Section_id]
      , stu.SIS_NUMBER                       AS [Student_id]

FROM   rev.EPC_STU                    stu
       JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU            = stu.STUDENT_GU
                                              AND ssyr.STATUS IS NULL
       JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU   = ssyr.ORGANIZATION_YEAR_GU
                                              AND oyr.YEAR_GU            = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS         cls  ON cls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT       sect ON sect.SECTION_GU            = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS        scrs ON scrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
        JOIN
	   (select 
       t.OrgGU
     , t.SchoolYear
	 , t.TermCode
	 , TermBegin
	 , TermEnd
from rev.SIF_22_TermInfo() t 
     join rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_GU = t.OrgGU
	                                       and oyr.YEAR_GU     = (select year_gu from rev.SIF_22_Common_CurrentYearGU)) AS trm
	   ON trm.OrgGU                  = oyr.ORGANIZATION_GU
                                              and trm.TermCode           = sect.TERM_CODE
WHERE 
 '2016-08-11' between trm.TermBegin and trm.TermEnd
and
 (cls.LEAVE_DATE is null or cls.LEAVE_DATE > '2016-08-11')

END --END STORED PROCEDURE
GO