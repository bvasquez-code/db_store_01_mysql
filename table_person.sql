DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `PersonCod` varchar(16) NOT NULL COMMENT 'codigo de persona',
  `PersonType` char(2) NOT NULL COMMENT 'tipo de persona',
  `DocumentType` char(2) NOT NULL COMMENT 'tipo de documento',
  `DocumentNum` varchar(16) NOT NULL COMMENT 'Numero de documento de identidad',
  `Names` varchar(128) NOT NULL COMMENT 'Nombres',
  `LastNames` varchar(128) NOT NULL COMMENT 'Apellidos',
  `UbigeoCod` varchar(12) DEFAULT NULL COMMENT 'codigo de ubigeo',
  `Phone` varchar(20) DEFAULT NULL COMMENT 'Telefono',
  `CellPhone` varchar(20) DEFAULT NULL COMMENT 'Telefono celular',
  `Email` varchar(32) DEFAULT NULL COMMENT 'Email',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PersonCod`),
  UNIQUE KEY `idx_person_uniqper` (`DocumentType`,`DocumentNum`),
  KEY `idx_person_docnum` (`DocumentNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `presale_det`
--
