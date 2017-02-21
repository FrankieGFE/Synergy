USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[LCETeacherEndorsementsAsOf]    Script Date: 10/19/2016 12:15:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**
 * FUNCTION APS.LCETeacherEndorsementsAsOf
 * Summarizes LCE Specific Teacher Endorsements.  
 * Tables Used: EPC_STAFF_CRD
 *
 * #param DATETIME @asOfDate Date to pull endorsments from
 * 
 * #return TABLE Teacher Records with summarized LCE specific endorsment information
 */
ALTER FUNCTION [APS].[LCETeacherEndorsementsAsOf](@asOfDate DATETIME)
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

	,CASE WHEN MAX(ElementaryTESOL) = '0006' THEN 1 ELSE 0 END AS ElementaryTESOLWaiverOnly
	,CASE WHEN MAX(ElementaryBilingual) = '0006' THEN 1 ELSE 0 END AS ElementaryBilingualWaiverOnly
	,CASE WHEN MAX(SecondaryTESOL) = '0006' THEN 1 ELSE 0 END AS SecondaryTESOLWaiverOnly
	,CASE WHEN MAX(SecondaryBilingual) = '0006' THEN 1 ELSE 0 END AS SecondaryBilingualWaiverOnly
FROM
	(
	
	SELECT
		STAFF_GU
		,CASE WHEN 
			AUTHORIZED_TCH_AREA = '27' AND CREDENTIAL_TYPE IN ('0006', '0150', '0200', '0208', '0250', '0400', '0408', '0500', '0505', '0901') 
			THEN CREDENTIAL_TYPE ELSE '0' 
		END AS ElementaryTESOL
			
		,CASE WHEN 
			(AUTHORIZED_TCH_AREA = '67' AND CREDENTIAL_TYPE IN ('0006', '0150', '0200', '0208', '0250', '0400',  '0408', '0500', '0505', '0901'))
			THEN CREDENTIAL_TYPE ELSE '0' 
		END AS ElementaryBilingual
			
		,CASE WHEN 
			AUTHORIZED_TCH_AREA = '27' AND CREDENTIAL_TYPE IN ('0006', '0150', '0300', '0308', '0350', '0400','0408', '0500', '0501', '0505', '0901') 
			THEN CREDENTIAL_TYPE ELSE '0' 
		END AS SecondaryTESOL
					
		,CASE WHEN 
			(AUTHORIZED_TCH_AREA = '67' AND CREDENTIAL_TYPE IN ('0006','0150', '0300', '0308', '0350', '0400','0408', '0500', '0501', '0505', '0901'))
			THEN CREDENTIAL_TYPE ELSE '0' 
		END AS SecondaryBilingual
			
		,Case WHEN CREDENTIAL_TYPE = '0520' THEN 1 ELSE 0 END AS Navajo
	
	FROM
		rev.EPC_STAFF_CRD
	-- TOOK THIS OUT TO ALLOW FUTURE DATES
	--WHERE
	--	DATE_EARNED <= @asOfDate
	) AS AllCreds
GROUP BY
	STAFF_GU
GO


