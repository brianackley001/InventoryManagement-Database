



CREATE PROCEDURE [dbo].[getItemsByTags] 
	@subscriptionID		INT,
	@ids				IDTVP READONLY,
	@pageNum			INT = 1, 
	@pageSize			INT = 25,
	@sortBy				VARCHAR(50) = 'name',
	@sortAsc			BIT = 1,
	@collectionTotal	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @uniqueItems TABLE(id INT);
	DECLARE @pagedItemIds TABLE(id INT);
    DECLARE @allItemTags TABLE(itemId INT, tagId INT);
    DECLARE @allItemGroups TABLE(itemId INT, groupId INT);

	--	Unique Items associated with @ids IDTVP parameter (tagIds)
	INSERT INTO @uniqueItems
			SELECT	DISTINCT i.[id]
			  FROM	@ids tagIds INNER
			  JOIN	[dbo].[ItemTag] it (NOLOCK)
				ON	tagIds.id = it.tag_id INNER
			  JOIN	Tag t (NOLOCK)
				ON	tagIds.id = t.id INNER 
			  JOIN	[dbo].[Item] i (NOLOCK)
				ON	i.id = it.item_id
			 WHERE	i.subscription_id = @subscriptionID and 
					i.is_active = 1 and 
					it.tag_id IN (SELECT[id] FROM @ids);
	
	--	Assign @collectionTotal OUTPUT parameter value
	SELECT	@collectionTotal = COUNT([id]) FROM @uniqueItems;

	--	Select Paged Collection of matching Items
    INSERT  INTO @pagedItemIds
            SELECT	i.[id]
            FROM	[dbo].[Item] i
            WHERE	i.[id] in (SELECT [id] FROM @uniqueItems)
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

	SELECT	i.[id], i.[subscription_id] SubscriptionId, i.[name], i.[description], i.[amount_value] AmountValue, i.[create_date] CreateDate, i.[update_date] UpdateDate, i.[is_active] IsActive
	  FROM	[dbo].[Item] i
	 WHERE	i.[id] in (SELECT [id] FROM @pagedItemIds);

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
	 WHERE	[item_id] IN (SELECT [id] FROM @pagedItemIds);

    -- Group Objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Group] (NOLOCK)
	 WHERE	id IN (SELECT groupId FROM @allItemGroups);

	 --	Item to Group mappings
	SELECT	[id], [item_id] ItemId, [group_id] GroupId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemGroup]
	 WHERE	[item_id] IN (SELECT [id] FROM @pagedItemIds);
END
