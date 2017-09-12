USE [ST_Production]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [APS].[UpdateDisabledLogins]

(
	@ValidateOnly INT
)


AS
BEGIN

BEGIN TRANSACTION

UPDATE rev.REV_USER_NON_SYS
      SET LOGIN_ATTEMPTS = 0, DISABLED = 'N'
WHERE
	DISABLED = 'Y'  --just run this for everyone that is disabled

------------------------------------------------------------------------------------------------------------------------------------------------


--Validation Check to see how many records will be processed, 0 = INSERT-WILL UPDATE, 1 = ROLLBACK-WILL NOT UPDATE
IF @ValidateOnly = 0
	BEGIN
		PRINT 'UPDATED DISABLED LOGINS'
		COMMIT 

	END
ELSE
	BEGIN
		PRINT 'DISABLED LOGINS NOT UPDATED'
		ROLLBACK
	END

END

GO


--exec aps.UpdateDisabledLogins 0