DROP TABLE IF EXISTS `product_barcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_barcode` (
  `ProductCod` varchar(20) NOT NULL,
  `BarCode` varchar(20) NOT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`BarCode`),
  KEY `fk_product_product_barcode` (`ProductCod`),
  CONSTRAINT `fk_product_product_barcode` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config`
--
