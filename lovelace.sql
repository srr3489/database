-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP DATABASE IF EXISTS  `equipment_inventory`;
CREATE DATABASE `equipment_inventory`;
USE `equipment_inventory`;

# Ensure the user account exists before dropping it - MySQL in 5.5 doesn't
# support IF EXISTS on a DROP USER
GRANT USAGE ON *.* TO 'equipment_admin'@'localhost' IDENTIFIED BY 'password';
DROP USER 'equipment_admin'@'localhost';

# TEMP PASSWORD - MIGRATE TO SECURE SOLUTION
CREATE USER 'equipment_admin'@'localhost' IDENTIFIED BY 'uO(W1R~W]r7,M7l7';

-- -----------------------------------------------------
-- Table `equipment_inventory`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`user` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_dce` VARCHAR(45) NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `major_id` INT NULL,
  `university_id` VARCHAR(20) NULL,
  PRIMARY KEY (`user_id`),
  INDEX `major_idx` (`major_id` ASC),
  CONSTRAINT `major`
   FOREIGN KEY (`major_id`)
    REFERENCES `equipment_inventory`.`major` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `equipment_inventory`.`major`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`major` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`major` (
  `id` INT NOT NULL,
  `major` VARCHAR(96) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `equipment_inventory`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`role` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `display_name` VARCHAR(45) NOT NULL,
  `status` CHAR(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`user_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`user_role` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`user_role` (
  `user_id` INT NOT NULL,
  `role_id` INT NOT NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  INDEX `role_id_idx` (`role_id` ASC),
  CONSTRAINT `user_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `equipment_inventory`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_roles_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `equipment_inventory`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`category` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `parent_id` INT NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`category_id`),
  INDEX `parent_id_idx` (`parent_id` ASC),
  CONSTRAINT `parent_id`
    FOREIGN KEY (`parent_id`)
    REFERENCES `equipment_inventory`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`item_archetype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`item_archetype` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`item_archetype` (
  `item_archetype_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NULL,
  `name` VARCHAR(45) NULL,
  `description` VARCHAR(100) NULL,
  `manufacturer` VARCHAR(45) NULL,
  `image_path` VARCHAR(45) NULL,
  PRIMARY KEY (`item_archetype_id`),
  INDEX `category_id_idx` (`category_id` ASC),
  CONSTRAINT `category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `equipment_inventory`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`item` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`item` (
  `item_id` INT NOT NULL AUTO_INCREMENT,
  `archetype_id` INT NULL,
  `barcode` VARCHAR(60) NULL,
  `rit_barcode` VARCHAR(60) NULL,
  `serial` VARCHAR(60) NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`item_id`),
  INDEX `archetype_id_idx` (`archetype_id` ASC),
  CONSTRAINT `archetype_id`
    FOREIGN KEY (`archetype_id`)
    REFERENCES `equipment_inventory`.`item_archetype` (`item_archetype_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`checkout_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`checkout_log` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`checkout_log` (
  `checkout_id` INT NOT NULL AUTO_INCREMENT,
  `item_id` INT NULL,
  `checked_out_to_id` INT NULL,
  `checked_out_by_id` INT NULL,
  `checked_in_by_id` INT NULL,
  `checked_out` DATETIME NULL,
  `returned` DATETIME NULL,
  PRIMARY KEY (`checkout_id`),
  INDEX `checked_out_to_id_idx` (`checked_out_to_id` ASC),
  UNIQUE INDEX `checkout_id_UNIQUE` (`checkout_id` ASC),
  INDEX `item_id_idx` (`item_id` ASC),
  INDEX `checked_out_by_id_idx` (`checked_out_by_id` ASC),
  INDEX `checked_in_by_id_idx` (`checked_in_by_id` ASC),
  CONSTRAINT `checked_out_to_id`
    FOREIGN KEY (`checked_out_to_id`)
    REFERENCES `equipment_inventory`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `item_id`
    FOREIGN KEY (`item_id`)
    REFERENCES `equipment_inventory`.`item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `checked_out_by_id`
    FOREIGN KEY (`checked_out_by_id`)
    REFERENCES `equipment_inventory`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `checked_in_by_id`
    FOREIGN KEY (`checked_in_by_id`)
    REFERENCES `equipment_inventory`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`item_attribute_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`item_attribute_type` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`item_attribute_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`item_attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`item_attribute` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`item_attribute` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `item_attribute_item_id` INT NULL,
  `item_attribute_type_id` INT NULL,
  `value` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `item_id_idx` (`item_attribute_item_id` ASC),
  INDEX `item_attribute_type_id_idx` (`item_attribute_type_id` ASC),
  CONSTRAINT `item_attribute_item_id`
    FOREIGN KEY (`item_attribute_item_id`)
    REFERENCES `equipment_inventory`.`item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `type_id`
    FOREIGN KEY (`item_attribute_type_id`)
    REFERENCES `equipment_inventory`.`item_attribute_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`item_archetype_attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`item_archetype_attribute` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`item_archetype_attribute` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `item_archetype_id` INT NULL,
  `item_attribute_type_id` INT NULL,
  `value` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `item_archetype_id_idx` (`item_archetype_id` ASC),
  INDEX `item_attribute_type_id_idx` (`item_attribute_type_id` ASC),
  CONSTRAINT `item_archetype_id`
    FOREIGN KEY (`item_archetype_id`)
    REFERENCES `equipment_inventory`.`item_archetype` (`item_archetype_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `item_attribute_type_id`
    FOREIGN KEY (`item_attribute_type_id`)
    REFERENCES `equipment_inventory`.`item_attribute_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`employee` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`employee` (
  `user_id` INT NOT NULL,
  `pin` VARCHAR(96) NULL,
  `password` VARCHAR(96) NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `sys_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `equipment_inventory`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`document_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`document_type` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`document_type` (
  `document_type_id` INT NOT NULL AUTO_INCREMENT,
  `document_name` VARCHAR(45) NULL,
  `template` BLOB NULL,
  PRIMARY KEY (`document_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `equipment_inventory`.`checkout_document`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipment_inventory`.`checkout_document` ;

CREATE TABLE IF NOT EXISTS `equipment_inventory`.`checkout_document` (
  `checkout_id` INT NOT NULL AUTO_INCREMENT,
  `document_type_id` INT NULL,
  `document` VARCHAR(45) NULL,
  PRIMARY KEY (`checkout_id`),
  INDEX `document_type_id_idx` (`document_type_id` ASC),
  CONSTRAINT `checkout_id`
    FOREIGN KEY (`checkout_id`)
    REFERENCES `equipment_inventory`.`checkout_log` (`checkout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `document_type_id`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `equipment_inventory`.`document_type` (`document_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

GRANT ALL ON equipment_inventory.* TO 'equipment_admin'@'localhost';


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`major`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (1, 'IT - Information Technology');
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (2, 'NSSA - Networking and Systems Administration');
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (3, 'WMC - Web & Mobile Computing');
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (4, 'HCC - Human Centered Computing');
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (5, 'CIT - Computing & Information Technologies');
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (6, 'Other');
INSERT INTO `equipment_inventory`.`major` (`id`, `major`) VALUES (7, 'Not a student');

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (1, 'BEG3288', 'Barclay', 'Garner', '54286-6638', 1);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (2, 'BWW6950', 'Bruno', 'Wooten', '83968-4833', 2);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (3, 'WMP8401', 'William', 'Prince', '58431-0614', 3);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (4, 'PNH6074', 'Phelan', 'Hopkins', '75321-6766', 4);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (5, 'SGB7736', 'Summer', 'Boone', '43421-8849', 5);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (6, 'TSM2885', 'Theodore', 'Mayo', '66445-3805', 1);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (7, 'ACO6530', 'Amber', 'Osborn', '78804-3278', 2);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (8, 'AFV6160', 'Avram', 'Vinson', '68312-0186', 6);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (9, 'LFJ1173', 'Lawrence', 'Joseph', '14052-4189', 7);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (10, 'LTF4558', 'Kristen', 'Frederick','215010-9722', 5);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (11, 'PRP2986', 'Patrick', 'Putnam','123456-1234', 3);
INSERT INTO `equipment_inventory`.`user` (`user_id`, `user_dce`, `first_name`, `last_name`, `university_id`, `major_id`) VALUES (12, 'BJM4477', 'Brendan', 'McDonald', '987654-9876', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`role`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`role` (`id`, `name`, `display_name`, `status`) VALUES (1, 'ROLE_STUDENT', 'Student', 'A');
INSERT INTO `equipment_inventory`.`role` (`id`, `name`, `display_name`, `status`) VALUES (2, 'ROLE_FACULTY', 'Faculty', 'A');
INSERT INTO `equipment_inventory`.`role` (`id`, `name`, `display_name`, `status`) VALUES (3, 'ROLE_LAB_ASSISTANT', 'Lab Assistant', 'A');
INSERT INTO `equipment_inventory`.`role` (`id`, `name`, `display_name`, `status`) VALUES (4, 'ROLE_ADMIN', 'Admin', 'A');

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`user_role`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (1, 1, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (2, 1, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (3, 2, 'A', '2016-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (4, 2, 'A', '2016-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (5, 3, 'A', '2017-02-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (6, 4, 'A', '2015-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (7, 1, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (8, 3, 'A', '2017-01-12 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (9, 1, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (10, 1, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (11, 3, 'I', '2017-01-06 08:00:00', '2017-01-24 08:00:00');
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (11, 4, 'A', '2017-01-24 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`user_role` (`user_id`, `role_id`, `status`, `status_start`, `status_stop`) VALUES (12, 3, 'A', '2017-01-06 08:00:00', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`category`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`category` (`category_id`, `name`, `parent_id`, `status`, `status_start`, `status_stop`) VALUES (1, 'phone', 1, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`category` (`category_id`, `name`, `parent_id`, `status`, `status_start`, `status_stop`) VALUES (2, 'adapter', NULL, 'A', '2017-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`category` (`category_id`, `name`, `parent_id`, `status`, `status_start`, `status_stop`) VALUES (3, 'tablet', 1, 'A', '2016-01-06 08:00:00', NULL);
INSERT INTO `equipment_inventory`.`category` (`category_id`, `name`, `parent_id`, `status`, `status_start`, `status_stop`) VALUES (4, 'other', NULL, 'A', '2016-01-06 08:00:00', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`item_archetype`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`item_archetype` (`item_archetype_id`, `category_id`, `name`, `description`, `manufacturer`, `image_path`) VALUES (1, 1, 'iphone', 'an apple iphone 6s', 'apple', NULL);
INSERT INTO `equipment_inventory`.`item_archetype` (`item_archetype_id`, `category_id`, `name`, `description`, `manufacturer`, `image_path`) VALUES (2, 1, 'android', 'galaxy note 7', 'samsung', NULL);
INSERT INTO `equipment_inventory`.`item_archetype` (`item_archetype_id`, `category_id`, `name`, `description`, `manufacturer`, `image_path`) VALUES (3, 3, 'ipad', 'ipad 2', 'apple', NULL);
INSERT INTO `equipment_inventory`.`item_archetype` (`item_archetype_id`, `category_id`, `name`, `description`, `manufacturer`, `image_path`) VALUES (4, 2, 'MAC adapter', 'adapter for macbooks to go from hdmi to dvi', 'apple', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`item`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (2, 1, '12345-6789', NULL, 'A', '2017-03-19 02:34:34', NULL);
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (5, 3, '23422-3454', NULL, 'A', '2017-03-16 04:12:12', NULL);
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (57, 3, '23231-3453', NULL, 'A', '2017-03-19 01:21:34', '2017-03-21 04:00:00 ');
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (73, 4, '54642-2345', NULL, 'A', '2017-03-10 12:04:04 ', NULL);
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (1, 2, '67575-3454', NULL, 'I', '2017-03-08 02:34:34', '2017-03-21 05:00:00');
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (98, 2, '43534-2223', NULL, 'A', '2017-03-10 10:03:11', NULL);
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (22, 3, '23222-1111', NULL, 'A', '2017-03-06 09:02:03', NULL);
INSERT INTO `equipment_inventory`.`item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES (44, 3, '23423-2343', NULL, 'A', '2017-03-07 02:11:24', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`checkout_log`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`checkout_log` (`checkout_id`, `item_id`, `checked_out_to_id`, `checked_out_by_id`, `checked_in_by_id`, `checked_out`, `returned`) VALUES (1, 5, 1, 5, 5, '2017-03-16 12:34:23', '2017-03-16 2:12:23');
INSERT INTO `equipment_inventory`.`checkout_log` (`checkout_id`, `item_id`, `checked_out_to_id`, `checked_out_by_id`, `checked_in_by_id`, `checked_out`, `returned`) VALUES (2, 98, 2, 5, 8, '2017-03-18 10:34:23', '2017-03-18 12:52:23');
INSERT INTO `equipment_inventory`.`checkout_log` (`checkout_id`, `item_id`, `checked_out_to_id`, `checked_out_by_id`, `checked_in_by_id`, `checked_out`, `returned`) VALUES (3, 5, 7, 8, NULL, '2017-03-19 01:34:23', NULL);
INSERT INTO `equipment_inventory`.`checkout_log` (`checkout_id`, `item_id`, `checked_out_to_id`, `checked_out_by_id`, `checked_in_by_id`, `checked_out`, `returned`) VALUES (4, 73, 2, 8, 5, '2017-03-19 02:34:23', '2017-03-19 3:11:54');
INSERT INTO `equipment_inventory`.`checkout_log` (`checkout_id`, `item_id`, `checked_out_to_id`, `checked_out_by_id`, `checked_in_by_id`, `checked_out`, `returned`) VALUES (5, 73, 7, 8, NULL, '2017-03-21 03:12:11', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`item_attribute_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`item_attribute_type` (`id`, `type`) VALUES (1, 'Long term');
INSERT INTO `equipment_inventory`.`item_attribute_type` (`id`, `type`) VALUES (2, 'type2');
INSERT INTO `equipment_inventory`.`item_attribute_type` (`id`, `type`) VALUES (3, 'type3');

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`item_attribute`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`item_attribute` (`id`, `item_attribute_item_id`, `item_attribute_type_id`, `value`) VALUES (1, 5, 1, NULL);
INSERT INTO `equipment_inventory`.`item_attribute` (`id`, `item_attribute_item_id`, `item_attribute_type_id`, `value`) VALUES (2, 73, 2, 'value1');
INSERT INTO `equipment_inventory`.`item_attribute` (`id`, `item_attribute_item_id`, `item_attribute_type_id`, `value`) VALUES (3, 73, 3, 'value1');

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`item_archetype_attribute`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`item_archetype_attribute` (`id`, `item_archetype_id`, `item_attribute_type_id`, `value`) VALUES (1, 1, 1, NULL);
INSERT INTO `equipment_inventory`.`item_archetype_attribute` (`id`, `item_archetype_id`, `item_attribute_type_id`, `value`) VALUES (2, 1, 2, 'An attribute');
INSERT INTO `equipment_inventory`.`item_archetype_attribute` (`id`, `item_archetype_id`, `item_attribute_type_id`, `value`) VALUES (3, 3, 3, 'A different attribute');
INSERT INTO `equipment_inventory`.`item_archetype_attribute` (`id`, `item_archetype_id`, `item_attribute_type_id`, `value`) VALUES (4, 5, 2, 'Some other attribute');

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`employee`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (1, '7825');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (2, '7986');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (3, '4771');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (4, '3024');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (5, '1931');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (6, '7483');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (7, '4502');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (8, '4230');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (9, '3290');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`) VALUES (10,'5904');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`, `password`) VALUES (11, '$argon2i$v=19$m=65536,t=4,p=1$VIyGutAWGNmYMtciGslXOQ$mP27AwBn5MFdp0EmrjLFB/MCHOeTa1fcDC+qlpPJ4Xk', '$argon2i$v=19$m=65536,t=4,p=1$VIyGutAWGNmYMtciGslXOQ$mP27AwBn5MFdp0EmrjLFB/MCHOeTa1fcDC+qlpPJ4Xk');
INSERT INTO `equipment_inventory`.`employee` (`user_id`, `pin`, `password`) VALUES (12, '$argon2i$v=19$m=65536,t=4,p=1$Qakz+ooMLmoUAiUNpX4LBA$p3AGs9mONRkRxncaGs+QPGlnhQ8aAh464tD/LYQn/S0', '$argon2i$v=19$m=65536,t=4,p=1$Qakz+ooMLmoUAiUNpX4LBA$p3AGs9mONRkRxncaGs+QPGlnhQ8aAh464tD/LYQn/S0');

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`document_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`document_type` (`document_type_id`, `document_name`, `template`) VALUES (3, 'doc', NULL);
INSERT INTO `equipment_inventory`.`document_type` (`document_type_id`, `document_name`, `template`) VALUES (2, 'doc', NULL);
INSERT INTO `equipment_inventory`.`document_type` (`document_type_id`, `document_name`, `template`) VALUES (1, 'doc', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `equipment_inventory`.`checkout_document`
-- -----------------------------------------------------
START TRANSACTION;
USE `equipment_inventory`;
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (1, 2, 'doc2');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (2, 2, 'doc2');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (3, 3, 'doc2');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (4, 1, 'doc1');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (5, 2, 'doc2');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (6, 3, 'doc3');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (7, 1, 'doc1');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (8, 1, 'doc1');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (9, 2, 'doc2');
INSERT INTO `equipment_inventory`.`checkout_document` (`checkout_id`, `document_type_id`, `document`) VALUES (10, 2, 'doc2');

COMMIT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

CREATE VIEW item_details AS
SELECT
        i.item_id,
        i.archetype_id,
        i.barcode,
        i.rit_barcode,
        i.status,
        iar.name,
        iar.manufacturer,
        iar.description,
        c.name category,
        coalesce(iat.type, iata.type) attribute_type,
        coalesce(iatr.value, iaa.value) attribute_value,
        EXISTS(
            select
                  'x'
            from
                  checkout_log cl
            where
                  i.item_id = cl.item_id
                  and cl.returned is null
        ) is_checked_out
FROM
        item i
JOIN
        item_archetype iar
        ON i.archetype_id = iar.item_archetype_id
JOIN
        category c
        ON iar.category_id = c.category_id
LEFT JOIN
        item_attribute iatr
        ON i.item_id = iatr.item_attribute_item_id
LEFT JOIN
        item_archetype_attribute iaa
        ON iar.item_archetype_id = iaa.item_archetype_id
LEFT JOIN
        item_attribute_type iat
        ON iatr.item_attribute_type_id = iat.id
LEFT JOIN
        item_attribute_type iata
        ON iaa.item_attribute_type_id = iata.id;
