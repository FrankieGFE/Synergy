--<APS - SchoolNet code_withdrawl_type data>
declare @vSchYr varchar(4)
set @vSchYr = cast((select school_year from rev.SIF_22_Common_CurrentYear) as varchar(4))

SELECT
        @vSchYr + '-' + SUBSTRING(wcd.VALUE_DESCRIPTION,1,2) AS [withdrawal_type_code]
      , wcd.VALUE_DESCRIPTION                                AS [withdrawal_type_name]
FROM  (select 
             lv.VALUE_DESCRIPTION
       from  rev.REV_BOD_LOOKUP_VALUES lv 
       where LOOKUP_DEF_GU in
             (select LOOKUP_DEF_GU 
	          from   rev.REV_BOD_LOOKUP_DEF
              where  LOOKUP_NAMESPACE = 'K12.Enrollment' and LOOKUP_DEF_CODE = 'LEAVE_CODE')
                     and lv.Year_end is null) wcd