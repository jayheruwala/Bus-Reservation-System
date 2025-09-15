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
-- Table structure for table `intermediate_stations`
--

DROP TABLE IF EXISTS `intermediate_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intermediate_stations` (
  `StationID` int NOT NULL AUTO_INCREMENT,
  `BusID` int DEFAULT NULL,
  `StationName` varchar(100) DEFAULT NULL,
  `ArrivalDateTime` datetime DEFAULT NULL,
  `DepartureDateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`StationID`),
  KEY `BusID` (`BusID`),
  CONSTRAINT `intermediate_stations_ibfk_1` FOREIGN KEY (`BusID`) REFERENCES `buses` (`BusID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intermediate_stations`
--

LOCK TABLES `intermediate_stations` WRITE;
/*!40000 ALTER TABLE `intermediate_stations` DISABLE KEYS */;
INSERT INTO `intermediate_stations` VALUES (16,14,'Mahesana','2025-04-25 23:50:00','2025-04-25 23:59:00'),(17,16,'Palanpur','2025-04-29 01:35:00','2025-04-29 01:40:00'),(18,16,'Ahemedabad','2025-04-29 04:45:00','2025-04-29 04:55:00'),(20,10,'Deesa','2027-01-01 02:40:00','2027-01-01 02:45:00');
/*!40000 ALTER TABLE `intermediate_stations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-15 14:41:41
