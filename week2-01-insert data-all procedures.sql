INSERT INTO customers(CustomerID, Name, Contact, Email) 
VALUES
	(1, "Sterne Salterne", 12345670001, "sterne_salterne@gmail.com"),
	(2, "Mady McMennum", 12345670002, "mady_mcmennum@gmail.com"),
	(3, "Merwin Pikhno", 12345670003, "merwin_pikhno@gmail.com"),
	(4, "Aime Ferry", 12345670004, "aime_ferry@gmail.com"),
	(5, "Merlina Lermit", 12345670005, "merlina_lermit@gmail.com"),
	(6, "Schuyler Walewski", 12345670006, "schuyler_walewski@gmail.com"),
	(7, "Ariadne Copeland", 12345670007, "ariadne_copeland@gmail.com"),
	(8, "Tamma Clink", 12345670008, "tamma_clink@gmail.com"),
	(9, "Susette O'Neil", 12345670009, "susette_o'neil@gmail.com"),
	(10, "Aldrich Phythien", 12345670010, "aldrich_phythien@gmail.com");
COMMIT;



INSERT INTO menuitems (MenuItemID, Course, Starter, Dessert, Drink)
VALUES
	(1, "Greek salad", "Falafel", "Greek yoghurt", "Athens White wine"),
	(2, "Greek salad", "Olives", "Greek yoghurt", "Athens White wine"),
	(3, "Kabasa", "Falafel", "Turkish yoghurt", "Ankara White Wine"),
	(4, "Kabasa", "Flatbread", "Turkish yoghurt", "Ankara White Wine"),
	(5, "Kabasa", "Minestrone", "Turkish yoghurt", "Ankara White Wine"),
	(6, "Kabasa", "Tomato bread", "Turkish yoghurt", "Ankara White Wine"),
	(7, "Pizza", "Flatbread", "Cheesecake", "Italian Coffee"),
	(8, "Pizza", "Hummus", "Cheesecake", "Italian Coffee"),
	(9, "Bean soup", "Flatbread", "Ice cream", "Corfu Red Wine"),
	(10, "Bean soup", "Olives", "Ice cream", "Corfu Red Wine");
COMMIT;


INSERT INTO menus (MenuID, MenuItemID, MenuName, Cuisine)
VALUES
	(1, "1", "Greek salad", "Greek"),
	(2, "2", "Greek Kabasa", "Greek"),
	(3, "3", "Italian Bean soup", "Italian"),
	(4, "4", "Italian Carbonara", "Italian"),
	(5, "5", "Italian Kabasa", "Italian"),
	(6, "6", "Italian Pizza", "Italian"),
	(7, "7", "Italian Shwarma", "Italian"),
	(8, "8", "Turkish Bean soup", "Turkish"),
	(9, "9", "Turkish Carbonara", "Turkish"),
	(10, "10", "Turkish Shwarma", "Turkish");
COMMIT;




INSERT INTO Bookings (BookingID, BookingDate, TableNumber, CustomerID)
VALUES 	(1, "2022-10-10", 5, 1),
	(2, "2022-11-12", 3, 3),
	(3, "2022-10-11", 2, 2),
	(4, "2022-10-13", 2, 1);
COMMIT;


INSERT INTO orders (OrderID, MenuID, BookingID, TotalCost, Quantity)
VALUES
	(1, 1, 1, 20, 1),
	(2, 2, 1, 21, 1),
	(3, 3, 1, 44, 2),
	(4, 4, 2, 46, 2),
	(5, 5, 2, 72, 3),
	(6, 6, 2, 75, 3),
	(7, 7, 3, 104, 4),
	(8, 8, 3, 108, 4),
	(9, 9, 3, 140, 5),
	(10, 10, 4, 145, 5),
	(11, 1, 4, 40, 2),
	(12, 2, 4, 42, 2);
COMMIT;



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

