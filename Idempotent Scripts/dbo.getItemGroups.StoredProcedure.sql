/****** Object:  StoredProcedure [dbo].[getItemGroups]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getItemGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getItemGroups] AS' 
END
GO


ALTER PROCEDURE [dbo].[getItemGroups] 
	@itemID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [item_id] ItemId, [group_id] GroupId, [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ItemGroup]
	WHERE	[item_id] = @itemID;
END
GO
