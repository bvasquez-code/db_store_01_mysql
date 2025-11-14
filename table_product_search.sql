DROP TABLE IF EXISTS `product_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_search` (
  `ProductCod` varchar(20) NOT NULL COMMENT 'codigo de producto',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `ProductName` varchar(128) NOT NULL,
  `ProductDesc` varchar(256) DEFAULT NULL,
  `NumDigitalStock` int DEFAULT '0',
  `NumPhysicalStock` int DEFAULT '0',
  `NumPrice` decimal(16,2) DEFAULT '0.00',
  `NumMaxStock` int DEFAULT '0',
  `NumMinStock` int DEFAULT '0',
  `IsDiscontable` char(1) DEFAULT 'N',
  `DiscountType` char(2) DEFAULT NULL,
  `NumDiscountMax` decimal(16,2) DEFAULT '0.00',
  `BrandCod` varchar(10) NOT NULL,
  `BrandName` varchar(128) NOT NULL,
  `CategoryCod` varchar(10) NOT NULL,
  `CategoryName` varchar(128) NOT NULL,
  `CategoryDadCod` varchar(10) NOT NULL,
  `CategoryDadName` varchar(128) NOT NULL,
  `CurrencyCod` varchar(5) NOT NULL,
  `CurrencySymbol` varchar(5) NOT NULL,
  `FileCod` varchar(20) DEFAULT NULL,
  `FileRoute` varchar(500) DEFAULT NULL,
  `NumTrend` int DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`ProductCod`,`StoreCod`),
  KEY `fk_product_search_store` (`StoreCod`),
  KEY `fk_product_search_category` (`CategoryCod`),
  KEY `fk_product_search_brand` (`BrandCod`),
  KEY `idx_idx_product_search_trend` (`NumTrend`),
  KEY `idx_product_search` (`ProductName`),
  KEY `idx_product_search_1` (`ProductName`(3)),
  KEY `idx_product_search_2` (`ProductName`(4)),
  KEY `idx_product_search_3` (`ProductName`(5)),
  KEY `idx_product_search_4` (`ProductName`(6)),
  KEY `idx_product_search_5` (`ProductName`(7)),
  CONSTRAINT `fk_product_search_brand` FOREIGN KEY (`BrandCod`) REFERENCES `brand` (`BrandCod`),
  CONSTRAINT `fk_product_search_category` FOREIGN KEY (`CategoryCod`) REFERENCES `category` (`CategoryCod`),
  CONSTRAINT `fk_product_search_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_variant`
--
