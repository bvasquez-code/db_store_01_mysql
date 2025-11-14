DROP TABLE IF EXISTS `pucharse_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pucharse_det` (
  `PucharseCod` varchar(16) NOT NULL,
  `ProductCod` varchar(20) NOT NULL,
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000'),
  `NumUnit` int DEFAULT NULL,
  `NumUnitPrice` decimal(16,2) DEFAULT NULL,
  `NumTotalPrice` decimal(16,2) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `IsKardexAffected` char(1) DEFAULT 'N',
  `NumUnitDelivered` int DEFAULT '0',
  PRIMARY KEY (`PucharseCod`,`ProductCod`,`Variant`),
  KEY `fk_pucharse_det_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_pucharse_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_pucharse_det_pucharse_head` FOREIGN KEY (`PucharseCod`) REFERENCES `pucharse_head` (`PucharseCod`),
  CONSTRAINT `fk_pucharse_det_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pucharse_det_delivery`
--
