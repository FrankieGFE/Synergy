--This script will update all teachers
--and will change the setting within Grade Book Setup > Grade Book Settings
--to Check the box (true) or Uncheck the box (false) to 'Inherit Assignments from District Grade Books'

begin tran
UPDATE rev.EGB_CONFIGUSER
SET    CONFIG_VALUE = 'False'	--Update as necessary to True (Check) or False (Uncheck)
WHERE  CONFIGID IN (SELECT id
                    FROM   rev.EGB_CONFIG
                    WHERE  CONFIG = 'boolDistrictGB') 
commit
