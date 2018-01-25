USE
SChoolNet
GO
BEGIN TRAN


UPDATE [EOC_]
SET last_name = left(full_name, CHARINDEX(',', full_name) - 1)
WHERE last_name is null

ROLLBACK