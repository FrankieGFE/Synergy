/*
CREATE TABLE BilingualModelHours_2014_LastDay(
DST_NBR VARCHAR (4),
SCH_YR VARCHAR (4),
SCH_NBR VARCHAR (4),
SCH_NME VARCHAR (100),
ID_NBR VARCHAR (9),
GRDE VARCHAR (2),
GradeSort VARCHAR (5),
PHLOTE VARCHAR (1),
[English Evaluation] VARCHAR (100),
[English Score] VARCHAR (10),
[English Level] VARCHAR (100),
[Spanish Evaluation] VARCHAR (100),
[Spanish Score] VARCHAR (100),
[Spanish Level] VARCHAR (100),
[Funding Level] VARCHAR (100),
[Primary Language Name] VARCHAR (100),
[Student Name] VARCHAR (100),
[Bilingual Model] VARCHAR (100),
TotalHours VARCHAR (1),
COURSE VARCHAR (50),
CRS_DESCR VARCHAR (100),
SECT_ASG VARCHAR (10),
EMP_NBR VARCHAR (10),
[Teacher Name] VARCHAR (100),
TeacherBilingual VARCHAR (5),
TeacherESL VARCHAR (5),
[Course Tags] VARCHAR (100)
)
*/
/*
INSERT INTO BilingualModelHours_2012_40D
EXEC APS.LCEBilingualHoursAndModels'1','2012','20111012','%','detail'
*/
INSERT INTO BilingualModelHours_2012_80D
EXEC APS.LCEBilingualHoursAndModels'1','2012','20111201','%','detail'
INSERT INTO BilingualModelHours_2012_120D
EXEC APS.LCEBilingualHoursAndModels'1','2012','20120208','%','detail'
INSERT INTO BilingualModelHours_2012_LastDay
EXEC APS.LCEBilingualHoursAndModels'1','2012','20120525','%','detail'

INSERT INTO BilingualModelHours_2013_40D
EXEC APS.LCEBilingualHoursAndModels'1','2013','20121010','%','detail'
INSERT INTO BilingualModelHours_2013_80D
EXEC APS.LCEBilingualHoursAndModels'1','2013','20121203','%','detail'
INSERT INTO BilingualModelHours_2013_120D
EXEC APS.LCEBilingualHoursAndModels'1','2013','20130213','%','detail'
INSERT INTO BilingualModelHours_2013_LastDay
EXEC APS.LCEBilingualHoursAndModels'1','2013','20130522','%','detail'

INSERT INTO BilingualModelHours_2014_40D
EXEC APS.LCEBilingualHoursAndModels'1','2014','20131009','%','detail'
INSERT INTO BilingualModelHours_2014_80D
EXEC APS.LCEBilingualHoursAndModels'1','2014','20131202','%','detail'
INSERT INTO BilingualModelHours_2014_120D
EXEC APS.LCEBilingualHoursAndModels'1','2014','20140212','%','detail'
INSERT INTO BilingualModelHours_2014_LastDay
EXEC APS.LCEBilingualHoursAndModels'1','2014','20140522','%','detail'
