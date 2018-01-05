USE [db_Logon];
GO

IF OBJECT_ID('[dbo].[usp_Employee_File_Contact_InfoSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_File_Contact_InfoSelect] 
END 
GO
CREATE PROC [dbo].[usp_Employee_File_Contact_InfoSelect] 
    @EMPLOYEE_ID INT,
    @LOC_NUM INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [EMPLOYEE_ID], [LOC_NUM], [TEST_REP], [EMAIL], [EMAIL_VALID], [PHONE], [EXT], [CONFIRMED] 
	FROM   [dbo].[Employee_File_Contact_Info] 
	WHERE  ([EMPLOYEE_ID] = @EMPLOYEE_ID OR @EMPLOYEE_ID IS NULL) 
	       AND ([LOC_NUM] = @LOC_NUM OR @LOC_NUM IS NULL) 

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Employee_File_Contact_InfoInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_File_Contact_InfoInsert] 
END 
GO
CREATE PROC [dbo].[usp_Employee_File_Contact_InfoInsert] 
    @EMPLOYEE_ID int,
    @LOC_NUM int,
    @TEST_REP nvarchar(10),
    @EMAIL nvarchar(75),
    @EMAIL_VALID nvarchar(1),
    @PHONE nvarchar(50),
    @EXT nvarchar(50),
    @CONFIRMED nvarchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Employee_File_Contact_Info] ([EMPLOYEE_ID], [LOC_NUM], [TEST_REP], [EMAIL], [EMAIL_VALID], [PHONE], [EXT], [CONFIRMED])
	SELECT @EMPLOYEE_ID, @LOC_NUM, @TEST_REP, @EMAIL, @EMAIL_VALID, @PHONE, @EXT, @CONFIRMED
	
	-- Begin Return Select <- do not remove
	SELECT [EMPLOYEE_ID], [LOC_NUM], [TEST_REP], [EMAIL], [EMAIL_VALID], [PHONE], [EXT], [CONFIRMED]
	FROM   [dbo].[Employee_File_Contact_Info]
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM
	-- End Return Select <- do not remove
               
	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Employee_File_Contact_InfoUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_File_Contact_InfoUpdate] 
END 
GO
CREATE PROC [dbo].[usp_Employee_File_Contact_InfoUpdate] 
    @EMPLOYEE_ID int,
    @LOC_NUM int,
    @TEST_REP nvarchar(10),
    @EMAIL nvarchar(75),
    @EMAIL_VALID nvarchar(1),
    @PHONE nvarchar(50),
    @EXT nvarchar(50),
    @CONFIRMED nvarchar(50)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Employee_File_Contact_Info]
	SET    [EMPLOYEE_ID] = @EMPLOYEE_ID, [LOC_NUM] = @LOC_NUM, [TEST_REP] = @TEST_REP, [EMAIL] = @EMAIL, [EMAIL_VALID] = @EMAIL_VALID, [PHONE] = @PHONE, [EXT] = @EXT, [CONFIRMED] = @CONFIRMED
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM
	
	-- Begin Return Select <- do not remove
	SELECT [EMPLOYEE_ID], [LOC_NUM], [TEST_REP], [EMAIL], [EMAIL_VALID], [PHONE], [EXT], [CONFIRMED]
	FROM   [dbo].[Employee_File_Contact_Info]
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM	
	-- End Return Select <- do not remove

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Employee_File_Contact_InfoDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_File_Contact_InfoDelete] 
END 
GO
CREATE PROC [dbo].[usp_Employee_File_Contact_InfoDelete] 
    @EMPLOYEE_ID int,
    @LOC_NUM int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Employee_File_Contact_Info]
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM

	COMMIT
GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('[dbo].[usp_Employee_ListServeSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_ListServeSelect] 
END 
GO
CREATE PROC [dbo].[usp_Employee_ListServeSelect] 
    @EMPLOYEE_ID INT,
    @LOC_NUM INT,
    @GRADE_COMMUNICATION NVARCHAR(2)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [EMPLOYEE_ID], [LOC_NUM], [GRADE_COMMUNICATION] 
	FROM   [dbo].[Employee_ListServe] 
	WHERE  ([EMPLOYEE_ID] = @EMPLOYEE_ID OR @EMPLOYEE_ID IS NULL) 
	       AND ([LOC_NUM] = @LOC_NUM OR @LOC_NUM IS NULL) 
	       AND ([GRADE_COMMUNICATION] = @GRADE_COMMUNICATION OR @GRADE_COMMUNICATION IS NULL) 

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Employee_ListServeInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_ListServeInsert] 
END 
GO
CREATE PROC [dbo].[usp_Employee_ListServeInsert] 
    @EMPLOYEE_ID int,
    @LOC_NUM int,
    @GRADE_COMMUNICATION nvarchar(2)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Employee_ListServe] ([EMPLOYEE_ID], [LOC_NUM], [GRADE_COMMUNICATION])
	SELECT @EMPLOYEE_ID, @LOC_NUM, @GRADE_COMMUNICATION
	
	-- Begin Return Select <- do not remove
	SELECT [EMPLOYEE_ID], [LOC_NUM], [GRADE_COMMUNICATION]
	FROM   [dbo].[Employee_ListServe]
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM
	       AND [GRADE_COMMUNICATION] = @GRADE_COMMUNICATION
	-- End Return Select <- do not remove
               
	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Employee_ListServeUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_ListServeUpdate] 
END 
GO
CREATE PROC [dbo].[usp_Employee_ListServeUpdate] 
    @EMPLOYEE_ID int,
    @LOC_NUM int,
    @GRADE_COMMUNICATION nvarchar(2)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Employee_ListServe]
	SET    [EMPLOYEE_ID] = @EMPLOYEE_ID, [LOC_NUM] = @LOC_NUM, [GRADE_COMMUNICATION] = @GRADE_COMMUNICATION
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM
	       AND [GRADE_COMMUNICATION] = @GRADE_COMMUNICATION
	
	-- Begin Return Select <- do not remove
	SELECT [EMPLOYEE_ID], [LOC_NUM], [GRADE_COMMUNICATION]
	FROM   [dbo].[Employee_ListServe]
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM
	       AND [GRADE_COMMUNICATION] = @GRADE_COMMUNICATION	
	-- End Return Select <- do not remove

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Employee_ListServeDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_Employee_ListServeDelete] 
END 
GO
CREATE PROC [dbo].[usp_Employee_ListServeDelete] 
    @EMPLOYEE_ID int,
    @LOC_NUM int,
    @GRADE_COMMUNICATION nvarchar(2)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[Employee_ListServe]
	WHERE  [EMPLOYEE_ID] = @EMPLOYEE_ID
	       AND [LOC_NUM] = @LOC_NUM
	       AND [GRADE_COMMUNICATION] = @GRADE_COMMUNICATION

	COMMIT
GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

IF OBJECT_ID('[dbo].[usp_tbl_Web_LinksSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_tbl_Web_LinksSelect] 
END 
GO
CREATE PROC [dbo].[usp_tbl_Web_LinksSelect] 
    @fld_ID INT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [fld_ID], [fld_HREF], [fld_TITLE], [fld_DISPLAY], [fld_StartDate], [fld_EndDate], [fld_SchoolLevel], [fld_Table], [fld_AdditionalText], [fld_PreLinkText] 
	FROM   [dbo].[tbl_Web_Links] 
	WHERE  ([fld_ID] = @fld_ID OR @fld_ID IS NULL) 

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_tbl_Web_LinksInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_tbl_Web_LinksInsert] 
END 
GO
CREATE PROC [dbo].[usp_tbl_Web_LinksInsert] 
    @fld_ID int,
    @fld_HREF varchar(MAX),
    @fld_TITLE varchar(150),
    @fld_DISPLAY varchar(150),
    @fld_StartDate smalldatetime,
    @fld_EndDate smalldatetime,
    @fld_SchoolLevel varchar(3),
    @fld_Table varchar(25),
    @fld_AdditionalText varchar(150),
    @fld_PreLinkText varchar(150)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[tbl_Web_Links] ([fld_ID], [fld_HREF], [fld_TITLE], [fld_DISPLAY], [fld_StartDate], [fld_EndDate], [fld_SchoolLevel], [fld_Table], [fld_AdditionalText], [fld_PreLinkText])
	SELECT @fld_ID, @fld_HREF, @fld_TITLE, @fld_DISPLAY, @fld_StartDate, @fld_EndDate, @fld_SchoolLevel, @fld_Table, @fld_AdditionalText, @fld_PreLinkText
	
	-- Begin Return Select <- do not remove
	SELECT [fld_ID], [fld_HREF], [fld_TITLE], [fld_DISPLAY], [fld_StartDate], [fld_EndDate], [fld_SchoolLevel], [fld_Table], [fld_AdditionalText], [fld_PreLinkText]
	FROM   [dbo].[tbl_Web_Links]
	WHERE  [fld_ID] = @fld_ID
	-- End Return Select <- do not remove
               
	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_tbl_Web_LinksUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_tbl_Web_LinksUpdate] 
END 
GO
CREATE PROC [dbo].[usp_tbl_Web_LinksUpdate] 
    @fld_ID int,
    @fld_HREF varchar(MAX),
    @fld_TITLE varchar(150),
    @fld_DISPLAY varchar(150),
    @fld_StartDate smalldatetime,
    @fld_EndDate smalldatetime,
    @fld_SchoolLevel varchar(3),
    @fld_Table varchar(25),
    @fld_AdditionalText varchar(150),
    @fld_PreLinkText varchar(150)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[tbl_Web_Links]
	SET    [fld_ID] = @fld_ID, [fld_HREF] = @fld_HREF, [fld_TITLE] = @fld_TITLE, [fld_DISPLAY] = @fld_DISPLAY, [fld_StartDate] = @fld_StartDate, [fld_EndDate] = @fld_EndDate, [fld_SchoolLevel] = @fld_SchoolLevel, [fld_Table] = @fld_Table, [fld_AdditionalText] = @fld_AdditionalText, [fld_PreLinkText] = @fld_PreLinkText
	WHERE  [fld_ID] = @fld_ID
	
	-- Begin Return Select <- do not remove
	SELECT [fld_ID], [fld_HREF], [fld_TITLE], [fld_DISPLAY], [fld_StartDate], [fld_EndDate], [fld_SchoolLevel], [fld_Table], [fld_AdditionalText], [fld_PreLinkText]
	FROM   [dbo].[tbl_Web_Links]
	WHERE  [fld_ID] = @fld_ID	
	-- End Return Select <- do not remove

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_tbl_Web_LinksDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[usp_tbl_Web_LinksDelete] 
END 
GO
CREATE PROC [dbo].[usp_tbl_Web_LinksDelete] 
    @fld_ID int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE
	FROM   [dbo].[tbl_Web_Links]
	WHERE  [fld_ID] = @fld_ID

	COMMIT
GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

