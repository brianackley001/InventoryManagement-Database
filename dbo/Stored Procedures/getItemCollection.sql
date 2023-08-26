

CREATE PROCEDURE [dbo].[getItemCollection] 
	@subscriptionID INT,
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@sortBy VARCHAR(50) = 'name',
	@sortAsc bit = 1,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@resultItems TABLE(id INT IDENTITY(1,1), itemID INT);

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Item]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1;

	INSERT INTO @resultItems
		SELECT	[id]
		  FROM	[dbo].[Item]
		 WHERE	subscription_id = @subscriptionID AND is_active = 1
		 
		 ORDER	BY 
				CASE
					WHEN	@sortAsc != 1 THEN 0
					WHEN	@sortBy = 'quantity' THEN [amount_value] 
				END ASC,
				CASE
					WHEN	@sortAsc != 1 THEN ''
					WHEN	@sortBy = 'name' THEN [name]
				END ASC,
				CASE
					WHEN	@sortAsc != 1 THEN cast(null as date)
					WHEN	@sortBy = 'date' THEN [update_date]
				END ASC, 
				CASE
					WHEN	@sortAsc != 0 THEN 0
					WHEN	@sortBy = 'quantity' THEN [amount_value] 
				END DESC,
				CASE
					WHEN	@sortAsc != 0 THEN ''
					WHEN	@sortBy = 'name' THEN [name]
				END DESC,
				CASE
					WHEN	@sortAsc != 0 THEN cast(null as date)
					WHEN	@sortBy = 'date' THEN [update_date]
				END DESC
		OFFSET  (@pageNum - 1) * @pageSize ROWS
		 FETCH	NEXT @pageSize ROWS ONLY;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [description] , [amount_value] AmountValue, [create_date] CreateDate, 
			[update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Item]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1 
	 
	 ORDER	BY 
			CASE
				WHEN	@sortAsc != 1 THEN 0
				WHEN	@sortBy = 'quantity' THEN [amount_value] 
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN ''
				WHEN	@sortBy = 'name' THEN [name]
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN [update_date]
			END ASC, 
			CASE
				WHEN	@sortAsc != 0 THEN 0
				WHEN	@sortBy = 'quantity' THEN [amount_value] 
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN ''
				WHEN	@sortBy = 'name' THEN [name]
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN [update_date]
			END DESC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;
	 
	 --	Group Data
	 SELECT	g.[id] GroupId, g.[name] GroupName, ig.id Id, ri.itemID ItemId
	   FROM	@resultItems ri INNER
	   JOIN	[dbo].[ItemGroup] ig
	     ON	ri.itemID = ig.item_id INNER
	   JOIN	[dbo].[Group]g 
	     ON g.id = ig.group_id;

	--	Tag Data
	 SELECT	t.[id] TagId, t.[name] TagName, it.id Id, ri.itemID ItemId
	   FROM	@resultItems ri INNER
	   JOIN	[dbo].[ItemTag] it
	     ON	ri.itemID = it.item_id INNER
	   JOIN	[dbo].[Tag] t
	     ON t.id = it.tag_id;

END