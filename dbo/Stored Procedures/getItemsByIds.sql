



CREATE PROCEDURE [dbo].[getItemsByIds] 
	@subscriptionID		INT,
	@ids				IDTVP READONLY,
	@pageNum			INT = 1, 
	@pageSize			INT = 50,
	@sortBy				VARCHAR(50) = 'name',
	@sortAsc			BIT = 1,
	@collectionTotal	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @allItemTags TABLE(itemId INT, tagId INT);
    DECLARE @allItemGroups TABLE(itemId INT, groupId INT);
	DECLARE @pagedItemIds TABLE(id INT);

		--	Select Paged Collection of matching Items
    INSERT  INTO @pagedItemIds
            SELECT	i.[id]
            FROM	[dbo].[Item] i
            WHERE	i.[id] in (SELECT [id] FROM @ids)
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
	  FROM	@pagedItemIds p INNER
	  JOIN	[dbo].[Item] i 
	    ON	p.id = i.id;

	
	SELECT @collectionTotal = COUNT([id]) FROM @pagedItemIds;

    --  Map Full ItemGroup & ItemTag pairs for Items in pagedCollection:
    INSERT  INTO @allItemTags
            SELECT  [item_id], [tag_id]
             FROM   [dbo].[ItemTag] 
            WHERE   [item_id] IN(SELECT [id] FROM @ids);
    INSERT  INTO @allItemGroups
            SELECT  [item_id], [group_id]
             FROM   [dbo].[ItemGroup] 
            WHERE   [item_id] IN(SELECT [id] FROM @ids);

	--	Reference Lookup Record Sets for Tags, mapping to items
	--	Tag objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Tag] (NOLOCK)
	 WHERE	id IN (SELECT tagId FROM @allItemTags);

	 --	Item to Tag mappings
	SELECT	[id], [item_id] ItemId, [tag_id] TagId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemTag]
	 WHERE	[item_id] IN (SELECT [id] FROM @ids);

    -- Group Objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Group] (NOLOCK)
	 WHERE	id IN (SELECT groupId FROM @allItemGroups);

	 --	Item to Group mappings
	SELECT	[id], [item_id] ItemId, [group_id] GroupId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemGroup]
	 WHERE	[item_id] IN (SELECT [id] FROM @ids);
END