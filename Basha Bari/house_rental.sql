

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";




DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getbooking` ()  SELECT booking_date from booking$$

DELIMITER ;



CREATE TABLE `booking` (
  `t_id` int(11) NOT NULL,
  `h_id` int(11) NOT NULL,
  `booking_date` date DEFAULT NULL,
  `period` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `agreement` longblob
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




CREATE TABLE `house` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `no_of_rooms` int(11) DEFAULT NULL,
  `rate` int(11) DEFAULT NULL,
  `pics` blob,
  `country` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DELIMITER $$
CREATE TRIGGER `deletelog` BEFORE DELETE ON `house` FOR EACH ROW INSERT INTO logs VALUES(null,old.id,"deleted",now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertlog` AFTER INSERT ON `house` FOR EACH ROW INSERT INTO logs VALUES(null,new.id,"inserted",now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateLog` AFTER UPDATE ON `house` FOR EACH ROW INSERT INTO logs VALUES(null,new.id,"updated",now())
$$
DELIMITER ;



CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `action` varchar(20) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `member` (
  `t_id` int(11) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `occupation` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `relationship` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `owner` (
  `o_id` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `pwd` varchar(30) DEFAULT NULL,
  `mobile_no` bigint(20) DEFAULT NULL,
  `occupation` varchar(50) DEFAULT NULL,
  `no_of_houses` int(11) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `rating` (
  `id` int(11) NOT NULL,
  `t_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL,
  `comment` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `tenant` (
  `t_id` int(11) NOT NULL,
  `fname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `pwd` varchar(30) DEFAULT NULL,
  `mobile_no` bigint(20) DEFAULT NULL,
  `occupation` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `vacanthouses` (
`id` int(11)
,`owner_id` int(11)
,`no_of_rooms` int(11)
,`rate` int(11)
,`pics` blob
,`country` varchar(20)
,`state` varchar(20)
,`city` varchar(30)
,`address` varchar(50)
,`description` varchar(300)
);


DROP TABLE IF EXISTS `vacanthouses`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vacanthouses`  AS  select `house`.`id` AS `id`,`house`.`owner_id` AS `owner_id`,`house`.`no_of_rooms` AS `no_of_rooms`,`house`.`rate` AS `rate`,`house`.`pics` AS `pics`,`house`.`country` AS `country`,`house`.`state` AS `state`,`house`.`city` AS `city`,`house`.`address` AS `address`,`house`.`description` AS `description` from `house` where (not(`house`.`id` in (select `booking`.`h_id` from `booking`))) ;


ALTER TABLE `house`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner_id` (`owner_id`);


ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `member`
  ADD PRIMARY KEY (`t_id`,`fname`,`lname`);


ALTER TABLE `owner`
  ADD PRIMARY KEY (`o_id`);


ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`,`t_id`),
  ADD KEY `t_id` (`t_id`);


ALTER TABLE `tenant`
  ADD PRIMARY KEY (`t_id`);


ALTER TABLE `house`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;


ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;


ALTER TABLE `owner`
  MODIFY `o_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;


ALTER TABLE `tenant`
  MODIFY `t_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;


ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`h_id`) REFERENCES `house` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_ibfk_3` FOREIGN KEY (`t_id`) REFERENCES `tenant` (`t_id`) ON DELETE CASCADE;


ALTER TABLE `house`
  ADD CONSTRAINT `house_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`o_id`) ON DELETE CASCADE;

ALTER TABLE `member`
  ADD CONSTRAINT `member_ibfk_1` FOREIGN KEY (`t_id`) REFERENCES `tenant` (`t_id`) ON DELETE CASCADE;


ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_3` FOREIGN KEY (`id`) REFERENCES `house` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rating_ibfk_4` FOREIGN KEY (`t_id`) REFERENCES `tenant` (`t_id`) ON DELETE CASCADE;
COMMIT;
