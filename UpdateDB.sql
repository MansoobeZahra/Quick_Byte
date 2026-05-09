USE FoodserviceDB;
GO

-- 1. Create a centralized Users table for RBAC and authentication
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users_QB')
BEGIN
    CREATE TABLE Users_QB (
        UserID INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(100) UNIQUE NOT NULL,
        PasswordHash NVARCHAR(255) NOT NULL,
        Role NVARCHAR(50) NOT NULL, -- 'Customer', 'RestaurantManager', 'Rider', 'Admin'
        ReferenceID INT NULL -- Links to CustomerID, RestaurantID, or RiderID depending on Role
    );
END
GO

-- 2. Migrate existing Customers to Users
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
SELECT Email, 'Customer@123', 'Customer', CustomerID
FROM Customer
WHERE Email NOT IN (SELECT Email FROM Users_QB);
GO

-- 3. We can add default logins for Restaurants
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
SELECT 
    LOWER(REPLACE(Name, ' ', '')) + '@restaurant.com', 
    'Restaurant@123', 
    'RestaurantManager', 
    RestaurantID
FROM Restaurant
WHERE LOWER(REPLACE(Name, ' ', '')) + '@restaurant.com' NOT IN (SELECT Email FROM Users_QB);
GO

-- 4. Default logins for Riders
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
SELECT 
    LOWER(REPLACE(Name, ' ', '')) + CAST(RiderID AS NVARCHAR) + '@rider.com', 
    'Rider@123', 
    'Rider', 
    RiderID
FROM Rider
WHERE LOWER(REPLACE(Name, ' ', '')) + CAST(RiderID AS NVARCHAR) + '@rider.com' NOT IN (SELECT Email FROM Users_QB);
GO

-- 5. Default Admin User
IF NOT EXISTS (SELECT * FROM Users_QB WHERE Role = 'Admin')
BEGIN
    INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
    VALUES ('admin@quickbyte.com', 'Admin@123', 'Admin', NULL);
END
GO

-- 6. Rename Order table to Order_QB
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Order')
BEGIN
    EXEC sp_rename 'Order', 'Order_QB';
END
GO

-- 7. Rename remaining tables for consistency
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Customer') EXEC sp_rename 'Customer', 'Customer_QB';
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Restaurant') EXEC sp_rename 'Restaurant', 'Restaurant_QB';
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Rider') EXEC sp_rename 'Rider', 'Rider_QB';
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'MenuItem') EXEC sp_rename 'MenuItem', 'MenuItem_QB';
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderItem') EXEC sp_rename 'OrderItem', 'OrderItem_QB';
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Payment') EXEC sp_rename 'Payment', 'Payment_QB';
GO
