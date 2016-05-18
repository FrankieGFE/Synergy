
WITH XmlFile (Contents) AS (
SELECT CONVERT (XML, BulkColumn) 
FROM OPENROWSET (BULK 'C:\test.xml', SINGLE_BLOB) AS XmlData
)
SELECT *
FROM XmlFile
GO

