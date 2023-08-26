USE [InventoryManagement]
GO

DECLARE	@return_value int,
		@collectionTotal int,
		@idValues IDTVP
INSERT INTO @idValues VALUES(2);
INSERT INTO @idValues VALUES(4);
INSERT INTO @idValues VALUES(1);

EXEC	@return_value = [dbo].[getItemsByTags]
		@subscriptionID = 1,
		@ids = @idValues,
		@pageNum = 1,
		@pageSize = 5,
		@collectionTotal = @collectionTotal OUTPUT

SELECT	@collectionTotal as N'@collectionTotal'

SELECT	'Return Value' = @return_value

GO
