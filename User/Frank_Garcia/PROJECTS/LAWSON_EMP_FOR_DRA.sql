USE
Lawson
GO
--Title:			RDA Employee File
--FileName:		Employee_File.cfm
--Description:	Get active employees for RDA Logon Database from Lawson EMPLOYEE and PAEMPLOYEE and PAEMPPOS tables.
--Created:		May 8, 2012
--Updated:		July 16, 2013
--				Added PAEMPPOS.DATE_ASSIGN to find most recent assignment

--Notes:			



SELECT
  DISTINCT 
  EMPLOYEE.EMPLOYEE AS EMPLOYEE_ID,
  CAST(EMPLOYEE.USER_LEVEL AS INT) AS LOCATION,
  '' AS LOC_NUM,
  '' AS LOC_DESCRIPTION,
  CAST(EMPLOYEE.EMPLOYEE AS VARCHAR) + SUBSTRING(EMPLOYEE.FICA_NBR,8,4) AS ACCESS_CODE,
  EMPLOYEE.FIRST_NAME,
  EMPLOYEE.LAST_NAME,
  PAPOSITION.DESCRIPTION AS LAWSON_JOB_TITLE,
  CASE 
	WHEN PAPOSITION.DESCRIPTION LIKE '%:%' THEN REPLACE (LEFT(PAPOSITION.DESCRIPTION, CHARINDEX(':', PAPOSITION.DESCRIPTION) - 0),':','') 
	ELSE PAPOSITION.DESCRIPTION
  END AS 'JOB_TITLE_ABBREVIATION',
  '' AS GROUPS,
  '' AS SECURITY_LEVEL,
  EMPLOYEE.EMAIL_ADDRESS,
  LTRIM(RTRIM(EMPLOYEE.USER_LEVEL)) AS USER_LEVEL,
  YEAR(PAEMPLOYEE.BIRTHDATE) AS BIRTHYEAR,
  PAPOSITION.POSITION,
  --SUBSTR(PAPOSITION.DESCRIPTION, 1, DECODE(SUBSTRING (PAPOSITION.DESCRIPTION, ':'),0, LENGTH(PAPOSITION.DESCRIPTION)+1, INSTR(PAPOSITION.DESCRIPTION, ':'))-1) AS JOB_TITLE,
  
  PAEMPPOS.END_DATE,
  PAEMPPOS.JOB_CODE,
  CASE
  	WHEN (EMPLOYEE.EMPLOYEE = 138796)
    	THEN 'RDA_ADMINISTRATOR'
	WHEN (EMPLOYEE.USER_LEVEL = '0046' AND EMPLOYEE.EMPLOYEE <> 138796)  
    	THEN 'RDA STAFF'   
	WHEN (EMPLOYEE.USER_LEVEL = '0044' AND EMPLOYEE.EMPLOYEE <> 138796)  
    	THEN 'RDA STAFF'   
--- 	WHEN (EMPLOYEE.USER_LEVEL = '0022')  
    	--THEN 'FINE_ARTS'    --->
	ELSE ('')
    END
    AS RDA,  
    CONVERT (VARCHAR (10), PAEMPPOS.EFFECT_DATE, 120) AS DATE_ASSIGN
FROM
  PAEMPPOS 
  INNER JOIN PAPOSITION 
  	ON (PAEMPPOS .POSITION) = (PAPOSITION .POSITION) 
  LEFT OUTER JOIN PAEMPLOYEE 
  	ON (PAEMPLOYEE.EMPLOYEE) = (PAEMPPOS.EMPLOYEE)
  INNER JOIN EMPLOYEE 
  	ON (EMPLOYEE.EMPLOYEE) = (PAEMPLOYEE .EMPLOYEE)
 
WHERE 
PAEMPPOS.END_DATE IS NULL
--and last_name = 'Van Hoewyk'
--AND EMPLOYEE.EMPLOYEE = '89408'
--AND (PAPOSITION.DESCRIPTION <> 'Inactive') AND (EMPLOYEE .USER_LEVEL IS NOT NULL)

--AND LAST_NAME = 'GARCIA' AND FIRST_NAME = 'FRANK'
--AND EMPLOYEE.EMPLOYEE = '118143'
ORDER BY USER_LEVEL
--</CFQUERY>

--<CFQUERY NAME="qry_Positions_Conversions" DATASOURCE="db_Logon">
--SELECT
--	ABBREVIATION,
--    GROUPS,
--    SECURITY_LVL
--FROM
--	dbo.Positions_Conversion  
--</CFQUERY>     

--<CFQUERY NAME="qry_Location_Table" DATASOURCE="db_Logon">
--SELECT
--	fld_locdesc AS LOC_DESCRIPTION,
--    fld_locnum AS LOC_NUM
--FROM
--	dbo.Location_Table  
--</CFQUERY>       

--<cfquery name="qry_Employees" dbtype="query">
--SELECT
--	qry_Current_Employees.EMPLOYEE_ID, 
--    qry_Location_Table.LOC_NUM,
--    qry_Location_Table.LOC_DESCRIPTION,
--    qry_Current_Employees.ACCESS_CODE,
--    qry_Current_Employees.FIRST_NAME,
--    qry_Current_Employees.LAST_NAME,
--    qry_Current_Employees.LAWSON_JOB_TITLE,
--    qry_Current_Employees.JOB_TITLE,
--    qry_Current_Employees.BIRTHYEAR,
--    qry_Current_Employees.RDA,
--    qry_Current_Employees.EMAIL_ADDRESS,
--    qry_Current_Employees.DATE_ASSIGN
--FROM
--	qry_Current_Employees, qry_Location_Table <!--- ONLY 2 TABLES SUPPORTED. COMPLETE THIS QUERY AND DO ANOTHER--->
--WHERE    
--    (qry_Current_Employees.LOCATION = qry_Location_Table.LOC_NUM)
--ORDER BY qry_Current_Employees.EMPLOYEE_ID     
--</cfquery>  

--<cfquery name="qry_EMPLOYEE_FILE" dbtype="query">
--SELECT
--	qry_Employees.EMPLOYEE_ID,
--    qry_Employees.LOC_NUM,
--    qry_Employees.LOC_DESCRIPTION,
--    qry_Employees.ACCESS_CODE,
--    qry_Employees.FIRST_NAME,
--    qry_Employees.LAST_NAME,
--    qry_Employees.LAWSON_JOB_TITLE,
--    qry_Employees.JOB_TITLE,
--    qry_Employees.BIRTHYEAR,
--    qry_Employees.EMAIL_ADDRESS,
--    qry_Employees.RDA,
--    qry_Employees.DATE_ASSIGN,
    
--    qry_Positions_Conversions.ABBREVIATION,
--    qry_Positions_Conversions.GROUPS AS [GROUPS],
--    qry_Positions_Conversions.SECURITY_LVL
--FROM
--	qry_EMPLOYEES, qry_Positions_Conversions
--WHERE
--	(qry_Employees.JOB_TITLE = qry_Positions_Conversions.ABBREVIATION)
--ORDER BY EMPLOYEE_ID    
--</cfquery>

--<cfquery name="qry_Case" dbtype="query"> <!--- See page 79 SQL cookbook to remove dups where id, loc, and group are same --->
 
--SELECT
--	<!---ROW_NUMBER () OVER (PARTITION BY EMPLOYEE_ID, LOC_NUM, JOB_TITLE ORDER BY ID_NBR)AS RN--->
--	qry_EMPLOYEE_FILE.EMPLOYEE_ID,
--    qry_EMPLOYEE_FILE.LOC_NUM,
--    qry_EMPLOYEE_FILE.LOC_DESCRIPTION,
--    qry_EMPLOYEE_FILE.ACCESS_CODE,
--    qry_EMPLOYEE_FILE.FIRST_NAME,
--    qry_EMPLOYEE_FILE.LAST_NAME,
--    qry_EMPLOYEE_FILE.LAWSON_JOB_TITLE,
--    qry_EMPLOYEE_FILE.JOB_TITLE,
--    qry_EMPLOYEE_FILE.BIRTHYEAR,
--    qry_EMPLOYEE_FILE.EMAIL_ADDRESS,
--    qry_EMPLOYEE_FILE.ABBREVIATION,
--    qry_EMPLOYEE_FILE.GROUPS,
--    qry_EMPLOYEE_FILE.SECURITY_LVL,
--    qry_EMPLOYEE_FILE.RDA,
--    qry_EMPLOYEE_FILE.DATE_ASSIGN
--FROM
--	qry_EMPLOYEE_FILE
--ORDER BY EMPLOYEE_ID

    

--</cfquery>    
 
--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

--<CFOUTPUT>
--<html>

--<head>
--<title>#AppTitle#</title>

--</head>	
			
--<body>
--<h1>#AppTitle#</h1>
--<hr />

-- Table for display purposes

--<cfif (qry_Case.RecordCount EQ 0)>
--	<P>NO RECORDS AT THIS TIME</P>
--<cfelse>
--<!---Total Records: #qry_Case.RecordCount#--->
--<TABLE border="1" cellspacing="0" cellpadding="2">

--  	<TR valign="BOTTOM" align="center" bgcolor="B5D3E7">
--   		<TD>EMPLOYEE_ID</TD>
--    	<TD>LOC_NUM</TD>
--    	<TD>LOC_DESCRIPTION</TD>
--    	<TD>ACCESS_CODE</TD>
--        <TD>FIRST_NAME</TD>
--    	<TD>LAST_NAME</TD>
--    	<TD>LAWSON_JOB_TITLE</TD>
--    	<TD>JOB_TITLE_ABBREVIATION</TD>
--    	<TD>GROUP</TD>
--    	<TD>SECURITY_LVL</TD>
--    	<TD>DATE_CREATE</TD>
--        <TD>BIRTHYEAR</TD>
--    	<TD>EMAIL_ADDRESS</TD>
--	</TR>
  
--<cfloop query="qry_Case">    
--	<TR align="center">  
--    	<TD>#EMPLOYEE_ID#</TD>
--        <TD>#LOC_NUM#</TD>
--        <TD>#LOC_DESCRIPTION#</TD>
--        <TD>#ACCESS_CODE#</TD>
--        <TD>#FIRST_NAME#</TD>
--        <TD>#LAST_NAME#</TD>
--        #qry_Case.Employee_ID#
--        <CFIF (qry_Case.RDA) NEQ ('RDA STAFF')>
--        	<!---<cfset qry_Case.RDA = #LAWSON_JOB_TITLE# --->
--        	<TD>#LAWSON_JOB_TITLE#</TD>
--        <CFELSE>
--        	<TD>RDA STAFF</TD>
--		</CFIF>            
--        <CFIF (qry_Case.RDA) NEQ ('RDA STAFF')>
--			<TD>#JOB_TITLE#</TD>
--        <cfelse>
--        	<TD>RDA STAFF</TD>
--		</CFIF> 
--        <CFIF (qry_Case.LOC_NUM) NEQ ('46')>            
--        	<TD>#GROUPS#</TD>
--		<CFELSE>
--        	<TD>RDA STAFF</TD>
--		</CFIF>                        
--        <CFIF (qry_Case.LOC_NUM) EQ '46'>
--        	<!--- <cfset qry_Case.SECURITY_LVL = '2'>--->
--        	<TD>2</TD>
--		<CFELSE>
--        <TD>#SECURITY_LVL#</TD>
--		</CFIF>
--        <TD>#TODAY#</TD>
--        <TD>#BIRTHYEAR#</TD>
--        <TD>#EMAIL_ADDRESS#</TD>
--	</TR>        
--</cfloop> 
--</cfif>  
      
--</TABLE>

--End display table 



--<cfquery name="qry_DELETE" datasource="db_logon">
--DELETE FROM dbo.Employee_File_Temp
--</cfquery>

--<!--- 
--Dump qury_Case to view output 
--<cfdump var="#qry_Case#" expand="no" LABEL="qry_Case" OUTPUT="browser" top="100"><BR />
----->

--<cfloop query="qry_Case" >  
--        <CFIF (qry_Case.RDA) EQ ('RDA STAFF')>
--        	<cfset qry_Case.LAWSON_JOB_TITLE = 'RDA STAFF'>
--        	<cfset qry_Case.JOB_TITLE = 'RDA STAFF'>
--		</CFIF>  

        
--        <CFIF (qry_Case.LOC_NUM) EQ ('46')>
--        	<cfset qry_Case.GROUPS = 'RDA STAFF'>
--		</CFIF> 
        
--        <CFIF (qry_Case.LOC_NUM) EQ ('44')>
--        	<cfset qry_Case.GROUPS = 'RDA STAFF'>
--		</CFIF> 
        
--         <CFIF (qry_Case.LOC_NUM) EQ ('46')>
--        	<cfset qry_Case.SECURITY_LVL = '2'>
--		</CFIF>
        
--         <CFIF (qry_Case.LOC_NUM) EQ ('44')>
--        	<cfset qry_Case.SECURITY_LVL = '2'>
--		</CFIF> 
--         <CFIF (qry_Case.LOC_NUM) EQ ('49')>
--        	<cfset qry_Case.SECURITY_LVL = '2'>
--		</CFIF> 
--         <CFIF (qry_Case.LOC_NUM) EQ ('49')>
--        	<cfset qry_Case.GROUPS = 'RDA STAFF'>
--		</CFIF> 
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('139700')>
--        	<cfset qry_Case.LOC_NUM = '280'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'Susie Reyos Marmon Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('124031')>
--        	<cfset qry_Case.LOC_NUM = '258'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'Eubank Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('71230')>
--        	<cfset qry_Case.LOC_NUM = '46'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('131789')>
--        	<cfset qry_Case.LOC_NUM = '46'>
--            <cfset qry_Case.SECURITY_LVL = '2'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('141044')>
--        	<cfset qry_Case.LOC_NUM = '370'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'Valle Vista Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('138300')>
--        	<cfset qry_Case.LOC_NUM = '046'>
--            <CFSET qry_Case.GROUPS = 'RDA STAFF'>
--            <cfset qry_Case.SECURITY_LVL = '2'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('137979')>
--        	<cfset qry_Case.LOC_NUM = '376'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'Wherry Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>            

--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('204864')>
--        	<cfset qry_Case.LOC_NUM = '376'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'Wherry Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>            

--<!---         <CFIF (qry_Case.RDA) EQ ('FINE_ARTS')>
--        	<cfset qry_Case.LAWSON_JOB_TITLE = 'FINE_ARTS'>
--            <CFSET qry_Case.SECURITY_LVL = '2'>
--            <CFSET qry_Case.GROUPS = 'Teacher'>
--		</CFIF>  
-- --->
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('34083')>
--        	<cfset qry_Case.LOC_NUM = '275'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'Painted Sky Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>            

            
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('202983')>
--        	<cfset qry_Case.LOC_NUM = '231'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'KIT CARSON Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('121709')>
--        	<cfset qry_Case.LOC_NUM = '379'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'WHITTIER Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('202945')>
--        	<cfset qry_Case.LOC_NUM = '336'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'LOS RANCHOS Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('111275')>
--        	<cfset qry_Case.LOC_NUM = '376'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'WHERRY Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('105553')>
--        	<cfset qry_Case.LOC_NUM = '288'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'LAVALAND Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ('124607')>
--			<cfset qry_Case.SECURITY_LVL = '5'>
--		</CFIF>
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ('102916')>
--			<cfset qry_Case.SECURITY_LVL = '5'>
--		</CFIF>        
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('120673')>
--        	<cfset qry_Case.LOC_NUM = '315'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'MONTEZUMA Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('120929')>
--        	<cfset qry_Case.LOC_NUM = '339'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'CARLOS REY Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('87975')>
--        	<cfset qry_Case.LOC_NUM = '270'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'HAWTHORNE Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('5588')>
--        	<cfset qry_Case.LOC_NUM = '333'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'PAJARITO Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('139955')>
--        	<cfset qry_Case.LOC_NUM = '356'>
--            <CFSET qry_Case.LOC_DESCRIPTION = 'SIERRA VISTA Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <CFSET qry_Case.GROUPS = 'TEACHER'>
--		</CFIF>  
        
        
        
-- <!---       
--        <!--- Dante Tuton wants access to principal docs. I hard coded it in here just for her --->
--         <CFIF (qry_Case.EMPLOYEE_ID) EQ ('136978')>
--        	<cfset qry_Case.SECURITY_LVL = '5'>
--		</CFIF> 
        
--         <CFIF (qry_Case.EMPLOYEE_ID) EQ ('139955')>
--         	<cfset qry_Case.LOC_DESCRIPTION = 'Rudolfo Anaya Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <cfset qry_Case.GROUPS = 'TEACHER'>
--        	<cfset qry_Case.LOC_NUM = '392'>
--		</CFIF> 
        
--         <CFIF (qry_Case.EMPLOYEE_ID) EQ ('128188')>
--         	<cfset qry_Case.LOC_DESCRIPTION = 'Mary Ann Binford Elementary School'>
--            <cfset qry_Case.SECURITY_LVL = '9'>
--            <cfset qry_Case.GROUPS = 'TEACHER'>
--        	<cfset qry_Case.LOC_NUM = '250'>
--            <cfset qry_Case.JOB_TITLE_ABBREVIATION = 'TEACHER'>
--        	<cfset qry_Case.LLAWSON_JOB_TITLE = 'TEACHER: TITLE I'>
--		</CFIF> 
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('203513')>
--        	<cfset qry_Case.JOB_TITLE = 'Teacher'>
--		</CFIF> 
        
--        <CFIF (qry_Case.EMPLOYEE_ID) EQ ('51768')>
--        	<cfset qry_Case.JOB_TITLE = 'RDA STAFF'>
--		</CFIF> 
----->        
--        <CFSET DATE_CREATE = DateFormat("#Today#", "m/d/yyyy") & " " & TimeFormat("#Today#", "h:mm:ss tt")>
--        <CFSET DATE_ASSIG = DateFormat("#DATE_ASSIGN#", "m/d/yyyy") & " " & TimeFormat("#Today#", "h:mm:ss tt")>
     
--           <cfquery name="Case_Insert" datasource="db_logon">
--           Insert into dbo.Employee_File_Temp
--               (EMPLOYEE_ID
--               ,LOC_NUM
--               ,LOC_DESCRIPTION
--               ,ACCESS_CODE
--               ,FIRST_NAME
--               ,LAST_NAME
--               ,LAWSON_JOB_TITLE
--               ,JOB_TITLE_ABBREVIATION
--               ,[GROUP]
--               ,SECURITY_LVL
--               ,DATE_CREATE
--               ,BIRTHYEAR
--               ,EMAIL_ADDRESS
--               ,DATE_ASSIGN)
           
--           VALUES
--               (#Employee_ID#
--               ,#LOC_NUM#
--               ,'#LOC_DESCRIPTION#'
--               ,#ACCESS_CODE#
--               ,'#FIRST_NAME#'
--               ,'#LAST_NAME#'
--               ,'#LAWSON_JOB_TITLE#'
--               ,'#JOB_TITLE#'
--               ,'#GROUPS#'
--               ,'#SECURITY_LVL#'
--               ,'#DATE_CREATE#'
--               ,'#BIRTHYEAR#'
--               ,'#EMAIL_ADDRESS#'
--               ,'#DATE_ASSIGN#')
--           </cfquery>
--</cfloop>     









