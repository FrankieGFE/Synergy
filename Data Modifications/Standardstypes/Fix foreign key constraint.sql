USE ST_Experiment
GO

/*
*	Created by: Dennis Ackerman
*  Date: 6/24/2014
*
*	Used to fix update 9.0.1.0 Error:  " The ALTER TABLE statement conflicted with the FOREIGN KEY constraint "EGB_STANDARDS_NEW_F3".  
*	The conflict occurred in database "ST_Experiment", table "rev.EGB_STANDARDSTYPES", column 'ID'.  
*
*	Cause of error:  Shayne SQL/Accessed records for standardized grading.
*/

SET identity_insert rev.EGB_STANDARDSTYPES ON

INSERT INTO rev.EGB_STANDARDSTYPES (ID, STANDARDTYPE, ISVISIBLE, GRADEBOOKSCORETYPEID, AGGMETHOD, LOCKAGGMETHOD)
SELECT DISTINCT STANDARDSTYPEID
      , 'Deleted Standards Type - ' + cast(STANDARDSTYPEID AS varchar(5))
      , 'N'
      , 1
      , 'PowerLaw'
      , 'N' 
FROM rev.EGB_STANDARDS_NEW
WHERE STANDARDSTYPEID not in (
      SELECT ID 
      FROM rev.EGB_STANDARDSTYPES
      )
      
SET identity_insert rev.EGB_STANDARDSTYPES OFF
