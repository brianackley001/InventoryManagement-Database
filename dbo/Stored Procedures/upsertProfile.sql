
CREATE PROCEDURE [dbo].[upsertProfile] 
	@id				INT = NULL,
	@authID			VARCHAR(500),
	@source			VARCHAR(100),
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
				INSERT	INTO [dbo].[Profile]([auth_id], [source], [name])
				VALUES	(@authID, @source, @name);
				SELECT	@RetVal = @@IDENTITY;
			END

			--	UPDATE
			ELSE
			BEGIN
				UPDATE	[dbo].[Profile]
				   SET	[name]	 = @name,
						[auth_id] = @authID,
		   				[source]	 = @source,
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
