DROP TABLE IF EXISTS `sale_head`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_head` (
  `SaleCod` varchar(16) NOT NULL COMMENT 'codigo de venta',
  `PresaleCod` varchar(16) NOT NULL COMMENT 'codigo de preventa',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `ClientCod` varchar(16) DEFAULT NULL COMMENT 'codigo de cliente',
  `NumPriceSubTotal` decimal(16,2) NOT NULL COMMENT 'Precio subtotal',
  `NumDiscount` decimal(16,2) NOT NULL COMMENT 'Monto de descuento',
  `NumTotalPrice` decimal(16,2) NOT NULL COMMENT 'Precio total',
  `NumTotalPriceNoTax` decimal(16,2) NOT NULL COMMENT 'Precio total sin impuestos',
  `NumTotalTax` decimal(16,2) NOT NULL COMMENT 'Total de impuestos',
  `Commenter` varchar(128) DEFAULT NULL COMMENT 'comentario sobre la venta',
  `PeriodId` int NOT NULL COMMENT 'Periodo Is',
  `SaleStatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'estado de la preventa',
  `CurrencyCod` varchar(5) NOT NULL COMMENT 'codigo de moneda',
  `CurrencyCodSys` varchar(5) NOT NULL COMMENT 'codigo de moneda del sistema',
  `NumExchangevalue` decimal(16,4) DEFAULT NULL COMMENT 'valor de cambio',
  `IsPaid` char(1) NOT NULL DEFAULT 'N',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`SaleCod`),
  KEY `fk_sale_head_presale` (`PresaleCod`),
  KEY `fk_sale_head_client` (`ClientCod`),
  KEY `fk_sale_head_period` (`PeriodId`),
  KEY `fk_sale_head_store` (`StoreCod`),
  KEY `fk_sale_head_currency` (`CurrencyCod`),
  KEY `fk_sale_head_currencySys` (`CurrencyCodSys`),
  CONSTRAINT `fk_sale_head_client` FOREIGN KEY (`ClientCod`) REFERENCES `client` (`ClientCod`),
  CONSTRAINT `fk_sale_head_currency` FOREIGN KEY (`CurrencyCod`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_sale_head_currencySys` FOREIGN KEY (`CurrencyCodSys`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_sale_head_period` FOREIGN KEY (`PeriodId`) REFERENCES `period` (`PeriodId`),
  CONSTRAINT `fk_sale_head_presale` FOREIGN KEY (`PresaleCod`) REFERENCES `presale_head` (`PresaleCod`),
  CONSTRAINT `fk_sale_head_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sale_payments`
--
