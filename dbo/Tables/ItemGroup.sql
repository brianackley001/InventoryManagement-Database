CREATE TABLE [dbo].[ItemGroup] (
    [id]          INT      IDENTITY (1, 1) NOT NULL,
    [item_id]     INT      NOT NULL,
    [group_id]    INT      NOT NULL,
    [create_date] DATETIME CONSTRAINT [DF_ItemGroup_create_date] DEFAULT (getdate()) NULL,
    [update_date] DATETIME CONSTRAINT [DF_ItemGroup_update_date] DEFAULT (getdate()) NULL,
    [is_active]   BIT      CONSTRAINT [DF_ItemGroup_is_active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ItemGroup] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ItemGroup_Group] FOREIGN KEY ([group_id]) REFERENCES [dbo].[Group] ([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ItemGroup_Item] FOREIGN KEY ([item_id]) REFERENCES [dbo].[Item] ([id])
);




GO
CREATE NONCLUSTERED INDEX [IDX_ItemGroup_item_id_group_id]
    ON [dbo].[ItemGroup]([item_id] ASC)
    INCLUDE([group_id]);

