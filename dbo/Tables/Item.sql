CREATE TABLE [dbo].[Item] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [subscription_id] INT           NOT NULL,
    [name]            VARCHAR (255) NOT NULL,
    [description]     VARCHAR (255) NULL,
    [amount_value]    INT           CONSTRAINT [DF_Item_amount_value] DEFAULT ((2)) NULL,
    [create_date]     DATETIME      CONSTRAINT [DF_Table_1_cerate_date] DEFAULT (getdate()) NULL,
    [update_date]     DATETIME      CONSTRAINT [DF_Item_update_date] DEFAULT (getdate()) NULL,
    [is_active]       BIT           CONSTRAINT [DF_Item_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Item_Subscription] FOREIGN KEY ([subscription_id]) REFERENCES [dbo].[Subscription] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);

