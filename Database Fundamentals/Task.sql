CREATE TABLE Customers 
(
    CustomerID	INT PRIMARY KEY,
    CustomerName	VARCHAR(512),
    ContactName	VARCHAR(512),
    Address	VARCHAR(512),
    City	VARCHAR(512),
    PostalCode	VARCHAR(512),
    Country	VARCHAR(512)
);



CREATE TABLE Categories 
(
    CategoryID	INT PRIMARY KEY,
    CategoryName	VARCHAR(512),
    Description	VARCHAR(512)
);

CREATE TABLE Employees 
(
    EmployeeID	INT PRIMARY KEY,
    LastName	VARCHAR(512),
    FirstName	VARCHAR(512),
    BirthDate	VARCHAR(512),
    Photo	VARCHAR(512),
    Notes	VARCHAR(512)
);


CREATE TABLE OrderDetails 
(
    OrderDetailID	INT PRIMARY KEY,
    OrderID	INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID	INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity	INT
);

drop table OrderDetails




CREATE TABLE Orders 
(
    OrderID	INT PRIMARY KEY,
    CustomerID	INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID	INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    OrderDate	VARCHAR(512),
    ShipperID	INT FOREIGN KEY REFERENCES Shippers(ShipperID)
);




CREATE TABLE Products 
(
    ProductID	INT PRIMARY KEY,
    ProductName	VARCHAR(512),
    SupplierID	INT FOREIGN KEY REFERENCES Shippers(ShipperID),
    CategoryID	INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Unit	VARCHAR(512),
    Price	FLOAT
);


CREATE TABLE Shippers 
(
    ShipperID	INT PRIMARY KEY,
    ShipperName	VARCHAR(512),
    Phone	FLOAT
);





CREATE TABLE Suppliers 
(
    SupplierID	INT PRIMARY KEY,
    SupplierName	VARCHAR(512),
    ContactName	VARCHAR(512),
    Address	VARCHAR(512),
    City	VARCHAR(512),
    PostalCode	VARCHAR(512),
    Country	VARCHAR(512),
    Phone	VARCHAR(512)
);





Select TOP 10 Employees.EmployeeID,Employees.FirstName,Employees.LastName,count(Orders.EmployeeID) as NoOfOrders from Employees
INNER JOIN Orders on Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID,Employees.FirstName,Employees.LastName
ORDER BY NoOfOrders DESC;


select * from Categories;

--Beverages is CategoryID 1--

select * from OrderDetails

select * from products

Select TOP 10 Employees.EmployeeID,Employees.FirstName,Employees.LastName, SUM(OrderDetails.Quantity)as SoldMostBeverages from Employees
INNER JOIN Orders on  Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails on Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products on OrderDetails.ProductID = Products.ProductID
WHERE Products.CategoryID = 1
GROUP BY Employees.EmployeeID,Employees.FirstName,Employees.LastName
ORDER BY SoldMostBeverages DESC;


SELECT 'sqlserver' dbms,t.TABLE_CATALOG,t.TABLE_SCHEMA,t.TABLE_NAME,c.COLUMN_NAME,c.ORDINAL_POSITION,c.DATA_TYPE,c.CHARACTER_MAXIMUM_LENGTH,n.CONSTRAINT_TYPE,k2.TABLE_SCHEMA,k2.TABLE_NAME,k2.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES t LEFT JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_CATALOG=c.TABLE_CATALOG AND t.TABLE_SCHEMA=c.TABLE_SCHEMA AND t.TABLE_NAME=c.TABLE_NAME LEFT JOIN(INFORMATION_SCHEMA.KEY_COLUMN_USAGE k JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS n ON k.CONSTRAINT_CATALOG=n.CONSTRAINT_CATALOG AND k.CONSTRAINT_SCHEMA=n.CONSTRAINT_SCHEMA AND k.CONSTRAINT_NAME=n.CONSTRAINT_NAME LEFT JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r ON k.CONSTRAINT_CATALOG=r.CONSTRAINT_CATALOG AND k.CONSTRAINT_SCHEMA=r.CONSTRAINT_SCHEMA AND k.CONSTRAINT_NAME=r.CONSTRAINT_NAME)ON c.TABLE_CATALOG=k.TABLE_CATALOG AND c.TABLE_SCHEMA=k.TABLE_SCHEMA AND c.TABLE_NAME=k.TABLE_NAME AND c.COLUMN_NAME=k.COLUMN_NAME LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE k2 ON k.ORDINAL_POSITION=k2.ORDINAL_POSITION AND r.UNIQUE_CONSTRAINT_CATALOG=k2.CONSTRAINT_CATALOG AND r.UNIQUE_CONSTRAINT_SCHEMA=k2.CONSTRAINT_SCHEMA AND r.UNIQUE_CONSTRAINT_NAME=k2.CONSTRAINT_NAME WHERE t.TABLE_TYPE='BASE TABLE';
