-------------------------------------------------------------------------------------------------------------------------
-- Insert Profile(s)
-------------------------------------------------------------------------------------------------------------------------

--EXEC [dbo].[upsertProfile] @authID = 'TEST1', @source='MANUAL-TEST', @name='Data Population 1'
--EXEC [dbo].[upsertProfile] @authID = 'TEST2', @source='MANUAL-TEST 2', @name='Data Population 2'
--EXEC [dbo].[upsertProfile] @authID = 'TEST3', @source='MANUAL-TEST 3', @name='Data Population 3'
--EXEC [dbo].[upsertProfile] @authID = 'TEST4', @source='MANUAL-TEST 4', @name='Data Population 4'

-------------------------------------------------------------------------------------------------------------------------
-- Upsert Subscriptions
-------------------------------------------------------------------------------------------------------------------------
DECLARE @profileTemp Table(ID INT IDENTITY(1,1), profileId INT);
DECLARE	@pfCounter INT, @subName VARCHAR(255), @profileName  VARCHAR(255), @profileId INT,@subCounter INT;
SELECT	@pfCounter = 1;

INSERT INTO @profileTemp
	SELECT [id] FROM [dbo].[Profile];


WHILE @pfCounter < 5
BEGIN
	SELECT @profileName = p.[name], @profileId = p.id 
	  FROM [dbo].[Profile] p INNER JOIN
			@profileTemp pt
		ON	p.ID = pt.profileId
	  WHERE	pt.ID = @pfCounter;
	SELECT @subCounter = 1;

	WHILE	@subCounter < 4
	BEGIN
		SELECT	@subName = 'Profile' + CAST(@profileId AS VARCHAR(10)) + '_Subscription-' + CAST(@subCounter AS VARCHAR(10))
		--PRINT 'EXEC [dbo].[upsertSubscription] @name=''' + @subName + ''''
		EXEC	[dbo].[upsertSubscription] @name=@subName;
		SELECT	@subCounter = @subCounter + 1;
	END

	SELECT	@pfCounter = @pfCounter + 1;
END
/*

  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 1, @profileID = 1, @isActiveSelection = 1
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 2, @profileID = 1, @isActiveSelection = 0
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 3, @profileID = 1, @isActiveSelection = 0
  
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 4, @profileID = 2, @isActiveSelection = 1
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 5, @profileID = 2, @isActiveSelection = 0
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 6, @profileID = 2, @isActiveSelection = 0
  
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 7, @profileID = 3, @isActiveSelection = 1
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 8, @profileID = 3, @isActiveSelection = 0
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 9, @profileID = 3, @isActiveSelection = 0
  
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 10, @profileID = 4, @isActiveSelection = 1
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 11, @profileID = 4, @isActiveSelection = 0
  exec [dbo].[upsertProfileSubscription]  @subscriptionID = 12, @profileID = 4, @isActiveSelection = 0
*/