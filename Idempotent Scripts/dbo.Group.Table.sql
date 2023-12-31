/****** Object:  Table [dbo].[Group]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Group]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Group](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subscription_id] [int] NOT NULL,
	[name] [varchar](255) NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Group_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Group] ADD  CONSTRAINT [DF_Group_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Group_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Group] ADD  CONSTRAINT [DF_Group_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Group_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Group] ADD  CONSTRAINT [DF_Group_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Group_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[Group]'))
ALTER TABLE [dbo].[Group]  WITH CHECK ADD  CONSTRAINT [FK_Group_Subscription] FOREIGN KEY([subscription_id])
REFERENCES [dbo].[Subscription] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Group_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[Group]'))
ALTER TABLE [dbo].[Group] CHECK CONSTRAINT [FK_Group_Subscription]
GO
