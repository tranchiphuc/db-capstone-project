DELIMITER //
CREATE DEFINER=`phuctc`@`%` PROCEDURE `CheckBooking`(IN p_in_date VARCHAR(45), IN p_in_table_no INT)
BEGIN
	DECLARE status VARCHAR(45);
    IF EXISTS (SELECT * FROM bookings WHERE Date=p_in_date AND TableNo=p_in_table_no) THEN
		SET status = CONCAT("Table ", p_in_table_no, " is already booked");
	ELSE
		SET status = CONCAT("Table ", p_in_table_no, " is avalable");
    END IF;
    SELECT status as "Booking Status";
END
DELIMITER ;

USE `littlelemondb`;
DROP procedure IF EXISTS `AddValidBooking`;

USE `littlelemondb`;
DROP procedure IF EXISTS `AddValidBooking`;

USE `littlelemondb`;
DROP procedure IF EXISTS `littlelemondb`.`AddValidBooking`;
;

DELIMITER $$
USE `littlelemondb`$$
CREATE DEFINER=`phuctc`@`%` PROCEDURE `AddValidBooking`(IN p_in_date DATE, IN p_in_table_no INT)
BEGIN 
    DECLARE status VARCHAR(45);
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		ROLLBACK;
    END;
    
    START TRANSACTION;
    IF EXISTS (SELECT * FROM bookings WHERE Date=p_in_date AND TableNo=p_in_table_no) THEN
		SET status = CONCAT("Table ", p_in_table_no, " is already booked. Booking is cancelled.");
	ELSE
    	SELECT @BookingID := MAX(BookingID) + 1, @CustomerID := @Booking % 100 FROM bookings;
        INSERT INTO bookings(BookingID, CustomerID, TableNo, Date) 
        VALUES (@BookingID, @CustomerID, p_in_table_no, p_in_date);
		SET status = CONCAT("Table ", p_in_table_no, " is booked successfully");
    END IF;
    SELECT status as "Booking Status";
END$$
DELIMITER ;

USE `littlelemondb`;
DROP procedure IF EXISTS `AddBooking`;

DELIMITER $$
USE `littlelemondb`$$
CREATE PROCEDURE `AddBooking` (IN p_booking_id INT, IN p_customer_id INT, IN p_table_no INT, IN p_date DATE)
BEGIN
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		ROLLBACK;
    END;
    
    START TRANSACTION;
	INSERT INTO bookings(BookingID, CustomerID, TableNo, Date) 
	VALUES (p_booking_id, p_customer_id, p_table_no, p_date);
    SELECT "New booking added";
END$$
DELIMITER ;
;

USE `littlelemondb`;
DROP procedure IF EXISTS `littlelemondb`.`UpdateBooking`;
;

DELIMITER $$
USE `littlelemondb`$$
CREATE DEFINER=`phuctc`@`%` PROCEDURE `UpdateBooking`(IN p_booking_id INT, IN p_date DATE)
BEGIN
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		ROLLBACK;
        SELECT "Rollback is sucessfully";
    END;
    
    START TRANSACTION;
	UPDATE bookings
	SET Date = p_date
    WHERE p_booking_id = BookingID;
    SELECT CONCAT("Booking ",  p_booking_id, " updated") AS "Confirmation";
END$$

DELIMITER ;
;




SELECT customers.CustomerID, customers.Name, orders.OrderID, orders.TotalCost AS Cost, menus.MenuName, menuitems.Course as CourseName
FROM customers INNER JOIN bookings ON customers.CustomerID = bookings.CustomerID
INNER JOIN orders ON bookings.BookingID = orders.BookingID
INNER JOIN menus ON orders.MenuID = menus.MenuID
INNER JOIN menuitems ON menus.MenuItemsID = menuitems.MenuItemsID;


SELECT MenuName 
FROM menus 
WHERE MenuID = ANY
(SELECT MenuID FROM orders WHERE Quantity >= 2);

PREPARE GetOrderDetail FROM
	'SELECT OrderID, Quantity, TotalCost FROM ordersview WHERE OrderID = ?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;customerscustomers`GetMaxQuantity()`