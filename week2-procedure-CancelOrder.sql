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


