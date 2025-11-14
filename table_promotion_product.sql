DROP TABLE IF EXISTS `promotion_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_product` (
  `PromotionCod` char(6) NOT NULL COMMENT 'codigo de promocion',
  `ProductCod` varchar(20) NOT NULL COMMENT 'codigo de producto',
  `PositionPackage` int NOT NULL COMMENT 'Posicion dentro del grupo',
  `Package` int NOT NULL COMMENT 'Grupo',
  `TypeDiscount` char(1) NOT NULL COMMENT '(P:Porcentaje)(F:Precio fijo)',
  `DiscountAmount` decimal(16,2) DEFAULT '0.00',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PromotionCod`,`ProductCod`,`PositionPackage`,`Package`),
  KEY `fk_promotion_product_product` (`ProductCod`),
  CONSTRAINT `fk_promotion_product_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_promotion_product_promotion` FOREIGN KEY (`PromotionCod`) REFERENCES `promotion` (`PromotionCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion_store`
--
