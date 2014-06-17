SELECT 

	DISTINCT SECURITY_GROUP
/*
		LDAP_NAME
		,USERGROUP_NAME
		,UserGroupXWalk.SECURITY_GROUP
*/
	FROM
		
		HELPER.dbo.SynergyUserGroups AS UserGroupXWalk
		
			
		LEFT JOIN 
				
		[011-SYNERGYDB.APS.EDU.ACTD].ST_Production.rev.REV_USERGROUP AS Groups
		
		
		ON
		UserGroupXWalk.SECURITY_GROUP = Groups.USERGROUP_NAME

		LEFT JOIN
		
		[011-SYNERGYDB.APS.EDU.ACTD].ST_Production.rev.REV_USERGROUP_ORGANIZATION AS UserGroupOrganization
		ON
		Groups.USERGROUP_GU = UserGroupOrganization.USERGROUP_GU

		LEFT JOIN 

		[011-SYNERGYDB.APS.EDU.ACTD].ST_Production.REV.EPC_SCH AS School

		ON UserGroupOrganization.ORGANIZATION_GU = School.ORGANIZATION_GU
		
		

		
		WHERE 
		Groups.USERGROUP_NAME IS NULL

