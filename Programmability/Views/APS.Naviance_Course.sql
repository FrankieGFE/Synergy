--<APS - Naviance Course Catalog Data>
--Every active course in the district course master

CREATE VIEW
APS.NAVIANCE_COURSE
AS

SELECT
       crs.COURSE_ID AS [Course ID]
     , crs.COURSE_TITLE AS [Course Name]
     , crs.SUBJECT_AREA_1 AS [Subject Area]
     , crs.CREDIT AS [Credits]
-- 160 = 06, 220 = 12
     , case
         when crs.GRADE_RANGE_LOW = '160' THEN 'Y' 
         else 'N' 
       end                   AS [GR6]
     , case
         when crs.GRADE_RANGE_LOW = '170' THEN 'Y' 
         else 'N' 
       end                   AS [GR7]
     , case
         when crs.GRADE_RANGE_LOW = '180' THEN 'Y' 
         else 'N' 
       end                   AS [GR8]
     , case
         when crs.GRADE_RANGE_LOW = '190' THEN 'Y' 
         else 'N' 
       end                   AS [GR9]
     , case
         when crs.GRADE_RANGE_LOW = '200' THEN 'Y' 
         else 'N' 
       end                   AS [GR10]
     , case
         when crs.GRADE_RANGE_LOW = '210' THEN 'Y' 
         else 'N' 
       end                   AS [GR11]
     , case
         when crs.GRADE_RANGE_LOW = '220' THEN 'Y' 
         else 'N' 
       end                   AS [GR12]
     , case 
         when crs.INACTIVE = 'Y' then 'N' 
         else 'Y' 
       end                   AS [Status]
     , ''                    AS [Description]
     , crs.STATE_COURSE_CODE AS [State ID]
     , ''                    AS [Instructional Level]
     , ''                    AS [CTE]
     , ''                    AS [Tech_Prep]
FROM rev.EPC_CRS         crs