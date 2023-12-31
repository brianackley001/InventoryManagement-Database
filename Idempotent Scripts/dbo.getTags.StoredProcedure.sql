/****** Object:  StoredProcedure [dbo].[getTags]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getTags]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getTags] AS' 
END
GO


ALTER PROCEDURE [dbo].[getTags] 
	@subscriptionID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id], [name], [create_date], [update_date], [is_active]
	  FROM	[dbo].[Tag]
	WHERE	[subscription_id] = @subscriptionID;
END
GO
