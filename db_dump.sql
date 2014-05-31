-- MySQL dump 10.13  Distrib 5.6.15, for osx10.9 (x86_64)
--
-- Host: localhost    Database: goalkeeper
-- ------------------------------------------------------
-- Server version	5.6.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `phase_games`
--

DROP TABLE IF EXISTS `phase_games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase_games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phase_id` int(11) DEFAULT NULL,
  `game_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `team0` char(3) DEFAULT NULL,
  `team1` char(3) DEFAULT NULL,
  `score` varchar(10) DEFAULT NULL,
  `winner` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_phase_units_on_data_source_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phase_games`
--

LOCK TABLES `phase_games` WRITE;
/*!40000 ALTER TABLE `phase_games` DISABLE KEYS */;
INSERT INTO `phase_games` VALUES (449,92,'1444382','Brazil - Croatia','2014-06-12 22:00:00','BRA','CRO','2:0',0),(450,92,'1444383','Mexico - Cameroon','2014-06-13 18:00:00','MEX','CMR','1:1',2),(451,93,'1444388','Spain - Netherlands','2014-06-13 21:00:00','SPA','NED','2:3',1),(452,93,'1444389','Chile - Australia','2014-06-14 00:00:00','CHI','AUS','0:0',2),(453,94,'1444394','Colombia - Greece','2014-06-14 18:00:00','COL','GRE','1:0',0),(454,95,'1444400','Uruguay - Costa Rica','2014-06-14 21:00:00','URU','CRC',NULL,NULL),(455,95,'1444401','England - Italy','2014-06-15 00:00:00','ENG','ITA',NULL,NULL),(456,94,'1444395','Ivory Coast - Japan','2014-06-15 03:00:00','CIV','JPN',NULL,NULL),(457,96,'1444406','Switzerland - Ecuador','2014-06-15 18:00:00','SUI','ECU',NULL,NULL),(458,96,'1444407','France - Honduras','2014-06-15 21:00:00','FRA','HON',NULL,NULL),(459,97,'1444412','Argentina - Bosnia-Herzegovina','2014-06-16 00:00:00','ARG','BIH',NULL,NULL),(460,98,'1444418','Germany - Portugal','2014-06-16 18:00:00','GER','POR',NULL,NULL),(461,97,'1444413','Iran - Nigeria','2014-06-16 21:00:00','IRN','NGA',NULL,NULL),(462,98,'1444419','Ghana - USA','2014-06-17 00:00:00','GHA','USA',NULL,NULL),(463,99,'1444424','Belgium - Algeria','2014-06-17 18:00:00','BEL','ALG',NULL,NULL),(464,92,'1444384','Brazil - Mexico','2014-06-17 21:00:00','BRA','MEX',NULL,NULL),(465,99,'1444425','Russia - South Korea','2014-06-18 00:00:00','RUS','KOR',NULL,NULL),(466,93,'1444391','Australia - Netherlands','2014-06-18 18:00:00','AUS','NED',NULL,NULL),(467,93,'1444390','Spain - Chile','2014-06-18 21:00:00','SPA','CHI',NULL,NULL),(468,92,'1444385','Cameroon - Croatia','2014-06-19 00:00:00','CMR','CRO',NULL,NULL),(469,94,'1444396','Colombia - Ivory Coast','2014-06-19 18:00:00','COL','CIV',NULL,NULL),(470,95,'1444402','Uruguay - England','2014-06-19 21:00:00','URU','ENG',NULL,NULL),(471,94,'1444397','Japan - Greece','2014-06-20 00:00:00','JPN','GRE',NULL,NULL),(472,95,'1444403','Italy - Costa Rica','2014-06-20 18:00:00','ITA','CRC',NULL,NULL),(473,96,'1444408','Switzerland - France','2014-06-20 21:00:00','SUI','FRA',NULL,NULL),(474,96,'1444409','Honduras - Ecuador','2014-06-21 00:00:00','HON','ECU',NULL,NULL),(475,97,'1444414','Argentina - Iran','2014-06-21 18:00:00','ARG','IRN',NULL,NULL),(476,98,'1444420','Germany - Ghana','2014-06-21 21:00:00','GER','GHA',NULL,NULL),(477,97,'1444415','Nigeria - Bosnia-Herzegovina','2014-06-22 00:00:00','NGA','BIH',NULL,NULL),(478,99,'1444426','Belgium - Russia','2014-06-22 18:00:00','BEL','RUS',NULL,NULL),(479,99,'1444427','South Korea - Algeria','2014-06-22 21:00:00','KOR','ALG',NULL,NULL),(480,98,'1444421','USA - Portugal','2014-06-23 00:00:00','USA','POR',NULL,NULL),(481,93,'1444392','Australia - Spain','2014-06-23 18:00:00','AUS','SPA',NULL,NULL),(482,93,'1444393','Netherlands - Chile','2014-06-23 18:00:00','NED','CHI',NULL,NULL),(483,92,'1444386','Cameroon - Brazil','2014-06-23 22:00:00','CMR','BRA',NULL,NULL),(484,92,'1444387','Croatia - Mexico','2014-06-23 22:00:00','CRO','MEX',NULL,NULL),(485,95,'1444404','Italy - Uruguay','2014-06-24 18:00:00','ITA','URU',NULL,NULL),(486,95,'1444405','Costa Rica - England','2014-06-24 18:00:00','CRC','ENG',NULL,NULL),(487,94,'1444398','Japan - Colombia','2014-06-24 22:00:00','JPN','COL',NULL,NULL),(488,94,'1444399','Greece - Ivory Coast','2014-06-24 22:00:00','GRE','CIV',NULL,NULL),(489,97,'1444416','Nigeria - Argentina','2014-06-25 18:00:00','NGA','ARG',NULL,NULL),(490,97,'1444417','Bosnia-Herzegovina - Iran','2014-06-25 18:00:00','BIH','IRN',NULL,NULL),(491,96,'1444410','Honduras - Switzerland','2014-06-25 22:00:00','HON','SUI',NULL,NULL),(492,96,'1444411','Ecuador - France','2014-06-25 22:00:00','ECU','FRA',NULL,NULL),(493,98,'1444422','USA - Germany','2014-06-26 18:00:00','USA','GER',NULL,NULL),(494,98,'1444423','Portugal - Ghana','2014-06-26 18:00:00','POR','GHA',NULL,NULL),(495,99,'1444428','South Korea - Belgium','2014-06-26 22:00:00','KOR','BEL',NULL,NULL),(496,99,'1444429','Algeria - Russia','2014-06-26 22:00:00','ALG','RUS',NULL,NULL),(497,100,'1444452','1A - 2B','2014-06-28 18:00:00','1A','2B',NULL,NULL),(498,100,'1444453','1C - 2D','2014-06-28 22:00:00','1C','2D',NULL,NULL),(499,100,'1444454','1B - 2A','2014-06-29 18:00:00','1B','2A',NULL,NULL),(500,100,'1444455','1D - 2C','2014-06-29 22:00:00','1D','2C',NULL,NULL),(501,100,'1444456','1E - 2F','2014-06-30 18:00:00','1E','2F',NULL,NULL),(502,100,'1444457','1G - 2H','2014-06-30 22:00:00','1G','2H',NULL,NULL),(503,100,'1444458','1F - 2E','2014-07-01 18:00:00','1F','2E',NULL,NULL),(504,100,'1444459','1H - 2G','2014-07-01 22:00:00','1H','2G',NULL,NULL),(505,101,'1444462','Winner 1E/2F - Winner 1G/2H','2014-07-04 18:00:00','WIN','WIN',NULL,NULL),(506,101,'1444461','Winner 1A/2B - Winner 1C/2D','2014-07-04 22:00:00','WIN','WIN',NULL,NULL),(507,101,'1444465','Winner 1F/2E - Winner 1H/2G','2014-07-05 18:00:00','WIN','WIN',NULL,NULL),(508,101,'1444464','Winner 1B/2A - Winner 1D/2C','2014-07-05 22:00:00','WIN','WIN',NULL,NULL),(509,102,'1444466','Winner QF 1 - Winner QF 2','2014-07-08 22:00:00','WIN','WIN',NULL,NULL),(510,102,'1444467','Winner QF 3 - Winner QF 4','2014-07-09 22:00:00','WIN','WIN',NULL,NULL),(511,103,'1444468','Loser SF 1 - Loser SF 2','2014-07-12 22:00:00','LOS','LOS',NULL,NULL),(512,104,'1444469','Winner SF 1 - Winner SF 2','2014-07-13 21:00:00','WIN','WIN',NULL,NULL);
/*!40000 ALTER TABLE `phase_games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phases`
--

DROP TABLE IF EXISTS `phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phases`
--

LOCK TABLES `phases` WRITE;
/*!40000 ALTER TABLE `phases` DISABLE KEYS */;
INSERT INTO `phases` VALUES (92,'Group A'),(93,'Group B'),(94,'Group C'),(95,'Group D'),(96,'Group E'),(97,'Group F'),(98,'Group G'),(99,'Group H'),(100,'Round of 16'),(101,'Quarterfinals'),(102,'Semifinals'),(103,'Bronze Medal'),(104,'Bronze Medal');
/*!40000 ALTER TABLE `phases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sporting_events`
--

DROP TABLE IF EXISTS `sporting_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sporting_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sport_id` int(11) DEFAULT NULL,
  `data_source_id` varchar(255) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `event_type` varchar(24) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `status` varchar(32) DEFAULT NULL,
  `i18_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sporting_events`
--

LOCK TABLES `sporting_events` WRITE;
/*!40000 ALTER TABLE `sporting_events` DISABLE KEYS */;
INSERT INTO `sporting_events` VALUES (8,NULL,'7628','2014 FIFA World Cup',1,'2014-05-16 22:03:34','2014-05-16 22:03:34','Team',0,'men',NULL,NULL);
/*!40000 ALTER TABLE `sporting_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL,
  `first` varchar(250) NOT NULL,
  `last` varchar(250) NOT NULL,
  `picture_url` varchar(250) NOT NULL,
  `country` char(3) DEFAULT NULL,
  `player` varchar(50) DEFAULT NULL,
  `level` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_predictions`
--

DROP TABLE IF EXISTS `users_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_predictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `game_id` int(11) unsigned NOT NULL,
  `prediction` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_2` (`user_id`,`game_id`),
  KEY `IDX_1` (`game_id`,`prediction`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_predictions`
--

LOCK TABLES `users_predictions` WRITE;
/*!40000 ALTER TABLE `users_predictions` DISABLE KEYS */;
INSERT INTO `users_predictions` VALUES (1,100,1444382,0),(2,100,1444383,0),(3,100,1444388,0),(4,100,1444389,2),(5,100,1444394,0),(8,101,1444382,0),(9,101,1444383,1),(10,101,1444388,1),(11,101,1444389,2),(12,101,1444394,1),(15,10152166875768932,1444382,2),(16,10152166875768932,1444383,2),(17,10152166875768932,1444388,1),(18,10152166875768932,1444389,2),(19,10152166875768932,1444394,1),(22,102,1444382,0),(23,102,1444383,0),(24,102,1444388,2),(25,102,1444389,1),(26,102,1444394,2),(29,103,1444382,1),(30,103,1444383,2),(31,103,1444388,1),(32,103,1444389,1),(33,103,1444394,0);
/*!40000 ALTER TABLE `users_predictions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-31  5:43:12
