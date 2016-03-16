/* 
* Request by: Andy Gutierrez
*
* Created: March 2016 by 053285
*
* Intial Request: Read file from Shayne (RAMLabel) and pull students parents mailing addresses.
*
* INCLUDE:  Separate rows per parent
*
* Tables Referenced: rev.EPC_STU, rev.EPC_STU_PARENT, rev.REV_PERSON, rev.REV_ADDRESS
* Views:  
*/

EXECUTE AS login='QueryFileUser' 

go 

SELECT * 
               
FROM   OPENROWSET ( 'Microsoft.ACE.OLEDB.12.0', 
                    'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                    'SELECT * FROM   Labels_For_RAM.csv' 
					) AS [RAMLabel] 

		LEFT JOIN
		(
		SELECT sis_number, 
                parent_last_name, 
                parent_first_name,
				ADDRESS,
				CITY,
				STATE,
				ZIP_5
				
		FROM   rev.epc_stu AS STU	--HAS SIS_NUMBER, STUDENT_GU,

				INNER JOIN (SELECT SPAR.student_gu, 
									parent_gu, 
									PPER.last_name  AS PARENT_LAST_NAME, 
									PPER.first_name AS PARENT_FIRST_NAME,
									ADDR.ADDRESS,
									ADDR.CITY,
									ADDR.STATE,
									ADDR.ZIP_5
							
							FROM rev.epc_stu_parent AS spar	--HAS STUDENT_GU, PARENT_GU

								LEFT JOIN rev.rev_person pper	--HAS MAIL_ADDRESS_GU
								ON pper.person_gu = spar.parent_gu

								LEFT JOIN rev.REV_ADDRESS AS ADDR	--HAS ADDRESS_GU AND ALL FIELDS
								ON PPER.MAIL_ADDRESS_GU = ADDR.ADDRESS_GU

							) AS STUPAR 
				
				ON STU.STUDENT_GU = STUPAR.STUDENT_GU

	   ) AS PARENT

	   ON RAMLabel.SIS_NUMBER = PARENT.SIS_NUMBER
	   
--WHERE	RAMLabel.sis_number = '970089673'

REVERT 

go   