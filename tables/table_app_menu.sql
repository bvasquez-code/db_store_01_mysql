DROP TABLE IF EXISTS `app_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_menu` (
  `MenuCod` varchar(8) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Description` varchar(128) DEFAULT NULL,
  `IsMenuDad` char(1) NOT NULL,
  `MenuDadCod` varchar(8) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`MenuCod`),
  KEY `idx_app_menu_dad` (`MenuDadCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_profile`
--
