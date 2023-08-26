

CREATE PROCEDURE [dbo].[getProfileSubscriptions] 
	@authID 				VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@profileID INT;

    -- Profile Information
	SELECT	[id], [auth_id] AuthId, [source], [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Profile] 
	 WHERE	[auth_id] = @authID;

	--	Subscription Information
	SELECT	s.[id], s.[name], s.[create_date] CreateDate, s.[update_date] UpdateDate, 
			s.[is_active] IsActive, ps.[active_selection] IsSelectedSubscription, ps.id ProfileSubscriptionId, p.id ProfileId
	 FROM	[dbo].[Profile] p INNER 
	 JOIN	[dbo].[ProfileSubscription] ps
	   ON	p.[id] = ps.[profile_id] INNER
	 JOIN	[dbo].[Subscription] s
	   ON	s.[id] = ps.[subscription_id]
	 WHERE	p.auth_id = @authID;
END
