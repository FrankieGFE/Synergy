BEGIN TRAN

DELETE FROM
rev.EPC_PER_SECT_MSG
WHERE

[STUDENT_GU] IN ('B3083B8B-6EFC-4037-8D6B-DE9753AC8AEB','818B1012-AFD9-4F0D-8D8F-2BBD617822B0')

/*DELETE FROM
	[rev].[EPC_NM_STU_SPED_RPT_EVT]

WHERE
	[STUDENT_GU] IN ('37350626-357D-4CC8-AE71-BE125E96AE4B'
,'8D5786FB-E67B-409F-A761-A90743A5D9D1'
,'DEEC9E97-CAF3-4B9B-9960-952138F1D49A'
,'E4DA5830-07E0-419E-BF68-1F9B9D67830B'
,'EB073DE8-7B45-4CA5-A43D-CFC9BDC9025C')

DELETE FROM
	[rev].[EPC_NM_STU_SPED_RPT]

WHERE
[STUDENT_GU] IN ('8D5786FB-E67B-409F-A761-A90743A5D9D1'
,'DEEC9E97-CAF3-4B9B-9960-952138F1D49A'
,'E4DA5830-07E0-419E-BF68-1F9B9D67830B'
,'EB073DE8-7B45-4CA5-A43D-CFC9BDC9025C')*/

ROLLBACK