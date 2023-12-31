/****** Object:  StoredProcedure [dbo].[getGroups]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getGroups] AS' 
END
GO


ALTER PROCEDURE [dbo].[getGroups] 
	@subscriptionID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Group]
	WHERE	[subscription_id] = @subscriptionID;
END
GO
