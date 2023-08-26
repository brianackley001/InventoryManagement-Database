

CREATE PROCEDURE [dbo].[getItemGroups] 
	@itemID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	ig.[id] ItemGroupId, ig.[item_id] ItemId, ig.[group_id] 'id', g.[name], ig.[create_date] CreateDate, ig.[update_date] UpdateDate, ig.[is_active] IsActive
	  FROM	[dbo].[ItemGroup] ig INNER
	  JOIN	[dbo].[Group] g
	    ON	g.[id] = ig.[group_id]
	WHERE	ig.[item_id] = @itemID;
END
