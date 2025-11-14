DROP TABLE IF EXISTS `warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse` (
  `WarehouseCod` varchar(8) NOT NULL COMMENT 'codigo de alamcen',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `WarehouseName` varchar(32) NOT NULL COMMENT 'nombre del almacen',
  `WarehouseDesc` varchar(128) NOT NULL COMMENT 'descripcion del almacen',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`WarehouseCod`),
  KEY `fk_warehouse_store` (`StoreCod`),
  CONSTRAINT `fk_warehouse_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
