DROP TABLE IF EXISTS `kardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kardex` (
  `kardexID` bigint NOT NULL AUTO_INCREMENT,
  `OperationCod` varchar(16) NOT NULL COMMENT 'Codigo de operacion',
  `SourceTable` varchar(20) NOT NULL COMMENT 'Tabla origen',
  `TypeOperation` char(1) NOT NULL COMMENT 'tipo de operacion',
  `ProductCod` varchar(20) NOT NULL COMMENT 'Codigo de producto',
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'Codigo de variante',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `WarehouseCod` varchar(8) NOT NULL COMMENT 'codigo de alamacen',
  `NumStockBefore` int DEFAULT NULL,
  `NumStockMoved` int DEFAULT NULL,
  `NumStockAfter` int DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `TypeOperationCod` int DEFAULT NULL,
  PRIMARY KEY (`kardexID`),
  KEY `fk_kardex_variant` (`ProductCod`,`Variant`),
  KEY `fk_kardex_store` (`StoreCod`),
  KEY `fk_kardex_warehouse` (`WarehouseCod`),
  KEY `idx_kardex_table` (`SourceTable`,`OperationCod`),
  CONSTRAINT `fk_kardex_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_kardex_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`),
  CONSTRAINT `fk_kardex_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`),
  CONSTRAINT `fk_kardex_warehouse` FOREIGN KEY (`WarehouseCod`) REFERENCES `warehouse` (`WarehouseCod`)
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_method`
--
