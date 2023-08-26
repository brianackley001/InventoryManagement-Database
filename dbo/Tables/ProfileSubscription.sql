CREATE TABLE [dbo].[ProfileSubscription] (
    [id]               INT      IDENTITY (1, 1) NOT NULL,
    [profile_id]       INT      NOT NULL,
    [subscription_id]  INT      NOT NULL,
    [active_selection] BIT      CONSTRAINT [DF_ProfileSubscription_active_selection] DEFAULT ((0)) NOT NULL,
    [create_date]      DATETIME CONSTRAINT [DF_ProfileSubscription_create_date] DEFAULT (getdate()) NULL,
    [update_date]      DATETIME CONSTRAINT [DF_ProfileSubscription_update_date] DEFAULT (getdate()) NULL,
    [is_active]        BIT      CONSTRAINT [DF_ProfileSubscription_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ProfileSubscription] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Profile_ProfileSubscription] FOREIGN KEY ([profile_id]) REFERENCES [dbo].[Profile] ([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ProfileSubscription_Subscription] FOREIGN KEY ([subscription_id]) REFERENCES [dbo].[Subscription] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);

