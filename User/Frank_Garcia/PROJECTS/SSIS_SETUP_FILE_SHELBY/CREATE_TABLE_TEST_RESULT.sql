USE [SCHOOLNET]
GO

/****** Object:  Table [dbo].[TEST_RESULT_template]    Script Date: 4/12/2013 2:55:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TEST_RESULT_template](
	[test_name] [varchar](50) NULL,
	[student_code] [varchar](50) NULL,
	[school_year] [int] NULL,
	[school_code] [varchar](50) NULL,
	[test_date_code] [date] NULL,
	[test_type_code] [varchar](50) NULL,
	[test_type_name] [varchar](50) NULL,
	[test_section_code] [varchar](50) NULL,
	[test_section_name] [varchar](100) NULL,
	[parent_test_section_code] [varchar](50) NULL,
	[low_test_level_code] [varchar](50) NULL,
	[high_test_level_code] [varchar](50) NULL,
	[test_level_name] [varchar](50) NULL,
	[version_code] [varchar](50) NULL,
	[score_group_name] [varchar](50) NULL,
	[score_group_code] [varchar](50) NULL,
	[score_group_label] [varchar](50) NULL,
	[last_name] [varchar](100) NULL,
	[first_name] [varchar](100) NULL,
	[dob] [date] NULL,
	[raw_score] [decimal](18, 0) NULL,
	[scaled_score] [decimal](18, 0) NULL,
	[nce_score] [decimal](18, 0) NULL,
	[percentile_score] [decimal](18, 0) NULL,
	[score_1] [varchar](40) NULL,
	[score_2] [varchar](40) NULL,
	[score_raw_name] [varchar](50) NULL,
	[score_scaled_name] [varchar](50) NULL,
	[score_nce_name] [varchar](50) NULL,
	[score_percentile_name] [varchar](50) NULL,
	[score_1_name] [varchar](50) NULL,
	[score_2_name] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
