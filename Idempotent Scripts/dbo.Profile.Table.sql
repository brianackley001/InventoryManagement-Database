/****** Object:  Table [dbo].[Profile]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Profile](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[auth_id] [varchar](500) NOT NULL,
	[source] [varchar](100) NULL,
	[name] [varchar](150) NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Profile_1]    Script Date: 12/1/2019 9:44:28 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Profile]') AND name = N'_dta_index_Profile_1')
CREATE NONCLUSTERED INDEX [_dta_index_Profile_1] ON [dbo].[Profile]
(
	[auth_id] ASC,
	[id] ASC
)
INCLUDE([source],[name],[create_date],[update_date],[is_active]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Profile_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Profile_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Profile_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Profile] ADD  CONSTRAINT [DF_Profile_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
