--<APS - Transportation Student Extract File>
; with Parents AS
(
SELECT   
       stu.STUDENT_GU
     , stupar.ORDERBY
     , par.PRIMARY_PHONE
     , par.FIRST_NAME + ' ' + par.LAST_NAME             ParentName
     , ROW_NUMBER() over (partition by stu.student_gu order by stupar.orderby, stupar.parent_gu) rn
	 , CASE WHEN stupar.RELATION_TYPE NOT IN ('M', 'F') THEN 'X'
	        ELSE stupar.RELATION_TYPE
       END                                              RelType
     , par.EMAIL                                        Email
	 , phone.W                                          WorkPhone
	 , phone.C                                          CellPhone
FROM rev.EPC_STU_PARENT  stupar
     JOIN rev.REV_PERSON par    ON par.PERSON_GU  = stupar.PARENT_GU 
     JOIN rev.EPC_STU    stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
     LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                      PIVOT (min(phone) FOR phone_type in ([H], [C], [W])) phone ON phone.PERSON_GU = par.PERSON_GU
)
SELECT
        stu.SIS_NUMBER                           AS [Student ID Number]
      , stu.STATE_STUDENT_NUMBER                 AS [State ID Number]
      , sch.SCHOOL_CODE                          AS [SOR School Number]
      , ''                                       AS [CAL_SUB_TY]
      , per.FIRST_NAME                           AS [Student First Name]
      , per.MIDDLE_NAME                          AS [Student Middle Name]
      , per.LAST_NAME                            AS [Student Last Name]
      , grd.VALUE_DESCRIPTION                    AS [Student Current SOR Enrollment Grade Level]
      , CONVERT(VARCHAR(10), per.BIRTH_DATE,101) AS [Student Birthdate]
      , per.GENDER                               AS [Student Gender]
      , hadr.ADDRESS                             AS [Student Address]
      , hadr.CITY                                AS [City]
      , hadr.STATE                               AS [State]
      , hadr.ZIP_5                               AS [Zip Code]
      , LEFT(per.PRIMARY_PHONE,3)
	    + '-'+
		SUBSTRING(per.PRIMARY_PHONE,4,3)
		+ '-' +
		RIGHT(per.PRIMARY_PHONE,4)               AS [Student Home Phone Number]
      , LEFT(p1.PRIMARY_PHONE,3)
	    + '-'+
		SUBSTRING(p1.PRIMARY_PHONE,4,3)
		+ '-' +
		RIGHT(p1.PRIMARY_PHONE,4)                AS [Parent 1 Home Phone]
      , p1.ParentName                            AS [Parent 1 Full Name]
      , LEFT(p2.PRIMARY_PHONE,3)
	    + '-'+
		SUBSTRING(p2.PRIMARY_PHONE,4,3)
		+ '-' +
		RIGHT(p2.PRIMARY_PHONE,4)                AS [Parent 2 Home Phone]
      , p2.ParentName                            AS [Parent 2 Full Name]
	   , hadr.STREET_NUMBER                                           AS [HouseNumber]
	   , coalesce(hadr.street_direction + ' ', '') 
	    + coalesce(hadr.street_name, ' ')
		+ coalesce(' ' +hsty.value_description,'')  
		+ coalesce(' '+ hadr.street_post_direction, '' )
	                                                                  AS [Street]
	   , hadr.STREET_EXTRA                                            As [Apartment]
	   , LEFT(p1.WorkPhone,3)
          + '-'+
          SUBSTRING(p1.WorkPhone,4,3)
          + '-' +
         RIGHT(p1.WorkPhone,4)                                        AS [Parent1WorkPhone]
	   , LEFT(p1.CellPhone,3)
          + '-'+
          SUBSTRING(p1.CellPhone,4,3)
          + '-' +
         RIGHT(p1.CellPhone,4)                                        AS [Parent1CellPhone]
	   , p1.Email                                                     AS [Parent1Email]
	   , LEFT(p2.WorkPhone,3)
          + '-'+
          SUBSTRING(p2.WorkPhone,4,3)
          + '-' +
         RIGHT(p2.WorkPhone,4)                                        AS [Parent2WorkPhone]
	   , LEFT(p2.CellPhone,3)
          + '-'+
          SUBSTRING(p2.CellPhone,4,3)
          + '-' +
         RIGHT(p2.CellPhone,4)                                        AS [Parent2CellPhone]
	   , p2.Email                                                     AS [Parent2Email]
FROM  rev.EPC_STU                     stu
      JOIN  rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU             = stu.STUDENT_GU
                                              AND ssy.STATUS IS NULL
											  AND ssy.EXCLUDE_ADA_ADM IS NULL
      JOIN  rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
                                              AND oyr.YEAR_GU            = (select year_gu from rev.SIF_22_Common_CurrentYearGU)
      JOIN rev.EPC_SCH                sch  ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
      JOIN rev.REV_PERSON             per  ON per.PERSON_GU              = stu.STUDENT_GU
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE
      JOIN rev.REV_ADDRESS            hadr ON hadr.ADDRESS_GU            = per.HOME_ADDRESS_GU
	  LEFT JOIN Parents               p1   ON p1.STUDENT_GU              = stu.STUDENT_GU and p1.rn = 1
	  LEFT JOIN Parents               p2   ON p2.STUDENT_GU              = stu.STUDENT_GU and p2.rn = 2
      LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.AddressInfo', 'STREET_TYPE') hsty ON hsty.VALUE_CODE = hadr.STREET_TYPE