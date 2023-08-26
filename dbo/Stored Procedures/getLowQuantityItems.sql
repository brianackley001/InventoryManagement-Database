


CREATE PROCEDURE [dbo].[getLowQuantityItems] 
	@subscriptionID INT, 
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@sortBy	VARCHAR(50) = 'quantity',
	@sortAsc BIT = 1,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @pagedItemIds TABLE(id INT);
    DECLARE @allItemTags TABLE(itemId INT, tagId INT);
    DECLARE @allItemGroups TABLE(itemId INT, groupId INT);

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Item]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1 AND amount_value < 2;

	--	Lookup Group/Tag Attributes based on itemID:
	INSERT INTO @pagedItemIds
		SELECT	[id]
		  FROM	[dbo].[Item]
		 WHERE	[subscription_id] = @subscriptionID AND 
				amount_value < 2  AND is_active = 1
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
		 
	--	Item information
	SELECT	it.[id] 'resultId', i.id 'id', i.[name], 'item' resultType,  [description], [amount_value] amountValue, 1 resultWeight
	  FROM	[dbo].[Item] i INNER
	  JOIN	@pagedItemIds it
	    ON	it.id = i.id
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
			END DESC;


    --  Map Full ItemGroup & ItemTag pairs for Items in pagedCollection:
    INSERT  INTO @allItemTags
            SELECT  [item_id], [tag_id]
             FROM   [dbo].[ItemTag] 
            WHERE   [item_id] IN(SELECT [id] FROM @pagedItemIds);
    INSERT  INTO @allItemGroups
            SELECT  [item_id], [group_id]
             FROM   [dbo].[ItemGroup] 
            WHERE   [item_id] IN(SELECT [id] FROM @pagedItemIds);

	--	Reference Lookup Record Sets for Tags, mapping to items
	--	Tag objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Tag] (NOLOCK)
	 WHERE	id IN (SELECT tagId FROM @allItemTags);

	 --	Item to Tag mappings
	SELECT	[id], [item_id] ItemId, [tag_id] TagId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemTag]
	 WHERE	[item_id] IN(SELECT [id] FROM @pagedItemIds);

    -- Group Objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Group] (NOLOCK)
	 WHERE	id IN (SELECT groupId FROM @allItemGroups);

	 --	Item to Group mappings
	SELECT	[id], [item_id] ItemId, [group_id] GroupId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemGroup]
	 WHERE	[item_id] IN(SELECT [id] FROM @pagedItemIds);
END
