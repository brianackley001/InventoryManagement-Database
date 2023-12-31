/****** Object:  StoredProcedure [dbo].[getItem]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getItem] AS' 
END
GO


ALTER PROCEDURE [dbo].[getItem] 
	@id	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [description], [amount_value] AmountValue, [create_date] CreateDate, 
			[update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Item]
	WHERE	[id] = @id;
END
GO
