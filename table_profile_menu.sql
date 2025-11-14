DROP TABLE IF EXISTS `profile_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile_menu` (
  `ProfileCod` varchar(8) NOT NULL,
  `MenuCod` varchar(8) NOT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`ProfileCod`,`MenuCod`),
  KEY `fk_product_search_menu` (`MenuCod`),
  CONSTRAINT `fk_product_search_menu` FOREIGN KEY (`MenuCod`) REFERENCES `app_menu` (`MenuCod`),
  CONSTRAINT `fk_profile_menu_profile` FOREIGN KEY (`ProfileCod`) REFERENCES `app_profile` (`ProfileCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion`
--
