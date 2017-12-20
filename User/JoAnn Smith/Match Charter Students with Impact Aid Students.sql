
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
	impactaid.STUDENT_GU,
	impactaid.LAST_NAME,
	impactaid.FIRST_NAME,
	impactaid.AGE,
	impactaid.HOH_FULL_NAME,
	impactaid.UNIT_ADDRESS,
	impactaid.MAILING_CSZ,
	impactaid.BIRTHDATE,
	impactaid.ETHNICITY,
	impactaid.GENDER,
	impactaid.SYNERGY_STUDENT_ID,
	impactaid.SYNERGY_LAST_NAME,
	impactaid.SYNERGY_FIRST_NAME,
	impactaid.SYNERGY_DOB,
	CASE
		when cast(charter.location_id as nvarchar (50)) is not null then cast(charter.location_id as nvarchar (50))
		else impactaid.enrolled_school
	 end as ENROLLED_SCHOOL
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from HousingDataForImpactAid.csv') 
impactaid
left join
    
	(
	select * from
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from CharterSchool.csv')) charter
		on cast(impactaid.synergy_student_id as nvarchar(10)) = cast(charter.state_id as nvarchar (10))
