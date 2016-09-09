CREATE PROCEDURE [dbo].[p_create_table_from_procedure]
    @TABLE_NAME AS NVARCHAR(MAX),
    @PROCEDURE_NAME AS NVARCHAR(MAX)

As
    DECLARE @CREATE_TABLE_QUERY NVARCHAR(MAX) = N'';


    SELECT 
        @CREATE_TABLE_QUERY += ', ' + name + ' ' + UPPER(system_type_name) + CHAR(13) + CHAR(10) + CHAR(9)

    FROM 
        sys.dm_exec_describe_first_result_set(@procedure_name, NULL, 1);


    SELECT 
        @CREATE_TABLE_QUERY = N'CREATE TABLE ' + @table_name + '(' + CHAR(13) + CHAR(10) + CHAR(9) + STUFF(@CREATE_TABLE_QUERY, 1, 1, N'') + ');';

    PRINT @CREATE_TABLE_QUERY;