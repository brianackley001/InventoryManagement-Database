

CREATE PROCEDURE [dbo].[getShoppingListItems] 
	@subscriptionID	INT,
	@shoppingListID	INT,
	@sortBy VARCHAR(50) = 'quantity',
	@sortAsc bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@items TABLE(id INT IDENTITY(1,1), itemID INT);
	--	Lookup Group/Tag Attributes based on itemID:
	INSERT INTO @items
		SELECT	sli.[item_id]
		  FROM	[dbo].[ShoppingListItem] sli
		 WHERE	[subscription_id] = @subscriptionID AND 
				sli.[shopping_list_id] = @shoppingListID

	SELECT	sli.[id], sli.[subscription_id] SubscriptionId, sli.[shopping_list_id] ShoppingListId, sli.[item_id] ItemId, 
			sli.[create_date] ShoppingListCreateDate, sli.[update_date] ShoppingListUpdateDate, sli.[is_active] ShoppingListIsActive,
			i.[name], i.[description], i.[amount_value] AmountValue, 
			i.[create_date] ItemCreateDate, i.[update_date] ItemUpdateDate, i.[is_active] ItemIsActive
	  FROM	[dbo].[Item] i INNER
	  JOIN	[dbo].[ShoppingListItem] sli
	    ON	i.[id] = sli.[item_id]
	WHERE	sli.[subscription_id] = @subscriptionID AND sli.[shopping_list_id] = @shoppingListID
	ORDER	BY 
			CASE
				WHEN	@sortAsc != 1 THEN 0
				WHEN	@sortBy = 'quantity' THEN i.[amount_value] 
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN ''
				WHEN	@sortBy = 'name' THEN i.[name]
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN i.[update_date]
			END ASC, 
			CASE
				WHEN	@sortAsc != 0 THEN 0
				WHEN	@sortBy = 'quantity' THEN i.[amount_value] 
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN ''
				WHEN	@sortBy = 'name' THEN i.[name]
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN i.[update_date]
			END DESC;
	
	 --	Group Data
	 SELECT	g.[id] GroupId, g.[name] GroupName, ig.id Id, ri.itemID ItemId
	   FROM	@items ri INNER
	   JOIN	[dbo].[ItemGroup] ig
	     ON	ri.itemID = ig.item_id INNER
	   JOIN	[dbo].[Group]g 
	     ON g.id = ig.group_id;

	--	Tag Data
	 SELECT	t.[id] TagId, t.[name] TagName, it.id Id, ri.itemID ItemId
	   FROM	@items ri INNER
	   JOIN	[dbo].[ItemTag] it
	     ON	ri.itemID = it.item_id INNER
	   JOIN	[dbo].[Tag] t
	     ON t.id = it.tag_id;
END
