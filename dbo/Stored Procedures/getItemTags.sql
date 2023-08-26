

CREATE PROCEDURE [dbo].[getItemTags] 
	@itemID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	it.[id] ItemTagId, it.[item_id] ItemId, it.[tag_id] 'id', t.[name], it.[create_date] CreateDate, it.[update_date] UpdateDate, it.[is_active] IsActive
	  FROM	[dbo].[ItemTag] it INNER
	  JOIN	[dbo].[Tag] t
	    ON	t.[id] = it.[tag_id]
	WHERE	it.[item_id] = @itemID;
END
