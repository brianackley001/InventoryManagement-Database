CREATE TABLE [dbo].[ItemTag] (
    [id]          INT      IDENTITY (1, 1) NOT NULL,
    [item_id]     INT      NOT NULL,
    [tag_id]      INT      NOT NULL,
    [create_date] DATETIME CONSTRAINT [DF_ItemTag_create_date] DEFAULT (getdate()) NULL,
    [update_date] DATETIME CONSTRAINT [DF_ItemTag_update_date] DEFAULT (getdate()) NULL,
    [is_active]   BIT      CONSTRAINT [DF_ItemTag_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ItemTag] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ItemTag_Item] FOREIGN KEY ([item_id]) REFERENCES [dbo].[Item] ([id]),
    CONSTRAINT [FK_ItemTag_Tag] FOREIGN KEY ([tag_id]) REFERENCES [dbo].[Tag] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [IDX_ItemTag_item_id_tag_id]
    ON [dbo].[ItemTag]([item_id] ASC)
    INCLUDE([tag_id]);

