USE
PR
GO

DECLARE @SynergyParent

TABLE
(
SIS_NUMBER NVARCHAR(20)
/*,RELATION_TYPE NVARCHAR(5)
 ,	LAST_NAME	nvarchar(60)
 ,	FIRST_NAME	nvarchar(60)
 ,	MIDDLE_NAME	nvarchar(20)
 ,	SUFFIX	nvarchar(10)
 ,	HOME_ADDRESS	nvarchar(50)
 ,	HOME_CITY	nvarchar(50)
 ,	HOME_STATE	nvarchar(5)
 ,	HOME_ZIPCODE	nvarchar(6)
 ,	MAIL_ADDRESS	nvarchar(50)
 ,	MAIL_CITY	nvarchar(50)
 ,	MAIL_STATE	nvarchar(5)
 ,	MAIL_ZIPCODE	nvarchar(6)
 ,	PHONE	nvarchar(10)
 ,	PHONE_TYPE	nvarchar(20)
 ,	PHONE_EXTN	nvarchar(5)
 ,	PHONE_LISTED	varchar(1) DEFAULT ''
 ,	PHONE_CONTACT	varchar(1) DEFAULT ''
 ,	PHONE_PRIMARY	varchar(1) DEFAULT ''
 ,	PHONE2	nvarchar(10)
 ,	PHONE2_TYPE	nvarchar(20)
 ,	PHONE2_EXTN	nvarchar(5)
 ,	PHONE2_LISTED	varchar(1) DEFAULT ''
 ,	PHONE2_CONTACT	varchar(1) DEFAULT ''
 ,	PHONE2_PRIMARY	varchar(1) DEFAULT ''
 ,	PHONE3	nvarchar(10)
 ,	PHONE3_TYPE	nvarchar(20)
 ,	PHONE3_EXTN	nvarchar(5)
 ,	PHONE3_LISTED	varchar(1) DEFAULT ''
 ,	PHONE3_CONTACT	varchar(1) DEFAULT ''
 ,	PHONE3_PRIMARY	varchar(1) DEFAULT ''
 ,	PHONE4	nvarchar(10)
 ,	PHONE4_TYPE	nvarchar(20)
 ,	PHONE4_EXTN	nvarchar(5)
 ,	PHONE4_LISTED	varchar(1) DEFAULT ''
 ,	PHONE4_CONTACT	varchar(1) DEFAULT ''
 ,	PHONE4_PRIMARY	varchar(1) DEFAULT ''
 ,	GENDER	nvarchar(5)
 ,	ETHNIC_CODE	nvarchar(5)
 ,	RACE1	nvarchar(5)
 ,	RACE2	nvarchar(5)
 ,	RACE3	nvarchar(5)
 ,	RACE4	nvarchar(5)
 ,	RACE5	nvarchar(5)
 ,	HISPANIC_INDICATOR	varchar(1) DEFAULT ''
 ,	BIRTHDATE	datetime
 ,	BIRTHPLACE	nvarchar(30)
 ,	SOCIAL_SECURITY_NUMBER	nvarchar(10)
 ,	PRIMARY_LANGUAGE	nvarchar(5)
 ,	US_CITIZEN	varchar(1) DEFAULT ''
 ,	E_MAIL	nvarchar(100)
 ,	TITLE	nvarchar(10)
 ,	EMPLOYER	nvarchar(40)
 ,	JOB_TITLE	nvarchar(50)
 ,	ADDITIONALINFO	nvarchar(50)
 ,	COMMENT	ntext
 ,	CONTACT_ALLOWED	varchar(1) DEFAULT ''
 ,	EDUCATIONAL_RIGHTS	varchar(1) DEFAULT ''
 ,	HAS_CUSTORY	varchar(1) DEFAULT ''
 ,	LIVES_WITH	varchar(1) DEFAULT ''
 ,	MAILINGS_ALLOWED	varchar(1) DEFAULT ''
 ,	ORDERBY	numeric(2,0)
 ,	EDUCATION_CODE	nvarchar(5)
 ,	WORK_ADDRESS	nvarchar(50)
 ,	WORK_CITY	nvarchar(50)
 ,	WORK_STATE	nvarchar(5)
 ,	WORK_ZIPCODE	nvarchar(6)
 ,	FEEDER_DISTRICT_ID	nvarchar(10)
 ,	FEEDER_STUDENT_ID	nvarchar(20)
 ,	RELEASE_TO	varchar(1) DEFAULT ''
 ,	ENROLLING_PARENT	varchar(1) DEFAULT ''*/
 )
 --INSERT INTO @SynergyParent
 
 SELECT
	ID_NBR AS SIS_NUMBER
	,CE810_V.RLTN_HH1
	,CE810_V.RLTN_HH2
	,CE810_V.FAM_NBR
	
	
	
	
	
	
	
FROM
	DBTSIS.CE810_V
	
	
	
	
	
WHERE
	DST_NBR = 1

		
	
	