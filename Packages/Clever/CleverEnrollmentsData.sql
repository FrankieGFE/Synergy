-- ===================================================================
-- Author     :	mlm - EduPoint                                      --
-- Create date: 12/17/2015                                          --
-- Description:	Clever - Enrollments Data Extract - enrollments.csv --
-- Revision   :                                                     --
-- ===================================================================

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
       --JOIN ##Terms                   trm  ON trm.OrgGU                  = oyr.ORGANIZATION_GU
       --                                       and trm.TermCode           = sect.TERM_CODE
WHERE 
--@RunDate between trm.TermStart and trm.TermEnd
--and
 (cls.LEAVE_DATE is null or cls.LEAVE_DATE > @RunDate)