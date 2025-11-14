DROP TABLE IF EXISTS `credit_note_head`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_note_head` (
  `CreditNoteCod` varchar(16) NOT NULL COMMENT 'codigo de nota de credito',
  `SaleCod` varchar(16) NOT NULL COMMENT 'codigo de venta',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `ClientCod` varchar(16) DEFAULT NULL COMMENT 'codigo de cliente',
  `NumTotalPrice` decimal(16,2) NOT NULL COMMENT 'Precio total',
  `Commenter` varchar(128) DEFAULT NULL COMMENT 'comentario sobre la nota de credito',
  `PeriodId` int NOT NULL COMMENT 'Periodo Is',
  `CreditNoteStatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'estado de la nota de credito',
  `CurrencyCod` varchar(5) NOT NULL COMMENT 'codigo de moneda',
  `CurrencyCodSys` varchar(5) NOT NULL COMMENT 'codigo de moneda del sistema',
  `NumExchangevalue` decimal(16,4) DEFAULT NULL COMMENT 'valor de cambio',
  `IsPaid` char(1) NOT NULL DEFAULT 'N',
  `IsStockReturned` char(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el stock fue regresado a la tienda',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `TypeCreditNote` char(1) DEFAULT NULL COMMENT 'Tipo de nota de crÃ©dito: T=Total, P=Parcial',
  PRIMARY KEY (`CreditNoteCod`),
  KEY `fk_credit_note_head_client` (`ClientCod`),
  KEY `fk_credit_note_head_period` (`PeriodId`),
  KEY `fk_credit_note_head_store` (`StoreCod`),
  KEY `fk_credit_note_head_currency` (`CurrencyCod`),
  KEY `fk_credit_note_head_currencySys` (`CurrencyCodSys`),
  KEY `fk_credit_note_head_sale` (`SaleCod`),
  CONSTRAINT `fk_credit_note_head_client` FOREIGN KEY (`ClientCod`) REFERENCES `client` (`ClientCod`),
  CONSTRAINT `fk_credit_note_head_currency` FOREIGN KEY (`CurrencyCod`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_credit_note_head_currencySys` FOREIGN KEY (`CurrencyCodSys`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_credit_note_head_period` FOREIGN KEY (`PeriodId`) REFERENCES `period` (`PeriodId`),
  CONSTRAINT `fk_credit_note_head_sale` FOREIGN KEY (`SaleCod`) REFERENCES `sale_head` (`SaleCod`),
  CONSTRAINT `fk_credit_note_head_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`),
  CONSTRAINT `chk_credit_note_type` CHECK ((`TypeCreditNote` in (_utf8mb4'T',_utf8mb4'P')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currency`
--
