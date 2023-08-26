CREATE TYPE [dbo].[ShoppingListItemTVP] AS TABLE (
    [shoppingListID] INT NOT NULL,
    [itemID]         INT NOT NULL,
    [subscriptionID] INT NULL,
    [isActive]       BIT NOT NULL,
    [isSelected]     BIT NOT NULL,
    PRIMARY KEY CLUSTERED ([shoppingListID] ASC, [itemID] ASC));





