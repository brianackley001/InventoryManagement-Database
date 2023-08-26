CREATE TABLE [dbo].[ShoppingListItem] (
    [id]               INT      IDENTITY (1, 1) NOT NULL,
    [subscription_id]  INT      NOT NULL,
    [shopping_list_id] INT      NOT NULL,
    [item_id]          INT      NOT NULL,
    [create_date]      DATETIME CONSTRAINT [DF_ShoppingListItem_create_date] DEFAULT (getdate()) NOT NULL,
    [update_date]      DATETIME CONSTRAINT [DF_ShoppingListItem_update_date] DEFAULT (getdate()) NOT NULL,
    [is_active]        BIT      CONSTRAINT [DF_ShoppingListItem_is_active] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ShoppingListItem] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ShoppingListItem_Item] FOREIGN KEY ([item_id]) REFERENCES [dbo].[Item] ([id]),
    CONSTRAINT [FK_ShoppingListItem_ShoppingList1] FOREIGN KEY ([shopping_list_id]) REFERENCES [dbo].[ShoppingList] ([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ShoppingListItem_Subscription] FOREIGN KEY ([subscription_id]) REFERENCES [dbo].[Subscription] ([id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_Subscription_ID_ShoppingList_ID]
    ON [dbo].[ShoppingListItem]([subscription_id] ASC, [shopping_list_id] ASC);

