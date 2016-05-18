
DECLARE @X XML

SELECT @X = D
FROM OPENROWSET (BULK 'C:\test.xml', SINGLE_BLOB) AS XMLDATA(D)

DECLARE @hdoc INT

EXEC sp_xml_preparedocument @hdoc OUTPUT, @X

SELECT *
FROM OPENXML (@hdoc, '/Fines/Fine',1)
WITH (
	
	FineID int,
	FineSiteShortName varchar (100),
	FineDescription varchar (20)

)

EXEC sp_xml_removedocument @hdoc