DROP TABLE IF EXISTS `sale_det_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_det_warehouse` (
  `SaleCod` varchar(16) NOT NULL COMMENT 'codigo de venta',
  `ProductCod` varchar(20) NOT NULL COMMENT 'codigo de producto',
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'codigo de variante',
  `WarehouseCod` varchar(8) NOT NULL COMMENT 'codigo de almacen',
  `NumUnit` int DEFAULT NULL COMMENT 'Numero de unidades',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`SaleCod`,`ProductCod`,`Variant`,`WarehouseCod`),
  KEY `fk_sale_det_warehouse_warehouse` (`WarehouseCod`),
  KEY `fk_sale_det_warehouse_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_sale_det_warehouse_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_sale_det_warehouse_sale` FOREIGN KEY (`SaleCod`) REFERENCES `sale_head` (`SaleCod`),
  CONSTRAINT `fk_sale_det_warehouse_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`),
  CONSTRAINT `fk_sale_det_warehouse_warehouse` FOREIGN KEY (`WarehouseCod`) REFERENCES `warehouse` (`WarehouseCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sale_document`
--
