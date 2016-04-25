--<APS - One time insert of State Reporting - Event data>
DECLARE @NewID uniqueidentifier
DECLARE @InsertStat INT
DECLARE @ErrorMess varchar(100)
DECLARE @ErrorLine varchar(10)
DECLARE @Step varchar(50)
DECLARE @rolledback varchar(30)
DECLARE @SchYear INT
DECLARE @Student_GU uniqueidentifier

SET @NewID = NEWID()
SET @SchYear = ?                        --00
SET @InsertStat = 0
set @ErrorMess = ''
set @ErrorLine = 0
set @Step = ''
set @rolledback = ''


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
        set @InsertStat = 1
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Get StudentGU'
   set @InsertStat = 0
end catch
if @InsertStat = 1
begin try  --Insert TABLE [Rev].[EPC_NM_STU_SPED_RPT_EVT]
    set @InsertStat = 0
    insert rev.EPC_NM_STU_SPED_RPT_EVT
      (
         STU_SPED_RPT_EVT_GU
       , STUDENT_GU         
       , SCHOOL_YEAR        
       , EVENT_DATE         
       , EVENT_TYPE         
       , LOCKED            
       , ADD_DATE_TIME_STAMP
      )
      select
         NEWID()
       , @Student_GU
       , @SchYear
       , ? -- EVENT_DATE       02
       , ? -- EVENT_TYPE       03
       , 'N' -- LOCKED        
       , GETDATE()           
    if @@ROWCOUNT = 1
    begin
       set @InsertStat = 1
       set @Step = 'Insert EPC_NM_STU_SPED_RPT_EVT block'
    end
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Insert EPC_NM_STU_SPED_RPT_EVT block'
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
   
select Cast(@InsertStat as varchar(5)) c1, @ErrorMess c2, @ErrorLine c3, @Step c4, @rolledback  c5
