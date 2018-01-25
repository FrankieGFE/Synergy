
/**********************************************************************************************
Created by Debbie Ann Chavez
Date 1/12/2017

Delete Student notification for ELL due to some error, test should have never been taken, etc. 
Normally - The assessment needs to be deleted and the ELL record then the notification.  
Then the next day the "E" icon should be gone.  


***********************************************************************************************/


-- the ELL Rule ends in DD, if there are more than one notification.

SELECT NOTE.* FROM 
rev.REV_PERSON_NOT AS NOTe
INNER JOIN 
REV.epc_stu as stu
ON 
NOTE.PERSON_GU = STU.STUDENT_GU
WHERE
SIS_NUMBER = 980043540 

/*
DELETE rev.REV_PERSON_NOT
WHERE
PERSON_NOT_GU = 'DF8E3F1F-08DF-4C34-B5A6-EADDA8351C5D'
*/
