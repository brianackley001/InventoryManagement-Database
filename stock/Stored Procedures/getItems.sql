


CREATE PROCEDURE [stock].[getItems] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	NULL ItemId, [id] CategoryId, NULL SubCategoryId,  [create_date] CreateDate, [update_date] UpdateDate, 
			[is_active] IsActive, [id] + 750000 TreeNodeId, [name] name, NULL SubCategoryName, NULL ItemName, 'Category' NodeType
	  FROM	[stock].[Category]
	 WHERE	[is_active] = 1 ;

	SELECT	NULL ItemId, [category_id] CategoryId, [id] SubCategoryId, [create_date] CreateDate, [update_date] UpdateDate, 
			[is_active] IsActive, [id] + 700000 TreeNodeId, NULL CategoryName, [name] name, NULL ItemName, 'SubCategory' NodeType
	  FROM	[stock].[SubCategory]
	 WHERE	[is_active] = 1 ;

	SELECT	i.[id] AS ItemId, c.[id] AS CategoryId, sc.[id] AS SubCategoryId, i.[create_date] CreateDate, i.[update_date] UpdateDate,
			i.[is_active] IsActive, i.[id]  TreeNodeId,
			c.[name] AS CategoryName, sc.[name] AS SubCategoryName, i.[name] name, 'Item' NodeType
	  FROM	[stock].[SubCategory] sc INNER
	  JOIN	[stock].[Category] c 
	    ON	c.[id] = sc.category_id Inner
	  JOIN	[stock].Item i 
	    ON	i.category_id = c.[id] AND i.sub_category_id = sc.[id]
	  WHERE	ISNULL(i.[is_active], -1) > 0 AND 
			ISNULL(c.[is_active], -1) > 0 AND 
			ISNULL(sc.[is_active], -1) > 0
	 ORDER	BY c.[id] ASC, sc.[name] ASC, i.[name] ASC

END