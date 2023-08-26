CREATE TABLE [dbo].[ShoppingListItemCheckout] (
    [id]               BIGINT   IDENTITY (1, 1) NOT NULL,
    [shopping_list_id] INT      NOT NULL,
    [item_id]          INT      NOT NULL,
    [is_selected]      BIT      CONSTRAINT [DF_ShoppingListItemCheckout_is_selected] DEFAULT ((0)) NULL,
    [create_date]      DATETIME CONSTRAINT [DF_Table_1_create_data] DEFAULT (getdate()) NULL,
    [update_date]      DATETIME CONSTRAINT [DF_ShoppingListItemCheckout_update_date] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ShoppingListItemCheckout] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_shopping_list_item_id]
    ON [dbo].[ShoppingListItemCheckout]([shopping_list_id] ASC, [item_id] ASC);

