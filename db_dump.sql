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
-- Table structure for table `event_phases`
--

DROP TABLE IF EXISTS `event_phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_phases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sporting_event_id` int(11) DEFAULT NULL,
  `data_source_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `i18_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_phases`
--

LOCK TABLES `event_phases` WRITE;
/*!40000 ALTER TABLE `event_phases` DISABLE KEYS */;
INSERT INTO `event_phases` VALUES (92,8,'831471','Group A','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(93,8,'831472','Group B','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(94,8,'831473','Group C','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(95,8,'831474','Group D','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(96,8,'831475','Group E','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(97,8,'831476','Group F','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(98,8,'831477','Group G','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(99,8,'831478','Group H','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(100,8,'831479','Round of 16','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(101,8,'831480','Quarterfinals','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(102,8,'831481','Semifinals','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(103,8,'831482','Bronze Medal','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL),(104,8,'831483','Bronze Medal','2014-05-16 22:03:34','2014-05-16 22:03:34',NULL);
/*!40000 ALTER TABLE `event_phases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phase_units`
--

DROP TABLE IF EXISTS `phase_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phase_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_phase_id` int(11) DEFAULT NULL,
  `data_source_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `sport_body_id` varchar(32) DEFAULT NULL,
  `team0` char(3) DEFAULT NULL,
  `team1` char(3) DEFAULT NULL,
  `score` varchar(10) DEFAULT NULL,
  `winner` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_phase_units_on_data_source_id` (`data_source_id`),
  KEY `index_phase_units_on_sport_body_id` (`sport_body_id`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phase_units`
--

LOCK TABLES `phase_units` WRITE;
/*!40000 ALTER TABLE `phase_units` DISABLE KEYS */;
INSERT INTO `phase_units` VALUES (449,92,'1444382','Brazil - Croatia','2014-06-12 22:00:00','1','BRA','CRO',NULL,NULL),(450,92,'1444383','Mexico - Cameroon','2014-06-13 18:00:00','2','MEX','CMR',NULL,NULL),(451,93,'1444388','Spain - Netherlands','2014-06-13 21:00:00','3','SPA','NED',NULL,NULL),(452,93,'1444389','Chile - Australia','2014-06-14 00:00:00','4','CHI','AUS',NULL,NULL),(453,94,'1444394','Colombia - Greece','2014-06-14 18:00:00','5','COL','GRE',NULL,NULL),(454,95,'1444400','Uruguay - Costa Rica','2014-06-14 21:00:00','7','URU','CRC',NULL,NULL),(455,95,'1444401','England - Italy','2014-06-15 00:00:00','8','ENG','ITA',NULL,NULL),(456,94,'1444395','Ivory Coast - Japan','2014-06-15 03:00:00','6','CIV','JPN',NULL,NULL),(457,96,'1444406','Switzerland - Ecuador','2014-06-15 18:00:00','9','SUI','ECU',NULL,NULL),(458,96,'1444407','France - Honduras','2014-06-15 21:00:00','10','FRA','HON',NULL,NULL),(459,97,'1444412','Argentina - Bosnia-Herzegovina','2014-06-16 00:00:00','11','ARG','BIH',NULL,NULL),(460,98,'1444418','Germany - Portugal','2014-06-16 18:00:00','13','GER','POR',NULL,NULL),(461,97,'1444413','Iran - Nigeria','2014-06-16 21:00:00','12','IRN','NGA',NULL,NULL),(462,98,'1444419','Ghana - USA','2014-06-17 00:00:00','14','GHA','USA',NULL,NULL),(463,99,'1444424','Belgium - Algeria','2014-06-17 18:00:00','15','BEL','ALG',NULL,NULL),(464,92,'1444384','Brazil - Mexico','2014-06-17 21:00:00','17','BRA','MEX',NULL,NULL),(465,99,'1444425','Russia - South Korea','2014-06-18 00:00:00','16','RUS','KOR',NULL,NULL),(466,93,'1444391','Australia - Netherlands','2014-06-18 18:00:00','20','AUS','NED',NULL,NULL),(467,93,'1444390','Spain - Chile','2014-06-18 21:00:00','19','SPA','CHI',NULL,NULL),(468,92,'1444385','Cameroon - Croatia','2014-06-19 00:00:00','18','CMR','CRO',NULL,NULL),(469,94,'1444396','Colombia - Ivory Coast','2014-06-19 18:00:00','21','COL','CIV',NULL,NULL),(470,95,'1444402','Uruguay - England','2014-06-19 21:00:00','23','URU','ENG',NULL,NULL),(471,94,'1444397','Japan - Greece','2014-06-20 00:00:00','22','JPN','GRE',NULL,NULL),(472,95,'1444403','Italy - Costa Rica','2014-06-20 18:00:00','24','ITA','CRC',NULL,NULL),(473,96,'1444408','Switzerland - France','2014-06-20 21:00:00','25','SUI','FRA',NULL,NULL),(474,96,'1444409','Honduras - Ecuador','2014-06-21 00:00:00','26','HON','ECU',NULL,NULL),(475,97,'1444414','Argentina - Iran','2014-06-21 18:00:00','27','ARG','IRN',NULL,NULL),(476,98,'1444420','Germany - Ghana','2014-06-21 21:00:00','29','GER','GHA',NULL,NULL),(477,97,'1444415','Nigeria - Bosnia-Herzegovina','2014-06-22 00:00:00','28','NGA','BIH',NULL,NULL),(478,99,'1444426','Belgium - Russia','2014-06-22 18:00:00','31','BEL','RUS',NULL,NULL),(479,99,'1444427','South Korea - Algeria','2014-06-22 21:00:00','32','KOR','ALG',NULL,NULL),(480,98,'1444421','USA - Portugal','2014-06-23 00:00:00','30','USA','POR',NULL,NULL),(481,93,'1444392','Australia - Spain','2014-06-23 18:00:00','35','AUS','SPA',NULL,NULL),(482,93,'1444393','Netherlands - Chile','2014-06-23 18:00:00','36','NED','CHI',NULL,NULL),(483,92,'1444386','Cameroon - Brazil','2014-06-23 22:00:00','33','CMR','BRA',NULL,NULL),(484,92,'1444387','Croatia - Mexico','2014-06-23 22:00:00','34','CRO','MEX',NULL,NULL),(485,95,'1444404','Italy - Uruguay','2014-06-24 18:00:00','39','ITA','URU',NULL,NULL),(486,95,'1444405','Costa Rica - England','2014-06-24 18:00:00','40','CRC','ENG',NULL,NULL),(487,94,'1444398','Japan - Colombia','2014-06-24 22:00:00','37','JPN','COL',NULL,NULL),(488,94,'1444399','Greece - Ivory Coast','2014-06-24 22:00:00','38','GRE','CIV',NULL,NULL),(489,97,'1444416','Nigeria - Argentina','2014-06-25 18:00:00','43','NGA','ARG',NULL,NULL),(490,97,'1444417','Bosnia-Herzegovina - Iran','2014-06-25 18:00:00','44','BIH','IRN',NULL,NULL),(491,96,'1444410','Honduras - Switzerland','2014-06-25 22:00:00','41','HON','SUI',NULL,NULL),(492,96,'1444411','Ecuador - France','2014-06-25 22:00:00','42','ECU','FRA',NULL,NULL),(493,98,'1444422','USA - Germany','2014-06-26 18:00:00','45','USA','GER',NULL,NULL),(494,98,'1444423','Portugal - Ghana','2014-06-26 18:00:00','46','POR','GHA',NULL,NULL),(495,99,'1444428','South Korea - Belgium','2014-06-26 22:00:00','47','KOR','BEL',NULL,NULL),(496,99,'1444429','Algeria - Russia','2014-06-26 22:00:00','48','ALG','RUS',NULL,NULL),(497,100,'1444452','1A - 2B','2014-06-28 18:00:00','49','1A','2B',NULL,NULL),(498,100,'1444453','1C - 2D','2014-06-28 22:00:00','50','1C','2D',NULL,NULL),(499,100,'1444454','1B - 2A','2014-06-29 18:00:00','51','1B','2A',NULL,NULL),(500,100,'1444455','1D - 2C','2014-06-29 22:00:00','52','1D','2C',NULL,NULL),(501,100,'1444456','1E - 2F','2014-06-30 18:00:00','53','1E','2F',NULL,NULL),(502,100,'1444457','1G - 2H','2014-06-30 22:00:00','54','1G','2H',NULL,NULL),(503,100,'1444458','1F - 2E','2014-07-01 18:00:00','55','1F','2E',NULL,NULL),(504,100,'1444459','1H - 2G','2014-07-01 22:00:00','56','1H','2G',NULL,NULL),(505,101,'1444462','Winner 1E/2F - Winner 1G/2H','2014-07-04 18:00:00','58','WIN','WIN',NULL,NULL),(506,101,'1444461','Winner 1A/2B - Winner 1C/2D','2014-07-04 22:00:00','57','WIN','WIN',NULL,NULL),(507,101,'1444465','Winner 1F/2E - Winner 1H/2G','2014-07-05 18:00:00','60','WIN','WIN',NULL,NULL),(508,101,'1444464','Winner 1B/2A - Winner 1D/2C','2014-07-05 22:00:00','59','WIN','WIN',NULL,NULL),(509,102,'1444466','Winner QF 1 - Winner QF 2','2014-07-08 22:00:00','61','WIN','WIN',NULL,NULL),(510,102,'1444467','Winner QF 3 - Winner QF 4','2014-07-09 22:00:00','62','WIN','WIN',NULL,NULL),(511,103,'1444468','Loser SF 1 - Loser SF 2','2014-07-12 22:00:00','63','LOS','LOS',NULL,NULL),(512,104,'1444469','Winner SF 1 - Winner SF 2','2014-07-13 21:00:00','64','WIN','WIN',NULL,NULL);
/*!40000 ALTER TABLE `phase_units` ENABLE KEYS */;
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
  `first_name` varchar(250) NOT NULL,
  `last_name` varchar(250) NOT NULL,
  `picture_url` varchar(250) NOT NULL,
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-31  0:13:55
