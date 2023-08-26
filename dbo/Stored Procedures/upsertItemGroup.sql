
CREATE PROCEDURE [dbo].[upsertItemGroup] 
	@id				INT = NULL,
	@itemID			INT,
	@groupID		INT,
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;
	
	BEGIN TRY;
		BEGIN TRANSACTION;
			--	INSERT
			IF(ISNULL(@id, -1) = -1)
			BEGIN
				INSERT	INTO [dbo].[ItemGroup]([item_id], [group_id])
				VALUES	(@itemID, @groupID);
				SELECT	@RetVal = @@IDENTITY;
			END

			--	UPDATE
			ELSE
			BEGIN
				UPDATE	[dbo].[ItemGroup]
				   SET	[item_id]	 = @itemID,
						[group_id] = @groupID,
						[is_active] = @isActive,
						[update_date] = GETDATE()
				 WHERE	[id] = @id;
			END
	
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
