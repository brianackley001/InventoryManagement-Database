CREATE TABLE [stock].[Item] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [category_id]     INT           NOT NULL,
    [sub_category_id] INT           NOT NULL,
    [name]            VARCHAR (100) NOT NULL,
    [create_date]     DATETIME      CONSTRAINT [DF_CategoryItem_create_date] DEFAULT (getdate()) NULL,
    [update_date]     DATETIME      CONSTRAINT [DF_CategoryItem_update_date] DEFAULT (getdate()) NULL,
    [is_active]       BIT           CONSTRAINT [DF_CategoryItem_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_Item_1] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_Item_Category] FOREIGN KEY ([category_id]) REFERENCES [stock].[Category] ([id]),
    CONSTRAINT [FK_Item_SubCategory] FOREIGN KEY ([sub_category_id]) REFERENCES [stock].[SubCategory] ([id])
);

