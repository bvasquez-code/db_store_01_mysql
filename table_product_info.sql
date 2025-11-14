DROP TABLE IF EXISTS `product_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_info` (
  `ProductCod` varchar(20) NOT NULL,
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000'),
  `StoreCod` varchar(4) NOT NULL,
  `NumDigitalStock` int DEFAULT '0',
  `NumPhysicalStock` int DEFAULT '0',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`ProductCod`,`Variant`,`StoreCod`),
  KEY `fk_product_info_store` (`StoreCod`),
  CONSTRAINT `fk_product_info_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_product_info_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`),
  CONSTRAINT `fk_product_info_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_info_warehouse`
--
