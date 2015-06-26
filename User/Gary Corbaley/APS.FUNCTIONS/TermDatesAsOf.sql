/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 06/17/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 06/15/2015
 * 
 * Initial Request: Pull a list of all Term Starting and Ending Dates for each school in the district.
 *
 * Description: This script loops through each school's term definition and calculates each term's begin and end dates.
 * One Record Per School Per Term Per Year
 *
 * Tables and Functions Referenced: APS.YearDates, EPC_SCH, REV_ORGANIZATION, REV_ORGANIZATION_YEAR, REV_YEAR, EPC_SCH_ATT_CAL_OPT, EPC_SCH_ATT_CAL, EPC_SCH_YR_TRM_DEF, EPC_SCH_YR_TRM_CODES, 
 */

CREATE FUNCTION [APS].[TermDates](@AsOfDate DATE)
RETURNS @TERMS TABLE
(
	[SCHOOL_YEAR] INT NULL
	,[EXTENSION] VARCHAR(1) NULL
	,[SCHOOL_NAME] VARCHAR(100) NULL
	,[TermCode] VARCHAR(5) NULL
	,[TermName] VARCHAR(50) NULL
	,[TermBegin] smalldatetime NULL
	,[TermEnd] smalldatetime NULL
	,[OrgYearGU] uniqueidentifier NULL
	,[YEAR_GU] uniqueidentifier NULL
	,[ORGANIZATION_GU] uniqueidentifier NULL
)
AS
BEGIN

-- Return the List of Term Definitions and add the school year and school name for user readability
INSERT INTO @TERMS
SELECT
	*
FROM 
	APS.TermDates()	
WHERE
	@AsOfDate BETWEEN TermBegin and TermEnd
	
RETURN

END	
GO