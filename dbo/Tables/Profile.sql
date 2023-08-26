CREATE TABLE [dbo].[Profile] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [auth_id]     VARCHAR (500) NOT NULL,
    [source]      VARCHAR (100) NULL,
    [name]        VARCHAR (150) NULL,
    [create_date] DATETIME      CONSTRAINT [DF_Profile_create_date] DEFAULT (getdate()) NULL,
    [update_date] DATETIME      CONSTRAINT [DF_Profile_update_date] DEFAULT (getdate()) NULL,
    [is_active]   BIT           CONSTRAINT [DF_Profile_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Profile_1]
    ON [dbo].[Profile]([auth_id] ASC, [id] ASC)
    INCLUDE([source], [name], [create_date], [update_date], [is_active]);


GO
CREATE STATISTICS [_dta_stat_1637580872_1_2]
    ON [dbo].[Profile]([id], [auth_id]);

