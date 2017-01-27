--read from text file


             OPENROWSET (
                    'Microsoft.ACE.OLEDB.12.0', 
                    'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                    'SELECT * FROM admins_8_early_start_schools.csv'  
             )AS [FILE]
             ON [FILE].SCHOOL = EST.school

