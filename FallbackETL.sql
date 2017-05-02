-- --------------------------------------------------------
-- ORIGINAL DRADIS DB INFORMATION
-- Host:                         127.0.0.1
-- Server version:               5.6.14 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             8.2.0.4675
-- --------------------------------------------------------
-- --------------------------------------------------------
-- TEAM LOVELACE - Equipment Inventory Project
-- CREATED 5/2/17
-- This script is used to transfer data from the 
-- equipment_inventory DB to the DRADIS DB by using an
-- intermediate migration_db
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for migration_db
DROP DATABASE IF EXISTS `migration_db`;
CREATE DATABASE IF NOT EXISTS `migration_db` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `migration_db`;


-- Dumping structure for table migration_db.bugreports
DROP TABLE IF EXISTS `bugreports`;
CREATE TABLE IF NOT EXISTS `bugreports` (
  `id` int(5) NOT NULL AUTO_INCREMENT COMMENT 'ID OF BUG REPORT',
  `date` varchar(15) NOT NULL COMMENT 'DATE OF ENTRY',
  `time` varchar(15) NOT NULL COMMENT 'TIME OF ENTRY',
  `reporter` varchar(50) NOT NULL COMMENT 'NAME OF WHO REPORTED BUG',
  `description` varchar(750) NOT NULL COMMENT 'DESCRIPTION OF BUG',
  `markedRead` int(1) NOT NULL DEFAULT '0' COMMENT 'BUG WAS READ BY ADMIN',
  `resolved` int(1) NOT NULL DEFAULT '0' COMMENT 'BUG WAS RESOLVED BY ADMIN',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.changelog
DROP TABLE IF EXISTS `changelog`;
CREATE TABLE IF NOT EXISTS `changelog` (
  `version` varchar(15) NOT NULL COMMENT 'VERSION NUMBER OF ENTRY',
  `date` varchar(15) NOT NULL COMMENT 'DATE OF ENTRY',
  `time` varchar(10) NOT NULL COMMENT 'TIME OF ENTRY',
  `type` varchar(30) NOT NULL COMMENT 'TYPE OF CHANGE',
  `description` varchar(750) NOT NULL COMMENT 'DESCRIPTION OF CHANGE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.checkedout
DROP TABLE IF EXISTS `checkedout`;
CREATE TABLE IF NOT EXISTS `checkedout` (
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `outTime` varchar(20) NOT NULL COMMENT 'TIME OF CHECKOUT',
  `outDate` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `itemBarcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `dueDate` date NOT NULL COMMENT 'DATE FOR ITEM RETURN',
  PRIMARY KEY (`itemBarcode`),
  KEY `studentID` (`studentID`),
  CONSTRAINT `checkedOut_ibfk_1` FOREIGN KEY (`studentID`) REFERENCES `student` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_perCheckedOut` FOREIGN KEY (`itemBarcode`) REFERENCES `items` (`barcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.checkedoutcopy
DROP TABLE IF EXISTS `checkedoutcopy`;
CREATE TABLE IF NOT EXISTS `checkedoutcopy` (
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `outTime` varchar(20) NOT NULL COMMENT 'TIME OF CHECKOUT',
  `outDate` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `itemBarcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `dueDate` date NOT NULL COMMENT 'DATE FOR ITEM RETURN',
  PRIMARY KEY (`itemBarcode`),
  KEY `studentID` (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.checkouthistory
DROP TABLE IF EXISTS `checkouthistory`;
CREATE TABLE IF NOT EXISTS `checkouthistory` (
  `date` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `time` varchar(20) NOT NULL COMMENT 'TIME OF CHECKOUT',
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `firstName` varchar(45),
  `lastName` varchar(45),
  `transactionType` varchar(20) NOT NULL COMMENT 'TYPE OF TRANSACTION',
  `itemBarcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.departmentinventory
DROP TABLE IF EXISTS `departmentinventory`;
CREATE TABLE IF NOT EXISTS `departmentinventory` (
  `department` varchar(10) NOT NULL,
  `building` varchar(10) NOT NULL,
  `room` varchar(10) NOT NULL,
  `asset` varchar(20) NOT NULL,
  `retired` varchar(20) NOT NULL,
  `description` varchar(400) NOT NULL,
  `manufacturer` varchar(50) NOT NULL,
  `model` varchar(400) NOT NULL,
  `serial` varchar(60) NOT NULL,
  `tag` varchar(20) NOT NULL,
  `PO` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `cost` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.info
DROP TABLE IF EXISTS `info`;
CREATE TABLE IF NOT EXISTS `info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID OF INFO ITEM',
  `description` varchar(20) NOT NULL DEFAULT '' COMMENT 'DESCRIPTION OF INFO ITEM',
  `value` varchar(20) NOT NULL DEFAULT '' COMMENT 'VALUE OF INFO ITEM',
  PRIMARY KEY (`id`),
  KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `info` DISABLE KEYS */;
INSERT INTO `info` (`id`, `description`, `value`) VALUES
	(1, 'Version', 'v1.0.0');
/*!40000 ALTER TABLE `info` ENABLE KEYS */;

-- Dumping structure for table migration_db.items
DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `barcode` varchar(20) NOT NULL DEFAULT '' COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) NOT NULL DEFAULT '' COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL COMMENT 'LOCATION OF ITEM',
  `secondFormID` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES SECOND FORM OF ID TO CHECKOUT',
  `form` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES FORM TO CHECKOUT ITEM',
  `department` varchar(4) NOT NULL DEFAULT 'ISTE' COMMENT 'DEPARTMENT THAT OWNS ITEM',
  `acquireDate` date DEFAULT NULL COMMENT 'DATE ACQUIRED ',
  `hasWarranty` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'HAS WARRANTY',
  `warrantyExpireDate` date DEFAULT NULL COMMENT 'WARRANTY VALID UNTIL',
  PRIMARY KEY (`barcode`,`serial`),
  KEY `barcode` (`barcode`),
  KEY `serial` (`serial`),
  KEY `description` (`description`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Dumping structure for table migration_db.items2
DROP TABLE IF EXISTS `items2`;
CREATE TABLE IF NOT EXISTS `items2` (
  `barcode` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) CHARACTER SET utf8 NOT NULL COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) CHARACTER SET utf8 NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT 'Other' COMMENT 'TYPE OF ITEM',
  `location` varchar(100) CHARACTER SET utf8 NOT NULL COMMENT 'LOCATION OF ITEM',
  `secondFormID` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES SECOND FORM OF ID TO CHECKOUT',
  `form` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES FORM TO CHECKOUT ITEM',
  `department` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT 'ISTE' COMMENT 'DEPARTMENT THAT OWNS ITEM'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping structure for table migration_db.itemscopy
DROP TABLE IF EXISTS `itemscopy`;
CREATE TABLE IF NOT EXISTS `itemscopy` (
  `barcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) NOT NULL COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) NOT NULL DEFAULT 'Other' COMMENT 'TYPE OF ITEM',
  `location` varchar(100) NOT NULL COMMENT 'LOCATION OF ITEM',
  `secondFormID` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES SECOND FORM OF ID TO CHECKOUT',
  `form` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES FORM TO CHECKOUT ITEM',
  `department` varchar(4) NOT NULL DEFAULT 'ISTE' COMMENT 'DEPARTMENT THAT OWNS ITEM',
  PRIMARY KEY (`barcode`),
  KEY `barcode` (`barcode`),
  KEY `serial` (`serial`),
  KEY `description` (`description`(255)),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Dumping structure for table migration_db.maven
DROP TABLE IF EXISTS `maven`;
CREATE TABLE IF NOT EXISTS `maven` (
  `barcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) NOT NULL COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) NOT NULL COMMENT 'TYPE OF ITEM',
  `dateMavened` date NOT NULL COMMENT 'DATE ITEM WAS MAVENED'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.modelinfo
DROP TABLE IF EXISTS `modelinfo`;
CREATE TABLE IF NOT EXISTS `modelinfo` (
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `subtitle` varchar(50) NOT NULL COMMENT 'ADDITIONAL INFO FOR ITEM DESCRIPTION',
  `manufacturer` varchar(50) NOT NULL COMMENT 'MANUFACTURER OF ITEM',
  `model` varchar(50) NOT NULL COMMENT 'MODEL OF ITEM',
  `prefix` varchar(50) NOT NULL COMMENT 'PREFIX FOR BARCODE (DOES NOT APPLY TO RIT TAGS)',
  `feature1` varchar(50) NOT NULL COMMENT 'SPECIAL FEATURE 1',
  `feature2` varchar(50) NOT NULL COMMENT 'SPECIAL FEATURE 2',
  `feature3` varchar(50) NOT NULL COMMENT 'SPECIAL FEATURE 3',
  `image` varchar(100) NOT NULL COMMENT 'LOCATION OF IMAGE TO DESCRIBE ITEM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.printlabels
DROP TABLE IF EXISTS `printlabels`;
CREATE TABLE IF NOT EXISTS `printlabels` (
  `labelNumber` tinyint(2) NOT NULL AUTO_INCREMENT COMMENT 'NUMBER OF SPECIFIC LABEL',
  `barcode` varchar(20) NOT NULL COMMENT 'BARCODE OF ITEM',
  PRIMARY KEY (`labelNumber`),
  KEY `barcode` (`barcode`),
  CONSTRAINT `printLabels_ibfk_1` FOREIGN KEY (`barcode`) REFERENCES `items` (`barcode`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.signatureform
DROP TABLE IF EXISTS `signatureform`;
CREATE TABLE IF NOT EXISTS `signatureform` (
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `outDate` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `dueDate` date NOT NULL COMMENT 'DATE FOR ITEM(S) RETURN',
  `signatureFile` varchar(100) NOT NULL COMMENT 'LOCATION OF STUDENT''S SIGNATURE',
  `formFile` varchar(100) NOT NULL COMMENT 'LOCATION OF STUDENT''S SIGNED FORM',
  KEY `studentID` (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.student
DROP TABLE IF EXISTS `student`;
CREATE TABLE IF NOT EXISTS `student` (
  `dateAdded` date NOT NULL COMMENT 'DATE STUDENT WAS ADDED',
  `ID` varchar(9) NOT NULL COMMENT 'UID OF STUDENT',
  `firstName` varchar(45),
  `lastName` varchar(45),
  `email` varchar(16),
  `major` varchar(20) NOT NULL COMMENT 'MAJOR OF STUDENT',
  `type` varchar(20) NOT NULL DEFAULT 'Student' COMMENT 'TYPE (IF NOT STUDENT)',
  `flagged` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'STUDENT REQUIRES REVIEW FROM ADMIN',
  `approved` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'STUDENT REQUIRES APPROVAL FROM ADMIN',
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.types
DROP TABLE IF EXISTS `types`;
CREATE TABLE IF NOT EXISTS `types` (
  `typeM` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`typeM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping structure for table migration_db.updatebuffer
DROP TABLE IF EXISTS `updatebuffer`;
CREATE TABLE IF NOT EXISTS `updatebuffer` (
  `barcode` varchar(20) NOT NULL,
  `serial` varchar(60) NOT NULL,
  `description` varchar(400) NOT NULL,
  `type` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `secondFormID` tinyint(1) NOT NULL,
  `form` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table migration_db.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(4) NOT NULL AUTO_INCREMENT COMMENT 'ID OF USER',
  `username` varchar(65) NOT NULL COMMENT 'USERNAME OF USER',
  `password` varchar(32) NOT NULL COMMENT 'PASSWORD OF USER',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`checkouthistory`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`checkouthistory`(`studentID`, `date`,`time`, `ItemBarcode`, `firstName`,`lastName`,`transactionType`)
SELECT `university_id`,cast(`checked_out` as date), cast(`checked_out` as time), item.barcode, user.first_name, user.last_name, "checkout" FROM equipment_inventory.user join equipment_inventory.checkout_log ON equipment_inventory.user.user_id=equipment_inventory.checkout_log.checked_out_to_id join equipment_inventory.item ON equipment_inventory.checkout_log.item_id = equipment_inventory.item.item_id where returned IS NOT NULL;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`checkedout`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`checkedout`(`studentID`,`outDate`,`outTime`,`ItemBarcode`)
SELECT `university_id`,cast(`checked_out` as date), cast(`checked_out` as time), item.barcode FROM equipment_inventory.user join equipment_inventory.checkout_log ON equipment_inventory.user.user_id=equipment_inventory.checkout_log.checked_out_to_id join equipment_inventory.item ON equipment_inventory.checkout_log.item_id = equipment_inventory.item.item_id where returned IS NULL;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`items`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`items`(`barcode`, `serial`,`description`, `type`)
SELECT `barcode`, `serial`, item_archetype.description, equipment_inventory.category.name from equipment_inventory.item JOIN equipment_inventory.item_archetype ON equipment_inventory.item.archetype_id=equipment_inventory.item_archetype.item_archetype_id JOIN equipment_inventory.category ON equipment_inventory.item_archetype.category_id=equipment_inventory.category.category_id;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`types`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`types`(`typeM`)
SELECT category.name from equipment_inventory.category;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`student`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`student`(`ID`, `firstName`, `lastName`, `email`,`major`)
SELECT user.user_id, `first_name`, `last_name`, CONCAT(user_dce,"@rit.edu"), major.major from equipment_inventory.major JOIN equipment_inventory.user ON equipment_inventory.major.id=equipment_inventory.user.major_id;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`signatureform`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`signatureform`(`studentID`, `outDate`,`dueDate`, `signatureFile`, `formFile`)
SELECT `university_id`, cast(`checked_out` as date), cast(`returned` as date), `document`, `document_name` from equipment_inventory.user JOIN equipment_inventory.checkout_log ON equipment_inventory.user.user_id=equipment_inventory.checkout_log.checked_out_to_id JOIN equipment_inventory.checkout_document ON equipment_inventory.checkout_log.checkout_id=equipment_inventory.checkout_document.checkout_id JOIN equipment_inventory.document_type ON equipment_inventory.checkout_document.document_type_id=equipment_inventory.document_type.document_type_id;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `migration_db`.`modelinfo`
-- -----------------------------------------------------
START TRANSACTION;
USE `migration_db`;
INSERT INTO `migration_db`.`modelinfo`(`description`, `manufacturer`, `image`)
SELECT `description`,`manufacturer`,`image_path` FROM equipment_inventory.item_archetype;
COMMIT;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;





-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Transfer to Dradis DB
-- -----------------------------------------------------------------------------------
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for dradis
DROP DATABASE IF EXISTS `dradis`;
CREATE DATABASE IF NOT EXISTS `dradis` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dradis`;


-- Dumping structure for table dradis.bugreports
DROP TABLE IF EXISTS `bugreports`;
CREATE TABLE IF NOT EXISTS `bugreports` (
  `id` int(5) NOT NULL AUTO_INCREMENT COMMENT 'ID OF BUG REPORT',
  `date` varchar(15) NOT NULL COMMENT 'DATE OF ENTRY',
  `time` varchar(15) NOT NULL COMMENT 'TIME OF ENTRY',
  `reporter` varchar(50) NOT NULL COMMENT 'NAME OF WHO REPORTED BUG',
  `description` varchar(750) NOT NULL COMMENT 'DESCRIPTION OF BUG',
  `markedRead` int(1) NOT NULL DEFAULT '0' COMMENT 'BUG WAS READ BY ADMIN',
  `resolved` int(1) NOT NULL DEFAULT '0' COMMENT 'BUG WAS RESOLVED BY ADMIN',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.changelog
DROP TABLE IF EXISTS `changelog`;
CREATE TABLE IF NOT EXISTS `changelog` (
  `version` varchar(15) NOT NULL COMMENT 'VERSION NUMBER OF ENTRY',
  `date` varchar(15) NOT NULL COMMENT 'DATE OF ENTRY',
  `time` varchar(10) NOT NULL COMMENT 'TIME OF ENTRY',
  `type` varchar(30) NOT NULL COMMENT 'TYPE OF CHANGE',
  `description` varchar(750) NOT NULL COMMENT 'DESCRIPTION OF CHANGE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.checkedout
DROP TABLE IF EXISTS `checkedout`;
CREATE TABLE IF NOT EXISTS `checkedout` (
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `outTime` varchar(20) NOT NULL COMMENT 'TIME OF CHECKOUT',
  `outDate` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `itemBarcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `dueDate` date NOT NULL COMMENT 'DATE FOR ITEM RETURN',
  PRIMARY KEY (`itemBarcode`),
  KEY `studentID` (`studentID`),
  CONSTRAINT `checkedOut_ibfk_1` FOREIGN KEY (`studentID`) REFERENCES `student` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_perCheckedOut` FOREIGN KEY (`itemBarcode`) REFERENCES `items` (`barcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.checkedoutcopy
DROP TABLE IF EXISTS `checkedoutcopy`;
CREATE TABLE IF NOT EXISTS `checkedoutcopy` (
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `outTime` varchar(20) NOT NULL COMMENT 'TIME OF CHECKOUT',
  `outDate` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `itemBarcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `dueDate` date NOT NULL COMMENT 'DATE FOR ITEM RETURN',
  PRIMARY KEY (`itemBarcode`),
  KEY `studentID` (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.checkouthistory
DROP TABLE IF EXISTS `checkouthistory`;
CREATE TABLE IF NOT EXISTS `checkouthistory` (
  `date` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `time` varchar(20) NOT NULL COMMENT 'TIME OF CHECKOUT',
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `firstName` varchar(45),
  `lastName` varchar(45),
  `transactionType` varchar(20) NOT NULL COMMENT 'TYPE OF TRANSACTION',
  `itemBarcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.departmentinventory
DROP TABLE IF EXISTS `departmentinventory`;
CREATE TABLE IF NOT EXISTS `departmentinventory` (
  `department` varchar(10) NOT NULL,
  `building` varchar(10) NOT NULL,
  `room` varchar(10) NOT NULL,
  `asset` varchar(20) NOT NULL,
  `retired` varchar(20) NOT NULL,
  `description` varchar(400) NOT NULL,
  `manufacturer` varchar(50) NOT NULL,
  `model` varchar(400) NOT NULL,
  `serial` varchar(60) NOT NULL,
  `tag` varchar(20) NOT NULL,
  `PO` varchar(10) NOT NULL,
  `date` date NOT NULL,
  `cost` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.info
DROP TABLE IF EXISTS `info`;
CREATE TABLE IF NOT EXISTS `info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID OF INFO ITEM',
  `description` varchar(20) NOT NULL DEFAULT '' COMMENT 'DESCRIPTION OF INFO ITEM',
  `value` varchar(20) NOT NULL DEFAULT '' COMMENT 'VALUE OF INFO ITEM',
  PRIMARY KEY (`id`),
  KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `info` DISABLE KEYS */;
INSERT INTO `info` (`id`, `description`, `value`) VALUES
	(1, 'Version', 'v1.0.0');
/*!40000 ALTER TABLE `info` ENABLE KEYS */;

-- Dumping structure for table dradis.items
DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `barcode` varchar(20) NOT NULL DEFAULT '' COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) NOT NULL DEFAULT '' COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL COMMENT 'LOCATION OF ITEM',
  `secondFormID` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES SECOND FORM OF ID TO CHECKOUT',
  `form` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES FORM TO CHECKOUT ITEM',
  `department` varchar(4) NOT NULL DEFAULT 'ISTE' COMMENT 'DEPARTMENT THAT OWNS ITEM',
  `acquireDate` date DEFAULT NULL COMMENT 'DATE ACQUIRED ',
  `hasWarranty` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'HAS WARRANTY',
  `warrantyExpireDate` date DEFAULT NULL COMMENT 'WARRANTY VALID UNTIL',
  PRIMARY KEY (`barcode`,`serial`),
  KEY `barcode` (`barcode`),
  KEY `serial` (`serial`),
  KEY `description` (`description`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Dumping structure for table dradis.items2
DROP TABLE IF EXISTS `items2`;
CREATE TABLE IF NOT EXISTS `items2` (
  `barcode` varchar(20) CHARACTER SET utf8 NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) CHARACTER SET utf8 NOT NULL COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) CHARACTER SET utf8 NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT 'Other' COMMENT 'TYPE OF ITEM',
  `location` varchar(100) CHARACTER SET utf8 NOT NULL COMMENT 'LOCATION OF ITEM',
  `secondFormID` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES SECOND FORM OF ID TO CHECKOUT',
  `form` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES FORM TO CHECKOUT ITEM',
  `department` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT 'ISTE' COMMENT 'DEPARTMENT THAT OWNS ITEM'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dumping structure for table dradis.itemscopy
DROP TABLE IF EXISTS `itemscopy`;
CREATE TABLE IF NOT EXISTS `itemscopy` (
  `barcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) NOT NULL COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) NOT NULL DEFAULT 'Other' COMMENT 'TYPE OF ITEM',
  `location` varchar(100) NOT NULL COMMENT 'LOCATION OF ITEM',
  `secondFormID` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES SECOND FORM OF ID TO CHECKOUT',
  `form` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'REQUIRES FORM TO CHECKOUT ITEM',
  `department` varchar(4) NOT NULL DEFAULT 'ISTE' COMMENT 'DEPARTMENT THAT OWNS ITEM',
  PRIMARY KEY (`barcode`),
  KEY `barcode` (`barcode`),
  KEY `serial` (`serial`),
  KEY `description` (`description`(255)),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Dumping structure for table dradis.maven
DROP TABLE IF EXISTS `maven`;
CREATE TABLE IF NOT EXISTS `maven` (
  `barcode` varchar(20) NOT NULL COMMENT 'BARCODE NUMBER OF ITEM',
  `serial` varchar(60) NOT NULL COMMENT 'SERIAL NUMBER OF ITEM',
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `type` varchar(100) NOT NULL COMMENT 'TYPE OF ITEM',
  `dateMavened` date NOT NULL COMMENT 'DATE ITEM WAS MAVENED'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.modelinfo
DROP TABLE IF EXISTS `modelinfo`;
CREATE TABLE IF NOT EXISTS `modelinfo` (
  `description` varchar(400) NOT NULL COMMENT 'DESCRIPTION OF ITEM',
  `subtitle` varchar(50) NOT NULL COMMENT 'ADDITIONAL INFO FOR ITEM DESCRIPTION',
  `manufacturer` varchar(50) NOT NULL COMMENT 'MANUFACTURER OF ITEM',
  `model` varchar(50) NOT NULL COMMENT 'MODEL OF ITEM',
  `prefix` varchar(50) NOT NULL COMMENT 'PREFIX FOR BARCODE (DOES NOT APPLY TO RIT TAGS)',
  `feature1` varchar(50) NOT NULL COMMENT 'SPECIAL FEATURE 1',
  `feature2` varchar(50) NOT NULL COMMENT 'SPECIAL FEATURE 2',
  `feature3` varchar(50) NOT NULL COMMENT 'SPECIAL FEATURE 3',
  `image` varchar(100) NOT NULL COMMENT 'LOCATION OF IMAGE TO DESCRIBE ITEM'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.printlabels
DROP TABLE IF EXISTS `printlabels`;
CREATE TABLE IF NOT EXISTS `printlabels` (
  `labelNumber` tinyint(2) NOT NULL AUTO_INCREMENT COMMENT 'NUMBER OF SPECIFIC LABEL',
  `barcode` varchar(20) NOT NULL COMMENT 'BARCODE OF ITEM',
  PRIMARY KEY (`labelNumber`),
  KEY `barcode` (`barcode`),
  CONSTRAINT `printLabels_ibfk_1` FOREIGN KEY (`barcode`) REFERENCES `items` (`barcode`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.signatureform
DROP TABLE IF EXISTS `signatureform`;
CREATE TABLE IF NOT EXISTS `signatureform` (
  `studentID` varchar(20) NOT NULL COMMENT 'UID OF STUDENT',
  `outDate` date NOT NULL COMMENT 'DATE OF CHECKOUT',
  `dueDate` date NOT NULL COMMENT 'DATE FOR ITEM(S) RETURN',
  `signatureFile` varchar(100) NOT NULL COMMENT 'LOCATION OF STUDENT''S SIGNATURE',
  `formFile` varchar(100) NOT NULL COMMENT 'LOCATION OF STUDENT''S SIGNED FORM',
  KEY `studentID` (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.student
DROP TABLE IF EXISTS `student`;
CREATE TABLE IF NOT EXISTS `student` (
  `dateAdded` date NOT NULL COMMENT 'DATE STUDENT WAS ADDED',
  `ID` varchar(9) NOT NULL COMMENT 'UID OF STUDENT',
  `firstName` varchar(45),
  `lastName` varchar(45),
  `email` varchar(16),
  `major` varchar(20) NOT NULL COMMENT 'MAJOR OF STUDENT',
  `type` varchar(20) NOT NULL DEFAULT 'Student' COMMENT 'TYPE (IF NOT STUDENT)',
  `flagged` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'STUDENT REQUIRES REVIEW FROM ADMIN',
  `approved` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'STUDENT REQUIRES APPROVAL FROM ADMIN',
  PRIMARY KEY (`ID`),
  KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.types
DROP TABLE IF EXISTS `types`;
CREATE TABLE IF NOT EXISTS `types` (
  `typeM` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`typeM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping structure for table dradis.updatebuffer
DROP TABLE IF EXISTS `updatebuffer`;
CREATE TABLE IF NOT EXISTS `updatebuffer` (
  `barcode` varchar(20) NOT NULL,
  `serial` varchar(60) NOT NULL,
  `description` varchar(400) NOT NULL,
  `type` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `secondFormID` tinyint(1) NOT NULL,
  `form` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping structure for table dradis.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(4) NOT NULL AUTO_INCREMENT COMMENT 'ID OF USER',
  `username` varchar(65) NOT NULL COMMENT 'USERNAME OF USER',
  `password` varchar(32) NOT NULL COMMENT 'PASSWORD OF USER',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


-- -----------------------------------------------------
-- Data migrated for table `dradis`.`checkouthistory`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`checkouthistory`(`studentID`, `date`,`time`, `ItemBarcode`, `firstName`,`lastName`,`transactionType`)
SELECT `studentID`, `date`,`time`, `ItemBarcode`, `firstName`,`lastName`,`transactionType` from migration_db.checkouthistory;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `dradis`.`checkedout`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`checkedout`(`studentID`,`outDate`,`outTime`,`ItemBarcode`)
SELECT `studentID`,`outDate`,`outTime`,`ItemBarcode` from migration_db.checkedout;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `dradis`.`items`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`items`(`barcode`, `serial`,`description`, `type`)
SELECT `barcode`, `serial`,`description`, `type` from migration_db.items;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `dradis`.`types`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`types`(`typeM`)
SELECT `typeM` from migration_db.types;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `dradis`.`student`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`student`(`ID`, `firstName`, `lastName`, `email`,`major`)
SELECT `ID`, `firstName`, `lastName`, `email`,`major` from migration_db.student;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `dradis`.`signatureform`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`signatureform`(`studentID`, `outDate`,`dueDate`, `signatureFile`, `formFile`)
SELECT `studentID`, `outDate`,`dueDate`, `signatureFile`, `formFile` from migration_db.signatureform;
COMMIT;

-- -----------------------------------------------------
-- Data migrated for table `dradis`.`modelinfo`
-- -----------------------------------------------------
START TRANSACTION;
USE `dradis`;
INSERT INTO `dradis`.`modelinfo`(`description`, `manufacturer`, `image`)
SELECT `description`,`manufacturer`,`image` FROM migration_db.modelinfo;
COMMIT;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

Drop database migration_db;
