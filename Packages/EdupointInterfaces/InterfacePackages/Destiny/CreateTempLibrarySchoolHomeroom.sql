--<APS - Destiny - LibrarySchoolHomeroom helper file>
-- Addendum file to be joined - Fixed rows from a temp table
IF OBJECT_ID('tempdb..##LibSchHomeroom') IS NOT NULL DROP TABLE ##LibSchHomeroom
CREATE TABLE ##LibSchHomeroom(
   [SCHOOL_CODE]                    NVARCHAR(50) null
 , [HOMEROOM_PERIOD_NUMBER]         NVARCHAR(50) null
 )
 ---- Load the data into the temp table 
 --BULK INSERT ##LibSchHomeroom
 --   FROM 'C:\work\clients\NM_Albuquerque\Destiny\LibrarySchoolHomeroom.txt'
 --   WITH
 --   (
 --   FIELDTERMINATOR = '\t',
 --   ROWTERMINATOR = '\n'
 --   )
