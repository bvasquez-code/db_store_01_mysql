DROP PROCEDURE IF EXISTS `p_manage_sale_payments`;

DELIMITER $$

CREATE PROCEDURE `p_manage_sale_payments`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'sale_payments';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
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
  PRIMARY KEY (`PaymentNumber`,`SaleCod`,`TrxPaymentId`),
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

        SELECT 'Tabla sale_payments creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        -- AGREGANDO PRIMARY KEY SI NO EXISTE
        IF NOT EXISTS (
            SELECT * FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'sale_payments'
            AND constraint_type = 'PRIMARY KEY'
        ) THEN
            ALTER TABLE `sale_payments` ADD PRIMARY KEY (`PaymentNumber`,`SaleCod`,`TrxPaymentId`);
            SELECT 'Primary key de sale_payments agregada exitosamente.' AS Mensaje;
        END IF;
        
        SELECT 'Tabla sale_payments ya existe. Proceso de validacion estructural finalizado.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_sale_payments`();
DROP PROCEDURE `p_manage_sale_payments`;
