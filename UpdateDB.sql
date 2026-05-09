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

-- 8. Create PlatformManager_QB table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PlatformManager_QB')
BEGIN
    CREATE TABLE PlatformManager_QB (
        ManagerID INT IDENTITY(1,1) PRIMARY KEY,
        FullName NVARCHAR(100) NOT NULL,
        Department NVARCHAR(50),
        Segment NVARCHAR(50) DEFAULT 'Standard'
    );
END
GO

-- 9. Add Segment column to other stakeholders for advanced segmentation
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Customer_QB') AND name = 'Segment')
    ALTER TABLE Customer_QB ADD Segment NVARCHAR(50) DEFAULT 'Regular';
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Restaurant_QB') AND name = 'Segment')
    ALTER TABLE Restaurant_QB ADD Segment NVARCHAR(50) DEFAULT 'Standard';
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Rider_QB') AND name = 'Segment')
    ALTER TABLE Rider_QB ADD Segment NVARCHAR(50) DEFAULT 'Regular';
GO

-- 11. Populate Live Sample Data for Demonstration
-- Clear existing sample data to avoid duplicates if needed (optional)
-- DELETE FROM Payment_QB; DELETE FROM OrderItem_QB; DELETE FROM Order_QB;

-- Realistic Customers
IF NOT EXISTS (SELECT * FROM Customer_QB WHERE Email = 'sarah.j@live.com')
BEGIN
    INSERT INTO Customer_QB (FirstName, LastName, Email, PhoneNumber, Segment) VALUES 
    ('Sarah', 'Johnson', 'sarah.j@live.com', '03001112223', 'Premium'),
    ('Mike', 'Ross', 'mike.r@gmail.com', '03004445556', 'Bulk Buyer'),
    ('Ali', 'Khan', 'ali.k@yahoo.com', '03007778889', 'Regular'),
    ('Zahra', 'Mansoob', 'zahra.m@outlook.com', '03219998887', 'Premium');
END
GO

-- Realistic Restaurants
IF NOT EXISTS (SELECT * FROM Restaurant_QB WHERE Name = 'Burger King')
BEGIN
    INSERT INTO Restaurant_QB (Name, Street, City, ContactNumber, Segment) VALUES 
    ('Burger King', 'F-7 Markaz', 'Islamabad', '0512223334', 'Top Performance'),
    ('Sushi Dash', 'Gulberg III', 'Lahore', '0423334445', 'Standard'),
    ('Taco Town', 'DHA Phase 6', 'Karachi', '0214445556', 'Needs Attention');
END
GO

-- Populate Menus
IF NOT EXISTS (SELECT * FROM MenuItem_QB)
BEGIN
    DECLARE @BK INT = (SELECT TOP 1 RestaurantID FROM Restaurant_QB WHERE Name = 'Burger King');
    DECLARE @SD INT = (SELECT TOP 1 RestaurantID FROM Restaurant_QB WHERE Name = 'Sushi Dash');
    
    INSERT INTO MenuItem_QB (RestaurantID, Name, Description, Price, Available) VALUES 
    (@BK, 'Whopper Meal', 'Flame-grilled beef with fries', 1200, 1),
    (@BK, 'Chicken Royale', 'Crispy chicken with lettuce', 950, 1),
    (@BK, 'Family Bucket', '10pcs Chicken + 2 Large Fries', 3500, 1),
    (@SD, 'California Roll', 'Crab, avocado, and cucumber', 1500, 1),
    (@SD, 'Salmon Nigiri', 'Fresh salmon over rice', 1800, 1);
END
GO

-- Realistic Riders
IF NOT EXISTS (SELECT * FROM Rider_QB WHERE Name = 'Kamran Speed')
BEGIN
    INSERT INTO Rider_QB (Name, ContactNumber, Availability, Segment) VALUES 
    ('Kamran Speed', '03451112222', 1, 'Elite Rider'),
    ('Javed Express', '03453334444', 1, 'Standard Rider'),
    ('Aslam Pro', '03455556666', 0, 'Standard Rider');
END
GO

-- Generate "Live" Orders for Segmentation Dashboard
IF NOT EXISTS (SELECT * FROM Order_QB)
BEGIN
    DECLARE @Cust1 INT = (SELECT TOP 1 CustomerID FROM Customer_QB WHERE Email = 'sarah.j@live.com');
    DECLARE @Cust2 INT = (SELECT TOP 1 CustomerID FROM Customer_QB WHERE Email = 'mike.r@gmail.com');
    DECLARE @Rest1 INT = (SELECT TOP 1 RestaurantID FROM Restaurant_QB WHERE Name = 'Burger King');
    DECLARE @Ride1 INT = (SELECT TOP 1 RiderID FROM Rider_QB WHERE Name = 'Kamran Speed');
    DECLARE @Item1 INT = (SELECT TOP 1 ItemID FROM MenuItem_QB WHERE Name = 'Family Bucket');
    DECLARE @Item2 INT = (SELECT TOP 1 ItemID FROM MenuItem_QB WHERE Name = 'Whopper Meal');

    -- Premium Customer Orders (Many orders)
    INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status, OrderDate)
    SELECT @Cust1, @Rest1, @Ride1, 'Delivered', GETDATE() - 1 FROM (SELECT TOP 12 1 as n FROM sys.objects) as t;

    -- Bulk Buyer Orders (Large quantities)
    INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status, OrderDate) VALUES (@Cust2, @Rest1, @Ride1, 'Delivered', GETDATE());
    DECLARE @BulkOrderID INT = SCOPE_IDENTITY();
    INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (@BulkOrderID, @Item1, 6);

    -- Standard items for other orders
    INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity)
    SELECT OrderID, @Item2, 1 FROM Order_QB WHERE OrderID <> @BulkOrderID;

    -- Payments
    INSERT INTO Payment_QB (OrderID, Method, Amount, Status, PaymentDate)
    SELECT OrderID, 'Cash', 1200, 'Paid', GETDATE() FROM Order_QB;
END
GO

-- 10. Populate Platform Manager and update Users_QB
IF NOT EXISTS (SELECT * FROM PlatformManager_QB WHERE FullName = 'Main Admin')
BEGIN
    INSERT INTO PlatformManager_QB (FullName, Department) VALUES ('Main Admin', 'Operations');
    DECLARE @MgrID INT = SCOPE_IDENTITY();
    
    IF NOT EXISTS (SELECT * FROM Users_QB WHERE Email = 'admin@quickbyte.com')
        INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
        VALUES ('admin@quickbyte.com', 'Admin@123', 'PlatformManager', @MgrID);
    ELSE
        UPDATE Users_QB SET Role = 'PlatformManager', ReferenceID = @MgrID WHERE Email = 'admin@quickbyte.com';
END
GO

-- 12. Final User Sync for all roles
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
SELECT Email, 'Customer@123', 'Customer', CustomerID FROM Customer_QB WHERE Email NOT IN (SELECT Email FROM Users_QB);
GO
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
SELECT LOWER(REPLACE(Name, ' ', '')) + '@restaurant.com', 'Rest@123', 'RestaurantManager', RestaurantID FROM Restaurant_QB WHERE LOWER(REPLACE(Name, ' ', '')) + '@restaurant.com' NOT IN (SELECT Email FROM Users_QB);
GO
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID)
SELECT LOWER(REPLACE(Name, ' ', '')) + '@rider.com', 'Rider@123', 'Rider', RiderID FROM Rider_QB WHERE LOWER(REPLACE(Name, ' ', '')) + '@rider.com' NOT IN (SELECT Email FROM Users_QB);
GO
