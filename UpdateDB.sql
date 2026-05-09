USE FoodserviceDB;
GO

-- 1. Create a centralized Users table for RBAC and authentication
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        UserID INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(100) UNIQUE NOT NULL,
        PasswordHash NVARCHAR(255) NOT NULL,
        Role NVARCHAR(50) NOT NULL, -- 'Customer', 'RestaurantManager', 'Rider', 'Admin'
        ReferenceID INT NULL -- Links to CustomerID, RestaurantID, or RiderID depending on Role
    );
END
GO

-- 2. Migrate existing Customers to Users
INSERT INTO Users (Email, PasswordHash, Role, ReferenceID)
SELECT Email, 'Customer@123', 'Customer', CustomerID
FROM Customer
WHERE Email NOT IN (SELECT Email FROM Users);
GO

-- 3. We can add default logins for Restaurants
INSERT INTO Users (Email, PasswordHash, Role, ReferenceID)
SELECT 
    LOWER(REPLACE(Name, ' ', '')) + '@restaurant.com', 
    'Restaurant@123', 
    'RestaurantManager', 
    RestaurantID
FROM Restaurant
WHERE LOWER(REPLACE(Name, ' ', '')) + '@restaurant.com' NOT IN (SELECT Email FROM Users);
GO

-- 4. Default logins for Riders
INSERT INTO Users (Email, PasswordHash, Role, ReferenceID)
SELECT 
    LOWER(REPLACE(Name, ' ', '')) + CAST(RiderID AS NVARCHAR) + '@rider.com', 
    'Rider@123', 
    'Rider', 
    RiderID
FROM Rider
WHERE LOWER(REPLACE(Name, ' ', '')) + CAST(RiderID AS NVARCHAR) + '@rider.com' NOT IN (SELECT Email FROM Users);
GO

-- 5. Default Admin User
IF NOT EXISTS (SELECT * FROM Users WHERE Role = 'Admin')
BEGIN
    INSERT INTO Users (Email, PasswordHash, Role, ReferenceID)
    VALUES ('admin@quickbyte.com', 'Admin@123', 'Admin', NULL);
END
GO
