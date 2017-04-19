
                EXEC('EXECUTE [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES] ''K12INTEL_DW'', ''FTBL_TEST_SCORES'', ''DISABLE'', ''NONCLUSTERED COLUMNSTORE'', NULL')
                
                    begin tran

                        DELETE K12INTEL_DW.FTBL_TEST_SCORES
                        WHERE TEST_SCORES_KEY IN (
                                SELECT a.TEST_SCORES_KEY
                                FROM K12INTEL_KEYMAP.KM_TESTSCORES a
                                INNER JOIN K12INTEL_USERDATA.XTBL_TEST_ADMIN b
                                    ON b.PROD_TEST_ID = a.PROD_TEST_ID
                                WHERE b.BATCH_ID in('1128')  and b.PARTICIPATION_YEAR='2015-2016'
                                   -- AND b.OVERRIDE_TEST_ADMIN_IND = 'N'
                                    AND b.PROD_TEST_ID IN (

                                        SELECT x.PROD_TEST_ID
                                        FROM K12INTEL_USERDATA.XTBL_TEST_ADMIN X
                                        WHERE 1=1
                                           -- AND x.DELETE_TEST_ADMIN_IND= 'N'
                                        GROUP BY x.PROD_TEST_ID
                                        HAVING COUNT(*) = 1
                                    )
                            )
               rollback



			   begin tran
                        DELETE K12INTEL_KEYMAP.KM_TESTSCORES
                        WHERE TEST_SCORES_KEY IN (
                                SELECT a.TEST_SCORES_KEY
                                FROM K12INTEL_KEYMAP.KM_TESTSCORES a
                                INNER JOIN K12INTEL_USERDATA.XTBL_TEST_ADMIN b
                                    ON b.PROD_TEST_ID = a.PROD_TEST_ID
                                WHERE b.BATCH_ID in('1128')  and PARTICIPATION_YEAR='2015-2016'
                                   -- AND b.OVERRIDE_TEST_ADMIN_IND = 'N'
                                    AND b.PROD_TEST_ID IN (

                                        SELECT x.PROD_TEST_ID
                                        FROM K12INTEL_USERDATA.XTBL_TEST_ADMIN X
                                        WHERE 1=1
                                          --  AND x.DELETE_TEST_ADMIN_IND= 'N'
                                        GROUP BY x.PROD_TEST_ID
                                        HAVING COUNT(*) = 1
                                    )
                            )
             rollback



			 begin tran
                        DELETE K12INTEL_USERDATA.XTBL_TEST_SCORES
                        WHERE TEST_ADMIN_KEY IN (
                                SELECT TEST_ADMIN_KEY
                                FROM K12INTEL_USERDATA.XTBL_TEST_ADMIN a
                                WHERE a.BATCH_ID in('1128')  and PARTICIPATION_YEAR='2015-2016'
                                    --AND a.OVERRIDE_TEST_ADMIN_IND = 'N'
                            )
rollback
begin tran
                        DELETE K12INTEL_USERDATA.XTBL_TEST_ADMIN
                        WHERE  BATCH_ID in('1128')   and PARTICIPATION_YEAR='2015-2016'
                           -- AND OVERRIDE_TEST_ADMIN_IND = 'N'

                        --DELETE K12INTEL_USERDATA.XTBL_TEST_BATCH_IDS
                        --WHERE BATCH_ID = @BATCH_ID
                        --    AND NOT EXISTS(
                        --        SELECT NULL
                        --        FROM K12INTEL_USERDATA.XTBL_TEST_ADMIN
                        --        WHERE BATCH_ID = @BATCH_ID
                        --    )
                
       
             
			    --IF @@TRANCOUNT > 0  COMMIT TRANSACTION

           rollback


         
                    EXEC('EXECUTE [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES] ''K12INTEL_DW'', ''FTBL_TEST_SCORES'', ''REBUILD'', ''NONCLUSTERED COLUMNSTORE'', NULL')
            
                