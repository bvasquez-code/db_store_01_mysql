DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `Name` varchar(32) NOT NULL COMMENT 'nombre de tienda',
  `Description` varchar(128) DEFAULT NULL COMMENT 'descripcion de tienda',
  `Address` varchar(128) DEFAULT NULL COMMENT 'direccion',
  `UbigeoCod` varchar(12) DEFAULT NULL COMMENT 'codigo de ubigeo',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `CompanyCod` varchar(4) DEFAULT NULL COMMENT 'CÃ³digo legible de la empresa (FK => company.CompanyCod).',
  PRIMARY KEY (`StoreCod`),
  KEY `idx_store_companycod` (`CompanyCod`),
  CONSTRAINT `fk_store_company` FOREIGN KEY (`CompanyCod`) REFERENCES `company` (`CompanyCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store_sequence`
--
