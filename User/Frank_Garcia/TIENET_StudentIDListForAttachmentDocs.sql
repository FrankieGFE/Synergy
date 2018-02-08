-- This query will Output a list of StudentIDs
-- If the student has multiple attachment documents, their StudentID will appear that many times in the output
-- The number of student ID's listed should equal the number of documents we want to export

SELECT	s.id					-- student ID
FROM   STUDENTS s
INNER JOIN DOC#STUDENTS#DOCUMENTS d               ON (s.IDT# = d.profileidt)
INNER JOIN DOC#STUDENTS#DOCUMENTFILEIMAGES f      ON (d.documentidt = f.documentidt)
WHERE d.templateidt IS null		-- only Attachment documents
  AND d.docstatus = 3			-- only documents with Status = Final
  AND d.deleteddatetime IS NULL -- exclude deleted documents
ORDER  BY s.id ASC, convert(varchar,d.creationdatetime,112) ASC, f.filename ASC, f.documentfileidt ASC
