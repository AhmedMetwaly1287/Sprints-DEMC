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
    Phone	VARCHAR(512)
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



--TASK 1--

Select TOP 10 Employees.EmployeeID,Employees.FirstName,Employees.LastName,count(Orders.EmployeeID) as NoOfOrders from Employees
INNER JOIN Orders on Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID,Employees.FirstName,Employees.LastName
ORDER BY NoOfOrders DESC;


--TASK 2--

Select TOP 10 Employees.EmployeeID,Employees.FirstName,Employees.LastName, SUM(OrderDetails.Quantity)as SoldMostBeverages from Employees
INNER JOIN Orders on  Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails on Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products on OrderDetails.ProductID = Products.ProductID
WHERE Products.CategoryID = 1
GROUP BY Employees.EmployeeID,Employees.FirstName,Employees.LastName
ORDER BY SoldMostBeverages DESC;


