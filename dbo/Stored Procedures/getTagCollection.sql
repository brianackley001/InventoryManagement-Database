

CREATE PROCEDURE [dbo].[getTagCollection] 
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


	SELECT	t.[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, 
			[update_date] UpdateDate, [is_active] IsActive, ri.itemAttributeCount AttributeCount
	  FROM	[dbo].[Tag] t INNER
	  JOIN	@resultItems ri
	    ON	ri.itemID = t.id
	 WHERE	subscription_id = @subscriptionID AND is_active = 1
	 ORDER	BY ri.id ASC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;



END
