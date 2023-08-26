


CREATE PROCEDURE [dbo].[upsertSubscription] 
	@id					INT = NULL,
	@profileID			INT,
	@name				VARCHAR(255),
	@isActive			BIT = 1,
	@isActiveSelection	BIT = 1
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
				INSERT	INTO  [dbo].[Subscription]([name])
				VALUES	(@name);
				SELECT @RetVal = @@IDENTITY;

				--	Check/Insert ProfileSubscription
				IF NOT EXISTS(SELECT [id] FROM [dbo].[ProfileSubscription] WHERE profile_id=@profileID AND subscription_id=@RetVal)
				BEGIN
					EXEC [dbo].[upsertProfileSubscription] @subscriptionID = @RetVal, @profileID=@profileID, @isActiveSelection=@isActiveSelection, @isActive=@isActive
				END
			END

			--	UPDATE
			IF(ISNULL(@id, -1) > -1)
			BEGIN
				UPDATE	[dbo].[Subscription]
				   SET	[name]	 = @name,
						[is_active] = @isActive,
						[update_date] = GETDATE()
				 WHERE	[id] = @id
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
