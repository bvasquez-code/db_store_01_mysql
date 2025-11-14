DROP TABLE IF EXISTS `sale_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_payments` (
  `PaymentNumber` int NOT NULL COMMENT 'Numero de pago',
  `SaleCod` varchar(16) NOT NULL COMMENT 'codigo de venta',
  `TrxPaymentId` bigint NOT NULL,
  `CurrencyCod` varchar(5) NOT NULL COMMENT 'codigo de moneda',
  `CurrencyCodSys` varchar(5) NOT NULL COMMENT 'codigo de moneda del sistema',
  `NumExchangevalue` decimal(16,4) DEFAULT NULL COMMENT 'valor de cambio',
  `NumAmountPaid` decimal(16,2) DEFAULT NULL,
  `NumAmountPaidOrigin` decimal(16,2) DEFAULT NULL,
  `NumAmountReturned` decimal(16,2) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  KEY `fk_sale_payments_sale` (`SaleCod`),
  KEY `fk_sale_payments_currency` (`CurrencyCod`),
  KEY `fk_sale_payments_currencySys` (`CurrencyCodSys`),
  KEY `fk_sale_payments_TrxPaymentId` (`TrxPaymentId`),
  CONSTRAINT `fk_sale_payments_currency` FOREIGN KEY (`CurrencyCod`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_sale_payments_currencySys` FOREIGN KEY (`CurrencyCodSys`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_sale_payments_sale` FOREIGN KEY (`SaleCod`) REFERENCES `sale_head` (`SaleCod`),
  CONSTRAINT `fk_sale_payments_TrxPaymentId` FOREIGN KEY (`TrxPaymentId`) REFERENCES `trx_payments` (`TrxPaymentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `store`
--
