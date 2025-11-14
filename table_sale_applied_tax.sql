DROP TABLE IF EXISTS `sale_applied_tax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_applied_tax` (
  `TaxCod` varchar(8) NOT NULL COMMENT 'codigo de impuesto',
  `SaleCod` varchar(16) NOT NULL COMMENT 'codigo de venta',
  `TaxRateValue` decimal(16,4) NOT NULL COMMENT 'valor porcentual sobre 100 del impuesto',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`TaxCod`,`SaleCod`),
  KEY `fk_sale_applied_tax_sale` (`SaleCod`),
  CONSTRAINT `fk_sale_applied_tax_sale` FOREIGN KEY (`SaleCod`) REFERENCES `sale_head` (`SaleCod`),
  CONSTRAINT `fk_sale_applied_tax_tax` FOREIGN KEY (`TaxCod`) REFERENCES `tax` (`TaxCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sale_det`
--
