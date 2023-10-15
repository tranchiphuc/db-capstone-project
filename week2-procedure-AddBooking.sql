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
