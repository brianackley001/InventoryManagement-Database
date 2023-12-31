/****** Object:  Table [dbo].[ItemTag]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemTag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ItemTag](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[item_id] [int] NOT NULL,
	[tag_id] [int] NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_ItemTag] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemTag_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemTag] ADD  CONSTRAINT [DF_ItemTag_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemTag_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemTag] ADD  CONSTRAINT [DF_ItemTag_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemTag_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemTag] ADD  CONSTRAINT [DF_ItemTag_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemTag_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemTag]'))
ALTER TABLE [dbo].[ItemTag]  WITH CHECK ADD  CONSTRAINT [FK_ItemTag_Item] FOREIGN KEY([item_id])
REFERENCES [dbo].[Item] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemTag_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemTag]'))
ALTER TABLE [dbo].[ItemTag] CHECK CONSTRAINT [FK_ItemTag_Item]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemTag_Tag]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemTag]'))
ALTER TABLE [dbo].[ItemTag]  WITH CHECK ADD  CONSTRAINT [FK_ItemTag_Tag] FOREIGN KEY([tag_id])
REFERENCES [dbo].[Tag] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemTag_Tag]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemTag]'))
ALTER TABLE [dbo].[ItemTag] CHECK CONSTRAINT [FK_ItemTag_Tag]
GO
