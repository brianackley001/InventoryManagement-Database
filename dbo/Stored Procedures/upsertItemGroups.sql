
CREATE PROCEDURE [dbo].[upsertItemGroups] 
	@TVP			ItemAttributeTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;
	
	BEGIN TRY;
		BEGIN TRANSACTION;
			MERGE [dbo].[ItemGroup] ig 
			USING @TVP t
			ON (ig.[item_id]= t.[itemID] AND ig.[group_id] = t.[attributeID])
			WHEN MATCHED AND t.[isSelected] = 1 THEN 
				UPDATE SET [update_date] = GETDATE()
			WHEN MATCHED AND t.[isSelected] = 0 THEN 
				DELETE
			WHEN NOT MATCHED BY TARGET AND t.[isSelected] = 1 THEN 
				INSERT ([item_id], [group_id],  [is_active])
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