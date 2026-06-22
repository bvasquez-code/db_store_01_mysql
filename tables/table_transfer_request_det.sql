DROP PROCEDURE IF EXISTS `p_manage_transfer_request_det`;

DELIMITER $$

CREATE PROCEDURE `p_manage_transfer_request_det`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
    AND table_name = 'transfer_request_det';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `transfer_request_det` (
          `TransferReqCod` varchar(16) NOT NULL COMMENT 'Codigo de la transferencia (FK transfer_request_head.TransferReqCod)',
          `TypeOperation` char(2) NOT NULL COMMENT 'Tipo de operacion : TE=solicitud transferencia, TS=envio de transferencia',
          `ItemNumber` int NOT NULL COMMENT 'Numero de item/secuencia dentro de la transferencia',
          `ProductCod` varchar(20) NOT NULL COMMENT 'Codigo del producto transferido (FK product.ProductCod)',
          `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'Variante del producto (si aplica). Default 0000',
          `WarehouseCodOrigin` varchar(8) DEFAULT NULL COMMENT 'Codigo de almacen origen (FK warehouse.WarehouseCod). Null si no se usa almacen',
          `WarehouseCodDest` varchar(8) DEFAULT NULL COMMENT 'Codigo de almacen destino (FK warehouse.WarehouseCod). Null si no se usa almacen',
          `NumUnit` decimal(16,3) NOT NULL COMMENT 'Cantidad de unidades a transferir (permite decimales si aplica)',
          `NumUnitDispatch` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente despachadas',
          `NumUnitReception` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente recepcionadas',
          `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Numero de lote del producto (si aplica)',
          `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)',
          `CreationUser` varchar(16) NOT NULL COMMENT 'Usuario que creo el registro',
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creacion del registro',
          `ModifyUser` varchar(16) DEFAULT NULL COMMENT 'Usuario que modifico por ultima vez el registro',
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la ultima modificacion del registro',
          `Status` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estado logico del registro: A=Activo, I=Inactivo',
          PRIMARY KEY (`TransferReqCod`,`ItemNumber`),
          KEY `idx_transfer_request_det_old_pk` (`TransferReqCod`,`ProductCod`,`Variant`,`ItemNumber`),
          KEY `idx_transfer_request_det_transfer` (`TransferReqCod`) COMMENT 'Indice para listar detalles por transferencia',
          KEY `idx_transfer_request_det_product` (`ProductCod`) COMMENT 'Indice para consultas por producto dentro de transferencias',
          KEY `fk_transfer_request_det_wh_origin` (`WarehouseCodOrigin`),
          KEY `fk_transfer_request_det_wh_dest` (`WarehouseCodDest`),
          CONSTRAINT `fk_transfer_request_det_head` FOREIGN KEY (`TransferReqCod`) REFERENCES `transfer_request_head` (`TransferReqCod`),
          CONSTRAINT `fk_transfer_request_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
          CONSTRAINT `fk_transfer_request_det_wh_dest` FOREIGN KEY (`WarehouseCodDest`) REFERENCES `warehouse` (`WarehouseCod`),
          CONSTRAINT `fk_transfer_request_det_wh_origin` FOREIGN KEY (`WarehouseCodOrigin`) REFERENCES `warehouse` (`WarehouseCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Detalle de solicitud de transferencia de productos entre locales';

        SELECT 'Tabla transfer_request_det creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================

        -- AGREGANDO COLUMNA ItemNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND column_name = 'ItemNumber'
        ) THEN
            ALTER TABLE `transfer_request_det` ADD COLUMN `ItemNumber` int NOT NULL DEFAULT 0 COMMENT 'Numero de item/secuencia dentro de la transferencia' AFTER `TypeOperation`;
            UPDATE `transfer_request_det` t
            JOIN (
                SELECT x.`TransferReqCod`, x.`ProductCod`, x.`Variant`,
                       @item_number := IF(@parent_cod = x.`TransferReqCod`, @item_number + 1, 1) AS NewItemNumber,
                       @parent_cod := x.`TransferReqCod`
                FROM (
                    SELECT `TransferReqCod`, `ProductCod`, `Variant`
                    FROM `transfer_request_det`
                    ORDER BY `TransferReqCod`, `ProductCod`, `Variant`
                ) x
                CROSS JOIN (SELECT @parent_cod := '', @item_number := 0) vars
            ) n ON n.`TransferReqCod` = t.`TransferReqCod`
                AND n.`ProductCod` = t.`ProductCod`
                AND n.`Variant` = t.`Variant`
            SET t.`ItemNumber` = n.NewItemNumber;
            SELECT 'Columna ItemNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA NumUnitDispatch
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND column_name = 'NumUnitDispatch'
        ) THEN
            ALTER TABLE `transfer_request_det` ADD COLUMN `NumUnitDispatch` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente despachadas' AFTER `NumUnit`;
            SELECT 'Columna NumUnitDispatch agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA NumUnitReception
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND column_name = 'NumUnitReception'
        ) THEN
            ALTER TABLE `transfer_request_det` ADD COLUMN `NumUnitReception` decimal(16,3) DEFAULT NULL COMMENT 'Cantidad de unidades efectivamente recepcionadas' AFTER `NumUnitDispatch`;
            SELECT 'Columna NumUnitReception agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA LotNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND column_name = 'LotNumber'
        ) THEN
            ALTER TABLE `transfer_request_det` ADD COLUMN `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Numero de lote del producto (si aplica)' AFTER `NumUnitReception`;
            SELECT 'Columna LotNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA ExpirationDate
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND column_name = 'ExpirationDate'
        ) THEN
            ALTER TABLE `transfer_request_det` ADD COLUMN `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)' AFTER `LotNumber`;
            SELECT 'Columna ExpirationDate agregada exitosamente.' AS Mensaje;
        END IF;

        -- ACTUALIZANDO PRIMARY KEY SI ES NECESARIO
        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND index_name = 'PRIMARY' AND column_name = 'TransferReqCod' AND seq_in_index = 1
        ) OR NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND index_name = 'PRIMARY' AND column_name = 'ItemNumber' AND seq_in_index = 2
        ) OR EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
            AND index_name = 'PRIMARY' AND seq_in_index > 2
        ) THEN
            IF NOT EXISTS (
                SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
                AND index_name = 'idx_transfer_request_det_old_pk'
            ) THEN
                ALTER TABLE `transfer_request_det` ADD KEY `idx_transfer_request_det_old_pk` (`TransferReqCod`,`ProductCod`,`Variant`,`ItemNumber`);
                SELECT 'Indice idx_transfer_request_det_old_pk agregado exitosamente.' AS Mensaje;
            END IF;

            IF EXISTS (
                SELECT * FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'transfer_request_det'
                AND constraint_type = 'PRIMARY KEY'
            ) THEN
                ALTER TABLE `transfer_request_det` DROP PRIMARY KEY;
            END IF;

            ALTER TABLE `transfer_request_det` ADD PRIMARY KEY (`TransferReqCod`,`ItemNumber`);
            SELECT 'Primary key de transfer_request_det actualizada exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_transfer_request_det`();
DROP PROCEDURE `p_manage_transfer_request_det`;
