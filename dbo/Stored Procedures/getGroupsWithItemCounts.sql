



CREATE PROCEDURE [dbo].[getGroupsWithItemCounts] 
	@subscriptionID		INT,
	@pageNum			INT = 1, 
	@pageSize			INT = 25,
	@sortBy				VARCHAR(50) = 'name',
	@sortAsc			BIT = 1,
	@collectionTotal	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@resultItems TABLE(id INT IDENTITY(1,1), itemID INT);

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Group]
	 WHERE	subscription_id = @subscriptionID;


	SELECT	g.[id], g.[subscription_id] SubscriptionId, g.[name], g.[create_date] CreateDate, 
			g.[update_date] UpdateDate, g.[is_active] IsActive, COUNT(ig.id) as ItemCount 
	  FROM	[dbo].[Group] g LEFT
	  JOIN	[dbo].[ItemGroup] ig 
	    ON	g.id = ig.group_id LEFT 
	  JOIN	[dbo].[Item] i
		ON	i.id = ig.item_id
	 WHERE	g.[subscription_id] = @subscriptionID
	 GROUP	BY g.[name], g.[id], g.[subscription_id], g.[create_date], g.[update_date], g.[is_active]
	 ORDER	BY 
			CASE
				WHEN	@sortAsc != 1 THEN 0
				WHEN	@sortBy = 'quantity' THEN COUNT(ig.id)
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN ''
				WHEN	@sortBy = 'name' THEN g.[name]
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN g.[update_date]
			END ASC, 
			CASE
				WHEN	@sortAsc != 0 THEN 0
				WHEN	@sortBy = 'quantity' THEN COUNT(ig.id) 
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN ''
				WHEN	@sortBy = 'name' THEN g.[name]
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN g.[update_date]
			END DESC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;
END