/****** Object:  StoredProcedure [dbo].[getShoppingLists]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getShoppingLists]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getShoppingLists] AS' 
END
GO


ALTER PROCEDURE [dbo].[getShoppingLists] 
	@subscriptionID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id], [name], [create_date], [update_date], [is_active]
	  FROM	[dbo].[ShoppingList]
	WHERE	[subscription_id] = @subscriptionID
	ORDER	BY [update_date] DESC;
END
GO
