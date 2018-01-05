
 SELECT      c.name  AS 'Column Name'
            ,t.name AS 'Table Name'
			,s.name as 'Schema'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
join        sys.schemas s on t.schema_id=s.schema_id

WHERE       c.name = 'HOMEROOM_SECTION_GU'
ORDER BY    t.name asc 


