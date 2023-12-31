/****** Object:  Table [dbo].[Subscription]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Subscription]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Subscription](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Subscription_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Subscription_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Subscription_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Subscription] ADD  CONSTRAINT [DF_Subscription_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
