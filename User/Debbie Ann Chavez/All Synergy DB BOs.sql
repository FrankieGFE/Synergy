-- Show database table and column relationships to Data Bound Business Objects and Properties
-- Only show BO Properties that are bound to a single data column
-- (run on MSSQL 2005 or higher)

-- Only do this for database tables that have 1 or more records
declare @recCount int
declare @tableName varchar(50)
create table #tablesWithRecs (tableName varchar(50) not null, tableRecCnt int not null)

declare allTables cursor local fast_forward read_only for
select distinct c.TABLE_NAME
from Rev.REV_BOD_OBJECT a
  inner join Rev.REV_BOD_OBJECT_PROP b on (b.BOD_OBJECT_GU = a.BOD_OBJECT_GU)
  inner join Rev.REV_BOD_OBJECT_PROP_BIND c on (c.BOD_OBJECT_PROP_GU = b.BOD_OBJECT_PROP_GU)
  inner join sys.tables a2 on (a2.name = c.TABLE_NAME)
  inner join sys.columns b2 on (b2.object_id = a2.object_id and b2.name = c.COLUMN_NAME)
  inner join sys.types c2 on (c2.user_type_id = b2.user_type_id)
where b.BOD_OBJECT_PROP_GU in
  (select BOD_OBJECT_PROP_GU
   from Rev.REV_BOD_OBJECT_PROP_BIND
   group by BOD_OBJECT_PROP_GU
   having count(*) = 1)
order by c.TABLE_NAME

open allTables
fetch next from allTables into @tableName
while @@FETCH_STATUS = 0
begin
  exec ('insert into #tablesWithRecs select ''' +  @tableName + ''', count(*) from Rev.' + @tableName)
  fetch next from allTables into @tableName
end
close allTables
deallocate allTables

delete from #tablesWithRecs where tableRecCnt = 0

select c.TABLE_NAME,c.COLUMN_NAME,c2.name "SQL_Type",
       case c2.name when 'nvarchar' then b2.max_length/2 else b2.max_length end "Length",
       case c2.name when 'numeric' then b2.precision else null end "Precision",
       case c2.name when 'numeric' then b2.scale else null end "Scale",
       case b2.is_nullable when 1 then b2.is_nullable else null end Nullable,
       a.[NAMESPACE] BO_Namespace,a.NAME BO_Name,b.PROPERTY_NAME,b.[TYPE] Prop_Type,b.MAXLEN,b.MANDATORY,b.LOOKUP_TYPE,
       d.LOOKUP_NAMESPACE,d.LOOKUP_DEF_CODE,d.OWNED_BY_PRODUCT,b.DEFAULT_VALUE,b.COMMENT,
       recs.tableRecCnt RowsInTable
from Rev.REV_BOD_OBJECT a
  inner join Rev.REV_BOD_OBJECT_PROP b on (b.BOD_OBJECT_GU = a.BOD_OBJECT_GU)
  inner join Rev.REV_BOD_OBJECT_PROP_BIND c on (c.BOD_OBJECT_PROP_GU = b.BOD_OBJECT_PROP_GU)
  inner join sys.tables a2 on (a2.name = c.TABLE_NAME)
  inner join sys.columns b2 on (b2.object_id = a2.object_id and b2.name = c.COLUMN_NAME)
  inner join sys.types c2 on (c2.user_type_id = b2.user_type_id)
  inner join #tablesWithRecs recs on (recs.tableName = c.TABLE_NAME)
  left outer join Rev.REV_BOD_LOOKUP_DEF d on (d.LOOKUP_DEF_GU = case when len(b.SRC_LOOKUP) = 36 then convert(uniqueidentifier,b.SRC_LOOKUP) end)
where b.BOD_OBJECT_PROP_GU in
  (select BOD_OBJECT_PROP_GU
   from Rev.REV_BOD_OBJECT_PROP_BIND
   group by BOD_OBJECT_PROP_GU
   having count(*) = 1)
order by c.TABLE_NAME,BO_Namespace,BO_Name,c.COLUMN_NAME,b.PROPERTY_NAME

drop table #tablesWithRecs