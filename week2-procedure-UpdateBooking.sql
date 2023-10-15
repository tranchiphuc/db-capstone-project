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

