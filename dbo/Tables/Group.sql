﻿CREATE TABLE [dbo].[Group] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [subscription_id] INT           NOT NULL,
    [name]            VARCHAR (255) NOT NULL,
    [create_date]     DATETIME      CONSTRAINT [DF_Group_create_date] DEFAULT (getdate()) NULL,
    [update_date]     DATETIME      CONSTRAINT [DF_Group_update_date] DEFAULT (getdate()) NULL,
    [is_active]       BIT           CONSTRAINT [DF_Group_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Group_Subscription] FOREIGN KEY ([subscription_id]) REFERENCES [dbo].[Subscription] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);

