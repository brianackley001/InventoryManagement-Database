/****** Object:  Table [dbo].[ItemGroup]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ItemGroup](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[item_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_ItemGroup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemGroup_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemGroup] ADD  CONSTRAINT [DF_ItemGroup_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemGroup_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemGroup] ADD  CONSTRAINT [DF_ItemGroup_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemGroup_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemGroup] ADD  CONSTRAINT [DF_ItemGroup_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemGroup_Group]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemGroup]'))
ALTER TABLE [dbo].[ItemGroup]  WITH CHECK ADD  CONSTRAINT [FK_ItemGroup_Group] FOREIGN KEY([group_id])
REFERENCES [dbo].[Group] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemGroup_Group]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemGroup]'))
ALTER TABLE [dbo].[ItemGroup] CHECK CONSTRAINT [FK_ItemGroup_Group]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemGroup_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemGroup]'))
ALTER TABLE [dbo].[ItemGroup]  WITH CHECK ADD  CONSTRAINT [FK_ItemGroup_Item] FOREIGN KEY([item_id])
REFERENCES [dbo].[Item] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemGroup_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemGroup]'))
ALTER TABLE [dbo].[ItemGroup] CHECK CONSTRAINT [FK_ItemGroup_Item]
GO
