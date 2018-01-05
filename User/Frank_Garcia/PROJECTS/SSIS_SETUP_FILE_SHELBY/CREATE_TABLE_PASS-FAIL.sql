USE [SCHOOLNET]
GO

/****** Object:  Table [dbo].[pass_fail]    Script Date: 4/12/2013 2:49:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[pass_fail](
	[test_name] [varchar](50) NULL,
	[aps_subtest_name] [varchar](50) NULL,
	[schoolnet_subtest_name] [varchar](50) NULL,
	[cut_score] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
