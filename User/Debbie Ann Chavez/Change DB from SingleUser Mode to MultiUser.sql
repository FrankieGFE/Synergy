use master
GO

--RUN THIS FIRST
select 
    d.name, 
    d.dbid, 
    spid, 
    login_time, 
    nt_domain, 
    nt_username, 
    loginame
from sysprocesses p 
    inner join sysdatabases d 
        on p.dbid = d.dbid
where d.name = 'ST_DAILY'
GO

-- THEN RUN THIS
-- kill whichever SPID is in single user mode
kill 58 

GO
-- THEN THIS
ALTER DATABASE ST_DAILY
SET MULTI_USER;
GO