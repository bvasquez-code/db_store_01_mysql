DROP PROCEDURE IF EXISTS `p_manage_transfer_document`;

DELIMITER $$

CREATE PROCEDURE `p_manage_transfer_document`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'transfer_document';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `transfer_document` (
          `DocumentCod` varchar(16) NOT NULL COMMENT 'PK. Código del documento de transferencia. Incluye serie y correlativo (ej: T001-000001)',
          `TypeOperation` char(2) NOT NULL COMMENT 'Tipo de operacion : TE=solicitud transferencia, TS=envio de transferencia',
          `CounterfoilCod` varchar(16) NOT NULL COMMENT 'Código de talonario (DocumentType + Series). Mismo uso que en sale_document / credit_note_document',
          `TransferCod` varchar(16) NOT NULL COMMENT 'Código de la transferencia (FK transfer_head.TransferCod)',
          `DocumentRole` char(1) NOT NULL DEFAULT 'R' COMMENT 'Rol del documento: R=Remitente, T=Transportista, O=Otro',
          `ReasonTransferCod` varchar(2) NOT NULL COMMENT 'Código del motivo de traslado según catálogo SUNAT',
          `ReasonTransferDesc` varchar(128) DEFAULT NULL COMMENT 'Descripción libre del motivo de traslado',
          `TransportModeCod` varchar(2) NOT NULL COMMENT 'Modalidad de transporte SUNAT: 01=Publico, 02=Privado',
          `DepartureUbigeo` varchar(12) DEFAULT NULL COMMENT 'Código UBIGEO del punto de partida del traslado',
          `DepartureAddress` varchar(128) NOT NULL COMMENT 'Dirección física del punto de partida del traslado',
          `ArrivalUbigeo` varchar(12) DEFAULT NULL COMMENT 'Código UBIGEO del punto de llegada del traslado',
          `ArrivalAddress` varchar(128) NOT NULL COMMENT 'Dirección física del punto de llegada del traslado',
          `TotalWeightKg` decimal(16,3) DEFAULT NULL COMMENT 'Peso bruto total de la mercadería trasladada en kilogramos',
          `NumPackages` int DEFAULT NULL COMMENT 'Número total de bultos o paquetes transportados',
          `CarrierRuc` varchar(11) DEFAULT NULL COMMENT 'RUC de la empresa transportista (solo transporte público)',
          `CarrierName` varchar(128) DEFAULT NULL COMMENT 'Razón social de la empresa transportista',
          `VehiclePlate` varchar(16) DEFAULT NULL COMMENT 'Placa del vehículo que realiza el traslado (si aplica)',
          `DriverDocType` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del conductor (DNI, CE, etc)',
          `DriverDocNumber` varchar(16) DEFAULT NULL COMMENT 'Número de documento del conductor',
          `DriverLicenseNumber` varchar(16) DEFAULT NULL COMMENT 'Número de licencia de conducir del chofer',
          `SunatStatus` char(1) DEFAULT NULL COMMENT 'Estado SUNAT: P=Pending, S=Sent, A=Accepted, O=Observed, R=Rejected',
          `SunatTicket` varchar(64) DEFAULT NULL COMMENT 'Ticket devuelto por SUNAT al enviar el documento (si aplica)',
          `CdrCode` varchar(8) DEFAULT NULL COMMENT 'Código de respuesta del CDR SUNAT',
          `CdrDescription` varchar(256) DEFAULT NULL COMMENT 'Descripción del CDR SUNAT',
          `XmlHash` varchar(128) DEFAULT NULL COMMENT 'Hash del XML enviado a SUNAT para validación e integridad',
          `CreationUser` varchar(16) NOT NULL COMMENT 'Usuario que creó el registro',
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
          `ModifyUser` varchar(16) DEFAULT NULL COMMENT 'Usuario que modificó por última vez el registro',
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la última modificación del registro',
          `Status` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estado lógico del registro: A=Activo, I=Inactivo',
          PRIMARY KEY (`DocumentCod`),
          KEY `idx_transfer_document_transfer` (`TransferCod`) COMMENT 'Índice para listar documentos por transferencia',
          KEY `idx_transfer_document_counterfoil` (`CounterfoilCod`) COMMENT 'Índice para búsquedas por talonario',
          KEY `idx_transfer_document_sunat_status` (`SunatStatus`) COMMENT 'Índice para seguimiento de estado SUNAT',
          KEY `fk_transfer_document_head` (`TransferCod`,`TypeOperation`),
          CONSTRAINT `fk_transfer_document_counterfoil` FOREIGN KEY (`CounterfoilCod`) REFERENCES `counterfoil` (`CounterfoilCod`),
          CONSTRAINT `fk_transfer_document_head` FOREIGN KEY (`TransferCod`) REFERENCES `transfer_head` (`TransferCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Documento SUNAT de traslado (GRE) asociado a una transferencia entre locales';

        SELECT 'Tabla transfer_document creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla transfer_document ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_transfer_document`();
DROP PROCEDURE `p_manage_transfer_document`;
