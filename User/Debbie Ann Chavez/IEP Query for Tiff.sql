

select p.LAST_NAME+', '+p.FIRST_NAME Student,s.SIS_NUMBER PermNum,o.ORGANIZATION_NAME School,
       convert(varchar,i.IEP_DATE,101) IepDate,
       convert(varchar,se.NEXT_IEP_DATE,101) IepReviewDate,
       convert(varchar,(select max(is2.END_DATE) from rev.EP_STU_IEP_SERVICE is2 where is2.IEP_GU = i.IEP_GU),101) LastServEndDate 
	   ,BADGE_NUM, TEAM.LAST_NAME, TEAM.FIRST_NAME
	   ,[role].ROLE_TYPE, ROLE.ROLE_NAME_LARGE
	   from rev.EPC_STU s inner join rev.REV_PERSON p on (p.PERSON_GU = s.STUDENT_GU) 
	   inner join rev.EP_STUDENT_SPECIAL_ED se on (se.STUDENT_GU = s.STUDENT_GU) 
	   inner join rev.EP_STUDENT_IEP i on (i.STUDENT_GU = s.STUDENT_GU and i.IEP_STATUS = 'CU') 
	   inner join rev.EPC_STU_YR syr on (syr.STUDENT_GU = s.STUDENT_GU) 
	   inner join rev.EPC_STU_SCH_YR ssy on (ssy.STUDENT_SCHOOL_YEAR_GU = syr.STU_SCHOOL_YEAR_GU) 
	   inner join rev.REV_ORGANIZATION_YEAR oyr on (oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU) 
	   inner join rev.REV_ORGANIZATION o on (o.ORGANIZATION_GU = oyr.ORGANIZATION_GU) 
	   INNER JOIN 
	   (SELECT STAFF.BADGE_NUM, PERS.LAST_NAME, PERS.FIRST_NAME, STUDENT_GU, ROLE_GU FROM 
rev.EP_STUDENT_TEAM AS TEAM
INNER JOIN 
rev.EPC_STAFF AS STAFF
ON 
TEAM.STAFF_GU = STAFF.STAFF_GU
INNER JOIN 
REV.REV_PERSON AS PERS
ON 
STAFF.STAFF_GU = PERS.PERSON_GU
) AS TEAM
ON S.STUDENT_GU = TEAM.STUDENT_GU
LEFT JOIN 
rev.REV_ROLE as [role]
ON
ROLE.ROLE_GU = TEAM.ROLE_GU

	
	   where syr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU) 
	   and exists (select * from rev.EP_STU_IEP_SERVICE is3 where is3.IEP_GU = i.IEP_GU having max(is3.END_DATE) <> se.NEXT_IEP_DATE) 
	   AND BADGE_NUM != 'SpEdPen'
	   order by Student,PermNum
