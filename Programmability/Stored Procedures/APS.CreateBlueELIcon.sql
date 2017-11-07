

/***************************************************************


created by Debbie Ann Chavez
date 11/3/2017

****************************************************************/



CREATE PROC [APS].[CreateBlueELIcon](
	@ValidateOnly INT
)

AS
BEGIN

BEGIN TRAN


/**************************************************************************************************************************
-- CREATE A NOTIFICATION IF THEY CURRENTLY DO NOT HAVE ONE

***************************************************************************************************************************/

INSERT INTO rev.REV_PERSON_NOT

SELECT 
--SIS_NUMBER,
NEWID() AS PERSON_NOT_GU
,STU.STUDENT_GU AS PERSON_GU
,'256096C9-A40D-4654-8322-3E17FAF8EE2D' AS NOT_CFG_GU
,ELL.ADMIN_DATE AS BEGIN_DATE
,NULL AS END_DATE
,NULL AS COMMENT
,NULL AS CHANGE_DATE_TIME_STAMP
,NULL AS CHANGE_ID_STAMP
,GETDATE() AS ADD_DATE_TIME_STAMP
,'27CDCD0E-BF93-4071-94B2-5DB792BB735F' AS ADD_ID_STAMP
,'N' AS ADDED_BY_RULE
,NULL AS RULE_GU
,NULL AS COMMENT_DETAIL

FROM 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
LEFT JOIN 
(SELECT * FROM rev.REV_PERSON_NOT WHERE NOT_CFG_GU = '256096C9-A40D-4654-8322-3E17FAF8EE2D' AND END_DATE IS NULL
)  AS NOTE 
ON
NOTE.PERSON_GU = ELL.STUDENT_GU

INNER JOIN 
REV.epc_stu as stu
ON 
STU.STUDENT_GU = ELL.STUDENT_GU

WHERE

NOTE.PERSON_GU IS NULL



/**************************************************************************************************************************
-- CLOSE OUT ANY OPEN ELL NOTIFICATIONS IF THEY ARE NOT CURRENTLY ELL 

***************************************************************************************************************************/

UPDATE REV.REV_PERSON_NOT
SET END_DATE = GETDATE() , CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F', CHANGE_DATE_TIME_STAMP = GETDATE()

FROM 
(SELECT * FROM
(SELECT * FROM rev.REV_PERSON_NOT WHERE NOT_CFG_GU = '256096C9-A40D-4654-8322-3E17FAF8EE2D' AND END_DATE IS NULL)  AS NOTE
LEFT JOIN 
APS.ELLCalculatedAsOf(GETDATE()) AS ELL
ON
NOTE.PERSON_GU = ELL.STUDENT_GU

WHERE
ELL.STUDENT_GU IS NULL 
) AS T1

WHERE 
T1.PERSON_NOT_GU = REV.REV_PERSON_NOT.PERSON_NOT_GU



IF @ValidateOnly = 0
	BEGIN
		COMMIT 
	END
ELSE
	BEGIN
		ROLLBACK
	END
END -- END SPROC

GO
