DECLARE @total INT
SELECT @total=sum(cpu) FROM sys.sysprocesses sp (NOLOCK)
    join sys.sysdatabases sb (NOLOCK) ON sp.dbid = sb.dbid

SELECT sb.name 'database', @total 'system cpu', SUM(cpu) 'database cpu', CONVERT(DECIMAL(4,1), CONVERT(DECIMAL(17,2),SUM(cpu)) / CONVERT(DECIMAL(17,2),@total)*100) '%'
FROM sys.sysprocesses sp (NOLOCK)
JOIN sys.sysdatabases sb (NOLOCK) ON sp.dbid = sb.dbid
--WHERE sp.status = 'runnable'
GROUP BY sb.name
ORDER BY CONVERT(DECIMAL(4,1), CONVERT(DECIMAL(17,2),SUM(cpu)) / CONVERT(DECIMAL(17,2),@total)*100) desc