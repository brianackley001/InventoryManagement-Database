


CREATE PROCEDURE [stock].[importItems] 
	@subscriptionID			INT,
	@importAttributeValues	BIT = 0,
	@ids					IDTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @importItems TABLE(itemId INT, itemName VARCHAR(255), itemCompareString VARCHAR(255));
	DECLARE	@insertTimeStamp DATETIME, @currentNameValue VARCHAR(255), @currentItemExists INT;
	SELECT	@insertTimeStamp = getdate();
	DECLARE	@RetVal						INT = 0,
			@totalCount					INT,
			@counter					INT = 1,
			@nextTagId					INT,
			@importAttributeValue		INT,
			@itemAttributeValue			INT,
			@itemIdValue				INT;
	BEGIN TRY;
		BEGIN TRANSACTION;
			INSERT INTO @importItems(itemId, itemName, itemCompareString)
				SELECT	i.[id], si.[name], REPLACE(si.[name] , ' ', '')
				  FROM	@ids i INNER 
				  JOIN	[stock].[Item] si
					ON	i.id = si.id;

			-- Import/Insert stock items into Item table for the targeted subscription:
			INSERT	[dbo].[Item]([name], [subscription_id])
					SELECT	itemName, @subscriptionID
					  FROM	@importItems;

			----------------------------------------------------------------------------------
			-- Import Attribute(s) (Tags) if requested:
			----------------------------------------------------------------------------------
			IF(@importAttributeValues = 1)
			BEGIN
				DECLARE @importAttributes TABLE(id INT IDENTITY(1,1), itemId INT ,categoryId INT, subCategoryId INT, 
						categoryName VARCHAR(255), categoryCompareString VARCHAR(255), subCategoryName VARCHAR(255), subCategoryCompareString VARCHAR(255), 
						categoryTagId INT, subCategoryTagId INT, targetItemId INT);
				INSERT INTO @importAttributes
					SELECT	i.[id], c.[id], sc.[id],
							c.[name], REPLACE(c.[name] , ' ', ''), sc.[name], REPLACE(sc.[name] , ' ', ''), -1, -1, -1
					  FROM	[stock].[SubCategory] sc INNER
					  JOIN	[stock].[Category] c 
						ON	c.[id] = sc.category_id Inner
					  JOIN	[stock].Item i 
						ON	i.category_id = c.[id] AND i.sub_category_id = sc.[id]
					  WHERE	ISNULL(i.[is_active], -1) > 0 AND 
							ISNULL(c.[is_active], -1) > 0 AND 
							ISNULL(sc.[is_active], -1) > 0 AND
							i.[id] IN (SELECT [id] from @ids);

				-- Associate dbo.Item id to tabke for ItemTag mapping
				DECLARE	@targetItemIds TABLE(id INT IDENTITY(1,1), itemId INT, itemName VARCHAR(255));
				INSERT INTO @targetItemIds
					SELECT	[id], [name]
					 FROM	[dbo].[Item]
					WHERE	subscription_id = @subscriptionID AND 
							create_date >= @insertTimeStamp;
				SELECT	* FROM  @targetItemIds;

				UPDATE	@importAttributes
				   SET	targetItemId = c.itemId
				  FROM	@importAttributes a INNER
				  JOIN	@importItems b
					ON	b.itemId = a.itemId  INNER
				  JOIN	@targetItemIds c 
					ON	c.itemName = b.itemName

				-- Attribute Tag Creation:
				SELECT	@totalCount =  MAX([id]) FROM @importAttributes;

				WHILE	(@counter <= @totalCount)
					BEGIN
						-- Categories
						--PRINT	'Loop: Category, @counter=' + CAST(@counter AS VARCHAR(10));
						SELECT	@currentNameValue = categoryName FROM @importAttributes WHERE [id] = @counter;
						SELECT	@currentItemExists = COUNT(t.[id]) FROM [dbo].[Tag] t
						 WHERE	t.subscription_id = @subscriptionID AND t.[name] = @currentNameValue;
						 --PRINT	'*** Categories: @currentNameValue=' + @currentNameValue + 
							--	', @currentItemExists=' + CAST(@currentItemExists AS VARCHAR(255)) + ', @counter=' + 
							--	CAST(@counter AS VARCHAR(255));

						IF @currentItemExists = 0
							BEGIN
								--PRINT ' - NOT EXISTS(Categories): @currentNameValue=' + @currentNameValue;
								INSERT	[dbo].[Tag]([subscription_id], [name])
									SELECT	@subscriptionID, categoryName
									  FROM	@importAttributes
									 WHERE	[id] = @counter;
								SELECT	@nextTagId = @@IDENTITY;
								 --PRINT ' - @nextTagId (@@IDENTITY):' + CAST(@nextTagId AS VARCHAR(255));

								UPDATE	@importAttributes
								   SET	categoryTagId = @nextTagId
								 WHERE	[id] = @counter;
							END
						ELSE
							BEGIN
							--	PRINT ' - EXISTS(Categories): @currentNameValue=' + @currentNameValue;
								SELECT	@nextTagId = t.[id]
								  FROM [dbo].[Tag] t INNER
								  JOIN	@importAttributes i
								   ON	t.[name] = i.categoryName
								 WHERE	t.subscription_id = @subscriptionID
								 --PRINT ' - @nextTagId:' + CAST(@nextTagId AS VARCHAR(255));

								UPDATE	@importAttributes
								   SET	categoryTagId = @nextTagId
								 WHERE	[id] = @counter;
							END

						-- Subcategories
						--PRINT	'Loop: SubCategory, @counter=' + CAST(@counter AS VARCHAR(10));
						SELECT	@currentNameValue = subCategoryName FROM @importAttributes WHERE [id] = @counter;
						SELECT	@currentItemExists = COUNT(t.[id]) FROM [dbo].[Tag] t
						 WHERE	t.subscription_id = @subscriptionID AND t.[name] = @currentNameValue;
						 --PRINT	'*** Subcategories: @currentNameValue=' + @currentNameValue + 
							--	', @currentItemExists=' + CAST(@currentItemExists AS VARCHAR(255)) + ', @counter=' + 
							--	CAST(@counter AS VARCHAR(255));

						IF @currentItemExists = 0
							BEGIN
								--PRINT ' - NOT EXISTS(SubCategories): @currentNameValue=' + @currentNameValue;
								INSERT	[dbo].[Tag]([subscription_id], [name])
									SELECT	@subscriptionID, subCategoryName
									  FROM	@importAttributes
									 WHERE	[id] = @counter;
								SELECT	@nextTagId = @@IDENTITY;
								 --PRINT ' - @nextTagId (@@IDENTITY):' + CAST(@nextTagId AS VARCHAR(255));

								UPDATE	@importAttributes
								   SET	subCategoryTagId = @nextTagId
								 WHERE	[id] = @counter;
							END
						ELSE
							BEGIN
								--PRINT ' - EXISTS(SubCategories): @currentNameValue=' + @currentNameValue;
								SELECT	@nextTagId = t.[id]
								  FROM [dbo].[Tag] t INNER
								  JOIN	@importAttributes i
								   ON	t.[name] = i.subCategoryName
								 WHERE	t.subscription_id = @subscriptionID
								 --PRINT ' - @nextTagId:' + CAST(@nextTagId AS VARCHAR(255));

								UPDATE	@importAttributes
								   SET	subCategoryTagId = @nextTagId
								 WHERE	[id] = @counter;
							END

						-------------------------------------------------------------------------------------------
						-- ItemTag Insertion:
						-------------------------------------------------------------------------------------------
				
						-- GET ITEM ID:
						SELECT	@itemIdValue = targetItemId 
						  FROM	@importAttributes  
						 WHERE	id = @counter;

						-- Category Tag ID
						SELECT	@importAttributeValue = categoryTagId FROM @importAttributes WHERE [id] = @counter;
						SELECT	@itemAttributeValue = COUNT([id]) 
						 FROM	[dbo].[ItemTag]
						 WHERE	[item_id] = @itemIdValue AND [tag_id] = @importAttributeValue;

						IF(@importAttributeValue > 0 AND @itemIdValue > 0 AND @itemAttributeValue < 1)
						BEGIN
							--PRINT '** ItemTag Insertion | Category: INSERT INTO [dbo].[ItemTag]([item_id], [tag_id]) SELECT	itemId, categoryTagId FROM @importAttributes WHERE	[id] = ' + CAST(@counter AS VARCHAR(20)) + ';'
							INSERT INTO [dbo].[ItemTag]([item_id], [tag_id])
								SELECT	@itemIdValue, categoryTagId
								 FROM	@importAttributes
								WHERE	[id] = @counter;
						END

						-- Sub Category Tag ID
						SELECT	@importAttributeValue = subCategoryTagId FROM @importAttributes WHERE [id] = @counter;
						SELECT	@itemAttributeValue = COUNT([id]) 
						 FROM	[dbo].[ItemTag]
						 WHERE	[item_id] = @itemIdValue AND [tag_id] = @importAttributeValue;

						IF(@importAttributeValue > 0 AND @itemIdValue > 0 AND @itemAttributeValue < 1)
						BEGIN
							--PRINT '** ItemTag Insertion | SubCategory: INSERT INTO [dbo].[ItemTag]([item_id], [tag_id]) SELECT itemId, subCategoryTagId FROM @importAttributes WHERE	[id] = ' + CAST(@counter AS VARCHAR(20)) + ';'
							INSERT INTO [dbo].[ItemTag]([item_id], [tag_id])
								SELECT	@itemIdValue, subCategoryTagId
								 FROM	@importAttributes
								WHERE	[id] = @counter;
						END

						SET @counter  = @counter  + 1;
					END
			
					SELECT * FROM @importAttributes;
					SELECT	i.id ItemID, i.name ItemName, t.name TagName, i.subscription_id
					FROM	dbo.Item i INNER 
					JOIN	dbo.ItemTag it ON i.id = it.item_id INNER
					JOIN	dbo.Tag t ON t.id = it.tag_id
					WHERE	i.subscription_id = @subscriptionID;
			END
	
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH;
		DECLARE @msg nvarchar(max);
		SET @msg = ERROR_MESSAGE();
		RAISERROR (@msg, 16, 1);
		Set @RetVal = -1;
	
		ROLLBACK TRANSACTION;
	END CATCH;
	RETURN @RetVal;
END