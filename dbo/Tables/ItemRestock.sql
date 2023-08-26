CREATE TABLE [dbo].[ItemRestock] (
    [id]              INT      IDENTITY (1, 1) NOT NULL,
    [subscription_id] INT      NOT NULL,
    [item_id]         INT      NOT NULL,
    [create_date]     DATETIME CONSTRAINT [DF_ItemRestock_create_date] DEFAULT (getdate()) NULL,
    [update_date]     DATETIME CONSTRAINT [DF_ItemRestock_update_date] DEFAULT (getdate()) NULL,
    [is_active]       BIT      CONSTRAINT [DF_ItemRestock_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ItemRestock] PRIMARY KEY CLUSTERED ([id] ASC, [subscription_id] ASC, [item_id] ASC),
    CONSTRAINT [FK_ItemRestock_Item1] FOREIGN KEY ([item_id]) REFERENCES [dbo].[Item] ([id]),
    CONSTRAINT [FK_ItemRestock_Subscription1] FOREIGN KEY ([subscription_id]) REFERENCES [dbo].[Subscription] ([id])
);

