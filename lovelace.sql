-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema lovelace_db_schema
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema lovelace_db_schema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lovelace_db_schema` DEFAULT CHARACTER SET utf8 ;
USE `lovelace_db_schema` ;

-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`user` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`user` (
  `user_id` INT NOT NULL,
  `user_dce` VARCHAR(45) NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`role` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`role` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `status` CHAR(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`user_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`user_roles` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`user_roles` (
  `user_id` INT NOT NULL,
  `role_id` INT NOT NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC),
  INDEX `role_id_idx` (`role_id` ASC),
  CONSTRAINT `role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `lovelace_db_schema`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `lovelace_db_schema`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`permission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`permission` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`permission` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `status` CHAR(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`user_permission_override`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`user_permission_override` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`user_permission_override` (
  `user_id` INT NULL,
  `permission_id` INT NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`user_id`, `permission_id`),
  INDEX `permission_id_idx` (`permission_id` ASC),
  CONSTRAINT `user_id`
    FOREIGN KEY ()
    REFERENCES `lovelace_db_schema`.`user` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `permission_id`
    FOREIGN KEY (`permission_id`)
    REFERENCES `lovelace_db_schema`.`permission` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`role_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`role_permissions` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`role_permissions` (
  `permission_id` INT NOT NULL,
  `role_id` INT NOT NULL,
  UNIQUE INDEX `permission_id_UNIQUE` (`permission_id` ASC),
  PRIMARY KEY (`permission_id`, `role_id`),
  UNIQUE INDEX `role_id_UNIQUE` (`role_id` ASC),
  CONSTRAINT `permission_id`
    FOREIGN KEY (`permission_id`)
    REFERENCES `lovelace_db_schema`.`permission` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `lovelace_db_schema`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`category` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`category` (
  `category_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `parent_id` INT NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`category_id`),
  INDEX `parent_id_idx` (`parent_id` ASC),
  CONSTRAINT `parent_id`
    FOREIGN KEY (`parent_id`)
    REFERENCES `lovelace_db_schema`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`item_archetype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`item_archetype` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`item_archetype` (
  `item_archetype_id` INT NOT NULL,
  `category_id` INT NULL,
  `name` VARCHAR(45) NULL,
  `description` VARCHAR(100) NULL,
  `manufacturer` VARCHAR(45) NULL,
  PRIMARY KEY (`item_archetype_id`),
  INDEX `category_id_idx` (`category_id` ASC),
  CONSTRAINT `category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `lovelace_db_schema`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`item` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`item` (
  `item_id` INT NOT NULL,
  `archetype_id` INT NULL,
  `barcode` INT NULL,
  `rit_barcode` INT NULL,
  `status` CHAR(1) NULL,
  `status_start` DATETIME NULL,
  `status_stop` DATETIME NULL,
  PRIMARY KEY (`item_id`),
  INDEX `archetype_id_idx` (`archetype_id` ASC),
  CONSTRAINT `archetype_id`
    FOREIGN KEY (`archetype_id`)
    REFERENCES `lovelace_db_schema`.`item_archetype` (`item_archetype_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`checkout_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`checkout_log` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`checkout_log` (
  `checkout_id` INT NOT NULL,
  `item_id` INT NULL,
  `checked_out_to_id` INT NULL,
  `checked_out_by_id` INT NULL,
  `checked_in_by_id` INT NULL,
  `checked_out` DATETIME NULL,
  `due_back` DATETIME NULL,
  `returned` DATETIME NULL,
  PRIMARY KEY (`checkout_id`),
  INDEX `checked_out_to_id_idx` (`checked_out_to_id` ASC),
  UNIQUE INDEX `checkout_id_UNIQUE` (`checkout_id` ASC),
  INDEX `item_id_idx` (`item_id` ASC),
  INDEX `checked_out_by_id_idx` (`checked_out_by_id` ASC),
  INDEX `checked_in_by_id_idx` (`checked_in_by_id` ASC),
  CONSTRAINT `checked_out_to_id`
    FOREIGN KEY (`checked_out_to_id`)
    REFERENCES `lovelace_db_schema`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `item_id`
    FOREIGN KEY (`item_id`)
    REFERENCES `lovelace_db_schema`.`item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `checked_out_by_id`
    FOREIGN KEY (`checked_out_by_id`)
    REFERENCES `lovelace_db_schema`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `checked_in_by_id`
    FOREIGN KEY (`checked_in_by_id`)
    REFERENCES `lovelace_db_schema`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`item_attribute_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`item_attribute_type` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`item_attribute_type` (
  `item_attribute_type_id` INT NOT NULL,
  `type` VARCHAR(45) NULL,
  PRIMARY KEY (`item_attribute_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`item_attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`item_attribute` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`item_attribute` (
  `id` INT NOT NULL,
  `item_id` INT NULL,
  `item_attribute_type_id` INT NULL,
  `value` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `item_id_idx` (`item_id` ASC),
  INDEX `item_attribute_type_id_idx` (`item_attribute_type_id` ASC),
  CONSTRAINT `item_id`
    FOREIGN KEY (`item_id`)
    REFERENCES `lovelace_db_schema`.`item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `item_attribute_type_id`
    FOREIGN KEY (`item_attribute_type_id`)
    REFERENCES `lovelace_db_schema`.`item_attribute_type` (`item_attribute_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`item_archetype_attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`item_archetype_attribute` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`item_archetype_attribute` (
  `id` INT NOT NULL,
  `item_archetype_id` INT NULL,
  `item_attribute_type_id` INT NULL,
  `value` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `item_archetype_id_idx` (`item_archetype_id` ASC),
  INDEX `item_attribute_type_id_idx` (`item_attribute_type_id` ASC),
  CONSTRAINT `item_archetype_id`
    FOREIGN KEY (`item_archetype_id`)
    REFERENCES `lovelace_db_schema`.`item_archetype` (`item_archetype_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `item_attribute_type_id`
    FOREIGN KEY (`item_attribute_type_id`)
    REFERENCES `lovelace_db_schema`.`item_attribute_type` (`item_attribute_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`sys_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`sys_user` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`sys_user` (
  `user_id` INT NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC),
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `lovelace_db_schema`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`document_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`document_type` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`document_type` (
  `document_type_id` INT NOT NULL,
  `document_name` VARCHAR(45) NULL,
  `template` BLOB NULL,
  PRIMARY KEY (`document_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lovelace_db_schema`.`checkout_document`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lovelace_db_schema`.`checkout_document` ;

CREATE TABLE IF NOT EXISTS `lovelace_db_schema`.`checkout_document` (
  `checkout_id` INT NOT NULL,
  `document_type_id` INT NULL,
  `document` VARCHAR(45) NULL,
  PRIMARY KEY (`checkout_id`),
  INDEX `document_type_id_idx` (`document_type_id` ASC),
  CONSTRAINT `checkout_id`
    FOREIGN KEY (`checkout_id`)
    REFERENCES `lovelace_db_schema`.`checkout_log` (`checkout_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `document_type_id`
    FOREIGN KEY (`document_type_id`)
    REFERENCES `lovelace_db_schema`.`document_type` (`document_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
