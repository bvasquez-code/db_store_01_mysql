DROP TABLE IF EXISTS `app_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_session` (
  `SessionID` bigint NOT NULL AUTO_INCREMENT,
  `UserCod` varchar(16) NOT NULL,
  `Token` varchar(256) NOT NULL,
  `SessionOjb` text,
  `DeleteDate` datetime DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`SessionID`),
  KEY `fk_app_session_app_user` (`UserCod`),
  KEY `idx_app_session_Token` (`Token`),
  CONSTRAINT `fk_app_session_app_user` FOREIGN KEY (`UserCod`) REFERENCES `app_user` (`UserCod`)
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_session_history`
--
