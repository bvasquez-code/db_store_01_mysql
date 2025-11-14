DROP TABLE IF EXISTS `presale_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presale_det` (
  `PresaleCod` varchar(16) NOT NULL COMMENT 'codigo de preventa',
  `ProductCod` varchar(20) NOT NULL COMMENT 'codigo de producto',
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'codigo de variante',
  `NumUnit` int DEFAULT NULL COMMENT 'Numero de unidades',
  `NumUnitPrice` decimal(16,2) DEFAULT NULL COMMENT 'Precio unitario',
  `NumDiscount` decimal(16,2) DEFAULT NULL COMMENT 'descuento',
  `NumUnitPriceSale` decimal(16,2) DEFAULT NULL COMMENT 'Precio unitario de venta final',
  `NumTotalPrice` decimal(16,2) DEFAULT NULL COMMENT 'Precio Total',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PresaleCod`,`ProductCod`,`Variant`),
  KEY `fk_presale_det_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_presale_det_presale_head` FOREIGN KEY (`PresaleCod`) REFERENCES `presale_head` (`PresaleCod`),
  CONSTRAINT `fk_presale_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_presale_det_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `presale_det_warehouse`
--
