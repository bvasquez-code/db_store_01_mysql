DROP TABLE IF EXISTS `promotion_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_store` (
  `PromotionCod` char(6) NOT NULL COMMENT 'codigo de promocion',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PromotionCod`,`StoreCod`),
  KEY `fk_promotion_store_store` (`StoreCod`),
  CONSTRAINT `fk_promotion_store_promotion` FOREIGN KEY (`PromotionCod`) REFERENCES `promotion` (`PromotionCod`),
  CONSTRAINT `fk_promotion_store_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pucharse_det`
--
