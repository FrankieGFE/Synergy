--<APS - Read180 - Teacher Addendum>
-- Addendum file to be joined - Fixed rows from a temp table
IF OBJECT_ID('tempdb..##TempStfAddendum') IS NOT NULL DROP TABLE ##TempStfAddendum
CREATE TABLE ##TempStfAddendum(
   [DISTRICT_USER_ID]  NVARCHAR(50) null
 , [SPS_ID]            NVARCHAR(50) null
 , [PREFIX]            NVARCHAR(50) null
 , [FIRST_NAME]        NVARCHAR(50) null
 , [LAST_NAME]         NVARCHAR(50) null
 , [TITLE]             NVARCHAR(50) null
 , [SUFFIX]            NVARCHAR(50) null
 , [EMAIL]             NVARCHAR(50) null
 , [USER_NAME]         NVARCHAR(50) null
 , [PASSWORD]          NVARCHAR(50) null
 , [SCHOOL_NAME]       NVARCHAR(50) null
 , [CLASS_NAME]        NVARCHAR(50) null
 , [LAST_COL]          NVARCHAR(50) null
 )
 -- Load the data into the temp table 
 BULK INSERT ##TempStfAddendum
    FROM 'D:\from 011-synergydb\Edupoint_Work\InterfacePackages\Read180\TEACHER_addendum.csv'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    )
