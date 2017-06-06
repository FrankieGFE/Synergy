begin tran

update rev.rev_user set DISABLED = 'N'
from rev.rev_user where LOGIN_NAME = 'admin'

rollback