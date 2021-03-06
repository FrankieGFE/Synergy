
CREATE TABLE STUDENT_ATTENDANCE
		([SIS Number] VARCHAR (9)
		,[School Code] VARCHAR (20)
		,[School Name] VARCHAR (100)
		,Grade VARCHAR (2)
		,Gender VARCHAR (2)
		,[Hispanic Indicator] VARCHAR (1)
		, [Race1] VARCHAR (50)
		, [Race2] VARCHAR (50)
		, [Race3] VARCHAR (50)
		, [Race4] VARCHAR (50)
		, [Race5] VARCHAR (50)
		,[ELL Status] VARCHAR (1)
		,[Sped Status] VARCHAR (1)
		,[Gifted Status] VARCHAR (1)
		,[Lunch Status] VARCHAR (20)
		,[Home Address] VARCHAR (100)
		,[Home City] VARCHAR (100)
		,[Home State] VARCHAR (10)
		,[Home Zip] VARCHAR (10)
		,[Half-Day Unexcused] DECIMAL(5,2)
		,[Full-Day Unexcused] DECIMAL(5,2)
		,[Total Unexcused] DECIMAL(5,2)
		,[Half-Day Excused] DECIMAL(5,2)
		,[Full-Day Excused] DECIMAL(5,2)
		,[Total Excused] DECIMAL(5,2)
		,[Member Days] NUMERIC
		,Total_Exc_Unex DECIMAL(5,2)
		) 