select
  'TH'                                  as [rowtype]
, convert(varchar(10), getdate(), 101)  as [date]
, convert(varchar(8), getdate(), 108)   as [dtime]
, DATEPART(day, getdate())              as [day]
, '1.0'                                 as [ver]
, 'DELIMITER=0X09'+SPACE(88)            as [delimiter]
