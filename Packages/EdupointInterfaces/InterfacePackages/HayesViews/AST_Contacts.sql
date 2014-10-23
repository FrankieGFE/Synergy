--APS - Database View for Hayes Textbook Software System - ASTContacts>
IF OBJECT_ID('EVASourcedb.CleanName') IS NOT NULL DROP FUNCTION EVASourcedb.CleanName
GO
--function to cleanup name string
Create Function EVASourcedb.CleanName(@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin
    Declare @CleanValues as varchar(50)
    Set @CleanValues = '%[^a-z ]%'
    While PatIndex(@CleanValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@CleanValues, @Temp), 1, '')
    Return @Temp
End
go
IF OBJECT_ID('EVASourcedb.ASTContacts') IS NOT NULL DROP VIEW EVASourcedb.ASTContacts
GO
CREATE VIEW EVASourcedb.ASTContacts AS

SELECT  DISTINCT
         ''                                AS [ContactRowID]
       , 'S'+stu.SIS_NUMBER                AS [GivenID]
       , sch.SCHOOL_CODE                   AS [LocationGivenID]
       , '1'                               AS [CoreTypeID] 
       , EVASourcedb.CleanName(Parent.ParentName)  AS [ContactFullName]
       , Parent.Relation                   AS [ContactRelation]
       , '11'                              AS [ContactOrder]
       , Parent.ADDRESS                    AS [Address1]
       , Parent.Apt                        AS [Address2]
       , Parent.CITY                       AS [City]
       , Parent.STATE                      AS [State]
       , Parent.ZIP_5                      AS [Zip]
       , Parent.CellPhone                  AS [CellPhone]
       , Parent.WorkPhone                  AS [WorkPhone]
       , Parent.HomePhone                  AS [HomePhone]
       , Parent.OtherPhone                 AS [OtherPhone]
       , Parent.EMAIL                      AS [Email]
       , ''                                AS [OtherContactBearings]
       , ''                                AS [Other]
FROM  rev.EPC_STU                    stu
      JOIN rev.REV_PERSON            per   ON per.PERSON_GU              = stu.STUDENT_GU
      JOIN rev.EPC_STU_SCH_YR        ssy   ON ssy.STUDENT_GU             = stu.STUDENT_GU
                                              AND ssy.STATUS             IS NULL
      JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
      JOIN rev.REV_YEAR              yr    ON yr.YEAR_GU                 = oyr.YEAR_GU 
                                              and yr.SCHOOL_YEAR         = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
      JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
      LEFT JOIN (
                       SELECT   
                              stu.STUDENT_GU
                            , ROW_NUMBER() over (partition by stu.student_gu order by stupar.orderby) rn
                            , par.FIRST_NAME + ' ' + par.LAST_NAME ParentName
                            , rel.VALUE_DESCRIPTION Relation
                            , phone.H HomePhone
                            , phone.C CellPhone
                            , phone.W WorkPhone
                            , phone.O OtherPhone
                            , par.EMAIL
                            , adr.ADDRESS
							, adr.STREET_EXTRA Apt
                            , adr.CITY
                            , adr.STATE
                            , adr.ZIP_5
                       FROM rev.EPC_STU_PARENT  stupar
                            JOIN rev.REV_PERSON par    ON par.PERSON_GU  = stupar.PARENT_GU 
                            JOIN rev.EPC_STU    stu    ON stu.STUDENT_GU = stupar.STUDENT_GU
                            LEFT JOIN rev.REV_ADDRESS adr ON adr.ADDRESS_GU = COALESCE(par.HOME_ADDRESS_GU, par.MAIL_ADDRESS_GU)
                            LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'RELATION_TYPE') rel on rel.VALUE_CODE = stupar.RELATION_TYPE
                            LEFT JOIN (SELECT phn.PERSON_GU, phn.PHONE, phn.PHONE_TYPE FROM rev.REV_PERSON_PHONE phn) pl
                                       PIVOT (min(phone) FOR phone_type in ([H], [C], [W], [O])) phone ON phone.PERSON_GU = par.PERSON_GU
                       WHERE stupar.LIVES_WITH = 'Y'
                     ) Parent ON Parent.STUDENT_GU = stu.STUDENT_GU and parent.rn = 1
