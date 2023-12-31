/****** Object:  StoredProcedure [dbo].[getSearchResults]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getSearchResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getSearchResults] AS' 
END
GO


ALTER PROCEDURE [dbo].[getSearchResults] 
	@subscriptionID INT,
	@searchType VARCHAR(255) = NULL, 
	@searchTerm VARCHAR(255), 
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @iWeight INT, @gWeight INT, @tWeight INT, @slWeight INT;
	SELECT @iWeight = 1, @gWeight = 2, @tWeight = 3, @slWeight = 4;
	DECLARE @results TABLE(
			id INT IDENTITY(1,1), 
			resultID INT,
			resultType VARCHAR(255), 
			resultName VARCHAR(255) ,
			resultDesc VARCHAR(255),
			resultWeight INT
			);
			
	DECLARE	@resultItems TABLE(id INT IDENTITY(1,1), itemID INT);

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
		SELECT	[id], 'item', [name], [description], @iWeight
		FROM	[dbo].[Item]
		WHERE	[subscription_id] = @subscriptionID AND is_active = 1 AND
				(([name] LIKE '%' + @searchTerm + '%') OR ([description] LIKE '%' + @searchTerm + '%'));

	INSERT INTO @results
		SELECT	[id], 'group',[name], '', @gWeight
		  FROM	[dbo].[Group]
		 WHERE	[subscription_id] = @subscriptionID AND is_active = 1 AND
				([name] LIKE '%' + @searchTerm + '%');

	INSERT INTO @results
		SELECT	[id], 'tag',[name], '', @tWeight
		  FROM	[dbo].[Tag]
		 WHERE	[subscription_id] = @subscriptionID AND  is_active = 1 AND
				([name] LIKE '%' + @searchTerm + '%');

	INSERT INTO @results
		SELECT	[id], 'list',[name], '', @slWeight
		  FROM	[dbo].[ShoppingList]
		 WHERE	[subscription_id] = @subscriptionID AND  is_active = 1 AND
				([name] LIKE '%' + @searchTerm + '%');

	SELECT	@collectionTotal = COUNT([id])
	  FROM	@results;

	INSERT INTO @resultItems
		SELECT	[resultID]
		  FROM	@results
		 WHERE	resultType = 'item'
		 ORDER	BY resultWeight ASC
		OFFSET  (@pageNum - 1) * @pageSize ROWS
		 FETCH	NEXT @pageSize ROWS ONLY;

	SELECT	*
	  FROM	@results
	 ORDER	BY resultWeight ASC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	 FETCH	NEXT @pageSize ROWS ONLY;
	 
	 --	Group Data
	 SELECT	g.[id] group_id, g.[name] group_name, ig.id item_group_id, ri.itemID item_id
	   FROM	@resultItems ri INNER
	   JOIN	[dbo].[ItemGroup] ig
	     ON	ri.itemID = ig.item_id INNER
	   JOIN	[dbo].[Group]g 
	     ON g.id = ig.group_id;

	--	Tag Data
	 SELECT	t.[id] tag_id, t.[name] tag_name, it.id item_tag_id, ri.itemID item_id
	   FROM	@resultItems ri INNER
	   JOIN	[dbo].[ItemTag] it
	     ON	ri.itemID = it.item_id INNER
	   JOIN	[dbo].[Tag] t
	     ON t.id = it.tag_id;

END
GO
