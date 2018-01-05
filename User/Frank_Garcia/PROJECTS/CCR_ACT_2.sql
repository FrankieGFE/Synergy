

UPDATE
	CCR
SET
	CCR.APS_ID = TID.APS_ID
	,CCR.State_ID = TID.STATE_ID
FROM
	[ACT_2012-2013_LookUp] AS TID
INNER JOIN
	CCR_ACT AS CCR	
ON
	CCR.F_Name = TID.F_Name	
	AND CCR.L_Name = TID.L_Name
	AND CCR.MI = TID.MI
	AND CCR.Grade = TID.Grade
	AND CCR.DOB_NEW = TID.DOB_NEW
	AND CCR.Test_Date = TID.Test_Date
	AND CCR.English = TID.English
	AND CCR.Math = TID.Math
	AND CCR.Science = TID.Science
	AND CCR.Reading = TID.Reading
	AND CCR.SocStud_Science = TID.SocStud_Science
WHERE TID.APS_ID != ''

