/* 
* Request by: Andy Gutierrez
*
* Created: March 2016 by 053285
*
* Intial Request: Read file from Shayne (RAMLabel) and pull students parents mailing addresses.  If no Mailing address, pull Home address
*
* INCLUDE:  Separate rows per parent, show wheather student has a 2015 or 2016 enrollment
*
* Tables Referenced: rev.EPC_STU, rev.EPC_STU_PARENT, rev.REV_PERSON, rev.REV_ADDRESS
* Views:  APS.StudentEnrollmentDetails
*
*	ONLY WANT 2017 (NEXT YEAR) IF THEY HAVE IT OR SHOW IF THEY ARE ACTIVE 2015-2016 (DON'T LOOK AT CONCURRENT OR NO SHOWS SUMMERSCHOOL WITHDRAWALS)
*/

EXECUTE AS login='QueryFileUser' 

go 

SELECT * 
               
FROM   OPENROWSET ( 'Microsoft.ACE.OLEDB.12.0', 
                    'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                    'SELECT * FROM   Labels_For_RAM.csv' 
					) AS [RAMLabel] 

		LEFT JOIN (SELECT sis_number, 
						  parent_last_name, 
						  parent_first_name,
				          ADDRESS,
						  CASE
						    WHEN ENR16.SCHOOL_YEAR = '2016' THEN '2017'
							ELSE
								CASE
									WHEN ENR15.SCHOOL_YEAR = '2015' THEN '2016'
									ELSE ' '
								END
						  END AS '2016 OR 2017 ENR'
						  

				   FROM   rev.epc_stu AS STU	--HAS SIS_NUMBER, STUDENT_GU,

						  INNER JOIN (SELECT SPAR.student_gu, 
									         parent_gu, 
									         PPER.last_name  AS PARENT_LAST_NAME, 
									         PPER.first_name AS PARENT_FIRST_NAME,
											 CASE
											    WHEN ADDR.ADDRESS is not null THEN
												ADDR.ADDRESS + ', ' + ADDR.CITY +', '+ 
												ADDR.STATE + ', ' + ADDR.ZIP_5
												ELSE ADDR2.ADDRESS + ', ' + ADDR2.CITY +
													', ' + ADDR2.STATE + ', ' + ADDR2.ZIP_5
											 END AS ADDRESS
							
									   FROM	 rev.epc_stu_parent AS spar	--STUDENT_GU, PARENT_GU

										     LEFT JOIN rev.rev_person pper --MAIL_ADDRESS_GU, HOME_ADDRESS_GU
										     ON pper.person_gu = spar.parent_gu

											 LEFT JOIN rev.REV_ADDRESS AS ADDR --ADDRESS_GU, MAIL_ADDDRESS_GU
											 ON PPER.MAIL_ADDRESS_GU = ADDR.ADDRESS_GU

											 LEFT JOIN rev.REV_ADDRESS AS ADDR2 --ADDRESS_GU, HOME_ADDRESS_GU
											 ON PPER.HOME_ADDRESS_GU = ADDR2.ADDRESS_GU

							            ) AS STUPAR 
				
										ON STU.STUDENT_GU = STUPAR.STUDENT_GU 

					  ---------------------
					  LEFT JOIN APS.StudentEnrollmentDetails AS ENR15
							 ON ENR15.SCHOOL_YEAR = '2015'	--2015-2016
						        AND ENR15.EXTENSION = 'R'
								AND ENR15.EXCLUDE_ADA_ADM IS NULL
								AND ENR15.SUMMER_WITHDRAWL_CODE IS NULL
						        AND STU.STUDENT_GU = ENR15.STUDENT_GU

					  LEFT JOIN APS.StudentEnrollmentDetails AS ENR16
						     ON ENR16.SCHOOL_YEAR = '2016'	--2016-2017
						        AND ENR16.EXTENSION = 'R'
								AND ENR16.EXCLUDE_ADA_ADM IS NULL
								AND ENR16.SUMMER_WITHDRAWL_CODE IS NULL
						        AND STU.STUDENT_GU = ENR16.STUDENT_GU
					 ----------------------

				) AS PARENT

	       ON RAMLabel.SIS_NUMBER = PARENT.SIS_NUMBER
		   
REVERT 

go   