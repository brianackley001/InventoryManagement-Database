/****** Object:  StoredProcedure [dbo].[getItemsByTags]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getItemsByTags]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getItemsByTags] AS' 
END
GO




ALTER PROCEDURE [dbo].[getItemsByTags] 
	@subscriptionID INT,
	@ids			IDTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	i.[id], i.[subscription_id], i.[name], i.[description], i.[amount_value], i.[create_date], i.[update_date], i.[is_active], 
			t.[name] 'tag_name', t.id 'tag_id'
	  FROM	@ids tagIds INNER
	  JOIN	[dbo].[ItemTag] it (NOLOCK)
	    ON	tagIds.id = it.tag_id INNER
	  JOIN	Tag t (NOLOCK)
	    ON	tagIds.id = t.id INNER 
	  JOIN	[dbo].[Item] i (NOLOCK)
	    ON	i.id = it.item_id
	 WHERE	i.subscription_id = @subscriptionID;
END
GO
