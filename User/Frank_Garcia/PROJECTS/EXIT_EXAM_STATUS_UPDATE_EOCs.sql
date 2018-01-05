USE Assessments
GO
--BEGIN TRAN


UPDATE
	[EOC_AIMS_SBA_AND_EOC]
SET [Algebra I 7 12 V001] =  EES.[Algebra I 7 12 V001]
	,[Algebra I 7 12 V003] =  EES.[Algebra I 7 12 V003]
	,[Algebra II 10 12 V002] = EES.[Algebra II 10 12 V002]
	,[Algebra II 10 12 V006] = EES.[Algebra II 10 12 V006]
	,[Anatomy Physiology 11 12 V002] = EES.[Anatomy Physiology 11 12 V002]
	,[Biology 9 12 V002] = EES.[Biology 9 12 V002]
	,[Biology 9 12 V003] = EES.[Biology 9 12 V003]
	,[Biology 9 12 V007] = EES.[Biology 9 12 V007]
	,[Chemistry 9 12 V001] = EES.[Chemistry 9 12 V001]
	,[Chemistry 9 12 V002] = EES.[Chemistry 9 12 V002]
	,[Chemistry 9 12 V003] = EES.[Chemistry 9 12 V003]
	,[Chemistry 9 12 V008] = EES.[Chemistry 9 12 V008]
	,[Economics 9 12 V001] = EES.[Economics 9 12 V001]
	,[Economics 9 12 V004] = EES.[Economics 9 12 V004]
	,[English Language Arts III Reading 11 11 V001] = EES.[English Language Arts III Reading 11 11 V001]
	,[English Language Arts III Reading 11 11 V002] = EES.[English Language Arts III Reading 11 11 V002]
	,[English Language Arts III Reading 11 11 V006] = EES.[English Language Arts III Reading 11 11 V006]
	,[English Language Arts III Writing 11 11 V001] = EES.[English Language Arts III Writing 11 11 V001]
	,[English Language Arts III Writing 11 11 V002] = EES.[English Language Arts III Writing 11 11 V002]
	,[English Language Arts III Writing 11 11 V006] = EES.[English Language Arts III Writing 11 11 V006]
	,[English Language Arts IV Reading 12 12 V001] = EES.[English Language Arts IV Reading 12 12 V001]
	,[English Language Arts IV Reading 11 11 V003] = EES.[English Language Arts IV Reading 11 11 V003]
	,[English Language Arts IV Writing 12 12 V001] = EES.[English Language Arts IV Writing 12 12 V001]
	,[English Language Arts IV Writing 12 12 V003] = EES.[English Language Arts IV Writing 12 12 V003]
	,[Environmental Science 10 12 V001] = EES.[Environmental Science 10 12 V001]
	,[Financial Literacy 9 12 V003] = EES.[Financial Literacy 9 12 V003]
	,[Geometry 9 12 V003] = EES.[Geometry 9 12 V003]
	,[Physics 9 12 V003] = EES.[Physics 9 12 V003]
	,[Pre-Calculus 9 12 V004] = EES.[Pre-Calculus 9 12 V004]
	,[New Mexico History 7 12 V001] = EES.[New Mexico History 7 12 V001]
	,[New Mexico 7 12 History V004] = EES.[New Mexico 7 12 History V004]
	,[New Mexico 7 12 History V001] = EES.[New Mexico 7 12 History V001]
	--,[NM History 7 12 V001] = EES.[NM History 7 12 V001]
	,[Spanish Language Arts III Reading 11 11 V001] = EES.[Spanish Language Arts III Reading 11 11 V001]
	,[Spanish Language Arts III Writing 11 11 V001] = EES.[Spanish Language Arts III Writing 11 11 V001]
	,[US Government Comprehensive 9 12 V001] = EES.[US Government Comprehensive 9 12 V001]
	,[US Government Comprehensive 9 12 V002] = EES.[US Government Comprehensive 9 12 V002]
	,[US Government Comprehensive 9 12 V005] = EES.[US Government Comprehensive 9 12 V005]
    ,[US History 9 12 V002] = EES.[US History 9 12 V002]
	,[US History 9 12 V001] = EES.[US History 9 12 V001]
	,[US History 9 12 V007] = EES.[US History 9 12 V007]
	,[World History And Geography 9 12 V001] = EES.[World History And Geography 9 12 V001]
	,[World History And Geography 9 12 V003] = EES.[World History And Geography 9 12 V003]
FROM
	[EOC_AIMS_SBA_AND_EOC] AS EOC
	INNER JOIN
	[EOC_AIMS_FROM_EOC_] AS EES
	ON EOC.[ID_NBR] = EES.[ID NUMBER]

--ROLLBACK