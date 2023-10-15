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