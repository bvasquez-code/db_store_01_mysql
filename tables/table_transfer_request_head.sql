DROP PROCEDURE IF EXISTS `p_manage_transfer_request_head`;

DELIMITER $$

CREATE PROCEDURE `p_manage_transfer_request_head`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
    AND table_name = 'transfer_request_head';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `transfer_request_head` (
          `TransferReqCod` varchar(16) NOT NULL COMMENT 'PK. Codigo interno de la transferencia',
          `TypeOperation` char(2) NOT NULL COMMENT 'Tipo de operacion : TE=solicitud transferencia, TS=envio de transferencia',
          `StoreCodOrigin` varchar(4) NOT NULL COMMENT 'Codigo del local origen (FK store.StoreCod)',
          `StoreCodDest` varchar(4) NOT NULL COMMENT 'Codigo del local destino (FK store.StoreCod)',
          `StoreCodRequestedBy` varchar(4) DEFAULT NULL COMMENT 'Codigo del local que solicita/ordena la transferencia (ej. super local central). Puede ser distinto a origen/destino',
          `TransferStatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'Estado del proceso: P=Pending, C=Confirmed, D=Dispatched, F=Finalized, R=Rejected, X=Cancelled',
          `DispatchDate` datetime DEFAULT NULL COMMENT 'Fecha/hora real de despacho desde origen',
          `ArrivalDate` datetime DEFAULT NULL COMMENT 'Fecha/hora real de recepcion/llegada a destino',
          `UserOriginConfirm` varchar(16) DEFAULT NULL COMMENT 'Usuario que confirma/autoriza la salida en el local origen',
          `DateOriginConfirm` datetime DEFAULT NULL COMMENT 'Fecha/hora de confirmacion de salida en el local origen',
          `UserDestConfirm` varchar(16) DEFAULT NULL COMMENT 'Usuario que confirma la recepcion en el local destino',
          `DateDestConfirm` datetime DEFAULT NULL COMMENT 'Fecha/hora de confirmacion de recepcion en el local destino',
          `Observation` varchar(256) DEFAULT NULL COMMENT 'Observacion o nota interna asociada a la transferencia',
          `CreationUser` varchar(16) NOT NULL COMMENT 'Usuario que creo el registro',
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creacion del registro',
          `ModifyUser` varchar(16) DEFAULT NULL COMMENT 'Usuario que modifico por ultima vez el registro',
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la ultima modificacion del registro',
          `Status` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estado logico del registro: A=Activo, I=Inactivo',
          PRIMARY KEY (`TransferReqCod`),
          KEY `idx_transfer_request_cod` (`TransferReqCod`) COMMENT 'Indice para busquedas por Codigo interno',
          KEY `idx_transfer_request_head_origin` (`StoreCodOrigin`) COMMENT 'Indice para busquedas por local origen',
          KEY `idx_transfer_request_head_dest` (`StoreCodDest`) COMMENT 'Indice para busquedas por local destino',
          KEY `idx_transfer_request_head_status` (`TransferStatus`) COMMENT 'Indice para busquedas por estado del proceso',
          KEY `idx_transfer_request_head_create` (`CreationDate`) COMMENT 'Indice para busquedas/filtrado por fecha de creacion',
          KEY `fk_transfer_request_head_store_reqby` (`StoreCodRequestedBy`),
          CONSTRAINT `fk_transfer_request_head_store_dest` FOREIGN KEY (`StoreCodDest`) REFERENCES `store` (`StoreCod`),
          CONSTRAINT `fk_transfer_request_head_store_origin` FOREIGN KEY (`StoreCodOrigin`) REFERENCES `store` (`StoreCod`),
          CONSTRAINT `fk_transfer_request_head_store_reqby` FOREIGN KEY (`StoreCodRequestedBy`) REFERENCES `store` (`StoreCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cabecera de solicitud de transferencia de productos entre locales';

        SELECT 'Tabla transfer_request_head creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'StoreCodRequestedBy'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `StoreCodRequestedBy` varchar(4) DEFAULT NULL COMMENT 'Codigo del local que solicita/ordena la transferencia (ej. super local central). Puede ser distinto a origen/destino' AFTER `StoreCodDest`;
            SELECT 'Columna StoreCodRequestedBy agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'DispatchDate'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `DispatchDate` datetime DEFAULT NULL COMMENT 'Fecha/hora real de despacho desde origen' AFTER `TransferStatus`;
            SELECT 'Columna DispatchDate agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'ArrivalDate'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `ArrivalDate` datetime DEFAULT NULL COMMENT 'Fecha/hora real de recepcion/llegada a destino' AFTER `DispatchDate`;
            SELECT 'Columna ArrivalDate agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'UserOriginConfirm'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `UserOriginConfirm` varchar(16) DEFAULT NULL COMMENT 'Usuario que confirma/autoriza la salida en el local origen' AFTER `ArrivalDate`;
            SELECT 'Columna UserOriginConfirm agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'DateOriginConfirm'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `DateOriginConfirm` datetime DEFAULT NULL COMMENT 'Fecha/hora de confirmacion de salida en el local origen' AFTER `UserOriginConfirm`;
            SELECT 'Columna DateOriginConfirm agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'UserDestConfirm'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `UserDestConfirm` varchar(16) DEFAULT NULL COMMENT 'Usuario que confirma la recepcion en el local destino' AFTER `DateOriginConfirm`;
            SELECT 'Columna UserDestConfirm agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'DateDestConfirm'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `DateDestConfirm` datetime DEFAULT NULL COMMENT 'Fecha/hora de confirmacion de recepcion en el local destino' AFTER `UserDestConfirm`;
            SELECT 'Columna DateDestConfirm agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND column_name = 'Observation'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD COLUMN `Observation` varchar(256) DEFAULT NULL COMMENT 'Observacion o nota interna asociada a la transferencia' AFTER `DateDestConfirm`;
            SELECT 'Columna Observation agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND index_name = 'idx_transfer_request_cod'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD KEY `idx_transfer_request_cod` (`TransferReqCod`);
            SELECT 'Indice idx_transfer_request_cod agregado exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND index_name = 'idx_transfer_request_head_origin'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD KEY `idx_transfer_request_head_origin` (`StoreCodOrigin`);
            SELECT 'Indice idx_transfer_request_head_origin agregado exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND index_name = 'idx_transfer_request_head_dest'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD KEY `idx_transfer_request_head_dest` (`StoreCodDest`);
            SELECT 'Indice idx_transfer_request_head_dest agregado exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND index_name = 'idx_transfer_request_head_status'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD KEY `idx_transfer_request_head_status` (`TransferStatus`);
            SELECT 'Indice idx_transfer_request_head_status agregado exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'transfer_request_head'
            AND index_name = 'idx_transfer_request_head_create'
        ) THEN
            ALTER TABLE `transfer_request_head` ADD KEY `idx_transfer_request_head_create` (`CreationDate`);
            SELECT 'Indice idx_transfer_request_head_create agregado exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_transfer_request_head`();
DROP PROCEDURE `p_manage_transfer_request_head`;
