
--UPDATE Student State ID in rev.EPC_STU
UPDATE rev.EPC_STU
SET STATE_STUDENT_NUMBER = tssid.SSID
FROM ##TempSSIDImport tssid
JOIN rev.EPC_STU stu              ON stu.SIS_NUMBER = tssid.SIS_Number
                                     
select cast(@@rowcount as varchar(10)) as ur