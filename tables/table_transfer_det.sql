DROP PROCEDURE IF EXISTS `p_manage_transfer_det`;

DELIMITER $$

CREATE PROCEDURE `p_manage_transfer_det`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'transfer_det';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `transfer_det` (
          `TransferCod` varchar(16) NOT NULL COMMENT 'Código de la transferencia (FK transfer_head.TransferCod)',
          `TypeOperation` char(2) NOT NULL COMMENT 'Tipo de operacion : TE=solicitud transferencia, TS=envio de transferencia',
          `ItemNumber` int NOT NULL COMMENT 'Número de ítem/secuencia dentro de la transferencia',
          `ProductCod` varchar(20) NOT NULL COMMENT 'Código del producto transferido (FK product.ProductCod)',
          `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'Variante del producto (si aplica). Default 0000',
          `WarehouseCodOrigin` varchar(8) DEFAULT NULL COMMENT 'Código de almacén origen (FK warehouse.WarehouseCod). Null si no se usa almacén',
          `WarehouseCodDest` varchar(8) DEFAULT NULL COMMENT 'Código de almacén destino (FK warehouse.WarehouseCod). Null si no se usa almacén',
          `NumUnit` decimal(16,3) NOT NULL COMMENT 'Cantidad de unidades a transferir (permite decimales si aplica)',
          `NumUnitDispatch` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente despachadas',
          `NumUnitReception` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente recepcionadas',
          `FlgRequested` char(1) NOT NULL DEFAULT 'S' COMMENT 'Indicador si el producto fue solicitado (S=Si, N=No)',
          `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)',
          `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)',
          `CreationUser` varchar(16) NOT NULL COMMENT 'Usuario que creó el registro',
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
          `ModifyUser` varchar(16) DEFAULT NULL COMMENT 'Usuario que modificó por última vez el registro',
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la última modificación del registro',
          `Status` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estado lógico del registro: A=Activo, I=Inactivo',
          PRIMARY KEY (`TransferCod`,`ItemNumber`),
          KEY `idx_transfer_det_old_pk` (`TransferCod`,`ProductCod`,`Variant`,`ItemNumber`),
          KEY `idx_transfer_det_transfer` (`TransferCod`) COMMENT 'Índice para listar detalles por transferencia',
          KEY `idx_transfer_det_product` (`ProductCod`) COMMENT 'Índice para consultas por producto dentro de transferencias',
          KEY `fk_transfer_det_wh_origin` (`WarehouseCodOrigin`),
          KEY `fk_transfer_det_wh_dest` (`WarehouseCodDest`),
          CONSTRAINT `fk_transfer_det_head` FOREIGN KEY (`TransferCod`) REFERENCES `transfer_head` (`TransferCod`),
          CONSTRAINT `fk_transfer_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
          CONSTRAINT `fk_transfer_det_wh_dest` FOREIGN KEY (`WarehouseCodDest`) REFERENCES `warehouse` (`WarehouseCod`),
          CONSTRAINT `fk_transfer_det_wh_origin` FOREIGN KEY (`WarehouseCodOrigin`) REFERENCES `warehouse` (`WarehouseCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Detalle de productos transferidos entre locales (ítems de la transferencia)';

        SELECT 'Tabla transfer_det creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- AGREGANDO COLUMNA ItemNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_det' 
            AND column_name = 'ItemNumber'
        ) THEN
            ALTER TABLE `transfer_det` ADD COLUMN `ItemNumber` int NOT NULL DEFAULT 0 COMMENT 'Número de ítem/secuencia dentro de la transferencia' AFTER `TypeOperation`;
            UPDATE `transfer_det` t
            JOIN (
                SELECT x.`TransferCod`, x.`ProductCod`, x.`Variant`,
                       @item_number := IF(@parent_cod = x.`TransferCod`, @item_number + 1, 1) AS NewItemNumber,
                       @parent_cod := x.`TransferCod`
                FROM (
                    SELECT `TransferCod`, `ProductCod`, `Variant`
                    FROM `transfer_det`
                    ORDER BY `TransferCod`, `ProductCod`, `Variant`
                ) x
                CROSS JOIN (SELECT @parent_cod := '', @item_number := 0) vars
            ) n ON n.`TransferCod` = t.`TransferCod`
                AND n.`ProductCod` = t.`ProductCod`
                AND n.`Variant` = t.`Variant`
            SET t.`ItemNumber` = n.NewItemNumber;
            SELECT 'Columna ItemNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA NumUnitDispatch
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_det' 
            AND column_name = 'NumUnitDispatch'
        ) THEN
            ALTER TABLE `transfer_det` ADD COLUMN `NumUnitDispatch` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente despachadas' AFTER `NumUnit`;
            SELECT 'Columna NumUnitDispatch agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA NumUnitReception
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_det' 
            AND column_name = 'NumUnitReception'
        ) THEN
            ALTER TABLE `transfer_det` ADD COLUMN `NumUnitReception` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente recepcionadas' AFTER `NumUnitDispatch`;
            SELECT 'Columna NumUnitReception agregada exitosamente.' AS Mensaje;
        END IF;
        -- AGREGANDO COLUMNA FlgRequested
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_det' 
            AND column_name = 'FlgRequested'
        ) THEN
            ALTER TABLE `transfer_det` ADD COLUMN `FlgRequested` char(1) NOT NULL DEFAULT 'S' COMMENT 'Indicador si el producto fue solicitado (S=Si, N=No)' AFTER `NumUnitReception`;
            SELECT 'Columna FlgRequested agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA LotNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_det' 
            AND column_name = 'LotNumber'
        ) THEN
            ALTER TABLE `transfer_det` ADD COLUMN `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)' AFTER `FlgRequested`;
            SELECT 'Columna LotNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA ExpirationDate
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_det' 
            AND column_name = 'ExpirationDate'
        ) THEN
            ALTER TABLE `transfer_det` ADD COLUMN `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)' AFTER `LotNumber`;
            SELECT 'Columna ExpirationDate agregada exitosamente.' AS Mensaje;
        END IF;

        -- ACTUALIZANDO PRIMARY KEY SI ES NECESARIO
        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_det'
            AND index_name = 'PRIMARY' AND column_name = 'TransferCod' AND seq_in_index = 1
        ) OR NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_det'
            AND index_name = 'PRIMARY' AND column_name = 'ItemNumber' AND seq_in_index = 2
        ) OR EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_det'
            AND index_name = 'PRIMARY' AND seq_in_index > 2
        ) THEN
            IF NOT EXISTS (
                SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_det'
                AND index_name = 'idx_transfer_det_old_pk'
            ) THEN
                ALTER TABLE `transfer_det` ADD KEY `idx_transfer_det_old_pk` (`TransferCod`,`ProductCod`,`Variant`,`ItemNumber`);
                SELECT 'Índice idx_transfer_det_old_pk agregado exitosamente.' AS Mensaje;
            END IF;

            IF EXISTS (
                SELECT * FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'transfer_det'
                AND constraint_type = 'PRIMARY KEY'
            ) THEN
                ALTER TABLE `transfer_det` DROP PRIMARY KEY;
            END IF;

            ALTER TABLE `transfer_det` ADD PRIMARY KEY (`TransferCod`,`ItemNumber`);
            SELECT 'Primary key de transfer_det actualizada exitosamente.' AS Mensaje;
        END IF;
        
    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_transfer_det`();
DROP PROCEDURE `p_manage_transfer_det`;
