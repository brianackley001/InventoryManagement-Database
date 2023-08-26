
CREATE PROCEDURE [dbo].[getTagsWithItemCounts] 
	@subscriptionID		INT,
	@pageNum			INT = 1, 
	@pageSize			INT = 25,
	@sortBy				VARCHAR(50) = 'name',
	@sortAsc			BIT = 1,
	@collectionTotal	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Tag]
	 WHERE	subscription_id = @subscriptionID;


	SELECT	t.[id], t.[subscription_id] SubscriptionId, t.[name], t.[create_date] CreateDate, 
			t.[update_date] UpdateDate, t.[is_active] IsActive, COUNT(it.id) as ItemCount 
	  FROM	[dbo].[Tag] t LEFT
	  JOIN	[dbo].[ItemTag] it 
	    ON	t.id = it.tag_id LEFT 
	  JOIN	[dbo].[Item] i
		ON	i.id = it.item_id
	 WHERE	t.[subscription_id] = @subscriptionID
	 GROUP	BY t.[name], t.[id], t.[subscription_id], t.[create_date], t.[update_date], t.[is_active]
	 ORDER	BY 
			CASE
				WHEN	@sortAsc != 1 THEN 0
				WHEN	@sortBy = 'quantity' THEN COUNT(it.id)
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN ''
				WHEN	@sortBy = 'name' THEN t.[name]
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN t.[update_date]
			END ASC, 
			CASE
				WHEN	@sortAsc != 0 THEN 0
				WHEN	@sortBy = 'quantity' THEN COUNT(it.id) 
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN ''
				WHEN	@sortBy = 'name' THEN t.[name]
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN t.[update_date]
			END DESC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;
END