USE [SchoolNet]
GO

SELECT [rptStudID]
      ,[NASISID]
      ,[DisCode]
      ,[SchCode]
      ,[SendDisCode]
      ,[SendSchCode]
      ,[StuGrade]
      ,[Grade]
      --,[LName]
      --,[FName]
      --,[MI]
      --,[DOB]
      ,[Gender]
      ,[Ethnicity]
      ,[ELL]
      ,[Bilingual]
      ,[SpecialED]
      ,[Migrant]
      ,[EconDis]
      ,SBA.[Gifted]
      ,[Plan504]
      ,[Title1]
      ,[NewArrival]
      --,[BookletID]
      --,[TestDate]
      ,[TestLanguage]
      ,[Braille]
      ,[SocForm]
      ,[MathForm]
      ,[ReadForm]
      ,[WriForm]
      ,[SciForm]
      ,[SpanishParentReport]
      ,[SocMC]
      ,[MathMC]
      ,[ReadMC]
      ,[WriMC]
      ,[SciMC]
      ,[SocTC]
      ,[MathTC]
      ,[ReadTC]
      ,[WriTC]
      ,[SciTC]
      --,[TeacherInfo]
      --,[ELLMatAccom20]
      --,[ELLMatAccom21]
      --,[ELLMatAccom22]
      --,[ELLMatAccom23]
      --,[ELLMatAccom24]
      --,[ELLMatAccom25]
      --,[ELLMatAccom26]
      --,[ELLMatAccom27]
      --,[ELLMatAccom28]
      --,[ELLReaAccom21]
      --,[ELLReaAccom22]
      --,[ELLReaAccom23]
      --,[ELLReaAccom24]
      --,[ELLReaAccom25]
      --,[ELLReaAccom26]
      --,[ELLReaAccom28]
      --,[ELLWriAccom20]
      --,[ELLWriAccom22]
      --,[ELLWriAccom23]
      --,[ELLWriAccom26]
      --,[ELLWriAccom27]
      --,[ELLWriAccom28]
      --,[ELLSciAccom20]
      --,[ELLSciAccom21]
      --,[ELLSciAccom22]
      --,[ELLSciAccom23]
      --,[ELLSciAccom24]
      --,[ELLSciAccom25]
      --,[ELLSciAccom26]
      --,[ELLSciAccom27]
      --,[ELLSciAccom28]
      --,[SWDMatAccom01]
      --,[SWDMatAccom02]
      --,[SWDMatAccom03]
      --,[SWDMatAccom04]
      --,[SWDMatAccom05]
      --,[SWDMatAccom06]
      --,[SWDMatAccom07]
      --,[SWDMatAccom08]
      --,[SWDMatAccom09]
      --,[SWDMatAccom10]
      --,[SWDMatAccom11]
      --,[SWDMatAccom12]
      --,[SWDMatAccom13]
      --,[SWDMatAccom14]
      --,[SWDMatAccom15]
      --,[SWDReaAccom01]
      --,[SWDReaAccom02]
      --,[SWDReaAccom03]
      --,[SWDReaAccom05]
      --,[SWDReaAccom06]
      --,[SWDReaAccom07]
      --,[SWDReaAccom09]
      --,[SWDReaAccom10]
      --,[SWDReaAccom11]
      --,[SWDReaAccom12]
      --,[SWDReaAccom13]
      --,[SWDReaAccom14]
      --,[SWDReaAccom15]
      --,[SWDWriAccom01]
      --,[SWDWriAccom02]
      --,[SWDWriAccom03]
      --,[SWDWriAccom04]
      --,[SWDWriAccom05]
      --,[SWDWriAccom06]
      --,[SWDWriAccom07]
      --,[SWDWriAccom09]
      --,[SWDWriAccom10]
      --,[SWDWriAccom11]
      --,[SWDWriAccom12]
      --,[SWDWriAccom13]
      --,[SWDWriAccom14]
      --,[SWDWriAccom15]
      --,[SWDSciAccom01]
      --,[SWDSciAccom02]
      --,[SWDSciAccom03]
      --,[SWDSciAccom04]
      --,[SWDSciAccom05]
      --,[SWDSciAccom06]
      --,[SWDSciAccom07]
      --,[SWDSciAccom09]
      --,[SWDSciAccom10]
      --,[SWDSciAccom11]
      --,[SWDSciAccom12]
      --,[SWDSciAccom13]
      --,[SWDSciAccom14]
      --,[SWDSciAccom15]
      ,[FAYState]
      ,[FAYDistrict]
      ,[FAYSchool]
      --,[ReaCBT]
      --,[MatCBT]
      --,[WriCBT]
      --,[SciCBT]
      ,[MathRawScore]
      ,[MathScaleScore]
      ,[MathPerformanceLevel]
      ,[MathSEM]
      ,[MathSEMLower]
      ,[MathSEMUpper]
      ,[ReadRawScore]
      ,[LexileScore]
      ,[ReadScaleScore]
      ,[ReadPerformanceLevel]
      ,[ReadSEM]
      ,[ReadSEMLower]
      ,[ReadSEMUpper]
      ,[WriRawScore]
      ,[WriScaleScore]
      ,[WriPerformanceLevel]
      ,[WriSEM]
      ,[WriSEMLower]
      ,[WriSEMUpper]
      ,[SciRawScore]
      ,[SciScaleScore]
      ,[SciPerformanceLevel]
      ,[SciSEM]
      ,[SciSEMLower]
      ,[SciSEMUpper]
      ,[SocRawScore]
      ,[SocScaleScore]
      ,[SocPerformanceLevel]
      ,[SocSEM]
      ,[SocSEMLower]
      ,[SocSEMUpper]
      ,[MathRepCat1]
      ,[MathRepCat2]
      ,[MathRepCat3]
      ,[MathRepCat4]
      ,[MathRepCat5]
      ,[ReadRepCat1]
      ,[ReadRepCat2]
      ,[ReadRepCat3]
      ,[ReadRepCat4]
      ,[SciRepCat1]
      ,[SciRepCat2]
      ,[SciRepCat3]
      ,[SciRepCat4]
      ,[SciRepCat5]
      ,[SocRepCat1]
      ,[SocRepCat2]
      ,[SocRepCat3]
      ,[SocRepCat4]
      ,[SocRepCat5]
      ,[SocRepCat6]
      ,[WriRepCat1]
      ,[WriRepCat2]
      ,[MathRepCat1_PerfClass]
      ,[MathRepCat2_PerfClass]
      ,[MathRepCat3_PerfClass]
      ,[MathRepCat4_PerfClass]
      ,[MathRepCat5_PerfClass]
      ,[ReadRepCat1_PerfClass]
      ,[ReadRepCat2_PerfClass]
      ,[ReadRepCat3_PerfClass]
      ,[ReadRepCat4_PerfClass]
      ,[SciRepCat1_PerfClass]
      ,[SciRepCat2_PerfClass]
      ,[SciRepCat3_PerfClass]
      ,[SciRepCat4_PerfClass]
      ,[SciRepCat5_PerfClass]
      ,[WriRepCat1_PerfClass]
      ,[WriRepCat2_PerfClass]
  FROM [180-SMAXODS-01].SCHOOLNET.[dbo].[SBA_Spring_StudentFile_2014] AS SBA
  --LEFT JOIN
  --[046-WS02].DB_STARS_HISTORY.DBO.STUDENT AS STUD
  --ON SBA.NASISID = STUD.[ALTERNATE STUDENT ID]
  --AND STUD.SY = '2014'
GO

