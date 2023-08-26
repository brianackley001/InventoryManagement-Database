CREATE TABLE [dbo].[ShoppingList] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [subscription_id] INT           NOT NULL,
    [name]            VARCHAR (255) NOT NULL,
    [create_date]     DATETIME      CONSTRAINT [DF_ShoppingList_create_date] DEFAULT (getdate()) NULL,
    [update_date]     DATETIME      CONSTRAINT [DF_ShoppingList_update_date] DEFAULT (getdate()) NULL,
    [is_active]       BIT           CONSTRAINT [DF_ShoppingList_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ShoppingList] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ShoppingList_Subscription] FOREIGN KEY ([subscription_id]) REFERENCES [dbo].[Subscription] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [ClusteredIndex_Subscription_ID]
    ON [dbo].[ShoppingList]([subscription_id] ASC);

