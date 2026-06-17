DROP PROCEDURE IF EXISTS `p_manage_carrier`;

DELIMITER $$

CREATE PROCEDURE `p_manage_carrier`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
    AND table_name = 'carrier';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrier` (
  `CarrierCod` varchar(16) NOT NULL COMMENT 'codigo de transportista',
  `CarrierRuc` varchar(11) DEFAULT NULL COMMENT 'RUC de la empresa transportista',
  `CarrierName` varchar(128) DEFAULT NULL COMMENT 'Nombre o razon social del transportista',
  `VehiclePlate` varchar(16) DEFAULT NULL COMMENT 'Placa del vehiculo',
  `DriverDocType` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del conductor',
  `DriverDocNumber` varchar(16) DEFAULT NULL COMMENT 'Numero de documento del conductor',
  `DriverLicenseNumber` varchar(16) DEFAULT NULL COMMENT 'Numero de licencia del conductor',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`CarrierCod`),
  KEY `idx_carrier_ruc` (`CarrierRuc`),
  KEY `idx_carrier_driver_doc` (`DriverDocType`,`DriverDocNumber`),
  KEY `idx_carrier_vehicle_plate` (`VehiclePlate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

        SELECT 'Tabla carrier creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================

        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs

        SELECT 'Tabla carrier ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_carrier`();
DROP PROCEDURE `p_manage_carrier`;
