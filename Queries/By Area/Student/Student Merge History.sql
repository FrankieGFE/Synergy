
/*Created by Debbie Ann Chavez
	Date:  5/6/2015

Quick query to pull Merge History data *all records*

*/

SELECT SIS_NUMBER,[MERGE].* FROM
rev.UD_UD_EPC_STU_MERGE_HISTORY AS [MERGE]
INNER JOIN
rev.EPC_STU AS STU
ON
[MERGE].STUDENT_GU = STU.STUDENT_GU

