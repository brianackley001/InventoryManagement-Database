select * from Subscription
select * from dbo.ShoppingList
select * from Item where subscription_id=1

SELECT * FROM [dbo].[ShoppingListItem]

--exec [dbo].[upsertShoppingList]   @subscriptionId=1, @name='MISC List'

DECLARE  @tvp ShoppingListItemTVP;

INSERT INTO @tvp
	SELECT 3,15,1,1;
INSERT INTO @tvp
	SELECT 3,24,1,1;
INSERT INTO @tvp
	SELECT 3,6,1,1;
INSERT INTO @tvp
	SELECT 3,13,1,1;
INSERT INTO @tvp
	SELECT 3,14,1,1;

exec  [dbo].[upsertShoppingListItems] @TVP=@tvp