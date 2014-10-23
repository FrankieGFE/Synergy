IF OBJECT_ID('tempdb..##TempSSIDImport') IS NOT NULL DROP TABLE ##TempSSIDImport
CREATE TABLE ##TempSSIDImport(
    SIS_Number  NVARCHAR(09) not null
 ,  SSID NVARCHAR(09) not null
)