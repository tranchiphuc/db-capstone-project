DELIMITER $$
CREATE PROCEDURE `CancelOrder`(IN p_order_id INT)
BEGIN
    DECLARE status VARCHAR(255);
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		ROLLBACK;
    END;
	
    START TRANSACTION;
    IF EXISTS (SELECT OrderID FROM orders WHERE OrderID = p_order_id) THEN
		DELETE FROM orders WHERE OrderID = p_order_id;
		SET status = CONCAT("Order ", p_order_id, " is cancel");
        SELECT status AS "Confirmation";
	ELSE
		SET status = CONCAT("Order ", p_order_id, " does not exist");
        SELECT status AS "Information";
	END IF;
END$$
DELIMITER ;

CALL CancelOrder(5);



DELIMITER $$
CREATE PROCEDURE `CancelBooking`(IN p_booking_id INT)
BEGIN
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		ROLLBACK;
        SELECT "Rollback is sucessfully" AS "Information";
    END;
    
    START TRANSACTION;
	DELETE FROM bookings
    WHERE BookingID = p_booking_id;
    SELECT CONCAT("Booking ",  p_booking_id, " cancelled") AS "Confirmation";
END$$
DELIMITER ;

CALL CancelBooking(9);





DELIMITER $$
CREATE PROCEDURE `UpdateBooking`(IN p_booking_id INT, IN p_date DATE)
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

CALL UpdateBooking(9, "2022-12-17");



DELIMITER $$
CREATE PROCEDURE `GetMaxQuantity`()
BEGIN
	SELECT MAX(Quantity) AS "Max Quantity in Orders"
    FROM orders;
END$$
DELIMITER ;

CALL GetMaxQuantity();



DELIMITER $$
CREATE PROCEDURE `CheckBooking`(IN p_in_date VARCHAR(45), IN p_in_table_no INT)
BEGIN
	DECLARE status VARCHAR(45);
    IF EXISTS (SELECT * FROM bookings WHERE BookingDate=p_in_date AND TableNumber=p_in_table_no) THEN
		SET status = CONCAT("Table ", p_in_table_no, " is already booked");
	ELSE
		SET status = CONCAT("Table ", p_in_table_no, " is avalable");
    END IF;
    SELECT status as "Booking Status";
END$$
DELIMITER ;

CALL CheckBooking("2022-11-12", 3);





DELIMITER $$
CREATE PROCEDURE `AddValidBooking`(IN p_in_date DATE, IN p_in_table_no INT)
BEGIN 
    DECLARE status VARCHAR(45);
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		ROLLBACK;
    END;
    
    START TRANSACTION;
    IF EXISTS (SELECT BookingID FROM bookings WHERE BookingDate=p_in_date AND TableNumber=p_in_table_no) THEN
		SET status = CONCAT("Table ", p_in_table_no,  " is already booked. Booking is cancelled.");
	ELSE
    	SELECT @BookingID = MAX(BookingID) + 1, @CustomerID = @BookingID % 100 FROM bookings;
        INSERT INTO bookings(BookingID, CustomerID, TableNumber, BookingDate) 
        VALUES (@BookingID, @CustomerID, p_in_table_no, p_in_date);
		SET status = CONCAT("Table ", p_in_table_no, " is booked successfully");
    END IF;
    SELECT status as "Booking Status";
END$$
DELIMITER ;

CALL AddValidBooking("2022-12-17", 6)




DELIMITER $$
CREATE PROCEDURE `AddBooking`(IN p_booking_id INT, IN p_customer_id INT, IN p_table_no INT, IN p_date DATE)
BEGIN
	DECLARE status VARCHAR(45);
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		SET status =  "Booking is unsuccessful";
		SELECT status as "Booking Status";
		ROLLBACK;
    END;
	
    START TRANSACTION;
	IF EXISTS (SELECT BookingID FROM bookings WHERE BookingDate=p_date AND TableNumber=p_table_no) THEN
		SET status = CONCAT("Table ", p_in_table_no,  " is already booked. Booking is cancelled.");
	ELSE		
		INSERT INTO bookings(BookingID, CustomerID, TableNumber, BookingDate) 
		VALUES (p_booking_id, p_customer_id, p_table_no, p_date);
		SET status = CONCAT("Table ", p_table_no, " is booked successfully");
	END IF;
    SELECT status as "Booking Status";
END$$
DELIMITER ;

CALL AddBooking(9, 3, 4, "2022-12-30");



DELIMITER $$
CREATE PROCEDURE `ManageBooking`(IN p_booking_id INT, IN p_customer_id INT, IN p_table_no INT, IN p_date DATE)
BEGIN
	DECLARE status VARCHAR(45);
	DECLARE EXIT HANDLER FOR sqlexception, sqlwarning
    BEGIN
		SET status =  "Booking is unsuccessful";
		SELECT status as "Booking Status";
		ROLLBACK;
    END;
	
    START TRANSACTION;
	IF EXISTS (SELECT BookingID FROM bookings WHERE BookingDate=p_date AND TableNumber=p_table_no) THEN
		SET status = CONCAT("Table ", p_in_table_no,  " is already booked. Booking is cancelled.");
	ELSE		
		INSERT INTO bookings(BookingID, CustomerID, TableNumber, BookingDate) 
		VALUES (p_booking_id, p_customer_id, p_table_no, p_date);
		SET status = CONCAT("Table ", p_table_no, " is booked successfully");
	END IF;
    SELECT status as "Booking Status";
END$$
DELIMITER ;

CALL ManageBooking(9, 3, 4, "2022-12-30");




DROP TABLE IF EXISTS `LittleLemonDB`.`OrdersView`;
USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW `OrdersView` AS
SELECT OrderID, Quantity, TotalCost 
FROM Orders;


PREPARE GetOrderDetail FROM
	'SELECT OrderID AS "Order ID", Quantity, TotalCost AS "Order Cost" FROM ordersview WHERE OrderID = ?';
	
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

