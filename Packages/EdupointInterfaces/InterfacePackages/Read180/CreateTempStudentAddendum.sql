--<APS - Read180 - Students>
-- Addendum file to be joined - Fixed rows from a temp table
IF OBJECT_ID('tempdb..##TempStuAddendum') IS NOT NULL DROP TABLE ##TempStuAddendum
CREATE TABLE ##TempStuAddendum(
   [USER_NAME]                    NVARCHAR(50) null
 , [PASSWORD]                     NVARCHAR(50) null
 , [SIS_ID]                       NVARCHAR(50) null
 , [FIRST_NAME]                   NVARCHAR(50) null
 , [MIDDLE_NAME]                  NVARCHAR(50) null
 , [LAST_NAME]                    NVARCHAR(50) null
 , [GRADE]                        NVARCHAR(50) null
 , [SCHOOL_NAME]                  NVARCHAR(50) null
 , [CLASS_NAME]                   NVARCHAR(50) null
 , [ETHNIC_CAUCASIAN]             NVARCHAR(50) null
 , [ETHNIC_AFRICAN_AM]            NVARCHAR(50) null
 , [ETHNIC_HISPANIC]              NVARCHAR(50) null
 , [ETHNIC_PACIFIC_ISL]           NVARCHAR(50) null
 , [ETHNIC_AM_IND_AK_NATIVE]      NVARCHAR(50) null
 , [ETHNIC_ASIAN]                 NVARCHAR(50) null
 , [GENDER_MALE]                  NVARCHAR(50) null
 , [GENDER_FEMALE]                NVARCHAR(50) null
 , [AYP_ECON_DISADVANTAGED]       NVARCHAR(50) null
 , [AYP_LTD_ENGLISH_PROFICIENCY]  NVARCHAR(50) null
 , [AYP_GIFTED_TALENTED]          NVARCHAR(50) null
 , [AYP_MIGRANT]                  NVARCHAR(50) null
 , [LAST_COL]                     NVARCHAR(50) null
 )
 -- Load the data into the temp table 
 BULK INSERT ##TempStuAddendum
    FROM 'D:\from 011-synergydb\Edupoint_Work\InterfacePackages\Read180\Student_addendum.csv'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    )
