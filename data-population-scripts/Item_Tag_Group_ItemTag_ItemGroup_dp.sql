SET NOCOUNT ON;

DECLARE @subs TABLE (ID INT IDENTITY(1,1), SubId INT);
DECLARE @groupNames TABLE (ID INT IDENTITY(1,1), groupName VARCHAR(255));
DECLARE @tagNames TABLE (ID INT IDENTITY(1,1), tagName VARCHAR(255));
DECLARE	@subCounter INT, @subCounterMax INT, @currentSubId INT;
DECLARE	@attributeCounter INT, @attributeCounterMax INT, @attIsPresent INT, @attName VARCHAR(255);
DECLARE	@itemCounter INT, @itemCounterMax INT, @currentItemId INT, @itemsPresent INT, @itemName VARCHAR(255), @itemDescription VARCHAR(255), @itemValueRemaining INT;
DECLARE	@itemAttrCounter INT, @itemAttrCounterMax INT, @currentAttrItemId INT, @itemsAttrPresent INT, @insertedItemAttrs INT, @randomId INT, @insertAttrId INT;

CREATE TABLE #itemsDP (Id INT IDENTITY(1,1), ItemId INT);
CREATE TABLE #itemAttrDP (Id INT IDENTITY(1,1), AttrId INT);


INSERT INTO @subs
	SELECT	[id] FROM [dbo].[Subscription];

SELECT	@subCounter =  MIN([ID]) FROM @subs;
SELECT	@subCounterMax = MAX([ID]) FROM @subs;

INSERT INTO	@groupNames(groupName) VALUES('Costco');
INSERT INTO	@groupNames(groupName) VALUES('PCC');
INSERT INTO	@groupNames(groupName) VALUES('QFC');
INSERT INTO	@groupNames(groupName) VALUES('Whole Foods');
INSERT INTO	@groupNames(groupName) VALUES('Trader Joes');
INSERT INTO	@groupNames(groupName) VALUES('Fred Meyer');
INSERT INTO	@groupNames(groupName) VALUES('Home Depot');

INSERT INTO	@tagNames(tagName) VALUES('Home Improvement');
INSERT INTO	@tagNames(tagName) VALUES('Produce');
INSERT INTO	@tagNames(tagName) VALUES('Staples');
INSERT INTO	@tagNames(tagName) VALUES('Cleaning');
INSERT INTO	@tagNames(tagName) VALUES('Toiletries');
INSERT INTO	@tagNames(tagName) VALUES('Organizing');
INSERT INTO	@tagNames(tagName) VALUES('Outdoor');


--LOOP through Subscriptions:
WHILE	@subCounter < @subCounterMax
BEGIN
	SELECT @currentSubId = [SubId] FROM @subs WHERE [id] = @subCounter;

	-----------------------------------------------------------------------------------------------------------------------------
	-- Create Groups if needed
	-----------------------------------------------------------------------------------------------------------------------------
	SELECT	@attIsPresent = COUNT(DISTINCT [id]) FROM [dbo].[Group] WHERE [subscription_id] = @currentSubId;
	IF(@attIsPresent < 1)
	BEGIN
		PRINT	'Creating subscription groups...'
		SELECT	@attributeCounter = 1, @attributeCounterMax = 7
		WHILE @attributeCounter < @attributeCounterMax
		BEGIN
			SELECT @attName = groupName + '(s' + CAST(@currentSubId AS VARCHAR(255)) + ')'  FROM @groupNames WHERE [id] = @attributeCounter;
			PRINT	'[dbo].[upsertGroup] @subscriptionID =' + CAST(@currentSubId AS VARCHAR(10)) + ',@name=''' + @attName + '''';
			--EXEC	[dbo].[upsertGroup] @subscriptionID =@currentSubId, @name = @attName

			SELECT @attributeCounter = @attributeCounter + 1;
		END
	END

	-----------------------------------------------------------------------------------------------------------------------------
	-- Create Tags if needed
	-----------------------------------------------------------------------------------------------------------------------------
	SELECT	@attIsPresent = COUNT(DISTINCT [id]) FROM [dbo].[Tag] WHERE [subscription_id] = @currentSubId;
	IF(@attIsPresent < 1)
	BEGIN
		PRINT	'Creating subscription tags...'
		SELECT	@attributeCounter = 1, @attributeCounterMax = 7
		WHILE @attributeCounter < @attributeCounterMax
		BEGIN
			SELECT @attName = tagName + '(s' + CAST(@currentSubId AS VARCHAR(255)) + ')'  FROM @tagNames WHERE [id] = @attributeCounter;
			PRINT	'[dbo].[upsertTag] @subscriptionID =' + CAST(@currentSubId AS VARCHAR(10)) + ',@name=''' + @attName + '''';
			--EXEC	[dbo].[upsertTag] @subscriptionID =@currentSubId, @name = @attName

			SELECT @attributeCounter = @attributeCounter + 1;
		END
	END

	
	-----------------------------------------------------------------------------------------------------------------------------
	-- Create Items if needed
	-----------------------------------------------------------------------------------------------------------------------------
	SELECT @itemsPresent = COUNT(DISTINCT [id]) FROM [dbo].[Item] WHERE [subscription_id] = @currentSubId;
	IF(@itemsPresent < 1)
	BEGIN
		PRINT	'Creating subscription ITEMS...'
		SELECT	@itemCounter = 1, @itemCounterMax = 34
		WHILE @itemCounter < @itemCounterMax
		BEGIN
			SELECT	@itemName = 'Item Number ' + CAST(@itemCounter AS VARCHAR(255)) + ' testing',
					@itemDescription = 'Item Description ' + CAST(@itemCounter AS VARCHAR(255)) + ' testing. More: ' + CAST(NEWID() AS VARCHAR(255));
			PRINT	'[dbo].[upsertItem] @subscriptionID =' + CAST(@currentSubId AS VARCHAR(10)) + ',@name=''' + @itemName + ''', @description=''' + @itemDescription + '''';
			--EXEC	[dbo].[upsertItem] @subscriptionID =@currentSubId, @name=@itemName,  @description=@itemDescription;

			SELECT @itemCounter = @itemCounter + 1;
		END
	END

	
	-----------------------------------------------------------------------------------------------------------------------------
	-- Create Item Groups if needed
	-----------------------------------------------------------------------------------------------------------------------------
	SELECT	@itemsAttrPresent = COUNT(DISTINCT ig.[id]) 
	  FROM	[dbo].[ItemGroup] ig INNER
	  JOIN	[dbo].[Item] i
	    ON	i.id = ig.item_id
	 WHERE	i.[subscription_id] = @currentSubId;

	IF(@itemsAttrPresent < 1)
	BEGIN
		PRINT	'Creating Item ITEM-GROUP...'
		--	Collect applicable ItemIDS:
		INSERT INTO #itemsDP(ItemId)
			SELECT	[id]
			FROM	[dbo].[Item] WHERE subscription_id = @currentSubId;
		SELECT	@itemAttrCounter = 1;
		SELECT	@itemAttrCounterMax = MAX([id]) FROM #itemsDP;
		
		INSERT	INTO #itemAttrDP(AttrId)
		SELECT	g.[id] 
		FROM	[dbo].[Group] g
		WHERE	g.subscription_id = @currentSubId;

		WHILE @itemAttrCounter < @itemAttrCounterMax 
		BEGIN
			SELECT	@currentAttrItemId = [ItemId] FROM #itemsDP WHERE [id] = @itemAttrCounter;
			SELECT	@insertedItemAttrs = 1;
			

			WHILE @insertedItemAttrs < 4
			BEGIN
				-- Random Number:
				SELECT @randomId =  FLOOR(RAND()*(7-1+1))+1;
				SELECT @insertAttrId = AttrId FROM #itemAttrDP WHERE id = @randomId;
				IF NOT EXISTS(SELECT [id] FROM [dbo].[ItemGroup] WHERE [group_id] = @insertAttrId AND [item_id] = @currentAttrItemId)
				BEGIN
					--PRINT '-- NOT: SELECT [id] FROM [dbo].[ItemGroup] WHERE [group_id]=' + CAST(@insertAttrId AS VARCHAR(255)) + ' AND [item_id] = '+ CAST(@currentAttrItemId AS VARCHAR(255))
					PRINT	'EXEC [dbo].[upsertItemGroup] @itemID=' + CAST(@currentAttrItemId AS VARCHAR(255)) + ',@groupID=' + CAST(@insertAttrId AS VARCHAR(255));
					--EXEC [dbo].[upsertItemGroup] @itemID=@currentAttrItemId, @groupID=@insertAttrId;
					SELECT @insertedItemAttrs = @insertedItemAttrs + 1;
				END
			END
			SELECT @itemAttrCounter = @itemAttrCounter + 1;
		END
		TRUNCATE TABLE #itemAttrDP;
	END
	
	TRUNCATE TABLE #itemsDP;

	-----------------------------------------------------------------------------------------------------------------------------
	-- Create Item Tags if needed
	-----------------------------------------------------------------------------------------------------------------------------
	SELECT	@itemsAttrPresent = COUNT(DISTINCT it.[id]) 
	  FROM	[dbo].[ItemTag] it INNER
	  JOIN	[dbo].[Item] i
	    ON	i.id = it.item_id
	 WHERE	i.[subscription_id] = @currentSubId;

	IF(@itemsAttrPresent < 1)
	BEGIN
		PRINT	'Creating Item ITEM-TAG...'
		--	Collect applicable ItemIDS:
		INSERT INTO #itemsDP(ItemId)
			SELECT	[id]
			FROM	[dbo].[Item] WHERE subscription_id = @currentSubId;
		SELECT	@itemAttrCounter = 1;
		SELECT	@itemAttrCounterMax = MAX([id]) FROM #itemsDP;
		
		INSERT	INTO #itemAttrDP(AttrId)
		SELECT	t.[id] 
		FROM	[dbo].[Tag] t
		WHERE	t.subscription_id = @currentSubId;

		WHILE @itemAttrCounter < @itemAttrCounterMax 
		BEGIN
			SELECT	@currentAttrItemId = [ItemId] FROM #itemsDP WHERE [id] = @itemAttrCounter;
			SELECT	@insertedItemAttrs = 1;

			WHILE @insertedItemAttrs < 4
			BEGIN
				-- Random Number:
				SELECT @randomId =  FLOOR(RAND()*(7-1+1))+1;
				SELECT @insertAttrId = AttrId FROM #itemAttrDP WHERE id = @randomId;
				IF NOT EXISTS(SELECT [id] FROM [dbo].[ItemTag] WHERE [tag_id] = @insertAttrId AND [item_id] = @currentAttrItemId)
				BEGIN
					--PRINT '-- NOT: SELECT [id] FROM [dbo].[ItemGroup] WHERE [group_id]=' + CAST(@insertAttrId AS VARCHAR(255)) + ' AND [item_id] = '+ CAST(@currentAttrItemId AS VARCHAR(255))
					PRINT	'EXEC [dbo].[upsertItemTag] @itemID=' + CAST(@currentAttrItemId AS VARCHAR(255)) + ',@tagID=' + CAST(@insertAttrId AS VARCHAR(255));
					--EXEC [dbo].[upsertItemTag] @itemID=@currentAttrItemId, @tagID=@insertAttrId;
					SELECT @insertedItemAttrs = @insertedItemAttrs + 1;
				END
			END
			SELECT @itemAttrCounter = @itemAttrCounter + 1;
		END
		TRUNCATE TABLE #itemAttrDP;
	END
	
	TRUNCATE TABLE #itemsDP;
	SELECT	@subCounter = @subCounter + 1
END


-----------------------------------------------------------------------------------------------------------------------------
-- CLEAN-UP TEMP TABLES
-----------------------------------------------------------------------------------------------------------------------------
DROP TABLE #itemsDP;
DROP TABLE #itemAttrDP;