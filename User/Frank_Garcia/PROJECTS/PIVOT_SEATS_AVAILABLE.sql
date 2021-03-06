SELECT
	school_code
	,school_name
	,school_type_code
	,"K" AS KIND
	,"01" AS FIRST
	,"02" AS SECOND
	,"03" AS THIRD
	,"04" AS FOURTH
	,"05" AS FIFTH
	,"06" AS SIXTH
	,"07" AS SEVENTH
	,"08" AS EIGHTH
	,"09" AS NINETH
	,"10" AS TENTH
	,"11" AS ELEVENTH
	,"12" AS TWELFTH


FROM
(
SELECT 
	   SA.[school_code]
      ,[grade]
      ,[spaces_available]
	  ,SCH.school_type_code
	  ,Sch.school_name
  FROM [StudentTransfersDev].[dbo].[School_Availability] AS SA
  LEFT JOIN 
  SCHOOLS AS SCH
  ON SA.school_code = SCH.SCHOOL_CODE
) AS T1
PIVOT
	(MAX([SPACES_AVAILABLE]) FOR GRADE IN ([K],[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])) AS UP1

