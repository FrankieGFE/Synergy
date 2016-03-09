-- 20140903 rtt we need a tool to create or update the PVUE Role property in new and existing databases.  
-- 20140915 rtt fixed tables that had the incorrect Role Name
-- 20141110 rtt added more Gradebook tables needed for Assessment
-- 20150107 rtt Logic added to determine if Diable PVUE Update Review is enabled.  If it is we have to allow more access to specific tables
--				added update for EPC_STU to allow a user defined field and STUDENT Related Field to be updated 
--				added update for EPC_STU_PGM_ELL to allow the editing of Native Language
--				added update, Insert, and Delete for EPC_STU_EMG_CONTACT to allow editing of Student Emergency Contacts
--				added update for EPC_STU_PHYSICIAN to allow for editing of Physician information
--				added update, Insert, and Delete for REV_PERSON_SECONDARY_ETH_LST to allow for editing of Race Information
-- 20150206 rtt added to support happens if a parent is trying to view a class that has been assigned from one teacher 
-- 				to another, where the previous teacher had used their own score type
-- 20150817 rtt added GRANT INSERT ON [rev].[EGB_CLASS_OWNER] TO [PVUE_ROLE]; to solove Student login issues
-- 20150818 rtt EGB_STANDARDS_CLASS added by Jason Dingle
-- 20150821 rtt added per email from Brian Griess to support Streams
-- 20150915	rtt	Jason Dingle added tables for Mobile app support and  Assessment Recalc 
-- 20150915 rtt Jason Dingle added to allow for a code path that updates a column when parents view a report card
-- 20150921 rtt added to allow for scheduling Student Conferences
-- 20151002 rtt added tables for 9.0.12.0/10.01 Brian Griess
-- 20151017 rur	Corrected table name EGB_SETUP to EGB_GBSETUP
-- 20151017 rtt added Update for EGB_GBSETUP per email from Jason on 10/17/2015
-- 20151020 rtt added EGB_GBPERIODS for Assessment
-- 20151204	rtt added delete for REV_PERSON_PHONE due to Loudoun email from Jason Dingle
-- 20160120 rtt Andy added EPC_STU_SSY_TSK and EPC_PXP_OEN_PRG_REVIEW tables from testing new releases
-- 20160203 rtt If a class is transferred to a new teacher and a student opens the class first they need access to the EGB_GBTYPESSECURITY table. 

DECLARE
	-- ops
	-- set to 0 for COMMIT 1 = no commit (ROLLBACK) 
   @DebugOn INT = 0,
   -- if you want to create the role set this to 0.  By Default we do not create or recreate the Role.
   @CreateRole INT = 1,
   -- Has the district disabled update review if so we need to allow more access to a few tables
   @DisablePUVEUpdateReview varchar(1) = (SELECT DISABLE_PVUE_UPDATE_REVIEW FROM REV.EPC_PXP_CFG)
   
   BEGIN TRANSACTION
   
		IF @CreateRole = 0 
			BEGIN
				DECLARE @RoleName sysname
				set @RoleName = N'PVUE_ROLE'
				IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = @RoleName AND type = 'R')
				Begin
					DECLARE @RoleMemberName sysname
					DECLARE Member_Cursor CURSOR FOR
					select [name]
					from sys.database_principals 
					where principal_id in ( 
						select member_principal_id 
						from sys.database_role_members 
						where role_principal_id in (
							select principal_id
							FROM sys.database_principals where [name] = @RoleName  AND type = 'R' ))

					OPEN Member_Cursor;

					FETCH NEXT FROM Member_Cursor
					into @RoleMemberName

					WHILE @@FETCH_STATUS = 0
					BEGIN

						exec sp_droprolemember @rolename=@RoleName, @membername= @RoleMemberName

						FETCH NEXT FROM Member_Cursor
						into @RoleMemberName
					END;

					CLOSE Member_Cursor;
					DEALLOCATE Member_Cursor;
					End


				/****** Object:  DatabaseRole [PVUE_ROLE]    Script Date: 09/03/2014 14:29:33 ******/
				IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'PVUE_ROLE' AND type = 'R')
				DROP ROLE [PVUE_ROLE]

				IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'PVUE_ROLE' AND type = 'R')
				
				BEGIN
				CREATE ROLE [PVUE_ROLE]
				EXEC sp_addrolemember N'PVUE_ROLE', N'pvue'
				END
			END
		 

		-- Ok here is where we give away specific table permissions to the role
		GRANT INSERT ON [rev].[REV_AUDIT_TRAIL_PROP] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_AUDIT_TRAIL_PROP] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_SCH_YR] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_YR] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_PARENT_PXP] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_PARENT_PXP] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_SCH_YR_OPT_SCHED] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_SCH_YR_OPT_SCHED] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_SCHD_REQUEST] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_SCHD_REQUEST] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_SCHD_REQUEST] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_AUDIT_TRAIL] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_AUDIT_TRAIL] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_USER_NON_SYS_ACT] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_USER_NON_SYS_ACT] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_DATASET_FILTER] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_DATASET_FILTER] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_DATASET_FILTER] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_WEB_FARM_SERVER] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_WEB_FARM_SERVER] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_WEB_FARM_SERVER] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_USER_NON_SYS] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_SCHD_REQUEST_ALT] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_SCHD_REQUEST_ALT] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_SCHD_REQUEST_ALT] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_VER] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_VER] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_VER] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_VER_FILE] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_VER_FILE] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_VER_FILE] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_VER_FILE_DEPLOY_STATUS] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_VER_FILE_DEPLOY_STATUS] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_VER_FILE_DEPLOY_STATUS] TO [PVUE_ROLE]
		-- only if Online Credit Card Processing Enabled
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_ONLINE_PMT_TERMS_VIEWED')
		GRANT UPDATE ON [rev].[EPC_ONLINE_PMT_TERMS_VIEWED] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_ONLINE_PMT_TERMS_VIEWED')
		GRANT INSERT ON [rev].[EPC_ONLINE_PMT_TERMS_VIEWED] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_ONLINE_PMT_TERMS_VIEWED')
		GRANT DELETE ON [rev].[EPC_ONLINE_PMT_TERMS_VIEWED] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_PXP_CHG] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_PXP_CHG] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_PXP_CHG] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_PXP_CHG_HIS] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_PXP_CHG_HIS] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_PXP_CHG_HIS] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_PXP_CHG_VAL] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_PXP_CHG_VAL] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_PXP_CHG_VAL] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_FEE] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_FEE] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_FEE] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_FEE_PAY_TRANS] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_FEE_PAY_TRANS] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_FEE_PAY_TRANS] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_FEE_PAYMENT] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_FEE_PAYMENT] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_FEE_PAYMENT] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_FEE_SUM] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_FEE_SUM] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_FEE_SUM] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_FEE_TRANSACTION] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_FEE_TRANSACTION] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_FEE_TRANSACTION] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_AUTO_SEQUENCE] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_AUTO_SEQUENCE] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_ERROR] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_ERROR] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_ERROR] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_TSK] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_TSK] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_TSK] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_SCH_YR_OPT_SCHED_LCK] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_SCH_YR_OPT_SCHED_LCK] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_SCH_YR_OPT_SCHED_LCK] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EGB_CONFIGUSER] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EGB_CONFIGUSER] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EGB_CONFIGUSER] TO [PVUE_ROLE]
		-- added for 9.0.8.0 Ticket 245534
		GRANT UPDATE ON [rev].[EGB_CONFIG] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EGB_CONFIG] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EGB_CONFIG] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_DLR] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_DLR] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_DLR] TO [PVUE_ROLE]
		-- added to support happens if a parent is trying to view a class that has been assigned from one teacher 
		-- to another, where the previous teacher had used their own score type
		GRANT UPDATE ON [rev].[EGB_GBSCORETYPES] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EGB_GBSCORETYPES] TO [PVUE_ROLE]
		-- End added upport 
		GRANT UPDATE ON [rev].[EGB_DOCUMENTS] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EGB_DOCUMENTS] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EGB_DOCUMENTS] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EGB_DOCUMENTSXREF] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EGB_DOCUMENTSXREF] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EGB_DOCUMENTSXREF] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_PERSON] TO [PVUE_ROLE]
		-- for future functionality for Parents
		GRANT INSERT ON [rev].[REV_PROCESS_QUEUE] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_PROCESS_QUEUE] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_PROCESS_QUEUE] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_PROCESS_QUEUE_RESULT] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_PROCESS_QUEUE_RESULT] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_PROCESS_QUEUE_RESULT] TO [PVUE_ROLE]
		-- added for on-line Registration
		GRANT INSERT ON [rev].[EPC_PXP_OEN_DOC] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_PXP_OEN_DOC] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_PXP_OEN_DOC] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG')
		GRANT INSERT ON [rev].[EPC_PXP_OEN_PRG] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG')
		GRANT DELETE ON [rev].[EPC_PXP_OEN_PRG] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG')
		GRANT UPDATE ON [rev].[EPC_PXP_OEN_PRG] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG_STU')
		GRANT INSERT ON [rev].[EPC_PXP_OEN_PRG_STU] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG_STU')
		GRANT DELETE ON [rev].[EPC_PXP_OEN_PRG_STU] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG_STU')
		GRANT UPDATE ON [rev].[EPC_PXP_OEN_PRG_STU] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG_STU_SCH')
		GRANT INSERT ON [rev].[EPC_PXP_OEN_PRG_STU_SCH] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG_STU_SCH')
		GRANT DELETE ON [rev].[EPC_PXP_OEN_PRG_STU_SCH] TO [PVUE_ROLE]
		IF  EXISTS (select * from sys.tables t where t.name ='EPC_PXP_OEN_PRG_STU_SCH')
		GRANT UPDATE ON [rev].[EPC_PXP_OEN_PRG_STU_SCH] TO [PVUE_ROLE]
		-- added by Andy while on-site at Lincoln 20140815
		GRANT INSERT ON [rev].[EPC_STU_SCH_YR_HWNOTES] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[EPC_STU_SCH_YR_HWNOTES] TO [PVUE_ROLE]
		GRANT UPDATE on [rev].[EPC_PARENT] to [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_PARENT] TO [PVUE_ROLE]
		GRANT UPDATE on [rev].[REV_PERSON_PHONE] to [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_PERSON_PHONE] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[REV_PERSON_PHONE] TO [PVUE_ROLE]
		-- If PUVE Disable Update Review is checked
		IF @DisablePUVEUpdateReview = 'Y'
			BEGIN
				PRINT 'PVUE Review Enabled'
				--added to allow for Editing of Student data
				GRANT UPDATE ON [rev].[EPC_STU] TO [PVUE_ROLE]
				--added to allow for editing of Native Language
				GRANT UPDATE ON [rev].[EPC_STU_PGM_ELL] TO [PVUE_ROLE]
				GRANT INSERT ON [rev].[EPC_STU_PGM_ELL] TO [PVUE_ROLE]
				--added to allow for editing of Emergency Contacts
				GRANT UPDATE ON [rev].[EPC_STU_EMG_CONTACT] TO [PVUE_ROLE]
				GRANT INSERT ON [rev].[EPC_STU_EMG_CONTACT] TO [PVUE_ROLE]
				GRANT DELETE ON [rev].[EPC_STU_EMG_CONTACT] TO [PVUE_ROLE]
				--EPC_STU_PHYSICIAN to allow for editing of Physician information
				GRANT UPDATE ON [rev].[EPC_STU_PHYSICIAN] TO [PVUE_ROLE]
				GRANT INSERT ON [rev].[EPC_STU_PHYSICIAN] TO [PVUE_ROLE]
				--REV_PERSON_SECONDRY_ETH_LST to allow for editing of Race Information
				GRANT UPDATE ON [rev].[REV_PERSON_SECONDRY_ETH_LST] TO [PVUE_ROLE]
				GRANT DELETE ON [rev].[REV_PERSON_SECONDRY_ETH_LST] TO [PVUE_ROLE]
				GRANT INSERT ON [rev].[REV_PERSON_SECONDRY_ETH_LST] TO [PVUE_ROLE]
				
				PRINT 'PVUE Role was updated'
			END
			ELSE
			
			PRINT 'PVUE Review Disabled'
			PRINT 'PVUE Role was updated'
			
		--added for on-line Registration
		GRANT INSERT ON [rev].[REV_PERSON] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_PERSON] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_USER_NON_SYS] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_USER_NON_SYS] TO [PVUE_ROLE]
		-- to allow for parent messages to be read and deleted
		GRANT INSERT ON [rev].[EPC_PARENT_ACK_RESPONSE] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EPC_PARENT_ACK_RESPONSE] TO [PVUE_ROLE];
		GRANT DELETE ON [rev].[EPC_PARENT_ACK_RESPONSE] TO [PVUE_ROLE];
		-- client had issue where they could not delete ParentVUE messages Ticket 239166 
		GRANT INSERT ON [rev].[EPC_PER_SECT_MSG] TO [PVUE_ROLE];
		GRANT DELETE ON [rev].[EPC_PER_SECT_MSG] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EPC_PER_SECT_MSG] TO [PVUE_ROLE];
		-- to allow for student assessment 
		GRANT INSERT ON [rev].[EGB_TEST_STUDENTRESPONSES] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_TEST_STUDENTRESPONSES] TO [PVUE_ROLE];
		GRANT DELETE ON [rev].[EGB_TEST_STUDENTRESPONSES] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_TEST_STUDENTS] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_TEST_STUDENTS] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_GRADEBOOK] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_GRADEBOOK] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_GBRESULT] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_GBRESULT] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_GBXREF] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_GBXREF] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_GBSTANDARDSRESULT] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_GBSTANDARDSRESULT] TO [PVUE_ROLE];
		GRANT DELETE ON [rev].[EGB_GBSTANDARDSRESULT] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_TEST_RESPONSEANSWER] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_TEST_RESPONSEANSWER] TO [PVUE_ROLE];
		GRANT DELETE ON [rev].[EGB_TEST_RESPONSEANSWER] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_CLASS_OWNER] TO [PVUE_ROLE];
		--20150818 added by Jason Dingle
		GRANT INSERT ON [rev].[EGB_STANDARDS_CLASS] TO [PVUE_ROLE];
		GRANT DELETE ON [rev].[EGB_STANDARDS_CLASS] TO [PVUE_ROLE];
		--added per email from Brian Griess 
		GRANT UPDATE ON [rev].[REV_STREAM_NOTIFICATION] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[REV_STREAM] TO [PVUE_ROLE]
		GRANT UPDATE ON [rev].[REV_STREAM] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[REV_STREAM_CONTEXT] TO [PVUE_ROLE]
		--added for Mobile app support 20150915
        GRANT INSERT ON [rev].[REV_TOKEN_DATA] TO [PVUE_ROLE]
        GRANT UPDATE ON [rev].[REV_TOKEN_DATA] TO [PVUE_ROLE]
        --added for Assessment Recalc 20150915
        GRANT UPDATE ON [rev].[EGB_CLASS] TO [PVUE_ROLE]
		-- 20150915 added to allow for a code path that updates a column when parents view a report card
		GRANT UPDATE on [rev].[EGB_REPORTCARD] TO [PVUE_ROLE];
		-- 20150921 added to allow for scheduling Student Conferences
		GRANT UPDATE ON [rev].[EPC_STU_CONFERENCE] TO [PVUE_ROLE]
		GRANT INSERT ON [rev].[EPC_STU_CONFERENCE] TO [PVUE_ROLE]
		GRANT DELETE ON [rev].[EPC_STU_CONFERENCE] TO [PVUE_ROLE]
		-- changes needed for 9.0.12.0/10.01 Brian Griess
		GRANT INSERT ON [rev].[REV_STREAM_NOTIFICATION] TO [PVUE_ROLE];
		GRANT INSERT ON [rev].[EGB_GBSETUP] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_GBSETUP] TO [PVUE_ROLE];
		-- added to support Assessment
		GRANT INSERT ON [rev].[EGB_GBPERIODS] TO [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EGB_GBPERIODS] TO [PVUE_ROLE];
		--added Data Set Filter
		GRANT INSERT ON [rev].[REV_DATASET_FILTER] to [PVUE_ROLE];
		--added changes needed for 10.02/9.0.13.0
		GRANT DELETE ON [rev].[EPC_STU_SSY_TSK] to [PVUE_ROLE];
		GRANT UPDATE ON [rev].[EPC_STU_SSY_TSK] to [PVUE_ROLE];
		GRANT INSERT ON [rev].[EPC_STU_SSY_TSK] to [PVUE_ROLE];
		--add OEN tables for 10.02 for Review Highlights
		GRANT INSERT ON[rev].[EPC_PXP_OEN_PRG_REVIEW] to [PVUE_ROLE];
		GRANT UPDATE ON[rev].[EPC_PXP_OEN_PRG_REVIEW] to [PVUE_ROLE];
		GRANT DELETE ON[rev].[EPC_PXP_OEN_PRG_REVIEW] to [PVUE_ROLE];
		-- added if a student looks at a transfered section in PVUE before the new teacher does
		GRANT INSERT ON[rev].[EGB_GBTYPESSECURITY] to [PVUE_ROLE];
		GRANT UPDATE ON[rev].[EGB_GBTYPESSECURITY] to [PVUE_ROLE];

   IF @DebugOn = 0 COMMIT
ELSE ROLLBACK

