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

