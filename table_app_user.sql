DROP TABLE IF EXISTS `app_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_user` (
  `UserCod` varchar(16) NOT NULL COMMENT 'Codigo de usuario',
  `PersonCod` varchar(16) NOT NULL COMMENT 'Codigo de persona',
  `Password` varchar(256) NOT NULL COMMENT 'ContraseÃ±a del usuario',
  `Email` varchar(32) NOT NULL COMMENT 'Correo electronico',
  `CreationCode` varchar(8) NOT NULL COMMENT 'Codigo de reversion del usuario',
  `DateExpire` datetime NOT NULL COMMENT 'Fecha de expiracion del usuario',
  `RecoveryCod` varchar(256) DEFAULT NULL COMMENT 'Codigo de recuperacion de cuenta',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `PasswordDecoded` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`UserCod`),
  KEY `idx_app_user_Email` (`Email`),
  KEY `fk_app_user_person` (`PersonCod`),
  CONSTRAINT `fk_app_user_person` FOREIGN KEY (`PersonCod`) REFERENCES `person` (`PersonCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brand`
--
