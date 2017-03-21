-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `lovelace`;
CREATE DATABASE `lovelace` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `lovelace`;

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `status_start` datetime DEFAULT NULL,
  `status_stop` datetime DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  KEY `parent_id_idx` (`parent_id`),
  CONSTRAINT `parent_id` FOREIGN KEY (`parent_id`) REFERENCES `category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `checkout_document`;
CREATE TABLE `checkout_document` (
  `checkout_id` int(11) NOT NULL,
  `document_type_id` int(11) DEFAULT NULL,
  `document` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`checkout_id`),
  KEY `document_type_id_idx` (`document_type_id`),
  CONSTRAINT `checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `checkout_log` (`checkout_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `document_type_id` FOREIGN KEY (`document_type_id`) REFERENCES `document_type` (`document_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `checkout_log`;
CREATE TABLE `checkout_log` (
  `checkout_id` int(11) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `checked_out_to_id` int(11) DEFAULT NULL,
  `checked_out_by_id` int(11) DEFAULT NULL,
  `checked_in_by_id` int(11) DEFAULT NULL,
  `checked_out` datetime DEFAULT NULL,
  `due_back` datetime DEFAULT NULL,
  `returned` datetime DEFAULT NULL,
  PRIMARY KEY (`checkout_id`),
  UNIQUE KEY `checkout_id_UNIQUE` (`checkout_id`),
  KEY `checked_out_to_id_idx` (`checked_out_to_id`),
  KEY `item_id_idx` (`item_id`),
  KEY `checked_out_by_id_idx` (`checked_out_by_id`),
  KEY `checked_in_by_id_idx` (`checked_in_by_id`),
  CONSTRAINT `checked_in_by_id` FOREIGN KEY (`checked_in_by_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `checked_out_by_id` FOREIGN KEY (`checked_out_by_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `checked_out_to_id` FOREIGN KEY (`checked_out_to_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `item_id` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `document_type`;
CREATE TABLE `document_type` (
  `document_type_id` int(11) NOT NULL,
  `document_name` varchar(45) DEFAULT NULL,
  `template` blob,
  PRIMARY KEY (`document_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `item_id` int(11) NOT NULL,
  `archetype_id` int(11) DEFAULT NULL,
  `barcode` int(11) DEFAULT NULL,
  `rit_barcode` int(11) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `status_start` datetime DEFAULT NULL,
  `status_stop` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `archetype_id_idx` (`archetype_id`),
  CONSTRAINT `archetype_id` FOREIGN KEY (`archetype_id`) REFERENCES `item_archetype` (`item_archetype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `item` (`item_id`, `archetype_id`, `barcode`, `rit_barcode`, `status`, `status_start`, `status_stop`) VALUES
(2,	1,	123456789,	NULL,	'A',	'1900-01-01 00:00:00',	NULL),
(5,	1,	234223454,	NULL,	'A',	'1900-01-01 00:00:00',	NULL),
(44,	1,	0,	NULL,	'O',	'1900-01-01 00:00:00',	'2017-01-01 00:00:00'),
(57,	1,	232313453,	NULL,	'O',	'1900-01-01 00:00:00',	'2017-03-19 00:00:00'),
(73,	1,	111111111,	NULL,	'A',	'1900-01-01 00:00:00',	NULL);

DROP TABLE IF EXISTS `item_archetype`;
CREATE TABLE `item_archetype` (
  `item_archetype_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `manufacturer` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`item_archetype_id`),
  KEY `category_id_idx` (`category_id`),
  CONSTRAINT `category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `item_archetype` (`item_archetype_id`, `category_id`, `name`, `description`, `manufacturer`) VALUES
(1,	NULL,	NULL,	NULL,	NULL);

DROP TABLE IF EXISTS `item_archetype_attribute`;
CREATE TABLE `item_archetype_attribute` (
  `id` int(11) NOT NULL,
  `item_archetype_id` int(11) DEFAULT NULL,
  `item_attribute_type_id` int(11) DEFAULT NULL,
  `value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_archetype_id_idx` (`item_archetype_id`),
  KEY `item_attribute_type_id_idx` (`item_attribute_type_id`),
  CONSTRAINT `item_archetype_id` FOREIGN KEY (`item_archetype_id`) REFERENCES `item_archetype` (`item_archetype_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `item_attribute_type_id` FOREIGN KEY (`item_attribute_type_id`) REFERENCES `item_attribute_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `item_attribute`;
CREATE TABLE `item_attribute` (
  `id` int(11) NOT NULL,
  `item_attribute_item_id` int(11) DEFAULT NULL,
  `item_attribute_type_id` int(11) DEFAULT NULL,
  `value` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id_idx` (`item_attribute_item_id`),
  KEY `item_attribute_type_id_idx` (`item_attribute_type_id`),
  CONSTRAINT `item_attribute_item_id` FOREIGN KEY (`item_attribute_item_id`) REFERENCES `item` (`item_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `type_id` FOREIGN KEY (`item_attribute_type_id`) REFERENCES `item_attribute_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `item_attribute_type`;
CREATE TABLE `item_attribute_type` (
  `id` int(11) NOT NULL,
  `type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions` (
  `role_permission_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`role_permission_id`,`role_id`),
  KEY `role_id_idx` (`role_id`),
  CONSTRAINT `role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `role_permission_id` FOREIGN KEY (`role_permission_id`) REFERENCES `permission` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `sys_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_dce` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_permission_override`;
CREATE TABLE `user_permission_override` (
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `status` char(1) DEFAULT NULL,
  `status_start` datetime DEFAULT NULL,
  `status_stop` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `permission_id_idx` (`permission_id`),
  CONSTRAINT `permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `status` char(1) DEFAULT NULL,
  `status_start` datetime DEFAULT NULL,
  `status_stop` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id_idx` (`role_id`),
  CONSTRAINT `user_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2017-03-21 03:35:57
