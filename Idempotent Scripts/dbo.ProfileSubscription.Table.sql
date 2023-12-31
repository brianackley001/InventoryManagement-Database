/****** Object:  Table [dbo].[ProfileSubscription]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfileSubscription]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProfileSubscription](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[profile_id] [int] NOT NULL,
	[subscription_id] [int] NOT NULL,
	[active_selection] [bit] NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_ProfileSubscription] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ProfileSubscription_active_selection]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfileSubscription] ADD  CONSTRAINT [DF_ProfileSubscription_active_selection]  DEFAULT ((0)) FOR [active_selection]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ProfileSubscription_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfileSubscription] ADD  CONSTRAINT [DF_ProfileSubscription_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ProfileSubscription_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfileSubscription] ADD  CONSTRAINT [DF_ProfileSubscription_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ProfileSubscription_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfileSubscription] ADD  CONSTRAINT [DF_ProfileSubscription_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Profile_ProfileSubscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfileSubscription]'))
ALTER TABLE [dbo].[ProfileSubscription]  WITH CHECK ADD  CONSTRAINT [FK_Profile_ProfileSubscription] FOREIGN KEY([profile_id])
REFERENCES [dbo].[Profile] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Profile_ProfileSubscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfileSubscription]'))
ALTER TABLE [dbo].[ProfileSubscription] CHECK CONSTRAINT [FK_Profile_ProfileSubscription]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfileSubscription_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfileSubscription]'))
ALTER TABLE [dbo].[ProfileSubscription]  WITH CHECK ADD  CONSTRAINT [FK_ProfileSubscription_Subscription] FOREIGN KEY([subscription_id])
REFERENCES [dbo].[Subscription] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfileSubscription_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfileSubscription]'))
ALTER TABLE [dbo].[ProfileSubscription] CHECK CONSTRAINT [FK_ProfileSubscription_Subscription]
GO
