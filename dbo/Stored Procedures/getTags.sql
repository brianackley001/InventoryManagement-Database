

CREATE PROCEDURE getTags 
	@subscriptionID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Tag]
	WHERE	[subscription_id] = @subscriptionID;
END
