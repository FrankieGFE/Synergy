SELECT DB_NAME(database_id) AS DatabaseName,
Physical_Name, (size*8)/1024 SizeMB
FROM sys.master_files
WHERE DB_NAME(database_id) = 'PR'
GO