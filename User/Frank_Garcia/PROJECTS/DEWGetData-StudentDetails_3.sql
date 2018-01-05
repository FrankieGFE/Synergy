    SELECT    
			  FamilyMembers.ID_NBR,
			  TranscriptHeaders.CERT_DATE,                            --- Get transcript header data from TN010... --->
              TranscriptHeaders.DIP_TYPE,
              TranscriptHeaders.GRAD_DT,
              TranscriptHeaders.GRAD_ST AS GradStatusCode,
              TranscriptHeaders.GRAD_TYP AS GradTypeCode,
              TranscriptHeaders.GSTD_YR AS GradStndYr_TN,
              TranscriptHeaders.MNT_DT,
              TranscriptHeaders.MNT_INIT,
              TranscriptHeaders.PS_GRAD_ST AS PSGradStatusCode,
              TranscriptHeaders.PS_PLANS AS PSPlansCode,

              FamilyMembers.GSTD_YR AS GradStndYr_CE,                       --- ...and graduation standard year from Family Member record in CE020... --->

              TranscriptCodesGradStat.CODE_DESCR AS GradStatusDescr,        --- ...and graduation status description from TN082... --->

              TranscriptCodesGradType.CODE_DESCR AS GradTypeDescr,          --- ...and graduation type description from TN082 --->

              TranscriptCodesPSGradStatus.CODE_DESCR AS PSGradStatusDescr,  --- ...and post-secondary graduation status description from TN082 --->

              TranscriptCodesPSGradPlans.CODE_DESCR AS PSPlansDescr         --- ...and post-secondary grad status description from TN082 --->


    FROM      PR.DBTSIS.TN010_V
    AS        TranscriptHeaders


    LEFT OUTER JOIN   PR.DBTSIS.CE020_V                  --- Join to Family Members table (CE020) to get graduation standard year --->
    AS                FamilyMembers
    ON                ((TranscriptHeaders.ID_NBR = FamilyMembers.ID_NBR) AND                  --- join on student ID and... --->
                       (TranscriptHeaders.DST_NBR = FamilyMembers.DST_NBR))                   --- ...district number --->

    LEFT OUTER JOIN   PR.DBTSIS.TN082_V                --- Join to Transcript codes table (TN082) to get graduation status description --->
    AS                TranscriptCodesGradStat
    ON                ((TranscriptHeaders.GRAD_ST = TranscriptCodesGradStat.CODE_NME) AND     --- join on graduation status code and... --->
                       (TranscriptCodesGradStat.CODE_TYPE = 'GRDST') AND                      --- ...graduation status code records only and... --->
                       (TranscriptHeaders.DST_NBR = TranscriptCodesGradStat.DST_NBR))         --- ...district number --->

    LEFT OUTER JOIN   PR.DBTSIS.TN082_V                --- Join to Transcript codes table (TN082) to get graduation type description --->
    AS                TranscriptCodesGradType
    ON                ((TranscriptHeaders.GRAD_TYP = TranscriptCodesGradType.CODE_NME) AND    --- join on graduation status code and... --->
                       (TranscriptCodesGradType.CODE_TYPE = 'GRDTY') AND                      --- ...graduation type code records only and... --->
                       (TranscriptHeaders.DST_NBR = TranscriptCodesGradType.DST_NBR))         --- ...district number --->

    LEFT OUTER JOIN   PR.DBTSIS.TN082_V                --- Join to Transcript codes table (TN082) to get post-secondary grad status description --->
    AS                TranscriptCodesPSGradStatus
    ON                ((TranscriptHeaders.PS_GRAD_ST = TranscriptCodesPSGradStatus.CODE_NME) AND --- join on graduation status code and... --->
                       (TranscriptCodesPSGradStatus.CODE_TYPE = 'PSGST') AND                  --- ...post-secondary grad status code records only and... --->
                       (TranscriptHeaders.DST_NBR = TranscriptCodesPSGradStatus.DST_NBR))     --- ...district number --->

    LEFT OUTER JOIN   PR.DBTSIS.TN082_V                --- Join to Transcript codes table (TN082) to get post-secondary plans description --->
    AS                TranscriptCodesPSGradPlans
    ON                ((TranscriptHeaders.PS_PLANS = TranscriptCodesPSGradPlans.CODE_NME) AND --- join on post-secondary plans code and... --->
                       (TranscriptCodesPSGradPlans.CODE_TYPE = 'PSPLS') AND                   --- ...post-secondary plans code records only and... --->
                       (TranscriptHeaders.DST_NBR = TranscriptCodesPSGradPlans.DST_NBR))      --- ...district number --->

 
    --WHERE     ((TranscriptHeaders.DST_NBR = 1) AND                                          --- Get records for district 1... --->
    --           (TranscriptHeaders.ID_NBR = <CFQUERYPARAM  VALUE="#Session.CurrentStudentID#"--- ...and the current student --->
    --                                                      CFSQLTYPE="CF_SQL_DECIMAL"
    --                                                      MAXLENGTH="9">)
    --          )

