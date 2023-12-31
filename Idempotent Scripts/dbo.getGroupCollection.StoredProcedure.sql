/****** Object:  StoredProcedure [dbo].[getGroupCollection]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getGroupCollection]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getGroupCollection] AS' 
END
GO


ALTER PROCEDURE [dbo].[getGroupCollection] 
	@subscriptionID INT,
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@resultItems TABLE(id INT IDENTITY(1,1), itemID INT, itemAttributeCount INT);

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Group]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1;

	INSERT INTO @resultItems
		SELECT	g.[id], NULL
		  FROM	[dbo].[Group] g
		 WHERE	subscription_id = @subscriptionID AND g.is_active = 1
		 ORDER	BY g.id ASC
		OFFSET  (@pageNum - 1) * @pageSize ROWS
		 FETCH	NEXT @pageSize ROWS ONLY;

	UPDATE	 ri
	   SET	itemAttributeCount = (SELECT COUNT(ig.id) FROM	[dbo].[ItemGroup] ig WHERE ri.itemID = ig.group_id)
	  FROM	@resultItems ri;


	SELECT	g.[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, 
			[update_date] UpdateDate, [is_active] IsActive, ri.itemAttributeCount AttributeCount
	  FROM	[dbo].[Group] g INNER
	  JOIN	@resultItems ri
	    ON	ri.itemID = g.id
	 WHERE	subscription_id = @subscriptionID AND is_active = 1
	 ORDER	BY id ASC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;



END
GO
