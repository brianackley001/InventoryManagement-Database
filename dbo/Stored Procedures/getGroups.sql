


CREATE PROCEDURE [dbo].[getGroups] 
	@subscriptionID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Group]
	WHERE	[subscription_id] = @subscriptionID;
END
