-- -----------------------------------------------------
-- View `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`OrdersView`;
USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW `OrdersView` AS
SELECT OrderID, Quantity, TotalCost 
FROM Orders;
