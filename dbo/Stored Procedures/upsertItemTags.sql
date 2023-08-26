
CREATE PROCEDURE [dbo].[upsertItemTags] 
	@TVP			ItemAttributeTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;
	
	BEGIN TRY;
		BEGIN TRANSACTION;
			MERGE [dbo].[ItemTag] it 
			USING @TVP t
			ON (it.[item_id]= t.[itemID] AND it.[tag_id] = t.[attributeID])
			WHEN MATCHED AND t.[isSelected] = 1 THEN 
				UPDATE SET [update_date] = GETDATE()
			WHEN MATCHED AND t.[isSelected] = 0 THEN 
				DELETE
			WHEN NOT MATCHED BY TARGET AND t.[isSelected] = 1 THEN 
				INSERT ([item_id], [tag_id],  [is_active])
				VALUES (t.[itemID], t.[attributeID], t.[isActive]);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH;
		DECLARE @msg nvarchar(max);
		SET @msg = ERROR_MESSAGE();
		RAISERROR (@msg, 16, 1);
		Set @RetVal = -1;
	
		ROLLBACK TRANSACTION;
	END CATCH;
	RETURN @RetVal;
END