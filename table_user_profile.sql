DROP TABLE IF EXISTS `user_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profile` (
  `UserCod` varchar(16) NOT NULL COMMENT 'Codigo de usuario',
  `ProfileCod` varchar(8) NOT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`UserCod`,`ProfileCod`),
  KEY `fk_user_profile_profile` (`ProfileCod`),
  CONSTRAINT `fk_user_profile_profile` FOREIGN KEY (`ProfileCod`) REFERENCES `app_profile` (`ProfileCod`),
  CONSTRAINT `fk_user_profile_user` FOREIGN KEY (`UserCod`) REFERENCES `app_user` (`UserCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_store`
--
