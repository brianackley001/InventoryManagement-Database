CREATE TABLE [stock].[SubCategory] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [category_id] INT           NOT NULL,
    [name]        VARCHAR (100) NOT NULL,
    [create_date] DATETIME      CONSTRAINT [DF_SubCategory_create_date] DEFAULT (getdate()) NULL,
    [update_date] DATETIME      CONSTRAINT [DF_SubCategory_update_date] DEFAULT (getdate()) NULL,
    [is_active]   BIT           CONSTRAINT [DF_SubCategory_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_SubCategory] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_SubCategory_Category] FOREIGN KEY ([category_id]) REFERENCES [stock].[Category] ([id])
);

