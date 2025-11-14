DROP TABLE IF EXISTS `tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax` (
  `TaxCod` varchar(8) NOT NULL COMMENT 'codigo de impuesto',
  `TaxRateValue` decimal(16,4) NOT NULL COMMENT 'valor porcentual sobre 100 del impuesto',
  `Name` varchar(32) NOT NULL COMMENT 'nombre del impuesto',
  `Description` varchar(64) NOT NULL COMMENT 'descripcion del impuesto',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`TaxCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trx_payments`
--
