-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: bus
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passengers` (
  `PassengerID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int NOT NULL,
  `SeatNumber` varchar(10) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Age` int NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  PRIMARY KEY (`PassengerID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `passengers_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `bookings` (`BookingID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passengers`
--

LOCK TABLES `passengers` WRITE;
/*!40000 ALTER TABLE `passengers` DISABLE KEYS */;
INSERT INTO `passengers` VALUES (1,2,'S1','Aman',12,'Male'),(2,3,'S2','Raj',50,'Female'),(3,4,'S40','Raj',50,'Male'),(4,5,'S35','Raj',52,'Male'),(5,5,'S36','Aman',25,'Male'),(6,6,'S3','Dev',12,'Male'),(7,6,'S4','Aman',15,'Male'),(8,6,'S7','Ay',10,'Female'),(9,7,'S8','Jay',15,'Male'),(10,7,'S12','Raj',25,'Male'),(11,7,'S16','Arya',16,'Male'),(12,8,'S3','Surname',16,'Male'),(13,8,'S1','Modi',15,'Male'),(14,8,'S2','Heruwala',25,'Male'),(15,9,'S24','Aarav',16,'Male'),(16,9,'S23','Abhi',25,'Male'),(17,9,'S19','Akshit',15,'Male'),(18,10,'S18','Dem',25,'Male'),(19,11,'S6','Aman',25,'Male'),(20,11,'S1','Raj',52,'Male'),(21,12,'S22','Aarav',19,'Male'),(22,12,'S21','Dev',27,'Male'),(23,12,'S17','Aman',25,'Male'),(24,13,'S10','Jay',8,'Male'),(25,13,'S13','Jigo',15,'Male'),(26,13,'S9','Manav',5,'Male'),(27,14,'S11','Raj',25,'Male'),(28,14,'S15','sdj',7,'Male'),(29,15,'S1','Jay Heruwala',25,'Male'),(30,15,'S2','Dev',52,'Male'),(31,16,'S14','JAy',15,'Male'),(32,17,'S10','JAy',15,'Male'),(33,18,'S37','Akshit',18,'Male'),(34,18,'S38','Hardik',19,'Male'),(35,19,'S12','Delip',25,'Male'),(36,20,'S20','Dev',24,'Male'),(37,20,'S19','Adam',25,'Male'),(38,21,'S11','Delip',25,'Male'),(39,22,'S9','Delip',25,'Female'),(40,23,'S18','Ram',25,'Male'),(41,24,'S28','Akshit',21,'Male'),(42,25,'S16','Akshit',21,'Male'),(43,26,'S16','Akshit',21,'Male'),(44,27,'S7','Dev',25,'Male'),(45,27,'S8','Devan',22,'Male'),(46,28,'S15','Akshit',18,'Male'),(47,29,'S15','Akshit',18,'Male'),(48,30,'S15','Akshit',18,'Male'),(49,31,'S15','Akshit',18,'Male'),(50,32,'S24','Dev',25,'Male'),(51,32,'S23','Akshit',18,'Male'),(52,32,'S27','Aarav',40,'Male'),(53,33,'S39','Jay',25,'Male');
/*!40000 ALTER TABLE `passengers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-15 14:41:43
