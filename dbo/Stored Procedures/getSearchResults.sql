


CREATE PROCEDURE [dbo].[getSearchResults] 
	@subscriptionID INT,
	@searchType VARCHAR(255) = NULL, 
	@searchTerm VARCHAR(255), 
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@sortBy	VARCHAR(50) = 'name',
	@sortAsc BIT = 1,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iWeight INT, @gWeight INT, @tWeight INT, @slWeight INT;
	SELECT @iWeight = 1, @gWeight = 2, @tWeight = 3, @slWeight = 4;
	DECLARE @results TABLE(
			id INT IDENTITY(1,1), 
			resultId INT,
			resultType VARCHAR(255), 
			resultName VARCHAR(255) ,
			resultDesc VARCHAR(255),
			resultWeight INT,
			amountValue INT,
			updateDate DATETIME
			);
			
	DECLARE	@resultItems TABLE(id INT IDENTITY(1,1), itemID INT);
    DECLARE @allItemTags TABLE(itemId INT, tagId INT);
    DECLARE @allItemGroups TABLE(itemId INT, groupId INT);

	IF(@searchType = 'group')
	BEGIN
		SELECT @iWeight = 2, @gWeight = 1, @tWeight = 3, @slWeight = 4;	
	END
	IF(@searchType = 'tag')
	BEGIN
		SELECT @iWeight = 3, @gWeight = 2, @tWeight = 1, @slWeight = 4;	
	END
	IF(@searchType = 'list')
	BEGIN
		SELECT @iWeight = 2, @gWeight = 3, @tWeight = 4, @slWeight = 1;	
	END


	INSERT INTO @results
		SELECT	[id], 'item', [name], [description], @iWeight, [amount_value], [update_date]
		FROM	[dbo].[Item]
		WHERE	[subscription_id] = @subscriptionID AND is_active = 1 AND
				(([name] LIKE '%' + @searchTerm + '%') OR ([description] LIKE '%' + @searchTerm + '%'));

	INSERT INTO @results
		SELECT	[id], 'group',[name], '', @gWeight, 0, [update_date]
		  FROM	[dbo].[Group]
		 WHERE	[subscription_id] = @subscriptionID AND is_active = 1 AND
				([name] LIKE '%' + @searchTerm + '%');

	INSERT INTO @results
		SELECT	[id], 'tag',[name], '', @tWeight, 0, [update_date]
		  FROM	[dbo].[Tag]
		 WHERE	[subscription_id] = @subscriptionID AND  is_active = 1 AND
				([name] LIKE '%' + @searchTerm + '%');

	INSERT INTO @results
		SELECT	[id], 'shoppinglist',[name], '', @slWeight, 0, [update_date]
		  FROM	[dbo].[ShoppingList]
		 WHERE	[subscription_id] = @subscriptionID AND  is_active = 1 AND
				([name] LIKE '%' + @searchTerm + '%');

	SELECT	@collectionTotal = COUNT([id])
	  FROM	@results;

	INSERT INTO @resultItems
		SELECT	resultId
		  FROM	@results
		 WHERE	resultType = 'item'
		 ORDER	BY resultWeight ASC
		OFFSET  (@pageNum - 1) * @pageSize ROWS
		 FETCH	NEXT @pageSize ROWS ONLY;

	SELECT	id 'resultId' ,resultId 'id', resultType, resultName 'Name', resultDesc 'Description', resultWeight, amountValue
	  FROM	@results
	  ORDER	BY  resultWeight ASC,
			CASE
				WHEN	@sortAsc != 1 THEN 0
				WHEN	@sortBy = 'quantity' THEN amountValue
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN ''
				WHEN	@sortBy = 'name' THEN resultName
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN updateDate
			END ASC, 
			CASE
				WHEN	@sortAsc != 0 THEN 0
				WHEN	@sortBy = 'quantity' THEN amountValue
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN ''
				WHEN	@sortBy = 'name' THEN resultName
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN updateDate
			END DESC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	 FETCH	NEXT @pageSize ROWS ONLY;


    --  Map Full ItemGroup & ItemTag pairs for Items in pagedCollection:
    INSERT  INTO @allItemTags
            SELECT  [item_id], [tag_id]
             FROM   [dbo].[ItemTag] 
            WHERE   [item_id] IN(SELECT [itemID] FROM @resultItems);
    INSERT  INTO @allItemGroups
            SELECT  [item_id], [group_id]
             FROM   [dbo].[ItemGroup] 
            WHERE   [item_id] IN(SELECT [itemID] FROM @resultItems);

	--	Reference Lookup Record Sets for Tags, mapping to items
	--	Tag objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Tag] (NOLOCK)
	 WHERE	id IN (SELECT tagId FROM @allItemTags);

	 --	Item to Tag mappings
	SELECT	[id], [item_id] ItemId, [tag_id] TagId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemTag]
	 WHERE	[item_id] IN (SELECT [itemID] FROM @resultItems);

    -- Group Objects
	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Group] (NOLOCK)
	 WHERE	id IN (SELECT groupId FROM @allItemGroups);

	 --	Item to Group mappings
	SELECT	[id], [item_id] ItemId, [group_id] GroupId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemGroup]
	 WHERE	[item_id] IN (SELECT [itemID] FROM @resultItems);

END
