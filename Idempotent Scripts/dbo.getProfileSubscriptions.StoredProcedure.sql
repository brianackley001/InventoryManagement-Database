/****** Object:  StoredProcedure [dbo].[getProfileSubscriptions]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getProfileSubscriptions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getProfileSubscriptions] AS' 
END
GO


ALTER PROCEDURE [dbo].[getProfileSubscriptions] 
	@authID 				VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@profileID INT;

    -- Profile Information
	SELECT	[id], [auth_id], [source], [name], [create_date], [update_date], [is_active]
	  FROM	[dbo].[Profile] 
	 WHERE	[auth_id] = @authID;

	--	Subscription Information
	SELECT	s.[id] subscription_id, s.[name] subscription_name, s.[create_date] subscription_create_date, s.[update_date] subscription_update_date, 
			s.[is_active] subscription_isactive, ps.[active_selection] is_active_selection
	 FROM	[dbo].[Profile] p INNER 
	 JOIN	[dbo].[ProfileSubscription] ps
	   ON	p.[id] = ps.[profile_id] INNER
	 JOIN	[dbo].[Subscription] s
	   ON	s.[id] = ps.[subscription_id]
	 WHERE	p.auth_id = @authID;
END
GO
