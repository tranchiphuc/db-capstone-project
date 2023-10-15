PREPARE GetOrderDetail FROM
	'SELECT OrderID AS "Order ID", Quantity, TotalCost AS "Order Cost" FROM ordersview WHERE OrderID = ?';
	
SET @id = 1;
EXECUTE GetOrderDetail USING @id;