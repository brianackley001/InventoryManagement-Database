CREATE TABLE [stock].[Category] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [name]        VARCHAR (100) NOT NULL,
    [create_date] DATETIME      CONSTRAINT [DF_Category_create_date] DEFAULT (getdate()) NULL,
    [update_date] DATETIME      CONSTRAINT [DF_Category_update_date] DEFAULT (getdate()) NULL,
    [is_active]   BIT           CONSTRAINT [DF_Category_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED ([id] ASC)
);

