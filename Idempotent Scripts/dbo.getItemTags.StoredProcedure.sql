/****** Object:  StoredProcedure [dbo].[getItemTags]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getItemTags]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getItemTags] AS' 
END
GO


ALTER PROCEDURE [dbo].[getItemTags] 
	@itemID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [item_id], [tag_id], [create_date], [update_date], [is_active]
	  FROM	[dbo].[ItemTag]
	WHERE	[item_id] = @itemID;
END
GO
