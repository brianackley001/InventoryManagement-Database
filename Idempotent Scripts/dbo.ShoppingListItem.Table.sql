/****** Object:  Table [dbo].[ShoppingListItem]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShoppingListItem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subscription_id] [int] NOT NULL,
	[shopping_list_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[create_date] [datetime] NOT NULL,
	[update_date] [datetime] NOT NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_ShoppingListItem] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [IDX_Subscription_ID_ShoppingList_ID]    Script Date: 12/1/2019 9:44:28 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]') AND name = N'IDX_Subscription_ID_ShoppingList_ID')
CREATE NONCLUSTERED INDEX [IDX_Subscription_ID_ShoppingList_ID] ON [dbo].[ShoppingListItem]
(
	[subscription_id] ASC,
	[shopping_list_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ShoppingListItem_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShoppingListItem] ADD  CONSTRAINT [DF_ShoppingListItem_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ShoppingListItem_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShoppingListItem] ADD  CONSTRAINT [DF_ShoppingListItem_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ShoppingListItem_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShoppingListItem] ADD  CONSTRAINT [DF_ShoppingListItem_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingListItem_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]'))
ALTER TABLE [dbo].[ShoppingListItem]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingListItem_Item] FOREIGN KEY([item_id])
REFERENCES [dbo].[Item] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingListItem_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]'))
ALTER TABLE [dbo].[ShoppingListItem] CHECK CONSTRAINT [FK_ShoppingListItem_Item]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingListItem_ShoppingList1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]'))
ALTER TABLE [dbo].[ShoppingListItem]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingListItem_ShoppingList1] FOREIGN KEY([shopping_list_id])
REFERENCES [dbo].[ShoppingList] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingListItem_ShoppingList1]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]'))
ALTER TABLE [dbo].[ShoppingListItem] CHECK CONSTRAINT [FK_ShoppingListItem_ShoppingList1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingListItem_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]'))
ALTER TABLE [dbo].[ShoppingListItem]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingListItem_Subscription] FOREIGN KEY([subscription_id])
REFERENCES [dbo].[Subscription] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingListItem_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingListItem]'))
ALTER TABLE [dbo].[ShoppingListItem] CHECK CONSTRAINT [FK_ShoppingListItem_Subscription]
GO
