DROP PROCEDURE IF EXISTS `p_manage_kardex`;

DELIMITER $$

CREATE PROCEDURE `p_manage_kardex`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'kardex';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kardex` (
  `kardexID` bigint NOT NULL AUTO_INCREMENT,
  `OperationCod` varchar(16) NOT NULL COMMENT 'Codigo de operacion',
  `ItemNumber` int DEFAULT NULL COMMENT 'Número de ítem/secuencia del documento origen',
  `SourceTable` varchar(20) NOT NULL COMMENT 'Tabla origen',
  `TypeOperation` char(1) NOT NULL COMMENT 'tipo de operacion',
  `ProductCod` varchar(20) NOT NULL COMMENT 'Codigo de producto',
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'Codigo de variante',
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `WarehouseCod` varchar(8) NOT NULL COMMENT 'codigo de alamacen',
  `NumStockBefore` int DEFAULT NULL,
  `NumStockMoved` int DEFAULT NULL,
  `NumStockAfter` int DEFAULT NULL,
  `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)',
  `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `TypeOperationCod` int DEFAULT NULL,
  PRIMARY KEY (`kardexID`),
  KEY `fk_kardex_variant` (`ProductCod`,`Variant`),
  KEY `fk_kardex_store` (`StoreCod`),
  KEY `fk_kardex_warehouse` (`WarehouseCod`),
  KEY `idx_kardex_table` (`SourceTable`,`OperationCod`),
  KEY `idx_kardex_source_item` (`SourceTable`,`OperationCod`,`ItemNumber`),
  CONSTRAINT `fk_kardex_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_kardex_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`),
  CONSTRAINT `fk_kardex_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`),
  CONSTRAINT `fk_kardex_warehouse` FOREIGN KEY (`WarehouseCod`) REFERENCES `warehouse` (`WarehouseCod`)
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payment_method`
--

        SELECT 'Tabla kardex creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- AGREGANDO COLUMNA ItemNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'kardex'
            AND column_name = 'ItemNumber'
        ) THEN
            ALTER TABLE `kardex` ADD COLUMN `ItemNumber` int DEFAULT NULL COMMENT 'Número de ítem/secuencia del documento origen' AFTER `OperationCod`;
            SELECT 'Columna ItemNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA LotNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'kardex'
            AND column_name = 'LotNumber'
        ) THEN
            ALTER TABLE `kardex` ADD COLUMN `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)' AFTER `NumStockAfter`;
            SELECT 'Columna LotNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA ExpirationDate
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'kardex'
            AND column_name = 'ExpirationDate'
        ) THEN
            ALTER TABLE `kardex` ADD COLUMN `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)' AFTER `LotNumber`;
            SELECT 'Columna ExpirationDate agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO ÍNDICE DE ORIGEN POR ÍTEM
        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'kardex'
            AND index_name = 'idx_kardex_source_item'
        ) THEN
            ALTER TABLE `kardex` ADD KEY `idx_kardex_source_item` (`SourceTable`,`OperationCod`,`ItemNumber`);
            SELECT 'Índice idx_kardex_source_item agregado exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_kardex`();
DROP PROCEDURE `p_manage_kardex`;
