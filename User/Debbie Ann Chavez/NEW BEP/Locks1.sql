

SELECT * 
FROM sys.dm_exec_requests
WHERE DB_NAME(database_id) = 'ST_Production' 
AND blocking_session_id <> 0 