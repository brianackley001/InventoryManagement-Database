/****** Object:  StoredProcedure [dbo].[getTagCollection]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getTagCollection]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getTagCollection] AS' 
END
GO


ALTER PROCEDURE [dbo].[getTagCollection] 
	@subscriptionID INT,
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@resultItems TABLE(id INT IDENTITY(1,1), itemID INT, itemAttributeCount INT);

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[Tag]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1;

	INSERT INTO @resultItems
		SELECT	t.[id], NULL
		  FROM	[dbo].[Tag] t
		 WHERE	subscription_id = @subscriptionID AND t.is_active = 1
		 ORDER	BY t.id ASC
		OFFSET  (@pageNum - 1) * @pageSize ROWS
		 FETCH	NEXT @pageSize ROWS ONLY;

	UPDATE	 ri
	   SET	itemAttributeCount = (SELECT COUNT(it.id) FROM	[dbo].[ItemTag] it WHERE ri.itemID = it.tag_id)
	  FROM	@resultItems ri;


	SELECT	t.[id], [subscription_id], [name], [create_date], [update_date], [is_active], ri.itemAttributeCount attribute_count
	  FROM	[dbo].[Tag] t INNER
	  JOIN	@resultItems ri
	    ON	ri.itemID = t.id
	 WHERE	subscription_id = @subscriptionID AND is_active = 1
	 ORDER	BY id ASC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;



END
GO
