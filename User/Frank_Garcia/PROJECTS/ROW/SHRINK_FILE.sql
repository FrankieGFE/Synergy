USE tempdb
GO
DBCC SHRINKFILE (tempdev2, 1); -- to empty "tempdev12" data file
GO
DBCC SHRINKFILE (tempdev3, 1); -- to empty "tempdev12" data file
GO
DBCC SHRINKFILE (tempdev4, 1); -- to empty "tempdev12" data file
GO
--Step3: Re-size the data files to target file size 
-- Use ALTER DATABASE if the target file size is greater than the current file size
USE [master]
GO
ALTER DATABASE [tempdb] 
MODIFY FILE ( NAME = N'tempdev', SIZE = 1024KB ) --grow to 3000 MB
GO
--Use DBCC SHRINKFILE if the target file size is less than the current file size
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 1) --shrink to 3000 MB
GO
ALTER DATABASE [tempdb] 
MODIFY FILE ( NAME = N'tempdev2', SIZE = 1024KB ) --grow to 3000 MB
GO
--Use DBCC SHRINKFILE if the target file size is less than the current file size
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev2' , 1) --shrink to 3000 MB
GO
ALTER DATABASE [tempdb] 
MODIFY FILE ( NAME = N'tempdev3', SIZE = 1024KB ) --grow to 3000 MB
GO
--Use DBCC SHRINKFILE if the target file size is less than the current file size
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev3' , 1) --shrink to 3000 MB
GO
ALTER DATABASE [tempdb] 
MODIFY FILE ( NAME = N'tempdev4', SIZE = 1024KB ) --grow to 3000 MB
GO
--Use DBCC SHRINKFILE if the target file size is less than the current file size
USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev4' , 1) --shrink to 3000 MB
GO
