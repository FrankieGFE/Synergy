
select d.name "Database",p.Hostname,COUNT(*)NumConnect
from sys.sysprocesses p inner join sys.databases d on d.database_id = p.[dbid]
group by d.name, p.hostname
order by COUNT(*) desc, d.name, p.Hostname
