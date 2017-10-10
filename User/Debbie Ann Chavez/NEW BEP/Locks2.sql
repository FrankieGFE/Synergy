

SELECT * FROM sys.dm_exec_requests CROSS APPLY sys.dm_exec_sql_text(sql_handle) 
where session_id IN (SELECT blocking_session_id FROM sys.dm_exec_requests 
WHERE DB_NAME(database_id)='ST_Production' and blocking_session_id <>0) 