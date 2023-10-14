-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `CustomerID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Contact` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `CustomerID` INT NOT NULL,
  `TableNo` INT NULL,
  `Date` DATE NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_customer_id_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_customer_id`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuItems` (
  `MenuItemsID` INT NOT NULL,
  `Course` VARCHAR(45) NULL,
  `Starter` VARCHAR(45) NULL,
  `Dessert` VARCHAR(45) NULL,
  `Drink` VARCHAR(45) NULL,
  PRIMARY KEY (`MenuItemsID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menus` (
  `MenuID` INT NOT NULL AUTO_INCREMENT,
  `MenuItemsID` INT NOT NULL,
  `MenuName` VARCHAR(45) NULL,
  `Cuisine` VARCHAR(45) NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `fk_menuitems_id_idx` (`MenuItemsID` ASC) VISIBLE,
  CONSTRAINT `fk_menuitems_id`
    FOREIGN KEY (`MenuItemsID`)
    REFERENCES `LittleLemonDB`.`MenuItems` (`MenuItemsID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `MenuID` INT NULL,
  `BookingID` INT NULL,
  `TotalCost` DECIMAL(10,2) NULL,
  `Quantity` INT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_booking_id_idx` (`BookingID` ASC) VISIBLE,
  INDEX `fk_menu_id_idx` (`MenuID` ASC) VISIBLE,
  CONSTRAINT `fk_booking_id`
    FOREIGN KEY (`BookingID`)
    REFERENCES `LittleLemonDB`.`Bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_menu_id`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonDB`.`Menus` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Role` VARCHAR(45) NOT NULL,
  `AnnualSalary` DECIMAL NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OrderDeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrderDeliveryStatus` (
  `OrderID` INT NOT NULL,
  `DeliveryDate` DATE NULL,
  `Status` VARCHAR(45) NULL,
  PRIMARY KEY (`OrderID`),
  CONSTRAINT `fk_order_id`
    FOREIGN KEY (`OrderID`)
    REFERENCES `LittleLemonDB`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Placeholder table for view `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OrdersView` (`OrderID` INT, `Quantity` INT, `TotalCost` INT);

-- -----------------------------------------------------
-- View `LittleLemonDB`.`OrdersView`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`OrdersView`;
USE `LittleLemonDB`;
CREATE  OR REPLACE VIEW `OrdersView` AS
SELECT OrderID, Quantity, TotalCost 
FROM Orders;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
