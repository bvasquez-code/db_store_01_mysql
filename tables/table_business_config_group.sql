DROP PROCEDURE IF EXISTS `p_manage_business_config_group`;

DELIMITER $$

CREATE PROCEDURE `p_manage_business_config_group`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
    AND table_name = 'business_config_group';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_config_group` (
  `GroupId` int NOT NULL,
  `GroupCod` varchar(64) NOT NULL,
  `GroupIdName` varchar(128) DEFAULT NULL,
  `GroupIdKey` varchar(64) DEFAULT NULL,
  `GroupCodName` varchar(128) DEFAULT NULL,
  `GroupCodKey` varchar(64) DEFAULT NULL,
  `ConfigCorrName` varchar(128) DEFAULT NULL,
  `ConfigCorrKey` varchar(64) DEFAULT NULL,
  `ConfigCodName` varchar(128) DEFAULT NULL,
  `ConfigCodKey` varchar(64) DEFAULT NULL,
  `ConfigValName` varchar(128) DEFAULT NULL,
  `ConfigValKey` varchar(64) DEFAULT NULL,
  `ConfigNameName` varchar(128) DEFAULT NULL,
  `ConfigNameKey` varchar(64) DEFAULT NULL,
  `ConfigDescName` varchar(128) DEFAULT NULL,
  `ConfigDescKey` varchar(64) DEFAULT NULL,
  `Str1ConfigName` varchar(128) DEFAULT NULL,
  `Str1ConfigKey` varchar(64) DEFAULT NULL,
  `Str2ConfigName` varchar(128) DEFAULT NULL,
  `Str2ConfigKey` varchar(64) DEFAULT NULL,
  `Str3ConfigName` varchar(128) DEFAULT NULL,
  `Str3ConfigKey` varchar(64) DEFAULT NULL,
  `Str4ConfigName` varchar(128) DEFAULT NULL,
  `Str4ConfigKey` varchar(64) DEFAULT NULL,
  `Num1ConfigName` varchar(128) DEFAULT NULL,
  `Num1ConfigKey` varchar(64) DEFAULT NULL,
  `Num2ConfigName` varchar(128) DEFAULT NULL,
  `Num2ConfigKey` varchar(64) DEFAULT NULL,
  `Num3ConfigName` varchar(128) DEFAULT NULL,
  `Num3ConfigKey` varchar(64) DEFAULT NULL,
  `Num4ConfigName` varchar(128) DEFAULT NULL,
  `Num4ConfigKey` varchar(64) DEFAULT NULL,
  `Dcm1ConfigName` varchar(128) DEFAULT NULL,
  `Dcm1ConfigKey` varchar(64) DEFAULT NULL,
  `Dcm2ConfigName` varchar(128) DEFAULT NULL,
  `Dcm2ConfigKey` varchar(64) DEFAULT NULL,
  `Dcm3ConfigName` varchar(128) DEFAULT NULL,
  `Dcm3ConfigKey` varchar(64) DEFAULT NULL,
  `Dcm4ConfigName` varchar(128) DEFAULT NULL,
  `Dcm4ConfigKey` varchar(64) DEFAULT NULL,
  `Sta1ConfigName` varchar(128) DEFAULT NULL,
  `Sta1ConfigKey` varchar(64) DEFAULT NULL,
  `Sta2ConfigName` varchar(128) DEFAULT NULL,
  `Sta2ConfigKey` varchar(64) DEFAULT NULL,
  `Sta3ConfigName` varchar(128) DEFAULT NULL,
  `Sta3ConfigKey` varchar(64) DEFAULT NULL,
  `Sta4ConfigName` varchar(128) DEFAULT NULL,
  `Sta4ConfigKey` varchar(64) DEFAULT NULL,
  `CreationUserName` varchar(128) DEFAULT NULL,
  `CreationUserKey` varchar(64) DEFAULT NULL,
  `CreationDateName` varchar(128) DEFAULT NULL,
  `CreationDateKey` varchar(64) DEFAULT NULL,
  `ModifyUserName` varchar(128) DEFAULT NULL,
  `ModifyUserKey` varchar(64) DEFAULT NULL,
  `ModifyDateName` varchar(128) DEFAULT NULL,
  `ModifyDateKey` varchar(64) DEFAULT NULL,
  `StatusName` varchar(128) DEFAULT NULL,
  `StatusKey` varchar(64) DEFAULT NULL,
  `GroupName` varchar(128) DEFAULT NULL,
  `GroupDesc` varchar(500) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`GroupCod`),
  UNIQUE KEY `uk_business_config_group_gcid` (`GroupId`),
  KEY `idx_business_config_group_gcid_gcod` (`GroupId`, `GroupCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

        SELECT 'Tabla business_config_group creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================

        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs

        SELECT 'Tabla business_config_group ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_business_config_group`();
DROP PROCEDURE `p_manage_business_config_group`;

