/****** Object:  StoredProcedure [dbo].[getItemsByGroups]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getItemsByGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getItemsByGroups] AS' 
END
GO




ALTER PROCEDURE [dbo].[getItemsByGroups] 
	@subscriptionID INT,
	@ids			IDTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	i.[id], i.[subscription_id] SubscriptionId, i.[name], i.[description], 
			i.[amount_value] AmountValue, i.[create_date] CreateDate, i.[update_date] UpdateDate, i.[is_active] IsActive, 
			g.[name] GroupName, g.id GroupId
	  FROM	@ids groupIds INNER
	  JOIN	[dbo].[ItemGroup] ig(NOLOCK)
	    ON	groupIds.id = ig.group_id INNER
	  JOIN	[Group] g(NOLOCK)
	    ON	groupIds.id = g.id INNER 
	  JOIN	[dbo].[Item] i(NOLOCK)
	    ON	i.id = ig.item_id
	 WHERE	i.subscription_id = @subscriptionID;
END
GO
