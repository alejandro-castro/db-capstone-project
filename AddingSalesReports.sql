USE little_lemon_db;
-- ------Part 1
-- Task 1
CREATE VIEW OrdersView  AS 
SELECT OrderId, Quantity, TotalCost
FROM Orders
WHERE Quantity > 2
;

-- Task 2
SELECT Customers.CustomerId, Customers.Name, OrderId, TotalCost, MenuName, CourseName, StarterName
FROM Customers
INNER JOIN (Orders, Menus, MenuItems, Menus_MenuItems)
ON Customers.CustomerId = Orders.CustomerId AND
Orders.MenuId = Menus.MenuId AND
Menus.MenuId = Menus_MenuItems.MenuId AND
Menus_MenuItems.MenuItemId = MenuItems.MenuItemId
WHERE TotalCost > 150
ORDER BY TotalCost ASC
;

-- Task 3
SELECT * FROM MenuItems 
WHERE EXISTS ( 
	SELECT COUNT(MenuItemId) AS menu_count 
    FROM Menus_MenuItems 
    GROUP BY MenuItemId 
    HAVING MenuItemId = MenuItems.MenuItemId AND menu_count > 2
);

-- ------Part 2
-- Task 1
CREATE PROCEDURE GetMaxQuantity() 
SELECT Quantity AS 'Max Quantity in Order'
FROM Orders 
ORDER BY Quantity DESC 
LIMIT 1;

CALL GetMaxQuantity();

-- Task 2
PREPARE GetOrderDetail FROM 
'SELECT OrderId, Quantity, TotalCost 
FROM Orders WHERE CustomerId = ?
';
SET @id =1;
EXECUTE GetOrderDetail USING @id;

-- Task 3
CREATE PROCEDURE CancelOrder(IN UserId INT)
DELETE FROM Orders WHERE CustomerId = UserId;
SELECT CONCAT("Order ", UserId, " is cancelled") AS Confirmation;
;
