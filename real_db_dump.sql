-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: dbproject
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `BANK` char(40) NOT NULL,
  `ID_Member` char(40) NOT NULL,
  `ACCOUNT` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Account_Member1_idx` (`ID_Member`),
  CONSTRAINT `Account_Member_ID_fk` FOREIGN KEY (`ID_Member`) REFERENCES `member` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concert`
--

DROP TABLE IF EXISTS `concert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concert` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `NAME` char(255) NOT NULL,
  `ARTIST` char(40) NOT NULL,
  `PLACE` char(255) NOT NULL,
  `DATE` datetime NOT NULL,
  `IMAGE` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`NUM`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concert`
--

LOCK TABLES `concert` WRITE;
/*!40000 ALTER TABLE `concert` DISABLE KEYS */;
INSERT INTO `concert` VALUES (1,'2022 IU CONCERT 〈The Golden Hour：오렌지 태양 아래〉','아이유','잠실종합운동장 올림픽주경기장','2022-09-17 19:00:00','https://cdnticket.melon.co.kr/resource/image/upload/product/2022/08/2022081115003052ef3ded-81f4-450b-8a60-3e0444da6d9f.jpg/melon/resize/180x254/strip/true/quality/90/optimize'),(2,'2024 IU HEREH WORLD TOUR CONCERT ENCORE：THE WINNING','아이유','KSPO DOME','2024-09-22 19:00:00','https://cdnticket.melon.co.kr/resource/image/upload/product/2024/08/20240809152954b0985229-8185-4d74-acbc-8805018fc7c2.jpg/melon/resize/180x254/strip/true/quality/90/optimize'),(3,'2024 윤하 20주년 기념 콘서트 〈스물〉','윤하','KSPO DOME','2024-02-04 17:00:00','https://ticketimage.interpark.com/Play/image/large/23/23018640_p.gif'),(4,'2024 윤하 소극장 콘서트 ［潤夏］','윤하','블루스퀘어 마스터카드홀','2024-07-10 20:00:00','https://ticketimage.interpark.com/Play/image/large/24/24007846_p.gif'),(5,'2024 윤하 연말 콘서트 〈GROWTH THEORY〉','윤하','KSPO DOME','2024-11-17 18:00:00','https://ticketimage.interpark.com/Play/image/large/24/24013649_p.gif');
/*!40000 ALTER TABLE `concert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concert_detail`
--

DROP TABLE IF EXISTS `concert_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concert_detail` (
  `NUM_Seat` char(40) NOT NULL,
  `CLASS_Seat` char(40) NOT NULL,
  `PRICE` int NOT NULL,
  `RESERVATION` tinyint(1) NOT NULL,
  `NUM_Concert` int NOT NULL,
  KEY `fk_Concert_Detail_Concert_idx` (`NUM_Concert`),
  KEY `idx_num_seat` (`NUM_Seat`),
  CONSTRAINT `Concert_Detail_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `concert` (`NUM`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concert_detail`
--

LOCK TABLES `concert_detail` WRITE;
/*!40000 ALTER TABLE `concert_detail` DISABLE KEYS */;
INSERT INTO `concert_detail` VALUES ('A01','VIP',200000,0,1),('A01','VIP',180000,0,2),('A01','VIP',220000,0,3),('A01','VIP',190000,0,4),('A01','VIP',250000,0,5),('A02','VIP',200000,0,1),('A02','VIP',180000,0,2),('A02','VIP',220000,0,3),('A02','VIP',190000,0,4),('A02','VIP',250000,0,5),('A03','VIP',200000,0,1),('A03','VIP',180000,0,2),('A03','VIP',220000,0,3),('A03','VIP',190000,0,4),('A03','VIP',250000,0,5),('A04','VIP',200000,0,1),('A04','VIP',180000,0,2),('A04','VIP',220000,0,3),('A04','VIP',190000,0,4),('A04','VIP',250000,0,5),('A05','VIP',200000,0,1),('A05','VIP',180000,0,2),('A05','VIP',220000,0,3),('A05','VIP',190000,0,4),('A05','VIP',250000,0,5),('A06','VIP',200000,0,1),('A06','VIP',180000,0,2),('A06','VIP',220000,0,3),('A06','VIP',190000,0,4),('A06','VIP',250000,0,5),('A07','VIP',200000,0,1),('A07','VIP',180000,0,2),('A07','VIP',220000,0,3),('A07','VIP',190000,0,4),('A07','VIP',250000,0,5),('A08','VIP',200000,0,1),('A08','VIP',180000,0,2),('A08','VIP',220000,0,3),('A08','VIP',190000,0,4),('A08','VIP',250000,0,5),('A09','VIP',200000,0,1),('A09','VIP',180000,0,2),('A09','VIP',220000,0,3),('A09','VIP',190000,0,4),('A09','VIP',250000,0,5),('A10','VIP',200000,0,1),('A10','VIP',180000,0,2),('A10','VIP',220000,0,3),('A10','VIP',190000,0,4),('A10','VIP',250000,0,5),('B01','R',150000,0,1),('B01','R',130000,0,2),('B01','R',170000,0,3),('B01','R',140000,0,4),('B01','R',200000,0,5),('B02','R',150000,0,1),('B02','R',130000,0,2),('B02','R',170000,0,3),('B02','R',140000,0,4),('B02','R',200000,0,5),('B03','R',150000,0,1),('B03','R',130000,0,2),('B03','R',170000,0,3),('B03','R',140000,0,4),('B03','R',200000,0,5),('B04','R',150000,0,1),('B04','R',130000,0,2),('B04','R',170000,0,3),('B04','R',140000,0,4),('B04','R',200000,0,5),('B05','R',150000,0,1),('B05','R',130000,0,2),('B05','R',170000,0,3),('B05','R',140000,0,4),('B05','R',200000,0,5),('B06','R',150000,0,1),('B06','R',130000,0,2),('B06','R',170000,0,3),('B06','R',140000,0,4),('B06','R',200000,0,5),('B07','R',150000,0,1),('B07','R',130000,0,2),('B07','R',170000,0,3),('B07','R',140000,0,4),('B07','R',200000,0,5),('B08','R',150000,0,1),('B08','R',130000,0,2),('B08','R',170000,0,3),('B08','R',140000,0,4),('B08','R',200000,0,5),('B09','R',150000,0,1),('B09','R',130000,0,2),('B09','R',170000,0,3),('B09','R',140000,0,4),('B09','R',200000,0,5),('B10','R',150000,0,1),('B10','R',130000,0,2),('B10','R',170000,0,3),('B10','R',140000,0,4),('B10','R',200000,0,5),('C01','S',100000,0,1),('C01','S',80000,0,2),('C01','S',120000,0,3),('C01','S',90000,0,4),('C01','S',150000,0,5),('C02','S',100000,0,1),('C02','S',80000,0,2),('C02','S',120000,0,3),('C02','S',90000,0,4),('C02','S',150000,0,5),('C03','S',100000,0,1),('C03','S',80000,0,2),('C03','S',120000,0,3),('C03','S',90000,0,4),('C03','S',150000,0,5),('C04','S',100000,0,1),('C04','S',80000,0,2),('C04','S',120000,0,3),('C04','S',90000,0,4),('C04','S',150000,0,5),('C05','S',100000,0,1),('C05','S',80000,0,2),('C05','S',120000,0,3),('C05','S',90000,0,4),('C05','S',150000,0,5),('C06','S',100000,0,1),('C06','S',80000,0,2),('C06','S',120000,0,3),('C06','S',90000,0,4),('C06','S',150000,0,5),('C07','S',100000,0,1),('C07','S',80000,0,2),('C07','S',120000,0,3),('C07','S',90000,0,4),('C07','S',150000,0,5),('C08','S',100000,0,1),('C08','S',80000,0,2),('C08','S',120000,0,3),('C08','S',90000,0,4),('C08','S',150000,0,5),('C09','S',100000,0,1),('C09','S',80000,0,2),('C09','S',120000,0,3),('C09','S',90000,0,4),('C09','S',150000,0,5),('C10','S',100000,0,1),('C10','S',80000,0,2),('C10','S',120000,0,3),('C10','S',90000,0,4),('C10','S',150000,0,5),('D01','A',50000,0,1),('D01','A',40000,0,2),('D01','A',60000,0,3),('D01','A',50000,0,4),('D01','A',80000,0,5),('D02','A',50000,0,1),('D02','A',40000,0,2),('D02','A',60000,0,3),('D02','A',50000,0,4),('D02','A',80000,0,5),('D03','A',50000,0,1),('D03','A',40000,0,2),('D03','A',60000,0,3),('D03','A',50000,0,4),('D03','A',80000,0,5),('D04','A',50000,0,1),('D04','A',40000,0,2),('D04','A',60000,0,3),('D04','A',50000,0,4),('D04','A',80000,0,5),('D05','A',50000,0,1),('D05','A',40000,0,2),('D05','A',60000,0,3),('D05','A',50000,0,4),('D05','A',80000,0,5),('D06','A',50000,0,1),('D06','A',40000,0,2),('D06','A',60000,0,3),('D06','A',50000,0,4),('D06','A',80000,0,5),('D07','A',50000,0,1),('D07','A',40000,0,2),('D07','A',60000,0,3),('D07','A',50000,0,4),('D07','A',80000,0,5),('D08','A',50000,0,1),('D08','A',40000,0,2),('D08','A',60000,0,3),('D08','A',50000,0,4),('D08','A',80000,0,5),('D09','A',50000,0,1),('D09','A',40000,0,2),('D09','A',60000,0,3),('D09','A',50000,0,4),('D09','A',80000,0,5),('D10','A',50000,0,1),('D10','A',40000,0,2),('D10','A',60000,0,3),('D10','A',50000,0,4),('D10','A',80000,0,5),('E01','B',30000,0,1),('E01','B',20000,0,2),('E01','B',35000,0,3),('E01','B',30000,0,4),('E01','B',40000,0,5),('E02','B',30000,0,1),('E02','B',20000,0,2),('E02','B',35000,0,3),('E02','B',30000,0,4),('E02','B',40000,0,5),('E03','B',30000,0,1),('E03','B',20000,0,2),('E03','B',35000,0,3),('E03','B',30000,0,4),('E03','B',40000,0,5),('E04','B',30000,0,1),('E04','B',20000,0,2),('E04','B',35000,0,3),('E04','B',30000,0,4),('E04','B',40000,0,5),('E05','B',30000,0,1),('E05','B',20000,0,2),('E05','B',35000,0,3),('E05','B',30000,0,4),('E05','B',40000,0,5),('E06','B',30000,0,1),('E06','B',20000,0,2),('E06','B',35000,0,3),('E06','B',30000,0,4),('E06','B',40000,0,5),('E07','B',30000,0,1),('E07','B',20000,0,2),('E07','B',35000,0,3),('E07','B',30000,0,4),('E07','B',40000,0,5),('E08','B',30000,0,1),('E08','B',20000,0,2),('E08','B',35000,0,3),('E08','B',30000,0,4),('E08','B',40000,0,5),('E09','B',30000,0,1),('E09','B',20000,0,2),('E09','B',35000,0,3),('E09','B',30000,0,4),('E09','B',40000,0,5),('E10','B',30000,0,1),('E10','B',20000,0,2),('E10','B',35000,0,3),('E10','B',30000,0,4),('E10','B',40000,0,5);
/*!40000 ALTER TABLE `concert_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
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
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES ('asdf','asdf','1234','','','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_exchange`
--

DROP TABLE IF EXISTS `member_exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_exchange` (
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
-- Dumping data for table `member_exchange`
--

LOCK TABLES `member_exchange` WRITE;
/*!40000 ALTER TABLE `member_exchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_exchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_orders`
--

DROP TABLE IF EXISTS `member_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_orders` (
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
  CONSTRAINT `Member_Orders_Concert_Detail_NUM_Seat_fk` FOREIGN KEY (`NUM_Seat`) REFERENCES `concert_detail` (`NUM_Seat`),
  CONSTRAINT `Member_Orders_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `concert` (`NUM`),
  CONSTRAINT `Member_Orders_Member_ID_fk` FOREIGN KEY (`ID_Member`) REFERENCES `member` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_orders`
--

LOCK TABLES `member_orders` WRITE;
/*!40000 ALTER TABLE `member_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_refund`
--

DROP TABLE IF EXISTS `member_refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_refund` (
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
-- Dumping data for table `member_refund`
--

LOCK TABLES `member_refund` WRITE;
/*!40000 ALTER TABLE `member_refund` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_refund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `non_member`
--

DROP TABLE IF EXISTS `non_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `non_member` (
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
-- Dumping data for table `non_member`
--

LOCK TABLES `non_member` WRITE;
/*!40000 ALTER TABLE `non_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `non_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `non_member_exchange`
--

DROP TABLE IF EXISTS `non_member_exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `non_member_exchange` (
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
-- Dumping data for table `non_member_exchange`
--

LOCK TABLES `non_member_exchange` WRITE;
/*!40000 ALTER TABLE `non_member_exchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `non_member_exchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `non_member_orders`
--

DROP TABLE IF EXISTS `non_member_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `non_member_orders` (
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
  CONSTRAINT `Non_Member_Orders_Concert_Detail_NUM_Seat_fk` FOREIGN KEY (`NUM_Seat`) REFERENCES `concert_detail` (`NUM_Seat`),
  CONSTRAINT `Non_Member_Orders_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `concert` (`NUM`),
  CONSTRAINT `Non_Member_Orders_Non_Member_PHONE_fk` FOREIGN KEY (`PHONE_Non_Member`) REFERENCES `non_member` (`PHONE`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `non_member_orders`
--

LOCK TABLES `non_member_orders` WRITE;
/*!40000 ALTER TABLE `non_member_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `non_member_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `non_member_refund`
--

DROP TABLE IF EXISTS `non_member_refund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `non_member_refund` (
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
-- Dumping data for table `non_member_refund`
--

LOCK TABLES `non_member_refund` WRITE;
/*!40000 ALTER TABLE `non_member_refund` DISABLE KEYS */;
/*!40000 ALTER TABLE `non_member_refund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `NUM` int NOT NULL AUTO_INCREMENT,
  `ID_Member` char(40) NOT NULL,
  `NUM_Concert` int NOT NULL,
  `NUM_Seat` char(40) NOT NULL,
  PRIMARY KEY (`NUM`),
  KEY `fk_Wishlist_Member1_idx` (`ID_Member`),
  KEY `fk_Wishlist_Concert1_idx` (`NUM_Concert`),
  KEY `NUM_Seat_idx` (`NUM_Seat`),
  CONSTRAINT `Wishlist_Concert_Detail_NUM_Seat_fk` FOREIGN KEY (`NUM_Seat`) REFERENCES `concert_detail` (`NUM_Seat`),
  CONSTRAINT `Wishlist_Concert_NUM_fk` FOREIGN KEY (`NUM_Concert`) REFERENCES `concert` (`NUM`),
  CONSTRAINT `Wishlist_Member_ID_fk` FOREIGN KEY (`ID_Member`) REFERENCES `member` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-25 14:25:09
