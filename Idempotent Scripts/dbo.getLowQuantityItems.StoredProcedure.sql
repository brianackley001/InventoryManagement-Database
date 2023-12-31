/****** Object:  StoredProcedure [dbo].[getLowQuantityItems]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getLowQuantityItems]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getLowQuantityItems] AS' 
END
GO


ALTER PROCEDURE [dbo].[getLowQuantityItems] 
	@subscriptionID INT, 
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@items TABLE(id INT IDENTITY(1,1), itemID INT);

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Item]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1 AND amount_value < 2;

	--	Lookup Group/Tag Attributes based on itemID:
	INSERT INTO @items
		SELECT	[id]
		  FROM	[dbo].[Item]
		 WHERE	[subscription_id] = @subscriptionID AND 
				amount_value < 2  AND is_active = 1
		 ORDER	BY [amount_value] ASC
		OFFSET  (@pageNum - 1) * @pageSize ROWS
		 FETCH	NEXT @pageSize ROWS ONLY;
		 
	--	Item information
	SELECT	[id], [subscription_id], [name], [description], [amount_value], [create_date], [update_date], [is_active]
	  FROM	[dbo].[Item]
	 WHERE	[subscription_id] = @subscriptionID AND 
			amount_value < 2
	 ORDER	BY [amount_value] ASC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	 FETCH	NEXT @pageSize ROWS ONLY;

	 --	Group Data
	 SELECT	g.[id] group_id, g.[name] group_name, ig.id item_group_id, i.itemID item_id
	   FROM	@items i INNER
	   JOIN	[dbo].[ItemGroup] ig
	     ON	i.itemID = ig.item_id INNER
	   JOIN	[dbo].[Group]g 
	     ON g.id = ig.group_id;

	--	Tag Data
	 SELECT	t.[id] tag_id, t.[name] tag_name, it.id item_tag_id, i.itemID item_id
	   FROM	@items i INNER
	   JOIN	[dbo].[ItemTag] it
	     ON	i.itemID = it.item_id INNER
	   JOIN	[dbo].[Tag] t
	     ON t.id = it.tag_id;
END
GO
