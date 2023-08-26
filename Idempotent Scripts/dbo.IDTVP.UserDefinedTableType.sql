/****** Object:  UserDefinedTableType [dbo].[IDTVP]    Script Date: 12/1/2019 9:44:28 PM ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'IDTVP' AND ss.name = N'dbo')
CREATE TYPE [dbo].[IDTVP] AS TABLE(
	[id] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
