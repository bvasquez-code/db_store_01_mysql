DROP PROCEDURE IF EXISTS `p_manage_presale_head`;

DELIMITER $$

CREATE PROCEDURE `p_manage_presale_head`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'presale_head';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presale_head` (
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
  PRIMARY KEY (`PresaleCod`),
  KEY `fk_presale_head_client` (`ClientCod`),
  KEY `fk_presale_head_period` (`PeriodId`),
  KEY `fk_presale_head_store` (`StoreCod`),
  KEY `fk_presale_head_currency` (`CurrencyCod`),
  KEY `fk_presale_head_currencySys` (`CurrencyCodSys`),
  CONSTRAINT `fk_presale_head_client` FOREIGN KEY (`ClientCod`) REFERENCES `client` (`ClientCod`),
  CONSTRAINT `fk_presale_head_currency` FOREIGN KEY (`CurrencyCod`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_presale_head_currencySys` FOREIGN KEY (`CurrencyCodSys`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_presale_head_period` FOREIGN KEY (`PeriodId`) REFERENCES `period` (`PeriodId`),
  CONSTRAINT `fk_presale_head_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

        SELECT 'Tabla presale_head creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla presale_head ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_presale_head`();
DROP PROCEDURE `p_manage_presale_head`;
