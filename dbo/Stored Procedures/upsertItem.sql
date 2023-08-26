
CREATE PROCEDURE [dbo].[upsertItem] 
	@id				INT = NULL,
	@subscriptionID	INT,
	@name			VARCHAR(255),
	@description	VARCHAR(255),
	@amountValue	INT = 2,
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
				INSERT	INTO [dbo].[Item]([subscription_id], [name], [description], [amount_value])
				VALUES	(@subscriptionID, @name, @description, @amountValue);
				SELECT	@RetVal = @@IDENTITY;
			END

			--	UPDATE
			ELSE
			BEGIN
				UPDATE	[dbo].[Item]
				   SET	[name]	 = @name,
						[description] = @description,
						[is_active] = @isActive,
						[amount_value] = @amountValue,
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
