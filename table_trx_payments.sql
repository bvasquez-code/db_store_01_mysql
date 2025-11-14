DROP TABLE IF EXISTS `trx_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trx_payments` (
  `TrxPaymentId` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID del pago',
  `PaymentMethodCod` varchar(8) NOT NULL COMMENT 'CÃ³digo del mÃ©todo de pago',
  `PaymentPlatform` varchar(16) NOT NULL COMMENT 'Plataforma de pago utilizada (POS o PayPal)',
  `CardNumber` varchar(16) DEFAULT NULL COMMENT 'NÃºmero de la tarjeta',
  `CardHolderName` varchar(64) DEFAULT NULL COMMENT 'Nombre del titular de la tarjeta',
  `CardExpirationDate` date DEFAULT NULL COMMENT 'Fecha de expiraciÃ³n de la tarjeta',
  `CardCVV` varchar(4) DEFAULT NULL COMMENT 'CÃ³digo de verificaciÃ³n de la tarjeta',
  `TransactionId` varchar(64) DEFAULT NULL COMMENT 'ID de la transacciÃ³n (proporcionado por POS o PayPal)',
  `PaymentStatus` varchar(16) NOT NULL COMMENT 'Estado del pago (Exitoso, Fallido, etc.)',
  `CurrencyCod` varchar(5) NOT NULL COMMENT 'codigo de moneda',
  `CurrencyCodSys` varchar(5) NOT NULL COMMENT 'codigo de moneda del sistema',
  `NumExchangevalue` decimal(16,4) DEFAULT NULL COMMENT 'valor de cambio',
  `AmountPaid` decimal(16,2) DEFAULT NULL,
  `AmountReturned` decimal(16,2) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `TypeMovement` char(1) NOT NULL DEFAULT 'I' COMMENT 'Tipo de movimiento (I:Ingreso, E:Extorno)',
  `ReversalOfTrxPaymentId` bigint DEFAULT NULL COMMENT 'Extorno de este pago original',
  PRIMARY KEY (`TrxPaymentId`),
  KEY `fk_card_payments_payment` (`PaymentMethodCod`),
  KEY `idx_trx_payments_reversal_of` (`ReversalOfTrxPaymentId`),
  CONSTRAINT `fk_card_payments_payment` FOREIGN KEY (`PaymentMethodCod`) REFERENCES `payment_method` (`PaymentMethodCod`)
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ubigeo_department`
--
