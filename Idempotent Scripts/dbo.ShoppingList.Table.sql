/****** Object:  Table [dbo].[ShoppingList]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShoppingList]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShoppingList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subscription_id] [int] NOT NULL,
	[name] [varchar](255) NOT NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[is_active] [bit] NULL,
 CONSTRAINT [PK_ShoppingList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [ClusteredIndex_Subscription_ID]    Script Date: 12/1/2019 9:44:28 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShoppingList]') AND name = N'ClusteredIndex_Subscription_ID')
CREATE NONCLUSTERED INDEX [ClusteredIndex_Subscription_ID] ON [dbo].[ShoppingList]
(
	[subscription_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ShoppingList_create_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShoppingList] ADD  CONSTRAINT [DF_ShoppingList_create_date]  DEFAULT (getdate()) FOR [create_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ShoppingList_update_date]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShoppingList] ADD  CONSTRAINT [DF_ShoppingList_update_date]  DEFAULT (getdate()) FOR [update_date]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_ShoppingList_is_active]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShoppingList] ADD  CONSTRAINT [DF_ShoppingList_is_active]  DEFAULT ((1)) FOR [is_active]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingList_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingList]'))
ALTER TABLE [dbo].[ShoppingList]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingList_Subscription] FOREIGN KEY([subscription_id])
REFERENCES [dbo].[Subscription] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShoppingList_Subscription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShoppingList]'))
ALTER TABLE [dbo].[ShoppingList] CHECK CONSTRAINT [FK_ShoppingList_Subscription]
GO
