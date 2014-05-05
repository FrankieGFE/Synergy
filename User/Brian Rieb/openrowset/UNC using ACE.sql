SELECT * 
FROM OPENROWSET (
  'Microsoft.ACE.OLEDB.12.0', 
    'Text;Database=\\syntempssis\Files\Import\Food Services\FRM; ', 
    'SELECT * from WINSNAPI.TXT'
    )