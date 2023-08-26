
CREATE PROCEDURE [dbo].[upsertProfileSubscription] 
	@id					INT = NULL,
	@subscriptionID		INT,
	@profileID			INT,
	@isActiveSelection	BIT = 1,
	@isActive			BIT = 1
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
				INSERT	INTO [dbo].[ProfileSubscription]( [profile_id], [subscription_id], [active_selection], [is_active])
				VALUES	(@profileID, @subscriptionID, @isActiveSelection, @isActive);
				SELECT	@RetVal = @@IDENTITY;
			END

			--	UPDATE
			ELSE
			BEGIN
				UPDATE	[dbo].[ProfileSubscription]
				   SET	[profile_id]	 = @profileID,
						[subscription_id] = @subscriptionID,
		   				[active_selection]	 = @isActiveSelection,
						[is_active] = @isActive,
						[update_date] = GETDATE()
				 WHERE	[id] = @id;
			END
	
			--	If  isActiveSelection is passed in as true, toggle other profile subscriptions isActiveSelection to false
			IF(@isActiveSelection = 1)
			BEGIN
				UPDATE	[dbo].[ProfileSubscription]
				   SET	[active_selection]= 0 
				 WHERE	[profile_id] = @profileID AND [subscription_id] != @subscriptionID;
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
