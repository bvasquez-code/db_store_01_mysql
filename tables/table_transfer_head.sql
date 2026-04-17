DROP PROCEDURE IF EXISTS `p_manage_transfer_head`;

DELIMITER $$

CREATE PROCEDURE `p_manage_transfer_head`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'transfer_head';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `transfer_head` (
          `TransferCod` varchar(16) NOT NULL COMMENT 'PK. Código interno de la transferencia',
          `TypeOperation` char(2) NOT NULL COMMENT 'Tipo de operacion : TE=solicitud transferencia, TS=envio de transferencia',
          `StoreCodOrigin` varchar(4) NOT NULL COMMENT 'Código del local origen (FK store.StoreCod)',
          `StoreCodDest` varchar(4) NOT NULL COMMENT 'Código del local destino (FK store.StoreCod)',
          `StoreCodRequestedBy` varchar(4) DEFAULT NULL COMMENT 'Código del local que solicita/ordena la transferencia (ej. super local central). Puede ser distinto a origen/destino',
          `TransferStatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'Estado del proceso: P=Pending, C=Confirmed, R=Rejected, X=Cancelled, A=Approved',
          `ReceiveStatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'Estado del proceso de recepcion: P=Pending, C=Confirmed, R=Rejected, X=Cancelled, A=Approved',
          `DispatchDate` datetime DEFAULT NULL COMMENT 'Fecha/hora real de despacho desde origen',
          `ArrivalDate` datetime DEFAULT NULL COMMENT 'Fecha/hora real de recepción/llegada a destino',
          `UserOriginConfirm` varchar(16) DEFAULT NULL COMMENT 'Usuario que confirma/autoriza la salida en el local origen',
          `DateOriginConfirm` datetime DEFAULT NULL COMMENT 'Fecha/hora de confirmación de salida en el local origen',
          `UserDestConfirm` varchar(16) DEFAULT NULL COMMENT 'Usuario que confirma la recepción en el local destino',
          `DateDestConfirm` datetime DEFAULT NULL COMMENT 'Fecha/hora de confirmación de recepción en el local destino',
          `Observation` varchar(256) DEFAULT NULL COMMENT 'Observación o nota interna asociada a la transferencia',
          `CreationUser` varchar(16) NOT NULL COMMENT 'Usuario que creó el registro',
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
          `ModifyUser` varchar(16) DEFAULT NULL COMMENT 'Usuario que modificó por última vez el registro',
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la última modificación del registro',
          `Status` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estado lógico del registro: A=Activo, I=Inactivo',
          PRIMARY KEY (`TransferCod`),
          KEY `idx_transfer_cod` (`TransferCod`) COMMENT 'Índice para búsquedas por Código interno',
          KEY `idx_transfer_head_origin` (`StoreCodOrigin`) COMMENT 'Índice para búsquedas por local origen',
          KEY `idx_transfer_head_dest` (`StoreCodDest`) COMMENT 'Índice para búsquedas por local destino',
          KEY `idx_transfer_head_status` (`TransferStatus`) COMMENT 'Índice para búsquedas por estado del proceso',
          KEY `idx_transfer_head_create` (`CreationDate`) COMMENT 'Índice para búsquedas/filtrado por fecha de creacion',
          KEY `fk_transfer_head_store_reqby` (`StoreCodRequestedBy`),
          CONSTRAINT `fk_transfer_head_store_dest` FOREIGN KEY (`StoreCodDest`) REFERENCES `store` (`StoreCod`),
          CONSTRAINT `fk_transfer_head_store_origin` FOREIGN KEY (`StoreCodOrigin`) REFERENCES `store` (`StoreCod`),
          CONSTRAINT `fk_transfer_head_store_reqby` FOREIGN KEY (`StoreCodRequestedBy`) REFERENCES `store` (`StoreCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cabecera de transferencia de productos entre locales (sirve para flujo de origen y destino)';

        SELECT 'Tabla transfer_head creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        -- Ejemplo:
        /*
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'transfer_head' 
            AND column_name = 'NewColumn'
        ) THEN
            ALTER TABLE `transfer_head` ADD COLUMN `NewColumn` ...;
            SELECT 'Columna NewColumn agregada exitosamente.' AS Mensaje;
        END IF;
        */

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns 
            WHERE table_schema = DATABASE() 
            AND table_name = 'transfer_head' 
            AND column_name = 'ReceiveStatus'
        ) THEN
            ALTER TABLE `transfer_head` ADD COLUMN `ReceiveStatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'Estado del proceso de recepcion: P=Pending, C=Confirmed, R=Rejected, X=Cancelled, A=Approved';
            SELECT 'Columna ReceiveStatus agregada exitosamente.' AS Mensaje;
        END IF;
        
        SELECT 'Tabla transfer_head ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_transfer_head`();
DROP PROCEDURE `p_manage_transfer_head`;
