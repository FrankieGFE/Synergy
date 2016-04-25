IF OBJECT_ID('tempdb..#TempSiblings1') IS NOT NULL DROP TABLE #TempSiblings1
CREATE TABLE #TempSiblings1
  (
    SIS_Number                varchar(14),
    StudentName               varchar(40),
    sn                        varchar(4),
    dn                        varchar(4),
    SiblingSISNumber          varchar(14),
	SiblingName               varchar(40)
   )
go
IF OBJECT_ID('tempdb..#TempSiblings') IS NOT NULL DROP TABLE #TempSiblings
CREATE TABLE #TempSiblings
  (
    rownum                    varchar(4),
    SIS_Number                varchar(14),
    StudentName               varchar(40),
    sn                        varchar(4),
    dn                        varchar(4),
    SiblingSISNumber          varchar(14),
	SiblingName               varchar(40)
   )
go
insert into #TempSiblings1
     (
    SIS_Number,     
    StudentName,    
    sn,               
    dn,              
    SiblingSISNumber,
	SiblingName
	 )
select 
           stu.SIS_NUMBER                          sSIS_Number
         , per.FIRST_NAME + ' ' + per.LAST_NAME    sStudentName
         , row_number() over(partition by stu.sis_number order by sibp.scroll_composite_key) ssn
		 , row_number() over(partition by sibs.sis_number order by sibp.scroll_composite_key) sdn
		 , sibs.SIS_NUMBER                         sSiblingSISNumber
		 , sibp.FIRST_NAME + ' ' + sibp.LAST_NAME  sSiblingName
from     rev.epc_stu               stu
         join rev.REV_PERSON       per  on per.PERSON_GU     = stu.STUDENT_GU
         join rev.EPC_STU_PARENT   spar on spar.STUDENT_GU   = stu.STUDENT_GU
		 join rev.EPC_PARENT       par  on par.PARENT_GU     = spar.PARENT_GU
		 join rev.EPC_STU_PARENT   ppar on ppar.PARENT_GU    = par.PARENT_GU
		 join rev.EPC_STU          sibs on sibs.STUDENT_GU   = ppar.STUDENT_GU
		 join rev.REV_PERSON       sibp on sibp.PERSON_GU    = sibs.STUDENT_GU
where    stu.STUDENT_GU <> ppar.STUDENT_GU
go

insert into #TempSiblings
     (
	rownum,
    SIS_Number,     
    StudentName,    
    sn,               
    dn,              
    SiblingSISNumber,
	SiblingName
	 )
select 
row_number() over (partition by t.sis_number, t.siblingsisnumber order by sn) dn
,* from #TempSiblings1 t

select * from #TempSiblings t
where t.sis_number = '905483'
order by sn