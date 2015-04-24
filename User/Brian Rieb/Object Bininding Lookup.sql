SELECT
	SynObject.NAMESPACE
	,SynObject.NAME AS ObjectName
	,Prop.PROPERTY_NAME
	,Prop.TYPE
	,Prop.LOOKUP_TYPE
	,Prop.LABEL
	,Bind.TABLE_NAME
	,Bind.COLUMN_NAME
	
	--,Bind2.TABLE_NAME
	--,Bind2.COLUMN_NAME
FROM
	rev.REV_BOD_OBJECT AS SynObject
	INNER JOIN
	rev.REV_BOD_OBJECT_PROP As Prop
	ON
	SynObject.BOD_OBJECT_GU = Prop.BOD_OBJECT_GU
	INNER JOIN
	rev.REV_BOD_OBJECT_PROP_BIND AS Bind
	ON
	Prop.BOD_OBJECT_PROP_GU = Bind.BOD_OBJECT_PROP_GU
	
	--INNER JOIN
	--rev.REV_BOD_OBJECT_PROP_BIND AS Bind2
	--ON
	--Bind.TABLE_NAME = Bind2.TABLE_NAME
WHERE
	SynObject.NAME LIKE '%Year%'
	-- TABLE_NAME LIKE '%CFG%'
	--LABEL LIKE '%Calendar%'
	
	--Bind.COLUMN_NAME LIKE '%Monday%'
	--AND Bind2.COLUMN_NAME = 'STUDENT_GU'
	
	AND SynObject.NAMESPACE LIKE '%Attendance%'