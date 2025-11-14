DROP TABLE IF EXISTS `credit_note_det_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_note_det_warehouse` (
  `CreditNoteCod` varchar(16) NOT NULL COMMENT 'codigo de nota de credito',
  `ProductCod` varchar(20) NOT NULL COMMENT 'codigo de producto',
  `Variant` varchar(4) NOT NULL DEFAULT '0000' COMMENT 'codigo de variante',
  `WarehouseCod` varchar(8) NOT NULL COMMENT 'codigo de almacen',
  `NumUnit` int DEFAULT NULL COMMENT 'Numero de unidades devueltas al almacen',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`CreditNoteCod`,`ProductCod`,`Variant`,`WarehouseCod`),
  KEY `fk_credit_note_det_warehouse_warehouse` (`WarehouseCod`),
  KEY `fk_credit_note_det_warehouse_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_credit_note_det_warehouse_credit_head` FOREIGN KEY (`CreditNoteCod`) REFERENCES `credit_note_head` (`CreditNoteCod`),
  CONSTRAINT `fk_credit_note_det_warehouse_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_credit_note_det_warehouse_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`),
  CONSTRAINT `fk_credit_note_det_warehouse_warehouse` FOREIGN KEY (`WarehouseCod`) REFERENCES `warehouse` (`WarehouseCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `credit_note_document`
--
