-- MariaDB dump 10.19  Distrib 10.4.25-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: group_cine
-- ------------------------------------------------------
-- Server version	10.4.25-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `group_cine`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `group_cine` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `group_cine`;

--
-- Table structure for table `cinemas`
--

DROP TABLE IF EXISTS `cinemas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cinemas` (
  `id_cinema` int(4) NOT NULL AUTO_INCREMENT,
  `name_cinema` varchar(30) NOT NULL,
  `address` varchar(80) NOT NULL,
  `city` varchar(50) NOT NULL,
  `total_halls` int(2) DEFAULT 0,
  `manager` int(5) DEFAULT NULL,
  PRIMARY KEY (`id_cinema`),
  KEY `manager` (`manager`),
  CONSTRAINT `cinemas_ibfk_1` FOREIGN KEY (`manager`) REFERENCES `managers` (`id_manager`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinemas`
--

LOCK TABLES `cinemas` WRITE;
/*!40000 ALTER TABLE `cinemas` DISABLE KEYS */;
INSERT INTO `cinemas` VALUES (1,'Megapolis','1 rue principale','Paris',3,1),(2,'Gigapolis','57, route principale','Metz',3,2),(3,'Cinepolis','23, rue de la culture ','Lille',3,3),(4,'Lecine','1, rue nationale ','Lyon',4,4);
/*!40000 ALTER TABLE `cinemas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `halls`
--

DROP TABLE IF EXISTS `halls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `halls` (
  `id_hall` int(5) NOT NULL AUTO_INCREMENT,
  `number_hall` int(2) NOT NULL,
  `total_places` int(3) NOT NULL,
  `id_cinema` int(4) NOT NULL,
  PRIMARY KEY (`id_hall`),
  UNIQUE KEY `number_hall` (`number_hall`,`id_cinema`),
  KEY `id_cinema` (`id_cinema`),
  CONSTRAINT `halls_ibfk_1` FOREIGN KEY (`id_cinema`) REFERENCES `cinemas` (`id_cinema`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `halls`
--

LOCK TABLES `halls` WRITE;
/*!40000 ALTER TABLE `halls` DISABLE KEYS */;
INSERT INTO `halls` VALUES (1,1,200,1),(2,2,300,1),(3,3,500,1),(4,1,100,2),(5,2,150,2),(6,3,200,2),(7,1,100,3),(8,2,500,3),(9,3,200,3),(10,1,200,4),(11,2,100,4),(12,3,500,4),(13,4,3,4);
/*!40000 ALTER TABLE `halls` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_after_add_hall_on_cinema 
AFTER INSERT ON halls 
FOR EACH ROW 
UPDATE cinemas 
SET total_halls = total_halls + 1 
WHERE id_cinema = NEW.id_cinema */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `managers`
--

DROP TABLE IF EXISTS `managers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `managers` (
  `id_manager` int(5) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `mail` varchar(50) NOT NULL,
  `password` varchar(64) NOT NULL,
  `cinema` int(4) NOT NULL,
  PRIMARY KEY (`id_manager`),
  KEY `cinema` (`cinema`),
  CONSTRAINT `cinema` FOREIGN KEY (`cinema`) REFERENCES `cinemas` (`id_cinema`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `managers`
--

LOCK TABLES `managers` WRITE;
/*!40000 ALTER TABLE `managers` DISABLE KEYS */;
INSERT INTO `managers` VALUES (1,'Martin','Michel','martinmichel@localhost','$2y$10$r5V1Ahx3ZsGhWKZ4DqwHweBkdC6tQELugMOCFxRW5KUQWbYi3evmy',1),(2,'Dupond','Eric','duponderic@localhost','$2y$10$MYwWat22dBf2szchDQyT/.dROce8ywZzNOZfUnvkk/Aba8F7otrsu',2),(3,'paul','henry','paulhenry@localhost','$2y$10$.IYO.jFq1bQs2Qh5aoexqe667km845jAFdxBohAbs3prlhcofcZyC',3),(4,'Doe','John','doejohn@localhost','$2y$10$4ndVad6pzwMYfmwe6cNKQ.6B4RID9ieGznVm4LwBSfPZCFx3IOZq.',4);
/*!40000 ALTER TABLE `managers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_after_insert_manager_udapte_manager_cinema
AFTER INSERT ON managers 
FOR EACH ROW
UPDATE cinemas 
SET manager = NEW.id_manager 
WHERE id_cinema = NEW.cinema */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movies` (
  `id_film` int(5) NOT NULL AUTO_INCREMENT,
  `title` varchar(40) NOT NULL,
  `genre` varchar(30) NOT NULL,
  PRIMARY KEY (`id_film`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movies`
--

LOCK TABLES `movies` WRITE;
/*!40000 ALTER TABLE `movies` DISABLE KEYS */;
INSERT INTO `movies` VALUES (1,'theMovie','science-fiction'),(2,'La tour infernale','comedie'),(3,'CodeGame','science-fiction'),(4,'La tour infernale','comedie');
/*!40000 ALTER TABLE `movies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prices`
--

DROP TABLE IF EXISTS `prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prices` (
  `id_price` int(1) NOT NULL AUTO_INCREMENT,
  `cost` double NOT NULL,
  `description` varchar(30) NOT NULL,
  PRIMARY KEY (`id_price`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prices`
--

LOCK TABLES `prices` WRITE;
/*!40000 ALTER TABLE `prices` DISABLE KEYS */;
INSERT INTO `prices` VALUES (1,9.2,'Plein tarif'),(2,7.6,'Etudiant'),(3,5.9,'Moins de 14 ans');
/*!40000 ALTER TABLE `prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reservations` (
  `id_reservation` int(10) NOT NULL AUTO_INCREMENT,
  `seance` int(5) DEFAULT NULL,
  `method_reservation` varchar(20) DEFAULT NULL,
  `price` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_reservation`),
  KEY `seance` (`seance`),
  KEY `price` (`price`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`seance`) REFERENCES `seances` (`id_seance`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`price`) REFERENCES `prices` (`id_price`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,1,'Sur place',1),(2,2,'Sur place',2),(3,1,'Sur place',3),(4,3,'Sur place',2);
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_before_insert_reservation BEFORE INSERT ON reservations
  FOR EACH ROW
  BEGIN
  	DECLARE available INT;
    SELECT available_place INTO available FROM seances WHERE id_seance = NEW.seance;
        IF(available > 0)THEN 
        UPDATE seances
        SET available_place = available_place -1
        WHERE id_seance = NEW.seance;
    ELSE 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Seance complete, plus de place disponible';
    END IF;    
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `seance_cinema_1`
--

DROP TABLE IF EXISTS `seance_cinema_1`;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_1`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `seance_cinema_1` (
  `cinema` tinyint NOT NULL,
  `id_seance` tinyint NOT NULL,
  `date_seance` tinyint NOT NULL,
  `hall` tinyint NOT NULL,
  `movie` tinyint NOT NULL,
  `available_place` tinyint NOT NULL,
  `number_hall` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `seance_cinema_2`
--

DROP TABLE IF EXISTS `seance_cinema_2`;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_2`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `seance_cinema_2` (
  `cinema` tinyint NOT NULL,
  `id_seance` tinyint NOT NULL,
  `date_seance` tinyint NOT NULL,
  `hall` tinyint NOT NULL,
  `movie` tinyint NOT NULL,
  `available_place` tinyint NOT NULL,
  `number_hall` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `seance_cinema_3`
--

DROP TABLE IF EXISTS `seance_cinema_3`;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_3`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `seance_cinema_3` (
  `cinema` tinyint NOT NULL,
  `id_seance` tinyint NOT NULL,
  `date_seance` tinyint NOT NULL,
  `hall` tinyint NOT NULL,
  `movie` tinyint NOT NULL,
  `available_place` tinyint NOT NULL,
  `number_hall` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `seance_cinema_4`
--

DROP TABLE IF EXISTS `seance_cinema_4`;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_4`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `seance_cinema_4` (
  `cinema` tinyint NOT NULL,
  `id_seance` tinyint NOT NULL,
  `date_seance` tinyint NOT NULL,
  `hall` tinyint NOT NULL,
  `movie` tinyint NOT NULL,
  `available_place` tinyint NOT NULL,
  `number_hall` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `seances`
--

DROP TABLE IF EXISTS `seances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seances` (
  `id_seance` int(5) NOT NULL AUTO_INCREMENT,
  `date_seance` datetime NOT NULL,
  `cinema` int(4) NOT NULL,
  `hall` int(2) NOT NULL,
  `movie` int(5) NOT NULL,
  `available_place` int(3) DEFAULT 0,
  PRIMARY KEY (`id_seance`),
  UNIQUE KEY `hall` (`hall`,`date_seance`),
  KEY `cinema` (`cinema`),
  KEY `movie` (`movie`),
  CONSTRAINT `seances_ibfk_1` FOREIGN KEY (`cinema`) REFERENCES `cinemas` (`id_cinema`),
  CONSTRAINT `seances_ibfk_2` FOREIGN KEY (`hall`) REFERENCES `halls` (`id_hall`),
  CONSTRAINT `seances_ibfk_3` FOREIGN KEY (`movie`) REFERENCES `movies` (`id_film`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seances`
--

LOCK TABLES `seances` WRITE;
/*!40000 ALTER TABLE `seances` DISABLE KEYS */;
INSERT INTO `seances` VALUES (1,'2022-11-24 15:00:00',1,1,1,198),(2,'2022-11-24 15:00:00',1,2,3,299),(3,'2022-11-24 17:00:00',1,3,3,499),(4,'2022-11-24 21:00:00',2,5,2,150),(5,'2022-11-24 22:00:00',3,7,2,100);
/*!40000 ALTER TABLE `seances` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_before_insert_seance BEFORE INSERT ON seances
  FOR EACH ROW
  BEGIN
  	DECLARE av_p INT;
    DECLARE id_c INT;
    SELECT total_places INTO av_p FROM halls WHERE id_hall = NEW.hall; 
    SELECT id_cinema INTO id_c FROM halls WHERE id_hall = NEW.hall;     
    SET 
    NEW.available_place= av_p, 
    NEW.cinema = id_c;        
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `group_cine`
--

USE `group_cine`;

--
-- Final view structure for view `seance_cinema_1`
--

/*!50001 DROP TABLE IF EXISTS `seance_cinema_1`*/;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `seance_cinema_1` AS select `s`.`cinema` AS `cinema`,`s`.`id_seance` AS `id_seance`,`s`.`date_seance` AS `date_seance`,`s`.`hall` AS `hall`,`s`.`movie` AS `movie`,`s`.`available_place` AS `available_place`,`h`.`number_hall` AS `number_hall` from (`seances` `s` join `halls` `h` on(`s`.`hall` = `h`.`id_hall`)) where `s`.`cinema` = 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `seance_cinema_2`
--

/*!50001 DROP TABLE IF EXISTS `seance_cinema_2`*/;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `seance_cinema_2` AS select `s`.`cinema` AS `cinema`,`s`.`id_seance` AS `id_seance`,`s`.`date_seance` AS `date_seance`,`s`.`hall` AS `hall`,`s`.`movie` AS `movie`,`s`.`available_place` AS `available_place`,`h`.`number_hall` AS `number_hall` from (`seances` `s` join `halls` `h` on(`s`.`hall` = `h`.`id_hall`)) where `s`.`cinema` = 2 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `seance_cinema_3`
--

/*!50001 DROP TABLE IF EXISTS `seance_cinema_3`*/;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_3`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `seance_cinema_3` AS select `s`.`cinema` AS `cinema`,`s`.`id_seance` AS `id_seance`,`s`.`date_seance` AS `date_seance`,`s`.`hall` AS `hall`,`s`.`movie` AS `movie`,`s`.`available_place` AS `available_place`,`h`.`number_hall` AS `number_hall` from (`seances` `s` join `halls` `h` on(`s`.`hall` = `h`.`id_hall`)) where `s`.`cinema` = 3 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `seance_cinema_4`
--

/*!50001 DROP TABLE IF EXISTS `seance_cinema_4`*/;
/*!50001 DROP VIEW IF EXISTS `seance_cinema_4`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `seance_cinema_4` AS select `s`.`cinema` AS `cinema`,`s`.`id_seance` AS `id_seance`,`s`.`date_seance` AS `date_seance`,`s`.`hall` AS `hall`,`s`.`movie` AS `movie`,`s`.`available_place` AS `available_place`,`h`.`number_hall` AS `number_hall` from (`seances` `s` join `halls` `h` on(`s`.`hall` = `h`.`id_hall`)) where `s`.`cinema` = 4 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-07 17:50:17
