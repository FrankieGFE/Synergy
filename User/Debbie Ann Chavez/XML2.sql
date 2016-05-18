
--OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=D:\SQLWorkingFiles;', 'SELECT * from "EngProf.csv"')
--		AS CSVFILE

CREATE DATABASE OPENXMLTesting
GO


USE OPENXMLTesting
GO


CREATE TABLE XMLwithOpenXML
(
Id INT IDENTITY PRIMARY KEY,
XMLData XML,
LoadedDateTime DATETIME
)


INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK 'D:\SQLWorkingFiles\OpenXMLTesting.xml', SINGLE_BLOB) AS x;


SELECT * FROM XMLwithOpenXML