CREATE TABLE [dbo].[Subscription] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [name]        VARCHAR (255) NOT NULL,
    [create_date] DATETIME      CONSTRAINT [DF_Subscription_create_date] DEFAULT (getdate()) NULL,
    [update_date] DATETIME      CONSTRAINT [DF_Subscription_update_date] DEFAULT (getdate()) NULL,
    [is_active]   BIT           CONSTRAINT [DF_Subscription_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED ([id] ASC)
);

