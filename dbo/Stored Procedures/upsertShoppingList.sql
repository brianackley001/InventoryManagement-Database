

CREATE PROCEDURE [dbo].[upsertShoppingList] 
	@id 			INT = NULL,
	@subscriptionID	INT,
	@name			VARCHAR(255),
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
				INSERT	INTO [dbo].[ShoppingList]([name],[subscription_id])
				VALUES	(@name, @subscriptionID);
				SELECT @RetVal = @@IDENTITY;
			END

			--	UPDATE
			IF(ISNULL(@id, -1) > -1)
			BEGIN
				UPDATE	[dbo].[ShoppingList]
				   SET	[name]	 = @name,
						[is_active] = @isActive,
						[update_date] = GETDATE()
				 WHERE	[id] = @id AND subscription_id = @subscriptionID;
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
