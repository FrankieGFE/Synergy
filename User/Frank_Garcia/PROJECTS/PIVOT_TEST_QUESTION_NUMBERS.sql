
SELECT
*
FROM
(
	 SELECT
	   [assessment_id]
      ,[assessment_name]
      ,[student_id]
      ,[student_name]
      ,[question_number]
      ,[answer]
  FROM [SchoolNet].[dbo].[DO NOT SHARE 2013-2014 Music 9-12 Alternate Assessment]
) AS T1
pivot
(max([answer]) FOR question_number IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48])) AS UP1

where student_id = '102783032'
