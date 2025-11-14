DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `CurrencyCod` varchar(5) NOT NULL,
  `CurrencyAbbr` varchar(8) NOT NULL,
  `CurrencySymbol` varchar(5) NOT NULL,
  `CurrencyName` varchar(32) NOT NULL,
  `CurrencyDesc` varchar(128) DEFAULT NULL,
  `IsMonedaSystem` char(1) NOT NULL DEFAULT 'N',
  `NumExchangevalue` decimal(16,4) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `IsCurrencySystem` char(1) DEFAULT 'N',
  PRIMARY KEY (`CurrencyCod`),
  KEY `idx_currency_currabbr` (`CurrencyAbbr`),
  KEY `idx_currency_currname` (`CurrencyName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `error_store`
--
