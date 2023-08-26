
CREATE PROCEDURE [dbo].[upsertItemTag] 
	@id				INT = NULL,
	@itemID			INT,
	@tagID			INT,
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
				INSERT	INTO [dbo].[ItemTag]([item_id], [tag_id])
				VALUES	(@itemID, @tagID);
				SELECT	@RetVal = @@IDENTITY;
			END

			--	UPDATE
			ELSE
			BEGIN
				UPDATE	[dbo].[ItemTag]
				   SET	[item_id]	 = @itemID,
						[tag_id] = @tagID,
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
