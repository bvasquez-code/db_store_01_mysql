DROP PROCEDURE IF EXISTS `p_manage_pucharse_det_delivery`;

DELIMITER $$

CREATE PROCEDURE `p_manage_pucharse_det_delivery`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'pucharse_det_delivery';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pucharse_det_delivery` (
  `PucharseCod` varchar(16) NOT NULL,
  `ItemNumber` int NOT NULL COMMENT 'Número de ítem/secuencia dentro de la compra',
  `ProductCod` varchar(20) NOT NULL,
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000'),
  `WarehouseCod` varchar(8) NOT NULL COMMENT 'codigo de almacen',
  `NumUnit` int DEFAULT NULL,
  `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)',
  `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PucharseCod`,`ItemNumber`),
  KEY `idx_pucharse_det_delivery_old_pk` (`PucharseCod`,`ProductCod`,`Variant`,`WarehouseCod`),
  KEY `fk_pucharse_det_delivery_warehouse` (`WarehouseCod`),
  KEY `fk_pucharse_det_delivery_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_pucharse_det_delivery_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_pucharse_det_delivery_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`),
  CONSTRAINT `fk_pucharse_det_delivery_warehouse` FOREIGN KEY (`WarehouseCod`) REFERENCES `warehouse` (`WarehouseCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pucharse_head`
--

        SELECT 'Tabla pucharse_det_delivery creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- AGREGANDO COLUMNA ItemNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
            AND column_name = 'ItemNumber'
        ) THEN
            ALTER TABLE `pucharse_det_delivery` ADD COLUMN `ItemNumber` int NOT NULL DEFAULT 0 COMMENT 'Número de ítem/secuencia dentro de la compra' AFTER `PucharseCod`;
            UPDATE `pucharse_det_delivery` t
            JOIN (
                SELECT x.`PucharseCod`, x.`ProductCod`, x.`Variant`, x.`WarehouseCod`,
                       @item_number := IF(@parent_cod = x.`PucharseCod`, @item_number + 1, 1) AS NewItemNumber,
                       @parent_cod := x.`PucharseCod`
                FROM (
                    SELECT `PucharseCod`, `ProductCod`, `Variant`, `WarehouseCod`
                    FROM `pucharse_det_delivery`
                    ORDER BY `PucharseCod`, `ProductCod`, `Variant`, `WarehouseCod`
                ) x
                CROSS JOIN (SELECT @parent_cod := '', @item_number := 0) vars
            ) n ON n.`PucharseCod` = t.`PucharseCod`
                AND n.`ProductCod` = t.`ProductCod`
                AND n.`Variant` = t.`Variant`
                AND n.`WarehouseCod` = t.`WarehouseCod`
            SET t.`ItemNumber` = n.NewItemNumber;
            SELECT 'Columna ItemNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA LotNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
            AND column_name = 'LotNumber'
        ) THEN
            ALTER TABLE `pucharse_det_delivery` ADD COLUMN `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)' AFTER `NumUnit`;
            SELECT 'Columna LotNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA ExpirationDate
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
            AND column_name = 'ExpirationDate'
        ) THEN
            ALTER TABLE `pucharse_det_delivery` ADD COLUMN `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)' AFTER `LotNumber`;
            SELECT 'Columna ExpirationDate agregada exitosamente.' AS Mensaje;
        END IF;

        -- ACTUALIZANDO PRIMARY KEY SI ES NECESARIO
        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
            AND index_name = 'PRIMARY' AND column_name = 'PucharseCod' AND seq_in_index = 1
        ) OR NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
            AND index_name = 'PRIMARY' AND column_name = 'ItemNumber' AND seq_in_index = 2
        ) OR EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
            AND index_name = 'PRIMARY' AND seq_in_index > 2
        ) THEN
            IF NOT EXISTS (
                SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
                AND index_name = 'idx_pucharse_det_delivery_old_pk'
            ) THEN
                ALTER TABLE `pucharse_det_delivery` ADD KEY `idx_pucharse_det_delivery_old_pk` (`PucharseCod`,`ProductCod`,`Variant`,`WarehouseCod`);
                SELECT 'Índice idx_pucharse_det_delivery_old_pk agregado exitosamente.' AS Mensaje;
            END IF;

            IF EXISTS (
                SELECT * FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'pucharse_det_delivery'
                AND constraint_type = 'PRIMARY KEY'
            ) THEN
                ALTER TABLE `pucharse_det_delivery` DROP PRIMARY KEY;
            END IF;

            ALTER TABLE `pucharse_det_delivery` ADD PRIMARY KEY (`PucharseCod`,`ItemNumber`);
            SELECT 'Primary key de pucharse_det_delivery actualizada exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_pucharse_det_delivery`();
DROP PROCEDURE `p_manage_pucharse_det_delivery`;
