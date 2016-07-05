-- Delete one SE student (but leave SIS data)
declare @sisNum varchar(20)
set @sisNum = '970076029'

delete from EP_STUDENT_SPECIAL_ED where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
delete from EP_STUDENT_DOCUMENT where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
delete from EP_STUDENT_IEP where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
delete from EP_STU_ATTCH_DOC where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
delete from EP_STU_PROCESS where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
delete from EP_MEDC_STU_PROV_ASSIG_HIST where STU_PROVIDER_ASSIGN_GU in (select STU_PROVIDER_ASSIGN_GU from EP_MEDC_STU_PROVIDER_ASSIGN where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum))
delete from EP_MEDC_STU_PROV_SERVICE where STU_PROVIDER_ASSIGN_GU in (select STU_PROVIDER_ASSIGN_GU from EP_MEDC_STU_PROVIDER_ASSIGN where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum))
delete from EP_MEDC_SRV_PROVIDER_SCHD where STU_PROVIDER_ASSIGN_GU in (select STU_PROVIDER_ASSIGN_GU from EP_MEDC_STU_PROVIDER_ASSIGN where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum))
delete from EP_MEDC_STU_PROVIDER_ASSIGN where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
delete from EP_STU where STUDENT_GU in (select STUDENT_GU from EPC_STU where SIS_NUMBER = @sisNum)
