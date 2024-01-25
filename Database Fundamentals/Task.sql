Select Employees.EmployeeID,concat(Employees.FirstName, ' ',Employees.LastName) as EmployeeName,count(Orders.EmployeeID) as NoOfOrders from Employees
LEFT JOIN Orders on Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID,Employees.FirstName,Employees.LastName
ORDER BY NoOfOrders DESC;


Select Employees.EmployeeID,concat(Employees.FirstName, ' ',Employees.LastName) as EmployeeName, count(OrderDetails.Quantity)as SoldMostBeverages from Employees
LEFT JOIN Orders on  Employees.EmployeeID = Orders.EmployeeID
RIGHT JOIN OrderDetails on Orders.OrderID = OrderDetails.OrderID
FULL OUTER JOIN Products on OrderDetails.ProductID = Products.ProductID
WHERE Products.CategoryID = 1
GROUP BY Employees.EmployeeID,Employees.FirstName,Employees.LastName
ORDER BY SoldMostBeverages DESC;
