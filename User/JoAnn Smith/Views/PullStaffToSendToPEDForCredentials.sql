/*
View in Lawson
aps.PullStaffToSendToPEDForCredentials
This was created to duplicate a file that PED needs
including filler fields.  The original view is
aps.PullStaffToSendToStateForCredentials which is
no longer used but which was modified to create this
view.
Created by:	JoAnn Smith
Date:		8/4/2017

*/

alter VIEW [APS].[PullStaffToSendToPEDForCredentials] AS



with TeacherCTE
as
(

/*
SSN
NAME
DOB
EMAIL
GENDER
ETHNICITY
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--PULLS ALL TEACHERS
--------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT distinct
		'001' AS DISTRICT_CODE,
		LEFT(REPLACE(EMP.FICA_NBR, '-', ''),9) AS STATEID,
		EMP.EMPLOYEE,
		EMP_STATUS,
		'' AS LIC_NUMBER,
		LEFT(EMP.MIDDLE_NAME,1) AS MIDDLE_INITIAL,
		'' AS F7,
		'' AS F8,
		'' AS F9,
		'' AS F10,
		'' AS F11,
		'' AS F12,
		'' AS F13,
		CASE WHEN (SUBSTRING(TEACH.USER_LEVEL,2,3)) in ('000', '004', '006', '007', '013', '015', '016', '017', '024', '025', '026', '027', '028', '030', '031', '038',
			 '039', '047', '051', '061', '063', '069', '090', '093', '095', '098', '101', '114', '115', '116', '118', '125', '130', '290',  '992', '993') THEN '000'
		ELSE
			(SUBSTRING(TEACH.USER_LEVEL,2,3))
		END AS LOCATION,
		'' AS F15,
		'' AS F16,
		'' AS F17,
		'' AS F18,
		'' AS F19,
		PEMP.SEX AS GENDER_CODE, 
		CASE WHEN PEMP.EEO_CLASS = 'WH' THEN 'C'
			WHEN PEMP.EEO_CLASS = 'BL' THEN 'B'
			WHEN PEMP.EEO_CLASS = 'AP' THEN 'I'
			WHEN PEMP.EEO_CLASS = 'AA' THEN 'A'
			WHEN PEMP.EEO_CLASS = 'HI' THEN 'Y'
		ELSE 'C' END AS ETHNIC_CODE_SHORT,
		'' AS F22,
		'' AS F23,
		'' AS F24,
		'' AS F25,
		'' AS F26,
		'' AS F27,
		'' AS F28,
		'' AS F29,
		'' AS F30,
		'' AS F31,
		'' AS F32,
		'' AS F33,
		CAST(DATE_HIRED AS DATE) AS EMP_DATE_HIRED,
		'' AS F34,
		CAST(TEACH.EFFECT_DATE AS DATE) AS WSC_START_DATE,
		CAST(TEACH.END_DATE AS DATE) AS EXIT_DATE,
		'' AS F37,
		'' AS F38,
		0 AS YEARS_EXPERIENCE,
		CAST(PEMP.BIRTHDATE AS DATE) AS BIRTHDATE,
		'' AS F41,
		'' AS F42,
		0 AS YEARS_EXPERIENCE_IN_DIS,
		'' AS F44,
		'B' AS HIGHEST_DEGREE_EARNED,
		'' AS F46,
		'' AS F47,
		'C' AS STAFF_QUALIFICATION_STA,
		'' AS F49,
		'' AS F50,
		'' AS F51,
		10000 AS ANNUAL_SALARY,
		'' AS F53,
		'' AS TERMINATION_CODE,
		'' AS F55,
		'' AS F56,
		'' AS F57,
		'' AS F58,
		'' AS F59,
		'' AS F60,
		'' AS F61,
		'' AS F62,
		'' AS F63,
		'' AS F64,
		EMP.FIRST_NAME AS FIRST_NAME_LONG,
		EMP.LAST_NAME AS LAST_NAME_LONG,
		'' AS F67,
		'' AS F68,
		CASE WHEN PEMP.EEO_CLASS = 'HI' THEN 'Y'
		ELSE
		'N'
		END AS HISPANIC_INDICATOR,
		CASE 
			WHEN PEMP.EEO_CLASS = 'I' THEN '23'
		ELSE
			'00' 
		END AS RACE_OR_ETHNICITY_SUBGROUP,
		'55' AS HIGHEST_DEGREE_INST,
		'55' AS BACCALAUREATE_DEG_INST,
		'' AS F73,
		'' AS F74,
		'' AS F75,
		CASE	
			WHEN EMP.EMAIL_ADDRESS IS NULL THEN LTRIM(RTRIM(EMP.FIRST_NAME))+ '.' + LTRIM(RTRIM(EMP.LAST_NAME)) + '@APS.EDU'
			WHEN EMP.EMAIL_ADDRESS = '' THEN LTRIM(RTRIM(EMP.FIRST_NAME)) + '.' + LTRIM(RTRIM(EMP.LAST_NAME)) + '@APS.EDU'
		else
			EMP.EMAIL_ADDRESS
		end	 AS EMAIL_ADDRESS,
		'' AS F77,
		'' AS RACE_2_CODE,
		'' AS RACE_3_CODE,
		'' AS RACE_4_CODE,
		'' AS RACE_5_CODE
FROM
APS.CurrentActiveTeachers AS TEACH
INNER JOIN
Employee AS EMP
ON
TEACH.EMPLOYEE = EMP.EMPLOYEE
INNER JOIN
Paemployee AS PEMP
ON
EMP.EMPLOYEE = PEMP.EMPLOYEE

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--PULLS ALL EA's
--------------------------------------------------------------------------------------------------------------------------------------------------------------

UNION ALL 

SELECT distinct
		'001' AS DISTRICT_CODE,
		LEFT(REPLACE(EMP.FICA_NBR, '-', ''),9) AS STATEID,
		EMP.EMPLOYEE,
		EMP_STATUS,
		'' AS LIC_NUMBER,
		LEFT(EMP.MIDDLE_NAME,1) AS MIDDLE_INITIAL,
		'' AS F7,
		'' AS F8,
		'' AS F9,
		'' AS F10,
		'' AS F11,
		'' AS F12,
		'' AS F13,
		CASE
			 WHEN (SUBSTRING(TEACH.USER_LEVEL,2,3)) in ('000', '004', '006', '007', '013', '015', '016', '017', '024', '025', '026', '027', '028', '030', '031', '038',
			 '039', '047', '051', '061', '063', '069', '090', '093', '095', '098', '101', '114', '115', '116', '118', '125', '130', '290',  '992', '993') THEN '000'
		ELSE
			(SUBSTRING(TEACH.USER_LEVEL,2,3))
		END AS LOCATION,
		'' AS F15,
		'' AS F16,
		'' AS F17,
		'' AS F18,
		'' AS F19,
		PEMP.SEX AS GENDER_CODE, 
		CASE WHEN PEMP.EEO_CLASS = 'WH' THEN 'C'
			WHEN PEMP.EEO_CLASS = 'BL' THEN 'B'
			WHEN PEMP.EEO_CLASS = 'AP' THEN 'I'
			WHEN PEMP.EEO_CLASS = 'AA' THEN 'A'
			WHEN PEMP.EEO_CLASS = 'HI' THEN 'Y'
		ELSE 'C' END AS ETHNIC_CODE_SHORT,
		'' AS F22,
		'' AS F23,
		'' AS F24,
		'' AS F25,
		'' AS F26,
		'' AS F27,
		'' AS F28,
		'' AS F29,
		'' AS F30,
		'' AS F31,
		'' AS F32,
		'' AS F33,
		CAST(DATE_HIRED AS DATE) AS EMP_DATE_HIRED,
		'' AS F34,
		CAST(TEACH.EFFECT_DATE AS DATE) AS WSC_START_DATE,
		CAST(TEACH.END_DATE AS DATE) AS EXIT_DATE,
		'' AS F37,
		'' AS F38,
		0 AS YEARS_EXPERIENCE,
		CAST(PEMP.BIRTHDATE AS DATE) AS BIRTHDATE,
		'' AS F41,
		'' AS F42,
		0 AS YEARS_EXPERIENCE_IN_DIS,
		'' AS F44,
		'B' AS HIGHEST_DEGREE_EARNED,
		'' AS F46,
		'' AS F47,
		'C' AS STAFF_QUALIFICATION_STA,
		'' AS F49,
		'' AS F50,
		'' AS F51,
		10000 AS ANNUAL_SALARY,
		'' AS F53,
		'' AS TERMINATION_CODE,
		'' AS F55,
		'' AS F56,
		'' AS F57,
		'' AS F58,
		'' AS F59,
		'' AS F60,
		'' AS F61,
		'' AS F62,
		'' AS F63,
		'' AS F64,
		EMP.FIRST_NAME AS FIRST_NAME_LONG,
		EMP.LAST_NAME AS LAST_NAME_LONG,
		'' AS F67,
		'' AS F68,
		CASE WHEN PEMP.EEO_CLASS = 'HI' THEN 'Y'
		ELSE
		'N'
		END AS HISPANIC_INDICATOR,
		CASE 
			WHEN PEMP.EEO_CLASS = 'I' THEN '23'
		ELSE
			'00' 
		END AS RACE_OR_ETHNICITY_SUBGROUP,
		'55' AS HIGHEST_DEGREE_INST,
		'55' AS BACCALAUREATE_DEG_INST,
		'' AS F73,
		'' AS F74,
		'' AS F75,
		CASE	
			WHEN EMP.EMAIL_ADDRESS IS NULL THEN LTRIM(RTRIM(EMP.FIRST_NAME)) + '.' + LTRIM(RTRIM(EMP.LAST_NAME)) + '@APS.EDU'
			WHEN EMP.EMAIL_ADDRESS = '' THEN LTRIM(RTRIM(EMP.FIRST_NAME)) + '.' + LTRIM(RTRIM(EMP.LAST_NAME)) + '@APS.EDU'
		else
			EMP.EMAIL_ADDRESS
		end	 AS EMAIL_ADDRESS,
		'' AS F77,
		'' AS RACE_2_CODE,
		'' AS RACE_3_CODE,
		'' AS RACE_4_CODE,
		'' AS RACE_5_CODE
FROM
APS.CurrentActiveEAs AS TEACH
INNER JOIN
Employee AS EMP
ON
TEACH.EMPLOYEE = EMP.EMPLOYEE
INNER JOIN
Paemployee AS PEMP
ON
EMP.EMPLOYEE = PEMP.EMPLOYEE

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--PULLS ALL SUBS
--------------------------------------------------------------------------------------------------------------------------------------------------------------

UNION ALL 

SELECT distinct
		'001' AS DISTRICT_CODE,
		LEFT(REPLACE(EMP.FICA_NBR, '-', ''),9) AS STATEID,
		EMP.EMPLOYEE,
		EMP_STATUS,
		'' AS LIC_NUMBER,
		LEFT(EMP.MIDDLE_NAME,1) AS MIDDLE_INITIAL,
		'' AS F7,
		'' AS F8,
		'' AS F9,
		'' AS F10,
		'' AS F11,
		'' AS F12,
		'' AS F13,
		CASE WHEN (SUBSTRING(TEACH.USER_LEVEL,2,3)) in ('000', '004', '006', '007', '013', '015', '016', '017', '024', '025', '026', '027', '028', '030', '031', '038',
			 '039', '047', '051', '061', '063', '069', '090', '093', '095', '098', '101', '114', '115', '116', '118', '125', '130', '290',  '992', '993') THEN '000'
		ELSE
			(SUBSTRING(TEACH.USER_LEVEL,2,3))
		END AS LOCATION,
		'' AS F15,
		'' AS F16,
		'' AS F17,
		'' AS F18,
		'' AS F19,
		PEMP.SEX AS GENDER_CODE, 
		CASE WHEN PEMP.EEO_CLASS = 'WH' THEN 'C'
			WHEN PEMP.EEO_CLASS = 'BL' THEN 'B'
			WHEN PEMP.EEO_CLASS = 'AP' THEN 'I'
			WHEN PEMP.EEO_CLASS = 'AA' THEN 'A'
			WHEN PEMP.EEO_CLASS = 'HI' THEN 'Y'
		ELSE 'C' END AS ETHNIC_CODE_SHORT,
		'' AS F22,
		'' AS F23,
		'' AS F24,
		'' AS F25,
		'' AS F26,
		'' AS F27,
		'' AS F28,
		'' AS F29,
		'' AS F30,
		'' AS F31,
		'' AS F32,
		'' AS F33,
		CAST(DATE_HIRED AS DATE) AS EMP_DATE_HIRED,
		'' AS F34,
		CAST(TEACH.EFFECT_DATE AS DATE) AS WSC_START_DATE,
		CAST(TEACH.END_DATE AS DATE) AS EXIT_DATE,
		'' AS F37,
		'' AS F38,
		0 AS YEARS_EXPERIENCE,
		CAST(PEMP.BIRTHDATE AS DATE) AS BIRTHDATE,
		'' AS F41,
		'' AS F42,
		0 AS YEARS_EXPERIENCE_IN_DIS,
		'' AS F44,
		'B' AS HIGHEST_DEGREE_EARNED,
		'' AS F46,
		'' AS F47,
		'C' AS STAFF_QUALIFICATION_STA,
		'' AS F49,
		'' AS F50,
		'' AS F51,
		10000 AS ANNUAL_SALARY,
		'' AS F53,
		'' AS TERMINATION_CODE,
		'' AS F55,
		'' AS F56,
		'' AS F57,
		'' AS F58,
		'' AS F59,
		'' AS F60,
		'' AS F61,
		'' AS F62,
		'' AS F63,
		'' AS F64,
		EMP.FIRST_NAME AS FIRST_NAME_LONG,
		EMP.LAST_NAME AS LAST_NAME_LONG,
		'' AS F67,
		'' AS F68,
		CASE WHEN PEMP.EEO_CLASS = 'HI' THEN 'Y'
		ELSE
		'N' 
		END AS HISPANIC_INDICATOR,
		CASE 
			WHEN PEMP.EEO_CLASS = 'I' THEN '23'
		ELSE
			'00' 
		END AS RACE_OR_ETHNICITY_SUBGROUP,
		'55' AS HIGHEST_DEGREE_INST,
		'55' AS BACCALAUREATE_DEG_INST,
		'' AS F73,
		'' AS F74,
		'' AS F75,
		CASE	
			WHEN EMP.EMAIL_ADDRESS IS NULL THEN LTRIM(RTRIM(EMP.FIRST_NAME)) + '.' + LTRIM(RTRIM(EMP.LAST_NAME)) + '@APS.EDU'
			WHEN EMP.EMAIL_ADDRESS = '' THEN LTRIM(RTRIM(EMP.FIRST_NAME)) + '.' + LTRIM(RTRIM(EMP.LAST_NAME)) + '@APS.EDU'
		else
			EMP.EMAIL_ADDRESS
		end	 AS EMAIL_ADDRESS,
		'' AS F77,
		'' AS RACE_2_CODE,
		'' AS RACE_3_CODE,
		'' AS RACE_4_CODE,
		'' AS RACE_5_CODE
 FROM
APS.CurrentActiveSubs AS TEACH
INNER JOIN
Employee AS EMP
ON
TEACH.EMPLOYEE = EMP.EMPLOYEE
INNER JOIN
Paemployee AS PEMP
ON
EMP.EMPLOYEE = PEMP.EMPLOYEE
)

--select * from TeacherCTE
,CTE_ETHNIC
as
(
select
	row_number() over(partition by t.employee order by t.employee) as RN,
	T.DISTRICT_CODE,
	T.STATEID,
	T.EMPLOYEE,
	T.EMP_STATUS,
	T.LIC_NUMBER,
	T.MIDDLE_INITIAL,
	T.F7,
	T.F8,
	T.F9,
	T.F10,
	T.F11,
	T.F12,
	T.F13,
	T.LOCATION,
	T.F15,
	T.F16,
	T.F17,
	T.F18,
	T.F19,
	T.GENDER_CODE,
	CASE 
		WHEN T.ETHNIC_CODE_SHORT = 'Y' THEN 'C'
	ELSE
		T.ETHNIC_CODE_SHORT
	END AS ETHNIC_CODE_SHORT,
	T.F22,
	T.F23,
	T.F24,
	T.F25,
	T.F26,
	T.F27,
	T.F28,
	T.F29,
	T.F30,
	T.F31,
	T.F32,
	T.F33,
	T.EMP_DATE_HIRED,
	T.F34,
	T.WSC_START_DATE,
	T.EXIT_DATE,
	T.F37,
	T.F38,
	T.YEARS_EXPERIENCE,
	T.BIRTHDATE,
	T.F41,
	T.F42,
	T.YEARS_EXPERIENCE_IN_DIS,
	T.F44,
	T.HIGHEST_DEGREE_EARNED,
	T.F46,
	T.F47,
	T.STAFF_QUALIFICATION_STA,
	T.F49,
	T.F50,
	T.F51,
	T.ANNUAL_SALARY,
	T.F53,
	T.TERMINATION_CODE,
	T.F55,
	T.F56,
	T.F57,
	T.F58,
	T.F59,
	T.F60,
	T.F61,
	T.F62,
	T.F63,
	T.F64,
	T.FIRST_NAME_LONG,
	T.LAST_NAME_LONG,
	T.F67,
	T.F68,
	T.HISPANIC_INDICATOR,
	CASE WHEN ETHNIC_CODE_SHORT = 'I' THEN '23'
	END AS RACE_OR_ETHNICITY_SUBGROUP,
	T.HIGHEST_DEGREE_INST,
	T.BACCALAUREATE_DEG_INST,
	T.F73,
	T.F74,
	T.F75,
	T.EMAIL_ADDRESS,
	T.F77,
	T.RACE_2_CODE,
	T.RACE_3_CODE,
	T.RACE_4_CODE,
	T.RACE_5_CODE
from
	TeacherCTE T
)
SELECT * FROM CTE_ETHNIC where rn = 1 








