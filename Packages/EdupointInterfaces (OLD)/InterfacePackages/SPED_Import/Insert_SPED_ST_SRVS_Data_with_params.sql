--<APS - One time insert of State Reporting Services data>
DECLARE @NewID uniqueidentifier
DECLARE @InsertStat INT
DECLARE @ErrorMess varchar(100)
DECLARE @ErrorLine varchar(10)
DECLARE @Step varchar(50)
DECLARE @rolledback varchar(30)
DECLARE @SchYear INT
DECLARE @Student_GU uniqueidentifier
DECLARE @RptExists INT
DECLARE @SpedRptGU uniqueidentifier
DECLARE @SrvRowExists INT
DECLARE @StaffNotFound varchar(50)

SET @NewID = NEWID()
SET @SchYear = ?                        --00
SET @InsertStat = 0
set @ErrorMess = ''
set @ErrorLine = 0
set @Step = ''
set @rolledback = ''
set @RptExists = 0
set @SrvRowExists = 0
set @StaffNotFound = ''

begin transaction
begin try -- get student_gu
   set @Student_GU = 
     (select top 1 stu.student_gu
      from rev.EPC_STU stu
      join rev.EPC_STU_SCH_YR ssy on ssy.STUDENT_GU = stu.STUDENT_GU and ssy.EXCLUDE_ADA_ADM is null 
      --join rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
      --join rev.REV_YEAR yr on yr.YEAR_GU = oyr.YEAR_GU and yr.SCHOOL_YEAR = @SchYear
      where stu.SIS_NUMBER = ? --01
     )
     if @@ROWCOUNT = 1 and @Student_GU is not null
     begin
        set @InsertStat = 1
     end 
     else
     begin
        set @InsertStat = 0
     end 
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Get StudentGU'
   set @InsertStat = 0
end catch
-- check if rpt row exists
begin try
   set @RptExists = 0
   set @SpedRptGU = (
   select rpt.STU_SPED_RPT_GU
   from rev.EPC_NM_STU_SPED_RPT rpt
   where rpt.STUDENT_GU = @Student_GU
   and rpt.SCHOOL_YEAR = @SchYear
   and rpt.SNAPSHOT_TYPE = '1' 
   )
   if @@ROWCOUNT = 1 and @SpedRptGU is not null
    begin
     set @RptExists = 1
     set @InsertStat = 1 
    end
   else
    begin
     set @RptExists = 0
     set @InsertStat = 0 
    end 
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Check if RPT row exists'
   set @InsertStat = 0
   set @RptExists = 0
end catch

if @InsertStat = 1
begin try --Insert TABLE [Rev].[EPC_NM_STU_SPED_RPT_SRV]
    set @InsertStat = 0
    insert rev.EPC_NM_STU_SPED_RPT_SRV
      (
          STU_SPED_RPT_SRV_GU
        , STU_SPED_RPT_GU 
        , SERVICE_CODE     
        , INTEGRATED_STATUS
        , SERVICE_SIZE   
        , SERVICE_FREQ       
        , SERVICE_CYCLE      
        , PROVIDER_NAME      
        , ADD_DATE_TIME_STAMP
		, PROVIDER_GU
		, PROVIDER_RES_FACILITY
      )
      select
          NEWID()
        , @SpedRptGU
        , ? --SERVICE_CODE      02
        , ? --INTEGRATED_STATUS 03
        , ? --SERVICE_SIZE      04
        , ? --SERVICE_FREQ      05
        , ? --SERVICE_CYCLE     06
        , CASE 
            WHEN (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL and ? != 'RF' THEN ? --PROVIDER_NAME   07, service code 08, provider_name, 09
          END 
        , GETDATE()
        , CASE 
            WHEN (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL THEN NULL --PROVIDER_GU --10
            ELSE (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?)                   --PROVIDER_GU --11
         END
		, CASE 
            WHEN (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL and ? = 'RF' THEN ? --badge_num 12, service code 13, badge_num 14
          END    
    if @@ROWCOUNT = 1
    begin
       set @InsertStat = 1
       set @Step = 'Insert EPC_NM_STU_SPED_RPT_SRV'
	   IF (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL --PROVIDER_NAME   15
	      set @StaffNotFound =  '['+?+']' + ' - Not found in Staff table'              --PROVIDER_NAME   16
	   ELSE 
	      set @StaffNotFound = ''   
    end
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Insert EPC_NM_STU_SPED_RPT_SRV block'
   set @InsertStat = 0
end catch


--------------------------
if @InsertStat = 1
   begin
   commit tran
   set @rolledback = 'Commit'
   end
else
   begin
   rollback tran
   set @rolledback = 'Rolled back - No commit'
   end
   
select Cast(@InsertStat as varchar(5)) c1, @ErrorMess c2, @ErrorLine c3, @Step c4, @rolledback  c5, Cast(@RptExists as varchar(5)) c6, Cast(@SrvRowExists as varchar(5)) c7, @StaffNotFound c8
