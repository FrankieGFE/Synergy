

select [FileSizeGB] = FileSizeMB / 1024, 
       [UsedSpaceGB] = UsedSpaceMB / 1024, 
       [UnusedSpaceGB] = UnusedSpaceMB / 1034,
          --FileSizeMB, UsedSpaceMB, UnusedSpaceMB, 
           FreePct = ROUND(UnusedSpaceMB / FileSizeMB *100, 2), 
       Type, DBFileName, DRIVE
from  (select [FileSizeMB] = convert(numeric(10,2),sum(round(a.size/128.,2))),
              [UsedSpaceMB] = convert(numeric(10,2),sum(round(fileproperty( a.name,'SpaceUsed')/128.,2))) ,
              [UnusedSpaceMB] = convert(numeric(10,2),sum(round((a.size-fileproperty( a.name,'SpaceUsed'))/128.,2))) ,
              [Type] = case when a.groupid is null then '' when a.groupid = 0 then 'Log' else 'Data' end,
              [DBFileName] = isnull(a.name,'*** Total for all files ***')
             ,DRIVE = SUBSTRING(case when a.name is null then null else min(filename) end, 1, 2)
         from sysfiles a
         group by groupid, a.name 
         with rollup having a.groupid is null or a.name is not null) z
order by Drive, 4, DBFileName

select --[FileSizeGB] = FileSizeMB / 1024, 
       [UsedSpaceGB] = ROUND((sum(UsedSpaceMB) / 1024), 2), 
       [UnusedSpaceGB] = ROUND((sum(UnusedSpaceMB) / 1034),2),
          --FileSizeMB, UsedSpaceMB, UnusedSpaceMB, 
           FreePct = ROUND((SUM(UnusedSpaceMB) / SUM(FileSizeMB)) *100, 2), 
       DRIVE
from   (select [FileSizeMB] = convert(numeric(10,2),sum(round(a.size/128.,2))),
               [UsedSpaceMB] = convert(numeric(10,2),sum(round(fileproperty( a.name,'SpaceUsed')/128.,2))) ,
               [UnusedSpaceMB] = convert(numeric(10,2),sum(round((a.size-fileproperty( a.name,'SpaceUsed'))/128.,2))) ,
               [Type] = case when a.groupid is null then '' when a.groupid = 0 then 'Log' else 'Data' end,
               [DBFileName] = isnull(a.name,'*** Total for all files ***')
              ,DRIVE = SUBSTRING(case when a.name is null then null else min(filename) end, 1, 2)
          from sysfiles a
          group by groupid, a.name 
          with rollup Having a.groupid is null or a.name is not null) z
GROUP BY Z.DRIVE
order by Drive--,  DBFileName
