DROP TABLE IF EXISTS `sale_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_document` (
  `DocumentCod` varchar(32) NOT NULL COMMENT 'codigo de documento',
  `CounterfoilCod` char(6) NOT NULL COMMENT 'codigo talonario',
  `SaleCod` varchar(16) NOT NULL COMMENT 'codigo de venta',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`DocumentCod`,`SaleCod`),
  KEY `fk_sale_document_sale` (`SaleCod`),
  CONSTRAINT `fk_sale_document_sale` FOREIGN KEY (`SaleCod`) REFERENCES `sale_head` (`SaleCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sale_head`
--
