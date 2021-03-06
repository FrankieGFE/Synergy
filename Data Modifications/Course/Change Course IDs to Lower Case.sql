/*
*	Created By:  Debbie ANn Chavez
*	Date:  7/2/2014
*
*	Change all Course ID's containing alphanumeric characters to LOWER CASE
*
*	This was because the entire Course ID does not fit on the transcript.
*/

USE ST_Functional
GO

BEGIN TRANSACTION

UPDATE rev.EPC_CRS
	
	SET COURSE_ID = LOWER(COURSE_ID)

FROM

/*
SELECT  [COURSE_GU]
      ,[SCHOOL_TYPE]
      ,LOWER([COURSE_ID] )
      ,[COURSE_TITLE]
      ,[COURSE_SHORT_TITLE]
 
*/
  	  [ST_Functional].[rev].[EPC_CRS]
  WHERE 
	 ISNUMERIC(COURSE_ID) <>1

ROLLBACK


