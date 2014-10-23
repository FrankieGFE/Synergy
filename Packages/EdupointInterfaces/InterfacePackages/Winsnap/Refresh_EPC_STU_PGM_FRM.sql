-- APS FRM Import
-- Truncates the FRM table 
-- inserts the recent history enter date row in epc_stu_pgm_frm
--
truncate table rev.epc_stu_pgm_frm
insert rev.EPC_STU_PGM_FRM
(
        STUDENT_GU
      , FRM_CODE
      , ENTER_DATE
      , EXIT_DATE
      , ADD_DATE_TIME_STAMP
)
select 
    h.student_gu
  , t.FRM_CODE
  , t.ENTER_DATE
  , t.EXIT_DATE
  , getdate()
  from rev.EPC_STU_PGM_FRM_HIS h
  join (
        select
          ROW_NUMBER() over (partition by student_gu order by enter_date desc) rn
		, his.STU_PGM_FRM_HIS_GU
		, his.STUDENT_GU
		, his.FRM_CODE
		, his.ENTER_DATE
		, his.EXIT_DATE
        from rev.epc_stu_pgm_frm_his his
       ) t on  t.rn = 1 and t.STU_PGM_FRM_HIS_GU = h.STU_PGM_FRM_HIS_GU