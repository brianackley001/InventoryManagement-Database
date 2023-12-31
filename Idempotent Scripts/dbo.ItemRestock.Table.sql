/****** Object:  Table [dbo].[ItemRestock]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemRestock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ItemRestock](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subscription_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_ItemRestock] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[subscription_id] ASC,
	[item_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemRestock_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemRestock] ADD  CONSTRAINT [DF_ItemRestock_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemRestock_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemRestock] ADD  CONSTRAINT [DF_ItemRestock_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ItemRestock_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ItemRestock] ADD  CONSTRAINT [DF_ItemRestock_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemRestock_Item1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemRestock]'))
ALTER TABLE [dbo].[ItemRestock]  WITH CHECK ADD  CONSTRAINT [FK_ItemRestock_Item1] FOREIGN KEY([item_id])
REFERENCES [dbo].[Item] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemRestock_Item1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemRestock]'))
ALTER TABLE [dbo].[ItemRestock] CHECK CONSTRAINT [FK_ItemRestock_Item1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemRestock_Subscription1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemRestock]'))
ALTER TABLE [dbo].[ItemRestock]  WITH CHECK ADD  CONSTRAINT [FK_ItemRestock_Subscription1] FOREIGN KEY([subscription_id])
REFERENCES [dbo].[Subscription] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemRestock_Subscription1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemRestock]'))
ALTER TABLE [dbo].[ItemRestock] CHECK CONSTRAINT [FK_ItemRestock_Subscription1]
GO
