/****** Object:  UserDefinedTableType [dbo].[ShoppingListItemTVP]    Script Date: 12/1/2019 9:44:28 PM ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'ShoppingListItemTVP' AND ss.name = N'dbo')
CREATE TYPE [dbo].[ShoppingListItemTVP] AS TABLE(
	[shoppingListID] [int] NOT NULL,
	[itemID] [int] NOT NULL,
	[subscriptionID] [int] NULL,
	[isActive] [bit] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[itemID] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
