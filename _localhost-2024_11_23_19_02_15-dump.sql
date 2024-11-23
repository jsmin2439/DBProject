-- MySQL dump 10.13  Distrib 9.0.1, for macos13.6 (x86_64)
--
-- Host: 127.0.0.1    Database: DBProject
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Account` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `BANK` char(40) NOT NULL,
  `ID_Member` char(40) NOT NULL,
  `ACCOUNT` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Account_Member1_idx` (`ID_Member`),
  CONSTRAINT `Account_Member_ID_fk` FOREIGN KEY (`ID_Member`) REFERENCES `Member` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO `Account` VALUES (12,'ewsa','1234','2314124');
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `ID` char(40) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Concert`
--

DROP TABLE IF EXISTS `Concert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Concert` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `NAME` char(40) NOT NULL,
  `ARTIST` char(40) NOT NULL,
  `PLACE` char(255) NOT NULL,
  `DATE` datetime NOT NULL,
  PRIMARY KEY (`NUM`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Concert`
--

LOCK TABLES `Concert` WRITE;
/*!40000 ALTER TABLE `Concert` DISABLE KEYS */;
INSERT INTO `Concert` VALUES (1,'레 미제라블','뮤지컬 캐스트','서울 예술의 전당','2024-12-01 00:00:00'),(2,'아이유 앙코르','아이유','고척 스카이돔','2024-12-15 00:00:00'),(3,'햄릿','국립극단','대학로 예술극장','2024-11-30 00:00:00'),(4,'백조의 호수','국립발레단','대구 오페라하우스','2024-12-20 00:00:00'),(5,'방탄소년단 월드투어','방탄소년단','부산 아시아드 경기장','2024-12-25 00:00:00');
/*!40000 ALTER TABLE `Concert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Concert_Detail`
--

DROP TABLE IF EXISTS `Concert_Detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Concert_Detail` (
  `NUM_Seat` char(40) NOT NULL,
  `CLASS_Seat` char(40) NOT NULL,
  `PRICE` int NOT NULL,
  `RESERVATION` tinyint(1) NOT NULL,
  `NUM_Concert` int NOT NULL,
  KEY `fk_Concert_Detail_Concert_idx` (`NUM_Concert`),
  KEY `idx_num_seat` (`NUM_Seat`),
  CONSTRAINT `Concert_Detail_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `Concert` (`NUM`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Concert_Detail`
--

LOCK TABLES `Concert_Detail` WRITE;
/*!40000 ALTER TABLE `Concert_Detail` DISABLE KEYS */;
INSERT INTO `Concert_Detail` VALUES ('A01','VIP',200000,0,1),('A02','VIP',200000,0,1),('A03','VIP',200000,0,1),('A04','VIP',200000,0,1),('A05','VIP',200000,0,1),('A06','VIP',200000,0,1),('A07','VIP',200000,0,1),('A08','VIP',200000,0,1),('A09','VIP',200000,0,1),('A10','VIP',200000,0,1),('B01','R',150000,0,1),('B02','R',150000,0,1),('B03','R',150000,0,1),('B04','R',150000,0,1),('B05','R',150000,0,1),('B06','R',150000,0,1),('B07','R',150000,0,1),('B08','R',150000,0,1),('B09','R',150000,0,1),('B10','R',150000,0,1),('C01','S',100000,0,1),('C02','S',100000,0,1),('C03','S',100000,0,1),('C04','S',100000,0,1),('C05','S',100000,0,1),('C06','S',100000,0,1),('C07','S',100000,0,1),('C08','S',100000,0,1),('C09','S',100000,0,1),('C10','S',100000,0,1),('D01','A',50000,0,1),('D02','A',50000,0,1),('D03','A',50000,0,1),('D04','A',50000,0,1),('D05','A',50000,0,1),('D06','A',50000,0,1),('D07','A',50000,0,1),('D08','A',50000,0,1),('D09','A',50000,0,1),('D10','A',50000,0,1),('E01','B',30000,0,1),('E02','B',30000,0,1),('E03','B',30000,0,1),('E04','B',30000,0,1),('E05','B',30000,0,1),('E06','B',30000,0,1),('E07','B',30000,0,1),('E08','B',30000,0,1),('E09','B',30000,0,1),('E10','B',30000,0,1),('A01','VIP',200000,0,1),('A02','VIP',200000,0,1),('A03','VIP',200000,0,1),('A04','VIP',200000,0,1),('A05','VIP',200000,0,1),('A06','VIP',200000,0,1),('A07','VIP',200000,0,1),('A08','VIP',200000,0,1),('A09','VIP',200000,0,1),('A10','VIP',200000,0,1),('B01','R',150000,0,1),('B02','R',150000,0,1),('B03','R',150000,0,1),('B04','R',150000,0,1),('B05','R',150000,0,1),('B06','R',150000,0,1),('B07','R',150000,0,1),('B08','R',150000,0,1),('B09','R',150000,0,1),('B10','R',150000,0,1),('C01','S',100000,0,1),('C02','S',100000,0,1),('C03','S',100000,0,1),('C04','S',100000,0,1),('C05','S',100000,0,1),('C06','S',100000,0,1),('C07','S',100000,0,1),('C08','S',100000,0,1),('C09','S',100000,0,1),('C10','S',100000,0,1),('D01','A',50000,0,1),('D02','A',50000,0,1),('D03','A',50000,0,1),('D04','A',50000,0,1),('D05','A',50000,0,1),('D06','A',50000,0,1),('D07','A',50000,0,1),('D08','A',50000,0,1),('D09','A',50000,0,1),('D10','A',50000,0,1),('E01','B',30000,0,1),('E02','B',30000,0,1),('E03','B',30000,0,1),('E04','B',30000,0,1),('E05','B',30000,0,1),('E06','B',30000,0,1),('E07','B',30000,0,1),('E08','B',30000,0,1),('E09','B',30000,0,1),('E10','B',30000,0,1),('A01','VIP',180000,0,2),('A02','VIP',180000,0,2),('A03','VIP',180000,0,2),('A04','VIP',180000,0,2),('A05','VIP',180000,0,2),('A06','VIP',180000,0,2),('A07','VIP',180000,0,2),('A08','VIP',180000,0,2),('A09','VIP',180000,0,2),('A10','VIP',180000,0,2),('B01','R',130000,0,2),('B02','R',130000,0,2),('B03','R',130000,0,2),('B04','R',130000,0,2),('B05','R',130000,0,2),('B06','R',130000,0,2),('B07','R',130000,0,2),('B08','R',130000,0,2),('B09','R',130000,0,2),('B10','R',130000,0,2),('C01','S',80000,0,2),('C02','S',80000,0,2),('C03','S',80000,0,2),('C04','S',80000,0,2),('C05','S',80000,0,2),('C06','S',80000,0,2),('C07','S',80000,0,2),('C08','S',80000,0,2),('C09','S',80000,0,2),('C10','S',80000,0,2),('D01','A',40000,0,2),('D02','A',40000,0,2),('D03','A',40000,0,2),('D04','A',40000,0,2),('D05','A',40000,0,2),('D06','A',40000,0,2),('D07','A',40000,0,2),('D08','A',40000,0,2),('D09','A',40000,0,2),('D10','A',40000,0,2),('E01','B',20000,0,2),('E02','B',20000,0,2),('E03','B',20000,0,2),('E04','B',20000,0,2),('E05','B',20000,0,2),('E06','B',20000,0,2),('E07','B',20000,0,2),('E08','B',20000,0,2),('E09','B',20000,0,2),('E10','B',20000,0,2),('A01','VIP',220000,0,3),('A02','VIP',220000,0,3),('A03','VIP',220000,0,3),('A04','VIP',220000,0,3),('A05','VIP',220000,0,3),('A06','VIP',220000,0,3),('A07','VIP',220000,0,3),('A08','VIP',220000,0,3),('A09','VIP',220000,0,3),('A10','VIP',220000,0,3),('B01','R',170000,0,3),('B02','R',170000,0,3),('B03','R',170000,0,3),('B04','R',170000,0,3),('B05','R',170000,0,3),('B06','R',170000,0,3),('B07','R',170000,0,3),('B08','R',170000,0,3),('B09','R',170000,0,3),('B10','R',170000,0,3),('C01','S',120000,0,3),('C02','S',120000,0,3),('C03','S',120000,0,3),('C04','S',120000,0,3),('C05','S',120000,0,3),('C06','S',120000,0,3),('C07','S',120000,0,3),('C08','S',120000,0,3),('C09','S',120000,0,3),('C10','S',120000,0,3),('D01','A',60000,0,3),('D02','A',60000,0,3),('D03','A',60000,0,3),('D04','A',60000,0,3),('D05','A',60000,0,3),('D06','A',60000,0,3),('D07','A',60000,0,3),('D08','A',60000,0,3),('D09','A',60000,0,3),('D10','A',60000,0,3),('E01','B',35000,0,3),('E02','B',35000,0,3),('E03','B',35000,0,3),('E04','B',35000,0,3),('E05','B',35000,0,3),('E06','B',35000,0,3),('E07','B',35000,0,3),('E08','B',35000,0,3),('E09','B',35000,0,3),('E10','B',35000,0,3),('A01','VIP',190000,0,4),('A02','VIP',190000,0,4),('A03','VIP',190000,0,4),('A04','VIP',190000,0,4),('A05','VIP',190000,0,4),('A06','VIP',190000,0,4),('A07','VIP',190000,0,4),('A08','VIP',190000,0,4),('A09','VIP',190000,0,4),('A10','VIP',190000,0,4),('B01','R',140000,0,4),('B02','R',140000,0,4),('B03','R',140000,0,4),('B04','R',140000,0,4),('B05','R',140000,0,4),('B06','R',140000,0,4),('B07','R',140000,0,4),('B08','R',140000,0,4),('B09','R',140000,0,4),('B10','R',140000,0,4),('C01','S',90000,0,4),('C02','S',90000,0,4),('C03','S',90000,0,4),('C04','S',90000,0,4),('C05','S',90000,0,4),('C06','S',90000,0,4),('C07','S',90000,0,4),('C08','S',90000,0,4),('C09','S',90000,0,4),('C10','S',90000,0,4),('D01','A',50000,0,4),('D02','A',50000,0,4),('D03','A',50000,0,4),('D04','A',50000,0,4),('D05','A',50000,0,4),('D06','A',50000,0,4),('D07','A',50000,0,4),('D08','A',50000,0,4),('D09','A',50000,0,4),('D10','A',50000,0,4),('E01','B',30000,0,4),('E02','B',30000,0,4),('E03','B',30000,0,4),('E04','B',30000,0,4),('E05','B',30000,0,4),('E06','B',30000,0,4),('E07','B',30000,0,4),('E08','B',30000,0,4),('E09','B',30000,0,4),('E10','B',30000,0,4),('A01','VIP',250000,0,5),('A02','VIP',250000,0,5),('A03','VIP',250000,0,5),('A04','VIP',250000,0,5),('A05','VIP',250000,0,5),('A06','VIP',250000,0,5),('A07','VIP',250000,0,5),('A08','VIP',250000,0,5),('A09','VIP',250000,0,5),('A10','VIP',250000,0,5),('B01','R',200000,0,5),('B02','R',200000,0,5),('B03','R',200000,0,5),('B04','R',200000,0,5),('B05','R',200000,0,5),('B06','R',200000,0,5),('B07','R',200000,0,5),('B08','R',200000,0,5),('B09','R',200000,0,5),('B10','R',200000,0,5),('C01','S',150000,0,5),('C02','S',150000,0,5),('C03','S',150000,0,5),('C04','S',150000,0,5),('C05','S',150000,0,5),('C06','S',150000,0,5),('C07','S',150000,0,5),('C08','S',150000,0,5),('C09','S',150000,0,5),('C10','S',150000,0,5),('D01','A',80000,0,5),('D02','A',80000,0,5),('D03','A',80000,0,5),('D04','A',80000,0,5),('D05','A',80000,0,5),('D06','A',80000,0,5),('D07','A',80000,0,5),('D08','A',80000,0,5),('D09','A',80000,0,5),('D10','A',80000,0,5),('E01','B',40000,0,5),('E02','B',40000,0,5),('E03','B',40000,0,5),('E04','B',40000,0,5),('E05','B',40000,0,5),('E06','B',40000,0,5),('E07','B',40000,0,5),('E08','B',40000,0,5),('E09','B',40000,0,5),('E10','B',40000,0,5);
/*!40000 ALTER TABLE `Concert_Detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member`
--

DROP TABLE IF EXISTS `Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member` (
  `ID` char(40) NOT NULL,
  `NAME` char(40) NOT NULL,
  `PHONE` char(40) NOT NULL,
  `ADDRESS` char(255) DEFAULT NULL,
  `POST` char(40) DEFAULT NULL,
  `PASSWORD` char(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member`
--

LOCK TABLES `Member` WRITE;
/*!40000 ALTER TABLE `Member` DISABLE KEYS */;
INSERT INTO `Member` VALUES ('1234','sdf','3241','','','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
/*!40000 ALTER TABLE `Member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member_Exchange`
--

DROP TABLE IF EXISTS `Member_Exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member_Exchange` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `NUM_Member_Orders` int NOT NULL,
  `NUM_Seat` int NOT NULL,
  `PRICE` int NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Member_Exchange_Member_Orders1_idx` (`NUM_Member_Orders`),
  KEY `fk_Member_Exchange_Concert_Detail1_idx` (`NUM_Seat`),
  KEY `fk_Member_Exchange_Concert_Detail2_idx` (`PRICE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member_Exchange`
--

LOCK TABLES `Member_Exchange` WRITE;
/*!40000 ALTER TABLE `Member_Exchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `Member_Exchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member_Orders`
--

DROP TABLE IF EXISTS `Member_Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member_Orders` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `SALEPRICE` int NOT NULL,
  `DATE` datetime NOT NULL,
  `ID_Member` char(40) NOT NULL,
  `NUM_Seat` char(40) NOT NULL,
  `NUM_Concert` int NOT NULL,
  `REFUND` tinyint(1) NOT NULL,
  `EXCHANGE` tinyint(1) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Member_Orders_Member1_idx` (`ID_Member`),
  KEY `fk_Member_Orders_Concert_Detail1_idx` (`NUM_Seat`),
  KEY `NUM_Concert_idx` (`NUM_Concert`),
  CONSTRAINT `Member_Orders_Concert_Detail_NUM_Seat_fk` FOREIGN KEY (`NUM_Seat`) REFERENCES `Concert_Detail` (`NUM_Seat`),
  CONSTRAINT `Member_Orders_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `Concert` (`NUM`),
  CONSTRAINT `Member_Orders_Member_ID_fk` FOREIGN KEY (`ID_Member`) REFERENCES `Member` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member_Orders`
--

LOCK TABLES `Member_Orders` WRITE;
/*!40000 ALTER TABLE `Member_Orders` DISABLE KEYS */;
INSERT INTO `Member_Orders` VALUES (27,200000,'2024-12-15 00:00:00','1234','A01',2,1,0),(28,150000,'2024-11-30 00:00:00','1234','B02',3,1,0),(29,150000,'2024-12-15 00:00:00','1234','B02',2,1,0),(30,150000,'2024-12-15 00:00:00','1234','B03',2,1,0),(31,150000,'2024-11-30 00:00:00','1234','B04',3,1,0),(32,150000,'2024-11-30 00:00:00','1234','B05',3,1,0),(33,150000,'2024-12-15 00:00:00','1234','B02',2,1,0),(34,150000,'2024-11-30 00:00:00','1234','B02',3,1,0),(35,100000,'2024-11-30 00:00:00','1234','C02',3,1,0);
/*!40000 ALTER TABLE `Member_Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member_QnA`
--

DROP TABLE IF EXISTS `Member_QnA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member_QnA` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `QUESTION` varchar(500) NOT NULL,
  `ID_Member` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Member_QnA_Member1_idx` (`ID_Member`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member_QnA`
--

LOCK TABLES `Member_QnA` WRITE;
/*!40000 ALTER TABLE `Member_QnA` DISABLE KEYS */;
/*!40000 ALTER TABLE `Member_QnA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Member_Refund`
--

DROP TABLE IF EXISTS `Member_Refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Member_Refund` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `NUM_Member_Orders` int NOT NULL,
  `NUM_Account` char(40) DEFAULT NULL,
  `Bank_Account` char(40) DEFAULT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Member_Refund_Member_Orders1_idx` (`NUM_Member_Orders`),
  KEY `fk_Member_Refund_Account1_idx` (`NUM_Account`),
  KEY `fk_Member_Refund_Account2_idx` (`Bank_Account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Member_Refund`
--

LOCK TABLES `Member_Refund` WRITE;
/*!40000 ALTER TABLE `Member_Refund` DISABLE KEYS */;
/*!40000 ALTER TABLE `Member_Refund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Non_Member`
--

DROP TABLE IF EXISTS `Non_Member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Non_Member` (
  `PHONE` char(40) NOT NULL,
  `NAME` char(40) NOT NULL,
  `ADDRESS` char(255) DEFAULT NULL,
  `POST` int DEFAULT NULL,
  `ACCOUNT` char(40) DEFAULT NULL,
  `BANK` char(40) DEFAULT NULL,
  PRIMARY KEY (`PHONE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Non_Member`
--

LOCK TABLES `Non_Member` WRITE;
/*!40000 ALTER TABLE `Non_Member` DISABLE KEYS */;
INSERT INTO `Non_Member` VALUES ('010','민종석','',0,'234','ㄴㅁㅇㄹ'),('111','111','',0,'3421','dsf'),('1234','waefa','',0,'',''),('123435','adsgag','',0,'',''),('123456','ㅁㄴㅇㄹ','',0,'',''),('2134','werq','',0,'',''),('2314','agr','',0,'234515','ㄹㅇㅎ'),('234','ㄷㅁㄱㅁㅇㅎ','',0,'',''),('3214','ㄴㅁㅇㄹㅁㄹ','',0,'',''),('341','dsfasd','',0,'',''),('345235','ㅗㅎ러','',0,'',''),('4325234','dfgdsh','',0,'435','ㄱㄷㅈㅅ'),('6585','dfgf','',0,'435','ㄴㅁㅇㄹ');
/*!40000 ALTER TABLE `Non_Member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Non_Member_Exchange`
--

DROP TABLE IF EXISTS `Non_Member_Exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Non_Member_Exchange` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `NUM_Non_Member_Orders` int NOT NULL,
  `NUM_Seat` int NOT NULL,
  `PRICE` int NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Non_Member_Exchange_Non_Member_Orders1_idx` (`NUM_Non_Member_Orders`),
  KEY `fk_Non_Member_Exchange_Concert_Detail1_idx` (`NUM_Seat`),
  KEY `fk_Non_Member_Exchange_Concert_Detail2_idx` (`PRICE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Non_Member_Exchange`
--

LOCK TABLES `Non_Member_Exchange` WRITE;
/*!40000 ALTER TABLE `Non_Member_Exchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `Non_Member_Exchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Non_Member_Orders`
--

DROP TABLE IF EXISTS `Non_Member_Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Non_Member_Orders` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `SALEPRICE` char(40) NOT NULL,
  `DATE` datetime NOT NULL,
  `NUM_Concert` int NOT NULL,
  `PHONE_Non_Member` char(40) NOT NULL,
  `NUM_Seat` char(40) NOT NULL,
  `REFUND` tinyint(1) NOT NULL,
  `EXCHANGE` tinyint(1) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Non_Member_Orders_Concert1_idx` (`NUM_Concert`),
  KEY `fk_Non_Member_Orders_Non_Member1_idx` (`PHONE_Non_Member`),
  KEY `fk_Non_Member_Orders_Concert_Detail1_idx` (`NUM_Seat`),
  CONSTRAINT `Non_Member_Orders_Concert_Detail_NUM_Seat_fk` FOREIGN KEY (`NUM_Seat`) REFERENCES `Concert_Detail` (`NUM_Seat`),
  CONSTRAINT `Non_Member_Orders_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `Concert` (`NUM`),
  CONSTRAINT `Non_Member_Orders_Non_Member_PHONE_fk` FOREIGN KEY (`PHONE_Non_Member`) REFERENCES `Non_Member` (`PHONE`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Non_Member_Orders`
--

LOCK TABLES `Non_Member_Orders` WRITE;
/*!40000 ALTER TABLE `Non_Member_Orders` DISABLE KEYS */;
INSERT INTO `Non_Member_Orders` VALUES (1,'150000','2024-12-15 00:00:00',2,'2314','B03',1,0),(2,'150000','2024-12-15 00:00:00',2,'6585','B04',1,0),(3,'150000','2024-12-15 00:00:00',2,'4325234','B05',1,0),(4,'150000','2024-12-15 00:00:00',2,'010','B06',1,0),(5,'150000','2024-12-15 00:00:00',2,'111','B07',1,0);
/*!40000 ALTER TABLE `Non_Member_Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Non_Member_QnA`
--

DROP TABLE IF EXISTS `Non_Member_QnA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Non_Member_QnA` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `QUESTION` varchar(500) NOT NULL,
  `PHONE_Non_Member` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Non_Member_QnA_Non_Member1_idx` (`PHONE_Non_Member`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Non_Member_QnA`
--

LOCK TABLES `Non_Member_QnA` WRITE;
/*!40000 ALTER TABLE `Non_Member_QnA` DISABLE KEYS */;
/*!40000 ALTER TABLE `Non_Member_QnA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Non_Member_Refund`
--

DROP TABLE IF EXISTS `Non_Member_Refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Non_Member_Refund` (
  `NUM` int NOT NULL,
  `NUM_Non_Member_Orders` int NOT NULL,
  `ACCOUNT_Non_Member` char(40) NOT NULL,
  `BANK_Non_Member` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Non_Member_Refund_Non_Member_Orders1_idx` (`NUM_Non_Member_Orders`),
  KEY `fk_Non_Member_Refund_Non_Member1_idx` (`ACCOUNT_Non_Member`),
  KEY `fk_Non_Member_Refund_Non_Member2_idx` (`BANK_Non_Member`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Non_Member_Refund`
--

LOCK TABLES `Non_Member_Refund` WRITE;
/*!40000 ALTER TABLE `Non_Member_Refund` DISABLE KEYS */;
/*!40000 ALTER TABLE `Non_Member_Refund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `QnA`
--

DROP TABLE IF EXISTS `QnA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `QnA` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `ANSWER` varchar(500) NOT NULL,
  `ID_Member` int DEFAULT NULL,
  `PHONE_Non_Member` char(40) DEFAULT NULL,
  `NUM_Member_QnA` int DEFAULT NULL,
  `NUM_Non_Member_QnA` int DEFAULT NULL,
  `ID_Admin` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_QnA_Member1_idx` (`ID_Member`),
  KEY `fk_QnA_Non_Member1_idx` (`PHONE_Non_Member`),
  KEY `fk_QnA_Member_QnA1_idx` (`NUM_Member_QnA`),
  KEY `fk_QnA_Non_Member_QnA1_idx` (`NUM_Non_Member_QnA`),
  KEY `fk_QnA_Admin1_idx` (`ID_Admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QnA`
--

LOCK TABLES `QnA` WRITE;
/*!40000 ALTER TABLE `QnA` DISABLE KEYS */;
/*!40000 ALTER TABLE `QnA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Wishlist`
--

DROP TABLE IF EXISTS `Wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Wishlist` (
  `NUM` int NOT NULL,
  `ID_Member` int NOT NULL,
  `NUM_Concert` int NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Wishlist_Member1_idx` (`ID_Member`),
  KEY `fk_Wishlist_Concert1_idx` (`NUM_Concert`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Wishlist`
--

LOCK TABLES `Wishlist` WRITE;
/*!40000 ALTER TABLE `Wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `Wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-23 19:02:15
