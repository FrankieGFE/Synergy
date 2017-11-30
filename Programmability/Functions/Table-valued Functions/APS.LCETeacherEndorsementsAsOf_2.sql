USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[LCETeacherEndorsementsAsOf_2]    Script Date: 11/14/2017 4:24:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/**
 * 
 * 
 *
 * 
 */
ALTER FUNCTION [APS].[LCETeacherEndorsementsAsOf_2](@asOfDate DATETIME)
RETURNS TABLE
AS
RETURN
SELECT
	STAFF_GU
	,CASE WHEN ISNULL(MAX(ElementaryTESOL),'0') = '0' THEN 0 ELSE 1 END AS ElementaryTESOL
	,CASE WHEN ISNULL(MAX(ElementaryBilingual),'0') = '0' THEN 0 ELSE 1 END AS ElementaryBilingual
	-- Elementary TESOL or Bilingual is considered ESL
	,CASE WHEN ISNULL(MAX(ElementaryTESOL),'0') + ISNULL(MAX(ElementaryBilingual),'0') != '00' THEN 1 ELSE 0 END AS ElementaryESL
	,CASE WHEN ISNULL(MAX(SecondaryTESOL),'0') = '0' THEN 0 ELSE 1 END AS SecondaryTESOL
	,CASE WHEN ISNULL(MAX(SecondaryBilingual),'0') = '0' THEN 0 ELSE 1 END AS SecondaryBilingual
	-- Only Secondary TESOL is considered SecondaryESL
	,CASE WHEN ISNULL(MAX(SecondaryTESOL),'0') = '0' THEN 0 ELSE 1 END AS SecondaryESL
	
	,ISNULL(MAX(Navajo),0) AS Navajo

	,CASE WHEN MAX(ElementaryTESOL) = 'W' THEN 1 ELSE 0 END AS ElementaryTESOLWaiverOnly
	,CASE WHEN MAX(ElementaryBilingual) = 'W' THEN 1 ELSE 0 END AS ElementaryBilingualWaiverOnly
	,CASE WHEN MAX(SecondaryTESOL) = 'W' THEN 1 ELSE 0 END AS SecondaryTESOLWaiverOnly
	,CASE WHEN MAX(SecondaryBilingual) = 'W' THEN 1 ELSE 0 END AS SecondaryBilingualWaiverOnly
FROM
	(
	
	SELECT
		STAFF_GU
		,CASE WHEN 
			CERT_AREA = '27' AND CERT_CODE IN ( '0150', '0200', '0208', '0250', '0400', '0408', '0500', '0505', '0901') 
			AND CERT_STATUS = 'Approved Waiver' THEN 'W'
			WHEN CERT_AREA = '27' AND CERT_CODE IN ( '0150', '0200', '0208', '0250', '0400', '0408', '0500', '0505', '0901') 
			--AND CERT_STATUS IN ('Approved', 'REINSTATED') 
			THEN CERT_CODE 
		 ELSE '0' 
		END AS ElementaryTESOL
			
		,CASE WHEN 
			CERT_AREA = '67' AND CERT_CODE IN ( '0150', '0200', '0208', '0250', '0400',  '0408', '0500', '0505', '0901')
			AND CERT_STATUS = 'Approved Waiver' THEN 'W'
			WHEN CERT_AREA = '67' AND CERT_CODE IN ( '0150', '0200', '0208', '0250', '0400',  '0408', '0500', '0505', '0901')
			--AND CERT_STATUS IN ('Approved', 'REINSTATED') 
			THEN CERT_CODE 
		ELSE '0' 
		END AS ElementaryBilingual
			
		,CASE WHEN 
			CERT_AREA = '27' AND CERT_CODE IN ( '0150', '0300', '0308', '0350', '0400','0408', '0500', '0501', '0505', '0901') 
			AND CERT_STATUS = 'Approved Waiver' THEN 'W'
			WHEN CERT_AREA = '27' AND CERT_CODE IN ( '0150', '0300', '0308', '0350', '0400','0408', '0500', '0501', '0505', '0901') 
			--AND CERT_STATUS IN ('Approved', 'REINSTATED') 	
			THEN CERT_CODE 
		ELSE '0' 
		END AS SecondaryTESOL
					
		,CASE WHEN 
			CERT_AREA = '67' AND CERT_CODE IN ('0150', '0300', '0308', '0350', '0400','0408', '0500', '0501', '0505', '0901')
			AND CERT_STATUS = 'Approved Waiver' THEN 'W'
			WHEN CERT_AREA = '67' AND CERT_CODE IN ('0150', '0300', '0308', '0350', '0400','0408', '0500', '0501', '0505', '0901')
			--AND CERT_STATUS IN ('Approved', 'REINSTATED') 
			THEN CERT_CODE 
		ELSE '0' 
		END AS SecondaryBilingual
			
		,CASE WHEN CERT_CODE = '0520' THEN 1 ELSE 0 END AS Navajo
	
	FROM
		--rev.EPC_STAFF_CRD
		rev.UD_LICENSURE_DATA
	--removed this to allow future dates
	WHERE
		CERT_STATUS NOT IN ('BCKGROUND ISSUE', 'CANCELLED', 'INACTIVE', 'NO BACKGROUND', 'Pending', 'REVOKED', 'SUSPENDED', 'VOL SURRENDER')
		--DATE_EARNED <= @asOfDate
	) AS AllCreds
GROUP BY
	STAFF_GU




--GO




GO


