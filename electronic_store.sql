-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: electronic_store
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `branch_id` int NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'Toko Utama Jakarta','Jakarta'),(2,'Cabang Bekasi','Bekasi'),(3,'Cabang Depok','Depok'),(4,'Cabang Tangerang','Tangerang'),(5,'Cabang Bogor','Bogor');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Kulkas'),(2,'Mesin Cuci'),(3,'AC'),(4,'Vacuum Cleaner'),(5,'Microwave'),(6,'Rice Cooker');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL AUTO_INCREMENT,
  `branch_id` int NOT NULL,
  `product_id` int NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`inventory_id`),
  KEY `fk_inventory_branch` (`branch_id`),
  KEY `fk_inventory_product` (`product_id`),
  CONSTRAINT `fk_inventory_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  CONSTRAINT `fk_inventory_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,1,1,45),(2,1,2,12),(3,1,3,6),(4,1,4,22),(5,1,5,20),(6,1,6,19),(7,1,7,13),(8,1,8,11),(9,1,9,48),(10,1,10,39),(11,1,11,10),(12,1,12,42),(13,1,13,32),(14,1,14,7),(15,1,15,6),(16,2,1,10),(17,2,2,18),(18,2,3,19),(19,2,4,37),(20,2,5,43),(21,2,6,6),(22,2,7,40),(23,2,8,17),(24,2,9,50),(25,2,10,46),(26,2,11,49),(27,2,12,39),(28,2,13,31),(29,2,14,19),(30,2,15,33),(31,3,1,42),(32,3,2,22),(33,3,3,5),(34,3,4,15),(35,3,5,49),(36,3,6,32),(37,3,7,26),(38,3,8,22),(39,3,9,14),(40,3,10,18),(41,3,11,26),(42,3,12,11),(43,3,13,10),(44,3,14,29),(45,3,15,11),(46,4,1,27),(47,4,2,27),(48,4,3,43),(49,4,4,21),(50,4,5,7),(51,4,6,34),(52,4,7,39),(53,4,8,12),(54,4,9,29),(55,4,10,10),(56,4,11,40),(57,4,12,23),(58,4,13,45),(59,4,14,44),(60,4,15,28),(61,5,1,41),(62,5,2,17),(63,5,3,50),(64,5,4,9),(65,5,5,7),(66,5,6,47),(67,5,7,19),(68,5,8,23),(69,5,9,10),(70,5,10,19),(71,5,11,11),(72,5,12,29),(73,5,13,22),(74,5,14,34),(75,5,15,45);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) DEFAULT NULL,
  `category_id` varchar(50) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'LG Kulkas 2 Pintu','1',4500000.00),(2,'Samsung Kulkas Side by Side','1',12500000.00),(3,'Polytron Mesin Cuci 1 Tabung','2',2800000.00),(4,'LG Mesin Cuci Front Load','2',7200000.00),(5,'Daikin AC 1 PK','3',5200000.00),(6,'Panasonic AC 1.5 PK','3',6700000.00),(7,'Philips Vacuum Cleaner','4',1500000.00),(8,'Sharp Vacuum Cleaner','4',1200000.00),(9,'Samsung Microwave','5',1800000.00),(10,'Panasonic Microwave','5',2200000.00),(11,'Miyako Rice Cooker','6',450000.00),(12,'Philips Rice Cooker','6',850000.00),(13,'Sharp Kulkas Mini','1',2100000.00),(14,'Aqua Mesin Cuci 2 Tabung','2',1900000.00),(15,'Gree AC 0.5 PK','3',3200000.00);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `sale_id` int NOT NULL AUTO_INCREMENT,
  `branch_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `branch_id` (`branch_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (1001,1,14,2,'2025-01-11'),(1002,1,6,2,'2025-01-14'),(1003,1,11,2,'2025-02-14'),(1004,1,15,3,'2025-02-11'),(1005,1,2,3,'2025-02-10'),(1006,1,3,3,'2025-02-16'),(1007,1,4,1,'2025-01-30'),(1008,1,7,2,'2025-03-01'),(1009,1,11,3,'2025-02-05'),(1010,1,4,3,'2025-01-21'),(1011,1,14,1,'2025-01-15'),(1012,1,14,1,'2025-02-21'),(1013,1,6,2,'2025-01-18'),(1014,1,2,1,'2025-02-28'),(1015,1,10,3,'2025-01-21'),(1016,1,4,3,'2025-02-01'),(1017,1,7,3,'2025-01-30'),(1018,1,3,2,'2025-01-09'),(1019,1,4,3,'2025-02-05'),(1020,1,9,2,'2025-02-17'),(1021,1,10,2,'2025-02-27'),(1022,1,10,2,'2025-01-24'),(1023,1,4,1,'2025-02-02'),(1024,1,8,1,'2025-02-18'),(1025,1,1,1,'2025-01-10'),(1026,1,11,1,'2025-02-20'),(1027,1,11,2,'2025-02-08'),(1028,1,2,2,'2025-01-25'),(1029,1,10,2,'2025-02-03'),(1030,1,5,3,'2025-02-25'),(1031,1,1,3,'2025-02-16'),(1032,1,2,3,'2025-02-26'),(1033,1,9,2,'2025-02-19'),(1034,1,11,2,'2025-01-08'),(1035,1,5,2,'2025-01-11'),(1036,1,8,1,'2025-02-16'),(1037,1,15,3,'2025-01-17'),(1038,1,9,1,'2025-02-02'),(1039,1,15,1,'2025-02-25'),(1040,1,11,2,'2025-02-23'),(1041,1,11,3,'2025-02-08'),(1042,1,4,1,'2025-01-24'),(1043,1,13,1,'2025-02-04'),(1044,1,13,3,'2025-02-28'),(1045,1,1,3,'2025-01-21'),(1046,2,8,1,'2025-01-08'),(1047,2,15,2,'2025-02-26'),(1048,2,14,2,'2025-01-16'),(1049,2,1,1,'2025-02-26'),(1050,2,10,1,'2025-01-06'),(1051,2,12,2,'2025-02-22'),(1052,2,2,3,'2025-02-19'),(1053,2,3,1,'2025-02-12'),(1054,2,8,3,'2025-01-11'),(1055,2,5,3,'2025-02-25'),(1056,2,10,2,'2025-01-14'),(1057,2,15,3,'2025-02-18'),(1058,2,12,3,'2025-01-13'),(1059,2,12,2,'2025-01-26'),(1060,2,11,3,'2025-01-24'),(1061,2,8,3,'2025-01-29'),(1062,2,2,1,'2025-01-15'),(1063,2,2,2,'2025-01-02'),(1064,2,10,3,'2025-01-15'),(1065,2,10,1,'2025-01-01'),(1066,2,2,3,'2025-02-10'),(1067,2,1,1,'2025-01-05'),(1068,2,15,1,'2025-02-25'),(1069,2,6,1,'2025-02-02'),(1070,2,4,2,'2025-02-12'),(1071,3,8,1,'2025-02-04'),(1072,3,3,3,'2025-03-01'),(1073,3,15,3,'2025-02-06'),(1074,3,8,1,'2025-02-20'),(1075,3,8,2,'2025-01-13'),(1076,3,2,1,'2025-02-12'),(1077,3,7,2,'2025-01-28'),(1078,3,7,2,'2025-02-25'),(1079,3,12,1,'2025-02-13'),(1080,3,11,3,'2025-01-07'),(1081,3,1,2,'2025-02-16'),(1082,3,6,1,'2025-01-16'),(1083,3,4,1,'2025-02-04'),(1084,3,8,1,'2025-01-28'),(1085,3,3,2,'2025-01-30'),(1086,3,4,1,'2025-01-29'),(1087,3,13,3,'2025-01-07'),(1088,3,1,3,'2025-02-04'),(1089,3,14,1,'2025-01-06'),(1090,3,15,1,'2025-01-11'),(1091,3,7,2,'2025-01-31'),(1092,3,4,2,'2025-02-27'),(1093,3,1,1,'2025-01-25'),(1094,3,1,2,'2025-01-17'),(1095,3,15,2,'2025-01-19'),(1096,3,7,3,'2025-02-16'),(1097,3,13,3,'2025-02-12'),(1098,3,12,2,'2025-01-10'),(1099,3,4,2,'2025-01-14'),(1100,3,1,3,'2025-02-17'),(1101,4,9,1,'2025-02-17'),(1102,4,6,1,'2025-01-04'),(1103,4,10,2,'2025-02-02'),(1104,4,15,3,'2025-01-11'),(1105,4,1,3,'2025-01-06'),(1106,4,14,1,'2025-01-05'),(1107,4,10,1,'2025-02-13'),(1108,4,14,1,'2025-01-26'),(1109,4,2,3,'2025-01-16'),(1110,4,10,3,'2025-01-03'),(1111,4,10,1,'2025-01-27'),(1112,4,11,3,'2025-02-06'),(1113,4,9,2,'2025-03-01'),(1114,4,5,1,'2025-02-12'),(1115,4,12,2,'2025-01-16'),(1116,4,5,2,'2025-01-09'),(1117,4,11,3,'2025-01-20'),(1118,4,8,2,'2025-03-01'),(1119,4,13,1,'2025-01-01'),(1120,4,8,3,'2025-02-06'),(1121,5,2,1,'2025-02-04'),(1122,5,4,3,'2025-01-17'),(1123,5,3,2,'2025-02-26'),(1124,5,2,1,'2025-01-24'),(1125,5,5,1,'2025-01-29'),(1126,5,14,3,'2025-02-15'),(1127,5,5,3,'2025-02-21'),(1128,5,11,3,'2025-01-01'),(1129,5,11,3,'2025-01-20'),(1130,5,15,3,'2025-01-07'),(1131,5,15,1,'2025-01-17'),(1132,5,2,1,'2025-02-17'),(1133,5,9,1,'2025-01-18'),(1134,5,5,3,'2025-01-14'),(1135,5,12,2,'2025-01-14'),(1136,5,11,3,'2025-02-24'),(1137,5,5,3,'2025-02-01'),(1138,5,5,1,'2025-01-06'),(1139,5,11,2,'2025-02-23'),(1140,5,5,1,'2025-01-01'),(1141,5,6,1,'2025-02-10'),(1142,5,5,1,'2025-02-17'),(1143,5,8,3,'2025-02-15'),(1144,5,7,3,'2025-01-01'),(1145,5,2,1,'2025-03-02'),(1146,5,15,3,'2025-02-27'),(1147,5,3,3,'2025-01-03'),(1148,5,14,2,'2025-02-07'),(1149,5,9,1,'2025-01-28'),(1150,5,3,1,'2025-01-20');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-01 22:38:15
