DROP PROCEDURE IF EXISTS `p_manage_pucharse_head`;

DELIMITER $$

CREATE PROCEDURE `p_manage_pucharse_head`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'pucharse_head';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pucharse_head` (
  `PucharseCod` varchar(16) NOT NULL,
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `ExternalCod` varchar(30) DEFAULT NULL,
  `DealerCod` varchar(16) DEFAULT NULL,
  `Commenter` varchar(128) DEFAULT NULL,
  `PurchaseStatus` char(1) DEFAULT NULL,
  `CurrencyCod` varchar(5) NOT NULL,
  `CurrencyCodSys` varchar(5) NOT NULL,
  `NumExchangevalue` decimal(16,4) DEFAULT NULL,
  `NumTotalPrice` decimal(16,2) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `PucharseReqCod` varchar(16) NOT NULL,
  PRIMARY KEY (`PucharseCod`),
  KEY `fk_pucharse_head_store` (`StoreCod`),
  KEY `fk_pucharse_head_currency` (`CurrencyCod`),
  KEY `fk_pucharse_head_currencySys` (`CurrencyCodSys`),
  KEY `idx_pucharse_PucharseReqCod` (`PucharseReqCod`),
  CONSTRAINT `fk_pucharse_head_currency` FOREIGN KEY (`CurrencyCod`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_pucharse_head_currencySys` FOREIGN KEY (`CurrencyCodSys`) REFERENCES `currency` (`CurrencyCod`),
  CONSTRAINT `fk_pucharse_head_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pucharse_request_det`
--

        SELECT 'Tabla pucharse_head creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla pucharse_head ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_pucharse_head`();
DROP PROCEDURE `p_manage_pucharse_head`;
