-- MySQL Script generated by MySQL Workbench
-- 08/26/17 15:48:12
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema bus_system
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bus_system
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bus_system` DEFAULT CHARACTER SET utf8 ;
USE `bus_system` ;

-- -----------------------------------------------------
-- Table `bus_system`.`card_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`card_types` (
  `id` INT(2) NOT NULL,
  `type_name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`stations_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`stations_types` (
  `id` INT(1) NOT NULL,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`route_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`route_types` (
  `id` INT(1) NOT NULL,
  `name` VARCHAR(255) NULL,
  `payment_amount` INT(7) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`routes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`routes` (
  `int` INT(7) NOT NULL,
  `name` VARCHAR(45) NULL,
  `type_id` INT(1) NULL,
  PRIMARY KEY (`int`),
  INDEX `fk_routes_route_types1_idx` (`type_id` ASC),
  CONSTRAINT `fk_routes_route_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES `bus_system`.`route_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`stations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`stations` (
  `id` INT(7) NOT NULL,
  `name` VARCHAR(255) NULL,
  `type_id` INT(1) NULL,
  `latlng` VARCHAR(50) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_stations_stations_types1_idx` (`type_id` ASC),
  CONSTRAINT `fk_stations_stations_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES `bus_system`.`stations_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`route_stations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`route_stations` (
  `id` INT(11) NOT NULL,
  `route_id` INT(7) NULL,
  `station_by_order` INT(3) NULL,
  `station_id` INT(7) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_route_stations_routes1_idx` (`route_id` ASC),
  INDEX `fk_route_stations_stations1_idx` (`station_id` ASC),
  CONSTRAINT `fk_route_stations_routes1`
    FOREIGN KEY (`route_id`)
    REFERENCES `bus_system`.`routes` (`int`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_route_stations_stations1`
    FOREIGN KEY (`station_id`)
    REFERENCES `bus_system`.`stations` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`payment_stations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`payment_stations` (
  `id` INT(7) NOT NULL,
  `name` VARCHAR(255) NULL,
  `employee_name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`incoming_payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`incoming_payments` (
  `id` BINARY(16) NOT NULL,
  `time` TIMESTAMP NULL,
  `card_id` INT(10) NULL,
  `card_type` INT(1) NULL,
  `payment_station_id` INT(7) NULL,
  `payment_amount` INT(7) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_incoming_payments_payment_stations_idx` (`payment_station_id` ASC),
  INDEX `fk_incoming_payments_card_types1_idx` (`card_type` ASC),
  CONSTRAINT `fk_incoming_payments_payment_stations`
    FOREIGN KEY (`payment_station_id`)
    REFERENCES `bus_system`.`payment_stations` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_incoming_payments_card_types1`
    FOREIGN KEY (`card_type`)
    REFERENCES `bus_system`.`card_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`drivers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`drivers` (
  `id` INT(7) NOT NULL,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`transport_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`transport_types` (
  `id` INT(1) NOT NULL,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`transports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`transports` (
  `id` INT(7) NOT NULL,
  `transport_gov_num` VARCHAR(10) NULL,
  `type_id` INT(1) NULL,
  `driver_id` INT(7) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_transports_drivers1_idx` (`driver_id` ASC),
  INDEX `fk_transports_transport_types1_idx` (`type_id` ASC),
  CONSTRAINT `fk_transports_drivers1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `bus_system`.`drivers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transports_transport_types1`
    FOREIGN KEY (`type_id`)
    REFERENCES `bus_system`.`transport_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`transport_routes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`transport_routes` (
  `id` INT(11) NOT NULL,
  `routes_id` INT(7) NULL,
  `transport_id` INT(7) NULL,
  `time` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_transport_routes_transports1_idx` (`transport_id` ASC),
  INDEX `fk_transport_routes_routes1_idx` (`routes_id` ASC),
  CONSTRAINT `fk_transport_routes_transports1`
    FOREIGN KEY (`transport_id`)
    REFERENCES `bus_system`.`transports` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transport_routes_routes1`
    FOREIGN KEY (`routes_id`)
    REFERENCES `bus_system`.`routes` (`int`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`transactions` (
  `id` INT(11) NOT NULL,
  `transaction_id` BINARY(16) NULL,
  `time` TIMESTAMP NULL,
  `transport_id` INT(7) NULL,
  `route_id` INT(7) NULL,
  `station_id` INT(7) NULL,
  `card_id` INT(10) NULL,
  `card_type_id` INT(2) NULL,
  `payment_amount` INT(7) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_transactions_card_types1_idx` (`card_type_id` ASC),
  INDEX `fk_transactions_stations1_idx` (`station_id` ASC),
  INDEX `fk_transactions_routes1_idx` (`route_id` ASC),
  INDEX `fk_transactions_transports1_idx` (`transport_id` ASC),
  CONSTRAINT `fk_transactions_card_types1`
    FOREIGN KEY (`card_type_id`)
    REFERENCES `bus_system`.`card_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transactions_stations1`
    FOREIGN KEY (`station_id`)
    REFERENCES `bus_system`.`stations` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transactions_routes1`
    FOREIGN KEY (`route_id`)
    REFERENCES `bus_system`.`routes` (`int`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transactions_transports1`
    FOREIGN KEY (`transport_id`)
    REFERENCES `bus_system`.`transports` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bus_system`.`misc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bus_system`.`misc` (
  `current_station_id` INT(7) NULL,
  `last_sync_id` INT(11) NULL,
  INDEX `fk_misc_stations1_idx` (`current_station_id` ASC),
  CONSTRAINT `fk_misc_stations1`
    FOREIGN KEY (`current_station_id`)
    REFERENCES `bus_system`.`stations` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;