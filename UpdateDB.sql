-- QuickByte Food Delivery App - Unified Clean Schema
CREATE DATABASE FoodserviceDB;
GO
USE FoodserviceDB;
GO

-- ==========================================
-- 1. STAKEHOLDER TABLES (Entity Tables)
-- ==========================================

-- Customers
CREATE TABLE Customer_QB (
    CustomerID INT IDENTITY(2001,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(20),
    Segment NVARCHAR(50) DEFAULT 'Regular', -- For segmentation logic
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Restaurants
CREATE TABLE Restaurant_QB (
    RestaurantID INT IDENTITY(3001,1) PRIMARY KEY,
    Name NVARCHAR(100),
    Street NVARCHAR(100),
    City NVARCHAR(50),
    ContactNumber NVARCHAR(20),
    Segment NVARCHAR(50) DEFAULT 'Standard' -- For performance segmentation
);

-- Riders
CREATE TABLE Rider_QB (
    RiderID INT IDENTITY(5001,1) PRIMARY KEY,
    Name NVARCHAR(100),
    ContactNumber NVARCHAR(20),
    Availability BIT DEFAULT 1,
    Segment NVARCHAR(50) DEFAULT 'Standard'
);

-- Platform Managers (Internal Admins)
CREATE TABLE PlatformManager_QB (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Department NVARCHAR(50),
    Segment NVARCHAR(50) DEFAULT 'Standard'
);

-- ==========================================
-- 2. CENTRALIZED USER MANAGEMENT (RBAC)
-- ==========================================

CREATE TABLE Users_QB (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL, -- 'Customer', 'RestaurantManager', 'Rider', 'PlatformManager'
    ReferenceID INT NULL -- Links to CustomerID, RestaurantID, RiderID, or ManagerID
);

-- ==========================================
-- 3. OPERATIONAL TABLES
-- ==========================================

-- Menu Items
CREATE TABLE MenuItem_QB (
    ItemID INT IDENTITY(4001,1) PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name NVARCHAR(100),
    Description NVARCHAR(255),
    Price DECIMAL(10,2),
    Available BIT DEFAULT 1,
    CONSTRAINT FK_MenuItem_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurant_QB(RestaurantID)
);

-- Orders
CREATE TABLE Order_QB (
    OrderID INT IDENTITY(6001,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    RiderID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(30) DEFAULT 'Pending',
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES Customer_QB(CustomerID),
    CONSTRAINT FK_Order_Restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurant_QB(RestaurantID),
    CONSTRAINT FK_Order_Rider FOREIGN KEY (RiderID) REFERENCES Rider_QB(RiderID)
);

-- Order Items
CREATE TABLE OrderItem_QB (
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT,
    PRIMARY KEY (OrderID, ItemID),
    CONSTRAINT FK_OrderItem_Order FOREIGN KEY (OrderID) REFERENCES Order_QB(OrderID),
    CONSTRAINT FK_OrderItem_MenuItem FOREIGN KEY (ItemID) REFERENCES MenuItem_QB(ItemID)
);

-- Payments
CREATE TABLE Payment_QB (
    PaymentID INT IDENTITY(7001,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    Method NVARCHAR(30),
    Amount DECIMAL(10,2),
    PaymentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(30) DEFAULT 'Pending',
    CONSTRAINT FK_Payment_Order FOREIGN KEY (OrderID) REFERENCES Order_QB(OrderID)
);

-- ==========================================
-- 4. LOGGING & AUDIT
-- ==========================================

CREATE TABLE CustomerAuditLog_QB (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    Email NVARCHAR(100),
    DeletedAt DATETIME DEFAULT GETDATE()
);

GO

-- ==========================================
-- 5. TRIGGERS (Automated Business Rules)
-- ==========================================

-- Auto-update Rider Availability
CREATE TRIGGER trg_UpdateRiderAvailability
ON Order_QB
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    BEGIN
        UPDATE Rider_QB
        SET Availability = 1
        FROM Rider_QB r
        JOIN inserted i ON r.RiderID = i.RiderID
        WHERE i.Status = 'Delivered';
    END
END;
GO

-- Log Deleted Customers
CREATE TRIGGER trg_LogCustomerDeletion
ON Customer_QB
AFTER DELETE
AS
BEGIN
    INSERT INTO CustomerAuditLog_QB (CustomerID, Email)
    SELECT CustomerID, Email
    FROM deleted;
END;
GO

-- ==========================================
-- 6. LIVE SAMPLE DATA & USERS
-- ==========================================

-- Populate Platform Managers
INSERT INTO PlatformManager_QB (FullName, Department, Segment) VALUES ('Main Admin', 'Operations', 'SuperAdmin');
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID) VALUES ('admin@quickbyte.com', 'Admin@123', 'PlatformManager', 1);

-- Populate Restaurants
INSERT INTO Restaurant_QB (Name, Street, City, ContactNumber) VALUES ('Pizza Palace','Main Road','Islamabad','0511111111'), ('Burger Hub','Blue Area','Islamabad','0512222222');
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID) 
SELECT 'manager' + CAST(RestaurantID AS VARCHAR) + '@quickbyte.com', 'Rest@123', 'RestaurantManager', RestaurantID FROM Restaurant_QB;

-- Populate Riders
INSERT INTO Rider_QB (Name, ContactNumber, Availability) VALUES ('Ahmed','03450000001',1), ('Bilal','03450000002',1);
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID) 
SELECT 'rider' + CAST(RiderID AS VARCHAR) + '@quickbyte.com', 'Rider@123', 'Rider', RiderID FROM Rider_QB;

-- Populate Customers
INSERT INTO Customer_QB (FirstName, LastName, Email, PhoneNumber) VALUES ('Ali','Raza','ali@example.com','03001111111'), ('Sara','Khan','sara@example.com','03002222222');
INSERT INTO Users_QB (Email, PasswordHash, Role, ReferenceID) 
SELECT Email, 'Customer@123', 'Customer', CustomerID FROM Customer_QB;

-- Populate Menu
DECLARE @Piz INT = (SELECT TOP 1 RestaurantID FROM Restaurant_QB WHERE Name = 'Pizza Palace');
INSERT INTO MenuItem_QB (RestaurantID, Name, Description, Price) VALUES (@Piz, 'Pepperoni Pizza', 'Large pepperoni pizza', 1200);

-- Populate Initial Orders & Payments
INSERT INTO Order_QB (CustomerID, RestaurantID, RiderID, Status) VALUES (2001, 3001, 5001, 'Delivered');
INSERT INTO OrderItem_QB (OrderID, ItemID, Quantity) VALUES (6001, 4001, 2);
INSERT INTO Payment_QB (OrderID, Method, Amount, Status) VALUES (6001, 'Cash', 2400, 'Paid');

GO
