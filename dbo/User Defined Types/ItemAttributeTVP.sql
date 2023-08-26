CREATE TYPE [dbo].[ItemAttributeTVP] AS TABLE (
    [attributeID] INT NOT NULL,
    [itemID]      INT NOT NULL,
    [isActive]    BIT NOT NULL,
    [isSelected]  BIT NOT NULL,
    PRIMARY KEY CLUSTERED ([itemID] ASC, [attributeID] ASC));



