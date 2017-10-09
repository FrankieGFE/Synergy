--/*
-- * Revision 1
-- * Last Changed By:    JoAnn Smith
-- * Last Changed Date:  8/31/17
-- ******************************************************
-- Get ELL data for Lutheran Services request
 
-- ******************************************************

--/*


EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
		T1.*,
		ELL.TEST_NAME,
		ELL.ADMIN_DATE,
		ELL.GRADE,
		ELL.IS_ELL

		
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from Lutheran_Family_Services_2016.csv'
                ) AS [T1]

LEFT JOIN
	aps.basicStudent BS
on
	bs.SIS_NUMBER = t1.aps_id
left join
	APS.LCELatestEvaluationAsOf('2017-05-25') ELL
ON bs.STUDENT_GU = ell.STUDENT_GU



