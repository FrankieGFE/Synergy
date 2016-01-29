--WHOISACTIVE TABLE CREATE

DECLARE @destination_table VARCHAR(4000) ;
SET @destination_table = 'WhoIsActive_' + CONVERT(VARCHAR, GETDATE(), 112) ;

DECLARE @schema VARCHAR(4000) ;
EXEC sp_WhoIsActive
@get_transaction_info = 1,
@get_plans = 1,
@find_block_leaders = 1,
@RETURN_SCHEMA = 1,
@SCHEMA = @schema OUTPUT ;

SET @schema = REPLACE(@schema, '<table_name>', @destination_table) ;

PRINT @schema
EXEC(@schema) ;
