--<APS - One time insert of State Reporting data>
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
		set @Step = 'Get StudentGU - Not Found in yr ' + cast(@SchYear as varchar(4))
     end 
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Get StudentGU - catch block'
   set @InsertStat = 0
end catch

if @InsertStat = 1
begin try --Insert TABLE [Rev].[EPC_NM_STU_SPED_RPT]
   set @InsertStat = 0
   insert rev.EPC_NM_STU_SPED_RPT
      (
         STU_SPED_RPT_GU      
       , STUDENT_GU           
       , SCHOOL_YEAR          
       , SNAPSHOT_TYPE        
       , INCLUDE_IN_SNAPSHOT  
       , SPED_GIFTED_TYPE     
       , ENROLLED_AT_START    
       , QUAL_MENTAL_HEALTH   
       , QUAL_VOC_REHAB       
       , QUAL_DEV_DISABLED    
       , QUAL_IND_LIVING      
       , QUAL_POST_SEC        
       , LOCKED               
       , ESY                  
       , LAST_IEP_DATE        
       , LAST_EVAL_DATE       
       , CASE_MANAGER_GU      
       , DIPLOMA_TYPE         
       , PRIMARY_CAUSE        
       , PRIMARY_SETTING      
       , IEP_TRANSITION_STATUS
       , PLACEMENT
       , ADD_DATE_TIME_STAMP
       , LEVEL_INTEGRATION 
       , PROJ_GRAD_EXIT_DATE
       , TRANSITION_SERVICES
	   , DISABILITY_PRIMARY
	   , DISABILITY_SECONDARY
	   , DISABILITY_TERTIARY
	   , DISABILITY_QUATERNARY
	   , CASE_MANAGER_NAME
      )
       select
         @NewID
       , @Student_GU
       , @SchYear
       , '1' --SnapshotType
       , 'Y'
       , ? --SPED_GIFTED_TYPE 02
       ,'N'
       ,'N'
       ,'N'
       ,'N'
       ,'N'
       ,'N'
       ,'N'
       , ? --ESY 03
       , (CASE WHEN ? =  'null' THEN NULL ELSE ? END) --LAST_IEP_DATE 04, 05
       , (CASE WHEN ? =  'null' THEN NULL ELSE ? END) --LAST_EVAL_DATE 06, 07
       , CASE 
            WHEN (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL THEN NULL --08
            ELSE (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?)                   --09
         END  --CASE_MANAGER_GU ************
       , ? --DIPLOMA_TYPE 10
       , ? --PRIMARY_CAUSE 11
       , ? --PRIMARY_SETTING 12
       , ? --IEP_TRANSITION_STATU 13
       , ? --PLACEMENT 14
       , GETDATE()
       , ? --LEVEL_INTEGRATION 15
       , (CASE WHEN ? =  'null' THEN NULL ELSE ? END) --PROJ_GRAD_EXIT_DATE 16, 17
	   , ? --TRANSITION_SERVICES 18
	     -- DISABILITY_PRIMARY
	   , (select COALESCE(PRIMARY_DISABILITY_CODE, PS_PRIMARY_DISABILITY_CODE)
          from rev.EP_STUDENT_SPECIAL_ED sstu
          join rev.EPC_STU stu on stu.STUDENT_GU = sstu.STUDENT_GU
          where stu.SIS_NUMBER = ? -- 19 SIS_number
	     )
		 -- DISABILITY_SECONDARY                                 
	   , (select COALESCE(SECONDARY_DISABILITY_CODE, PS_SECONDARY_DISABILITY_CODE)
          from rev.EP_STUDENT_SPECIAL_ED sstu
          join rev.EPC_STU stu on stu.STUDENT_GU = sstu.STUDENT_GU
          where stu.SIS_NUMBER = ? -- 20 SIS_number
	     )
	      --DISABILITY_TERTIARY 
	   , (select COALESCE(TERTIARY_DISABILITY_CODE, PS_TERTIARY_DISABILITY_CODE)
          from rev.EP_STUDENT_SPECIAL_ED sstu
          join rev.EPC_STU stu on stu.STUDENT_GU = sstu.STUDENT_GU
          where stu.SIS_NUMBER = ? -- 21 SIS_number
	     )
	     --DISABILITY_QUATERNARY
	   , (select COALESCE(QUATERNARY_DISABILITY_CODE, PS_QUATERNARY_DISABILITY_CODE)
          from rev.EP_STUDENT_SPECIAL_ED sstu
          join rev.EPC_STU stu on stu.STUDENT_GU = sstu.STUDENT_GU
          where stu.SIS_NUMBER = ? -- 22 SIS_number
	     ) 
        , CASE 
            WHEN (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL THEN ? --CASE_MANAGER_NAME   23,24
          END  
    if @@ROWCOUNT = 1
      begin
         set @InsertStat = 1
         set @Step = 'Insert EPC_NM_STU_SPED_RPT block' 
	     IF (select stf.staff_gu from rev.EPC_STAFF stf where stf.BADGE_NUM = ?) IS NULL --CASE MANAGER 25
	        set @StaffNotFound =  '['+?+']' + ' - Not found in Staff table'              --CASE MANAGER 26
	     ELSE 
	        set @StaffNotFound = ''   
      end
    else
	  begin
		    set @Step = 'Insert EPC_NM_STU_SPED_RPT block - Insert row count 0' 
	  end
end try
begin catch
   set @ErrorMess = (SELECT ERROR_MESSAGE() AS ErrorMessage)
   set @ErrorLine = (SELECT ERROR_Line())
   set @Step = 'Insert EPC_NM_STU_SPED_RPT catch block' 
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
